import '../../data/models/semester_model.dart';

abstract class SemesterState {}

class SemesterInitial extends SemesterState {}

class SemesterLoading extends SemesterState {}

class SemesterSuccess extends SemesterState {
  final List<SemesterModel> semesters;

  SemesterSuccess(this.semesters);
}

class SemesterFailure extends SemesterState {
  final String message;

  SemesterFailure(this.message);
}