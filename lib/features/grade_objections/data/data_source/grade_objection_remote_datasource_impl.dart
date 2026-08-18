import 'grade_objection_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/grade_objection_eligibility_model.dart';
import '../models/grade_objection_model.dart';

class GradeObjectionRemoteDataSourceImpl implements GradeObjectionRemoteDataSource {
  final ApiConsumer api;

  GradeObjectionRemoteDataSourceImpl(this.api);

  @override
  Future<GradeObjectionEligibilityModel> getEligibility(int studentGradeId) async {
    final response = await api.get(
      EndPoints.objectionEligibility(studentGradeId),
    );

    return GradeObjectionEligibilityModel.fromJson(response['data']);
  }

  @override
  Future<GradeObjectionModel> submitObjection({
    required int studentGradeId,
    required String details,
  }) async {
    final response = await api.post(
      EndPoints.gradeObjections,
      data: {
        'student_grade_id': studentGradeId,
        'details': details,
      },
    );

    return GradeObjectionModel.fromJson(response['data']);
  }

  @override
  Future<GradeObjectionPageResult> getMyObjections({
    required int page,
    required int perPage,
  }) async {
    final response = await api.get(
      EndPoints.myGradeObjections,
      // The docs only list `per_page`, but the response still comes
      // back paginated, so `page` is passed too (standard Laravel
      // paginator param) to make "load more" actually work.
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = response['data'] ?? {};
    final List items = data['items'] ?? [];
    final pagination = data['pagination'] ?? {};

    return GradeObjectionPageResult(
      items: items.map((e) => GradeObjectionModel.fromJson(e)).toList(),
      currentPage: _asInt(pagination['current_page']) == 0
          ? page
          : _asInt(pagination['current_page']),
      lastPage: _asInt(pagination['last_page']) == 0
          ? page
          : _asInt(pagination['last_page']),
    );
  }

  @override
  Future<GradeObjectionModel> getObjection(int id) async {
    final response = await api.get(EndPoints.gradeObjection(id));

    return GradeObjectionModel.fromJson(response['data']);
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
