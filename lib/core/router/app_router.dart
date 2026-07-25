import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/login',

    routes: [

      // GoRoute(
      //   path: "/",
      //   builder: (_, __) => const SplashPage(),
      // ),

      GoRoute(
        path: "/login",
        builder: (_, __) => const LoginPage(),
      ),

      GoRoute(
        path: "/forgot-password",
        builder: (_, __) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: "/otp",
        builder: (_, state) {

          final email = state.extra as String;

          return OtpVerificationPage(
            email: email,
          );
        },
      ),

      GoRoute(
        path: "/reset-password",
        builder: (_, state) {

          final data =
          state.extra as Map<String, String>;

          return ResetPasswordPage(
            email: data["email"]!,
            otp: data["otp"]!,
          );
        },
      ),

      // GoRoute(
      //   path: "/dashboard",
      //   builder: (_, __) => const DashboardPage(),
      // ),

    ],
  );
}