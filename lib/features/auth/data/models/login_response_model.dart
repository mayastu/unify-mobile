import 'user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final LoginDataModel data;

  const LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      data: LoginDataModel.fromJson(json['data']),
    );
  }
}

class LoginDataModel {
  final UserModel user;
  final String token;

  const LoginDataModel({

    required this.user,
    required this.token,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}