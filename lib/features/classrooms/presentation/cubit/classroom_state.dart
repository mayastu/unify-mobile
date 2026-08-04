import '../../data/models/classroom_model.dart';

abstract class ClassroomState {}

class ClassroomInitial extends ClassroomState {}

class ClassroomLoading extends ClassroomState {}

class ClassroomSuccess extends ClassroomState {
  final List<ClassroomModel> classrooms;

  ClassroomSuccess(this.classrooms);
}

class ClassroomFailure extends ClassroomState {
  final String message;

  ClassroomFailure(this.message);
}
