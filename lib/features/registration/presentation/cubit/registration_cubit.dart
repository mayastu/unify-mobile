import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/course_registration_request.dart';
import '../../data/repositories/registration_repository.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegistrationRepository repository;

  RegistrationCubit(this.repository) : super(RegistrationInitial());

  Future<void> getAvailableCourses({bool showLoading = true}) async {
    if (showLoading) {
      emit(RegistrationLoading());
    }

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
    final currentCourses = state.availableCourses;

    emit(RegistrationSubmitting(currentCourses));

    try {
      await repository.registerCourses(courses);

      final refreshed = await repository.getAvailableCourses();

      emit(RegistrationSubmitSuccess(refreshed));
      emit(RegistrationLoaded(refreshed));
    } catch (e) {
      emit(RegistrationSubmitFailure(e.toString(), currentCourses));
    }
  }

  /// Wired in once the "My courses" page (StudentCourse) exists to
  /// supply the studentCourse id this endpoint needs.
  Future<void> withdrawCourse(int studentCourseId) async {
    final currentCourses = state.availableCourses;

    emit(WithdrawLoading(currentCourses));

    try {
      await repository.withdrawCourse(studentCourseId);

      emit(WithdrawSuccess(currentCourses));
    } catch (e) {
      emit(WithdrawFailure(e.toString(), currentCourses));
    }
  }
}