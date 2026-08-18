import 'student_course_repository.dart';
import '../data_source/student_course_remote_datasource.dart';
import '../models/student_course_model.dart';

class StudentCourseRepositoryImpl implements StudentCourseRepository {
  final StudentCourseRemoteDataSource remote;

  StudentCourseRepositoryImpl(this.remote);

  @override
  Future<List<StudentCourseModel>> getStudentCourses() {
    return remote.getStudentCourses();
  }

  @override
  Future<StudentCourseModel> getStudentCourse(int id) {
    return remote.getStudentCourse(id);
  }
}
