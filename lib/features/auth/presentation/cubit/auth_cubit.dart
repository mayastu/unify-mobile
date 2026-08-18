import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    print("===== Cubit Login =====");

    emit(AuthLoading());

    try {
      final response = await repository.login(
        username: username,
        password: password,
      );

      emit(LoginSuccess(response));

      await SecureStorage.saveToken(response.data.token);
      await SecureStorage.saveStudentId(response.data.user.id);
      await SecureStorage.saveUserName(response.data.user.username);

      // The FCM token is usually already fetched by the time login
      // happens (NotificationService.initialize() runs at startup);
      // this registers it now that we have an auth token to send.
      await NotificationService.syncDeviceToken();
    } catch (e) {
      print(e);
      print(e.runtimeType);

      emit(AuthFailure(e.toString()));
    }
  }






  Future<void> checkAuth() async {

    final loggedIn =
    await repository.isLoggedIn();

    if(loggedIn){

      // Covers the app-restart case: the user already has a session,
      // and the device's FCM token (fetched again at this startup)
      // needs to be (re)registered against it.
      await NotificationService.syncDeviceToken();

      emit(
        Authenticated(),
      );

    }else{

      emit(
        UnAuthenticated(),
      );

    }

  }




  Future<void> forgotPassword({
    required String email,
  }) async {

    emit(AuthLoading());

    try {

      await repository.forgotPassword(
        email: email,
      );

      emit(
        ForgotPasswordSuccess(),
      );

    } catch (e) {

      emit(
        AuthFailure(
          e.toString(),
        ),
      );

    }

  }


  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {

    emit(AuthLoading());

    try {

      await repository.verifyOtp(
        email: email,
        otp: otp,
      );

      emit(VerifyOtpSuccess());

    } catch (e) {

      emit(AuthFailure(e.toString()));

    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    try {
      await repository.resetPassword(
        email: email,
        otp: otp,
        password: password,
      confirmPassword: confirmPassword,
      );

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }



  Future<void> logout() async {

    emit(AuthLoading());

    try {

      // Must run before repository.logout() clears the stored auth
      // token, since removing the device token still requires a valid
      // Authorization header.
      await NotificationService.unregisterDeviceToken();

      await repository.logout();

      emit(LogoutSuccess());

    } catch (e) {

      emit(
        AuthFailure(
          e.toString(),
        ),
      );

    }

  }
}