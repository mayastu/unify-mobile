import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

    final token = await SecureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    print("========== REQUEST ==========");
    print("${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Body: ${options.data}");
    print("=============================");

    handler.next(options);
  }



  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {

    print("========== RESPONSE ==========");
    print("${response.requestOptions.method} ${response.requestOptions.uri}");
    print("Status: ${response.statusCode}");
    print(response.data);
    print("==============================");

    handler.next(response);
  }


}
