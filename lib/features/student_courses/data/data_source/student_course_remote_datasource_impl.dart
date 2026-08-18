import 'student_course_remote_datasource.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/student_course_model.dart';

class StudentCourseRemoteDataSourceImpl
    implements StudentCourseRemoteDataSource {
  final ApiConsumer api;

  StudentCourseRemoteDataSourceImpl(this.api);

  @override
  Future<List<StudentCourseModel>> getStudentCourses() async {
    final response = await api.get(EndPoints.studentCourses);

    final List data = response["data"];

    return data.map((e) => StudentCourseModel.fromJson(e)).toList();
  }

  @override
  Future<StudentCourseModel> getStudentCourse(int id) async {
    final response = await api.get("${EndPoints.studentCourses}/$id");

    return StudentCourseModel.fromJson(response["data"]);
  }
}
