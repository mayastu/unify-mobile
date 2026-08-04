import 'course_section_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/course_section_model.dart';

class CourseSectionRemoteDataSourceImpl
    implements CourseSectionRemoteDataSource {
  final ApiConsumer api;

  CourseSectionRemoteDataSourceImpl(this.api);

  @override
  Future<List<CourseSectionModel>> getCourseSections() async {
    final response = await api.get(
      EndPoints.courseSections,
    );

    final List data = response["data"];

    return data
        .map((e) => CourseSectionModel.fromJson(e))
        .toList();
  }
}
