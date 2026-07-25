import 'package:unify/core/storage/secure_storage.dart';

import '../datasource/auth_remote_datasource.dart';
import '../models/login_response_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    print("===== Repository =====");
    final response = await remoteDataSource.login(
      username: username,
      password: password,
    );
    await SecureStorage.saveToken(response.data.token);
    return response;
  }


  Future<bool> isLoggedIn() async {

    final token =
    await SecureStorage.getToken();

    return token != null &&
        token.isNotEmpty;

  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await SecureStorage.deleteToken();
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) {
    return remoteDataSource.forgotPassword(
      email: email,
    );
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) {
    return remoteDataSource.verifyOtp(email: email, otp: otp);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) {
    return remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        password: password,
        passwordConfirmation: confirmPassword);
  }
}
