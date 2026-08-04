import 'registration_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/available_course_model.dart';
import '../models/course_registration_request.dart';

class RegistrationRemoteDataSourceImpl
    implements RegistrationRemoteDataSource {
  final ApiConsumer api;

  RegistrationRemoteDataSourceImpl(this.api);

  @override
  Future<List<AvailableCourseModel>> getAvailableCourses() async {
    final response = await api.get(
      EndPoints.availableCourses,
    );

    final List data = response["data"];

    return data
        .map((e) => AvailableCourseModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> registerCourses(
    List<CourseRegistrationRequest> courses,
  ) async {
    await api.post(
      EndPoints.registerCourses,
      data: {
        "courses": courses.map((c) => c.toJson()).toList(),
      },
    );
  }

  @override
  Future<void> withdrawCourse(int studentCourseId) async {
    await api.delete(
      "${EndPoints.withdrawCourse}/$studentCourseId/withdraw",
    );
  }
}
