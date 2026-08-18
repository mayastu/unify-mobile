import '../../data/models/current_semester_grades_model.dart';

abstract class GradesState {}

class GradesInitial extends GradesState {}

class GradesLoading extends GradesState {}

class GradesSuccess extends GradesState {
  final CurrentSemesterGradesModel grades;

  GradesSuccess(this.grades);
}

class GradesFailure extends GradesState {
  final String message;

  GradesFailure(this.message);
}
