import 'notification_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/notification_model.dart';
import '../models/notification_page_result.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiConsumer api;

  NotificationRemoteDataSourceImpl(this.api);

  @override
  Future<NotificationPageResult> getNotifications({
    required int page,
    required int perPage,
    String status = 'all',
    String? type,
  }) async {
    final response = await api.get(
      EndPoints.notifications,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (status != 'all') 'status': status,
        if (type != null) 'type': type,
      },
    );

    final data = response['data'] ?? {};
    final List items = data['items'] ?? [];
    final pagination = data['pagination'] ?? {};

    return NotificationPageResult(
      items: items.map((e) => NotificationModel.fromJson(e)).toList(),
      currentPage: pagination['current_page'] ?? page,
      lastPage: pagination['last_page'] ?? page,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await api.get(EndPoints.notificationsUnreadCount);
    return response['data']?['count'] ?? 0;
  }

  @override
  Future<NotificationModel> getNotification(String id) async {
    final response = await api.get('${EndPoints.notifications}/$id');
    return NotificationModel.fromJson(response['data']);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await api.delete('${EndPoints.notifications}/$id');
  }

  @override
  Future<int> markAllAsRead() async {
    final response = await api.patch(EndPoints.notificationsReadAll);
    return response['data']?['updated_count'] ?? 0;
  }

  @override
  Future<NotificationModel> markAsRead(String id) async {
    final response = await api.patch('${EndPoints.notifications}/$id/read');
    return NotificationModel.fromJson(response['data']);
  }

  @override
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  }) async {
    await api.post(
      EndPoints.deviceTokens,
      data: {
        'token': token,
        'platform': platform,
        if (deviceId != null) 'device_id': deviceId,
        if (deviceName != null) 'device_name': deviceName,
        if (appVersion != null) 'app_version': appVersion,
      },
    );
  }

  @override
  Future<void> unregisterDeviceToken(String token) async {
    await api.delete(
      EndPoints.deviceTokens,
      queryParameters: {'token': token},
    );
  }
}