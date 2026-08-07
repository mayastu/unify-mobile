import '../../data/models/available_course_model.dart';

abstract class RegistrationState {
  /// The most recently known list of available courses, carried
  /// forward through every state so the UI never needs to reach back
  /// into the cubit or cast between states to find it.
  List<AvailableCourseModel> get availableCourses => const [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  @override
  final List<AvailableCourseModel> availableCourses;

  RegistrationLoaded(this.availableCourses);
}

class RegistrationLoadFailure extends RegistrationState {
  final String message;

  RegistrationLoadFailure(this.message);
}

class RegistrationSubmitting extends RegistrationState {
  @override
  final List<AvailableCourseModel> availableCourses;

  RegistrationSubmitting(this.availableCourses);
}

class RegistrationSubmitSuccess extends RegistrationState {
  @override
  final List<AvailableCourseModel> availableCourses;

  RegistrationSubmitSuccess(this.availableCourses);
}

class RegistrationSubmitFailure extends RegistrationState {
  final String message;
  @override
  final List<AvailableCourseModel> availableCourses;

  RegistrationSubmitFailure(this.message, this.availableCourses);
}

class WithdrawLoading extends RegistrationState {
  @override
  final List<AvailableCourseModel> availableCourses;

  WithdrawLoading(this.availableCourses);
}

class WithdrawSuccess extends RegistrationState {
  @override
  final List<AvailableCourseModel> availableCourses;

  WithdrawSuccess(this.availableCourses);
}

class WithdrawFailure extends RegistrationState {
  final String message;
  @override
  final List<AvailableCourseModel> availableCourses;

  WithdrawFailure(this.message, this.availableCourses);
}