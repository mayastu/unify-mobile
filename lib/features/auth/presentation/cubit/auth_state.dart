import '../../data/models/login_response_model.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}


class LoginSuccess extends AuthState {
  final LoginResponseModel response;

  LoginSuccess(this.response);
}

class Authenticated extends AuthState {}

class UnAuthenticated extends AuthState {}

final class ForgotPasswordSuccess extends AuthState {}

final class VerifyOtpSuccess extends AuthState {}

final class ResetPasswordSuccess extends AuthState {}

final class LogoutSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}