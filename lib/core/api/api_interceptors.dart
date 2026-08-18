import 'package:dio/dio.dart';
import '../router/app_router.dart';
import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {

  // Guards against several requests failing at the exact same moment
  // (e.g. Home firing off profile/semesters/financial-account/etc. all
  // together) each trying to clear storage and redirect on top of
  // one another.
  static bool _handlingUnauthorized = false;

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



  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {

    print("========== ERROR ==========");
    print("${err.requestOptions.method} ${err.requestOptions.uri}");
    print("Status: ${err.response?.statusCode}");
    print(err.message);
    print("============================");

    final isUnauthorized = err.response?.statusCode == 401;

    // Backend quirk on the server side that can't be fixed from here:
    // an expired/invalid token sometimes comes back as a 500 with an
    // HTML "Route [login] not defined" page instead of a clean 401
    // JSON body (Laravel's guest-redirect trying to hit a `login` web
    // route this API-only app doesn't have). Every real API error in
    // this app is JSON (success/message/errors), so an HTML body here
    // is the tell — treat it the same as an expired session.
    final looksLikeBrokenAuthRedirect = err.response?.statusCode == 500 &&
        err.response?.data is String &&
        (err.response?.data as String).contains('Route [login] not defined');

    // The token is expired/invalid — no point leaving the user stuck
    // on whatever screen just failed to load (silently clearing
    // storage alone won't move them off it: the router's `redirect`
    // only re-runs on an actual navigation attempt). Clear the stale
    // local session and bounce straight to /login, the same as a
    // manual logout.
    if ((isUnauthorized || looksLikeBrokenAuthRedirect) &&
        !_handlingUnauthorized) {
      _handlingUnauthorized = true;

      await SecureStorage.clear();
      AppRouter.router.go('/login');

      _handlingUnauthorized = false;
    }

    handler.next(err);
  }


}