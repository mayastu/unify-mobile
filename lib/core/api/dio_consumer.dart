import 'package:dio/dio.dart';
import 'package:unify/core/api/api_interceptors.dart';
import 'api_consumer.dart';
import 'end_points.dart';
import 'error_interceptor.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: EndPoints.baseUrl,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
                headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/json",
                },
              ),
            ) {
    this.dio.interceptors.add(
          AuthInterceptor(),
        );
    this.dio.interceptors.add(
      ErrorInterceptor(),
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    print("POST => $path");

    print(data);
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      print("=========== DIO ERROR ===========");
      print(e.type);
      print(e.message);
      print(e.error);
      print(e.response?.statusCode);
      print(e.response?.data);
      print("================================");

      rethrow;
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
    );

    return response.data;
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );

    return response.data;
  }
}
