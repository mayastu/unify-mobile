import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/login_response_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    print("===== RemoteDataSource =====");
    final response = await api.post(
      EndPoints.login,
      data: {
        "username": username,
        "password": password,
      },
    );

    return LoginResponseModel.fromJson(response);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await api.post(
      EndPoints.forgotPassword,
      data: {
        "email": email,
      },
    );
  }

  @override
  Future<void> logout() async {

    await api.post(
      EndPoints.logout,
    );

  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    await api.post(
      EndPoints.resetPassword,
      data: {
        "email": email,
        "otp": otp,
        "password": password,
        "password_confirmation": passwordConfirmation,
      },
    );
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await api.post(
      EndPoints.verifyOtp,
      data: {
        "email": email,
        "otp": otp,
      },
    );
  }
}
