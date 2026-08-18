import 'course_material_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/course_material_model.dart';

class CourseMaterialRemoteDataSourceImpl implements CourseMaterialRemoteDataSource {
  final ApiConsumer api;

  CourseMaterialRemoteDataSourceImpl(this.api);

  @override
  Future<List<CourseMaterialModel>> getMaterials(int courseSectionId) async {
    final response = await api.get(
      EndPoints.courseSectionMaterials(courseSectionId),
    );

    final List data = response['data'] ?? [];
    return data.map((e) => CourseMaterialModel.fromJson(e)).toList();
  }
}
