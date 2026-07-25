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

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              err.response?.data["message"] ??
                  "Something went wrong",
            ),
          ),
        );

        break;

      default:

        handler.next(err);
    }
  }

}