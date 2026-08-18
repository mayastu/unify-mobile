import 'notification_repository.dart';
import '../data_source/notification_remote_datasource.dart';
import '../models/notification_model.dart';
import '../models/notification_page_result.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<NotificationPageResult> getNotifications({
    required int page,
    required int perPage,
    String status = 'all',
    String? type,
  }) {
    return remote.getNotifications(
      page: page,
      perPage: perPage,
      status: status,
      type: type,
    );
  }

  @override
  Future<int> getUnreadCount() => remote.getUnreadCount();

  @override
  Future<NotificationModel> getNotification(String id) =>
      remote.getNotification(id);

  @override
  Future<void> deleteNotification(String id) =>
      remote.deleteNotification(id);

  @override
  Future<int> markAllAsRead() => remote.markAllAsRead();

  @override
  Future<NotificationModel> markAsRead(String id) => remote.markAsRead(id);

  @override
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  }) {
    return remote.registerDeviceToken(
      token: token,
      platform: platform,
      deviceId: deviceId,
      deviceName: deviceName,
      appVersion: appVersion,
    );
  }

  @override
  Future<void> unregisterDeviceToken(String token) =>
      remote.unregisterDeviceToken(token);
}