import '../models/notification_model.dart';
import '../models/notification_page_result.dart';

abstract class NotificationRepository {
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

  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  });

  Future<void> unregisterDeviceToken(String token);
}