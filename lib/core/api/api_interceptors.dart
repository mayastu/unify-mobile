import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

    final token =
    await SecureStorage.getToken();

    if (token != null &&
        token.isNotEmpty) {

      options.headers["Authorization"] =
      "Bearer $token";
    }

    super.onRequest(
      options,
      handler,
    );
  }
}