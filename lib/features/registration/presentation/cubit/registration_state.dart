import '../../data/models/available_course_model.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  final List<AvailableCourseModel> availableCourses;

  RegistrationLoaded(this.availableCourses);
}

class RegistrationLoadFailure extends RegistrationState {
  final String message;

  RegistrationLoadFailure(this.message);
}

class RegistrationSubmitting extends RegistrationState {}

class RegistrationSubmitSuccess extends RegistrationState {}

class RegistrationSubmitFailure extends RegistrationState {
  final String message;

  RegistrationSubmitFailure(this.message);
}

class WithdrawLoading extends RegistrationState {}

class WithdrawSuccess extends RegistrationState {}

class WithdrawFailure extends RegistrationState {
  final String message;

  WithdrawFailure(this.message);
}
