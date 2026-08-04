import 'registration_repository.dart';
import '../data_source/registration_remote_datasource.dart';
import '../models/available_course_model.dart';
import '../models/course_registration_request.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remote;

  RegistrationRepositoryImpl(this.remote);

  @override
  Future<List<AvailableCourseModel>> getAvailableCourses() {
    return remote.getAvailableCourses();
  }

  @override
  Future<void> registerCourses(List<CourseRegistrationRequest> courses) {
    return remote.registerCourses(courses);
  }

  @override
  Future<void> withdrawCourse(int studentCourseId) {
    return remote.withdrawCourse(studentCourseId);
  }
}
