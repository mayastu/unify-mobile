import '../models/available_course_model.dart';
import '../models/course_registration_request.dart';

abstract class RegistrationRepository {
  Future<List<AvailableCourseModel>> getAvailableCourses();

  Future<void> registerCourses(List<CourseRegistrationRequest> courses);

  Future<void> withdrawCourse(int studentCourseId);
}
