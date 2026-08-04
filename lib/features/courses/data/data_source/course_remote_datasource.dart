import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();

  Future<CourseModel> getCourse(int id);
}
