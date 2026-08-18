import '../../data/models/student_course_model.dart';

abstract class StudentCourseState {
  /// The most recently known list of enrollments, carried forward
  /// through every state so the UI never needs to cast between states
  /// to find it.
  List<StudentCourseModel> get courses => const [];
}

class StudentCourseInitial extends StudentCourseState {}

class StudentCourseLoading extends StudentCourseState {}

class StudentCourseLoaded extends StudentCourseState {
  @override
  final List<StudentCourseModel> courses;

  StudentCourseLoaded(this.courses);
}

class StudentCourseLoadFailure extends StudentCourseState {
  final String message;

  StudentCourseLoadFailure(this.message);
}

/// [withdrawingId] lets the card for that specific enrollment show its
/// own spinner instead of blocking the whole list.
class StudentCourseWithdrawing extends StudentCourseState {
  @override
  final List<StudentCourseModel> courses;
  final int withdrawingId;

  StudentCourseWithdrawing(this.courses, this.withdrawingId);
}

class StudentCourseWithdrawSuccess extends StudentCourseState {
  @override
  final List<StudentCourseModel> courses;

  StudentCourseWithdrawSuccess(this.courses);
}

class StudentCourseWithdrawFailure extends StudentCourseState {
  final String message;
  @override
  final List<StudentCourseModel> courses;

  StudentCourseWithdrawFailure(this.message, this.courses);
}
