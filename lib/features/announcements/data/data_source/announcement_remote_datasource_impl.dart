import 'announcement_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/announcement_model.dart';
import '../models/announcement_page_result.dart';

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final ApiConsumer api;

  AnnouncementRemoteDataSourceImpl(this.api);

  @override
  Future<AnnouncementPageResult> getAnnouncements({
    required int page,
    required int perPage,
  }) async {
    final response = await api.get(
      EndPoints.announcements,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    final data = response['data'] ?? {};
    final List items = data['items'] ?? [];
    final pagination = data['pagination'] ?? {};

    return AnnouncementPageResult(
      items: items.map((e) => AnnouncementModel.fromJson(e)).toList(),
      currentPage: _asInt(pagination['current_page']) == 0
          ? page
          : _asInt(pagination['current_page']),
      lastPage: _asInt(pagination['last_page']) == 0
          ? page
          : _asInt(pagination['last_page']),
    );
  }

  @override
  Future<AnnouncementModel> getAnnouncement(String id) async {
    final response = await api.get('${EndPoints.announcements}/$id');
    return AnnouncementModel.fromJson(response['data']);
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
