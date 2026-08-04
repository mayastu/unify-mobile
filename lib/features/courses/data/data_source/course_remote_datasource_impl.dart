import 'course_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/course_model.dart';

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiConsumer api;

  CourseRemoteDataSourceImpl(this.api);

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await api.get(
      EndPoints.courses,
    );

    final List data = response["data"];

    return data
        .map((e) => CourseModel.fromJson(e))
        .toList();
  }

  @override
  Future<CourseModel> getCourse(int id) async {
    final response = await api.get(
      "${EndPoints.courses}/$id",
    );

    return CourseModel.fromJson(response["data"]);
  }
}
