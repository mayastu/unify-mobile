import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/course_registration_request.dart';
import '../../data/repositories/registration_repository.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegistrationRepository repository;

  RegistrationCubit(this.repository) : super(RegistrationInitial());

  Future<void> getAvailableCourses() async {
    emit(RegistrationLoading());

    try {
      final courses = await repository.getAvailableCourses();

      emit(RegistrationLoaded(courses));
    } catch (e) {
      emit(RegistrationLoadFailure(e.toString()));
    }
  }

  Future<void> submitRegistration(
    List<CourseRegistrationRequest> courses,
  ) async {
    emit(RegistrationSubmitting());

    try {
      await repository.registerCourses(courses);

      emit(RegistrationSubmitSuccess());

      // Refresh so already-registered courses drop off the list.
      await getAvailableCourses();
    } catch (e) {
      emit(RegistrationSubmitFailure(e.toString()));
    }
  }

  /// Wired in once the "My courses" page (StudentCourse) exists to
  /// supply the studentCourse id this endpoint needs.
  Future<void> withdrawCourse(int studentCourseId) async {
    emit(WithdrawLoading());

    try {
      await repository.withdrawCourse(studentCourseId);

      emit(WithdrawSuccess());
    } catch (e) {
      emit(WithdrawFailure(e.toString()));
    }
  }
}
