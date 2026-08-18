import '../models/student_course_model.dart';

abstract class StudentCourseRemoteDataSource {
  Future<List<StudentCourseModel>> getStudentCourses();

  Future<StudentCourseModel> getStudentCourse(int id);
}
