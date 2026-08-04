import '../../data/models/student_model.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {
  final StudentModel student;

  StudentSuccess(this.student);
}

class StudentFailure extends StudentState {
  final String message;

  StudentFailure(this.message);
}