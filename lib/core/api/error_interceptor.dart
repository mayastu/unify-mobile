import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {

    switch (err.type) {

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: TimeoutException(),
          ),
        );
        break;

      case DioExceptionType.connectionError:

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: NoInternetException(),
          ),
        );
        break;

      case DioExceptionType.badResponse:
        print("========== SERVER ERROR ==========");
        print("Status Code: ${err.response?.statusCode}");
        print("Response: ${err.response?.data}");
        print("Headers: ${err.response?.headers}");
        print("==================================");


        final responseData = err.response?.data;
        final message = (responseData is Map && responseData["message"] != null)
            ? responseData["message"].toString()
            : "Something went wrong";

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(message),
          ),
        );

        break;

      default:

        handler.next(err);
    }
  }

}