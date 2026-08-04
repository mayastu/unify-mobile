import '../models/course_model.dart';

abstract class CourseRepository {
  Future<List<CourseModel>> getCourses();

  Future<CourseModel> getCourse(int id);
}
