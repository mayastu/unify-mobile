import '../models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });

  Future<bool> isLoggedIn();

  Future<void> logout();

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  });
}