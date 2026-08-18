import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../di/service_locator.dart';
import '../../features/notifications/data/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../router/app_router.dart';
import '../storage/secure_storage.dart';

/// Handles FCM push notifications end to end: permissions, showing a
/// local notification while the app is open (FCM doesn't do that on
/// its own), routing a tap to the right screen, and registering the
/// device's FCM token against the logged-in student.
class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'unify_default_channel',
    'General notifications',
    description: 'Announcements, grades, and schedule updates.',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _initLocalNotifications();

    // Foreground: FCM hands the message to the app but shows nothing on
    // its own — we display it ourselves via flutter_local_notifications.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // App was backgrounded and the user tapped the system notification.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // App was fully terminated and got opened by tapping a notification.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleTap(initialMessage);
    }

    _onTokenReady(await _messaging.getToken());
    _messaging.onTokenRefresh.listen(_onTokenReady);
  }

  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null) return;

        final data = jsonDecode(payload) as Map<String, dynamic>;
        _navigate(data['screen']?.toString());
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    }

    // Keep the badge accurate immediately instead of waiting for a
    // manual pull-to-refresh on the notifications list.
    if (sl.isRegistered<NotificationCubit>()) {
      sl<NotificationCubit>().getUnreadCount();
    }
  }

  static void _handleTap(RemoteMessage message) {
    _navigate(message.data['screen']?.toString());
  }

  /// Maps a notification's `screen` value to an actual route. Adjust
  /// the cases here once the backend team confirms the exact `screen`
  /// strings they'll send — anything unrecognized safely falls back to
  /// opening the notifications list itself, so a tap never dead-ends.
  static void _navigate(String? screen) {
    switch (screen) {
      case 'registration':
        AppRouter.router.push('/registration');
        break;
      case 'schedule':
        AppRouter.router.push('/schedule');
        break;
      case 'payments':
        AppRouter.router.push('/payments');
        break;
      case 'financial_account':
        AppRouter.router.push('/financial-account');
        break;
      case 'profile':
        AppRouter.router.push('/profile');
        break;
      case 'announcements':
        // `extra: 1` opens NotificationsPage directly on the
        // Announcements tab (index 1) instead of Notifications (0).
        AppRouter.router.push('/notifications', extra: 1);
        break;
      default:
        AppRouter.router.push('/notifications');
    }
  }

  // Cached so syncDeviceToken()/unregisterDeviceToken() can reuse the
  // token without calling FirebaseMessaging.getToken() again.
  static String? _lastToken;

  static void _onTokenReady(String? token) {
    if (token == null) return;

    _lastToken = token;

    if (kDebugMode) {
      debugPrint('FCM device token: $token');
    }

    _registerToken(token);
  }

  static Future<void> _registerToken(String token) async {
    // NotificationService.initialize() runs at app startup, before the
    // user may be logged in, so a fetched/refreshed token can arrive
    // with no auth token yet. In that case do nothing here — the login
    // flow calls syncDeviceToken() once a session exists.
    final authToken = await SecureStorage.getToken();
    if (authToken == null || authToken.isEmpty) return;

    if (!sl.isRegistered<NotificationRepository>()) return;

    try {
      await sl<NotificationRepository>().registerDeviceToken(
        token: token,
        platform: _platform,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to register device token: $e');
    }
  }

  /// Call after a successful login (and after [AuthCubit.checkAuth]
  /// confirms an existing session) so a token obtained before the user
  /// authenticated still gets registered against their account.
  static Future<void> syncDeviceToken() async {
    final token = _lastToken ?? await _messaging.getToken();
    if (token == null) return;
    await _registerToken(token);
  }

  /// Call on logout, before the stored auth token is cleared — the
  /// request still needs a valid Authorization header to identify
  /// which registration to remove.
  static Future<void> unregisterDeviceToken() async {
    final token = _lastToken;
    if (token == null) return;
    if (!sl.isRegistered<NotificationRepository>()) return;

    try {
      await sl<NotificationRepository>().unregisterDeviceToken(token);
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to unregister device token: $e');
    }
  }

  static String get _platform {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        // The backend only accepts android/ios/web; anything else
        // (desktop targets) falls back to web rather than sending an
        // invalid value.
        return 'web';
    }
  }
}

/// Must stay top-level (or static) — this runs in a separate isolate
/// when a push arrives while the app is backgrounded or terminated, so
/// it can't touch any state from the running app.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Android already shows the system notification automatically from
  // the `notification` payload when the app isn't foregrounded. This
  // handler is here so data-only pushes can be processed later without
  // needing to open the app first.
}