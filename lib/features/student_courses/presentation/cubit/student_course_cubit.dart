import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../registration/data/repositories/registration_repository.dart';
import '../../data/repositories/student_course_repository.dart';
import 'student_course_state.dart';

class StudentCourseCubit extends Cubit<StudentCourseState> {
  final StudentCourseRepository repository;

  // Withdrawing hits the registration module's endpoint
  // (`/registration/{studentCourse}/withdraw`), so this cubit reuses
  // RegistrationRepository instead of duplicating that call here.
  final RegistrationRepository registrationRepository;

  StudentCourseCubit(this.repository, this.registrationRepository)
      : super(StudentCourseInitial());

  Future<void> getStudentCourses({bool showLoading = true}) async {
    if (showLoading) {
      emit(StudentCourseLoading());
    }

    try {
      final courses = await repository.getStudentCourses();
      emit(StudentCourseLoaded(courses));
    } catch (e) {
      emit(StudentCourseLoadFailure(e.toString()));
    }
  }

  Future<void> withdraw(int studentCourseId) async {
    final currentCourses = state.courses;

    emit(StudentCourseWithdrawing(currentCourses, studentCourseId));

    try {
      await registrationRepository.withdrawCourse(studentCourseId);

      // Refetch so status flips from "enrolled" to "withdrawn" (or the
      // row disappears, depending on how the backend models it)
      // instead of guessing the new state client-side.
      final refreshed = await repository.getStudentCourses();

      emit(StudentCourseWithdrawSuccess(refreshed));
      emit(StudentCourseLoaded(refreshed));
    } catch (e) {
      emit(StudentCourseWithdrawFailure(e.toString(), currentCourses));
    }
  }
}
