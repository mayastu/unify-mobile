import '../models/notification_model.dart';
import '../models/notification_page_result.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationPageResult> getNotifications({
    required int page,
    required int perPage,
    String status = 'all',
    String? type,
  });

  Future<int> getUnreadCount();

  Future<NotificationModel> getNotification(String id);

  Future<void> deleteNotification(String id);

  Future<int> markAllAsRead();

  Future<NotificationModel> markAsRead(String id);

  /// Registers (or refreshes) this device's push token against the
  /// logged-in user. `platform` must be one of 'android', 'ios', 'web'.
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  });

  /// Removes this device's push token, e.g. on logout, so the backend
  /// stops sending pushes to a device the user is no longer using.
  Future<void> unregisterDeviceToken(String token);
}