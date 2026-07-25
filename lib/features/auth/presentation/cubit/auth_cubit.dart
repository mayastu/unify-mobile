import 'package:flutter_bloc/flutter_bloc.dart';

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