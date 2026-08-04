import '../../data/models/course_model.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseSuccess extends CourseState {
  final List<CourseModel> courses;

  CourseSuccess(this.courses);
}

class CourseFailure extends CourseState {
  final String message;

  CourseFailure(this.message);
}

class CourseDetailsLoading extends CourseState {}

class CourseDetailsSuccess extends CourseState {
  final CourseModel course;

  CourseDetailsSuccess(this.course);
}

class CourseDetailsFailure extends CourseState {
  final String message;

  CourseDetailsFailure(this.message);
}
