import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/course_repository.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository repository;

  CourseCubit(this.repository) : super(CourseInitial());

  Future<void> getCourses() async {
    emit(CourseLoading());

    try {
      final courses = await repository.getCourses();

      emit(CourseSuccess(courses));
    } catch (e) {
      emit(CourseFailure(e.toString()));
    }
  }

  /// Kept for deep-linking straight to a course (e.g. from a
  /// notification) — the list already carries full course data,
  /// so CoursesPage passes it along instead of calling this again.
  Future<void> getCourseDetails(int id) async {
    emit(CourseDetailsLoading());

    try {
      final course = await repository.getCourse(id);

      emit(CourseDetailsSuccess(course));
    } catch (e) {
      emit(CourseDetailsFailure(e.toString()));
    }
  }
}
