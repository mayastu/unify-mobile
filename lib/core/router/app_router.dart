import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../di/service_locator.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/financial_account/presentation/cubit/financial_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/courses/data/models/course_model.dart';
import '../../features/courses/presentation/cubit/course_cubit.dart';
import '../../features/courses/presentation/pages/course_details_page.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/classrooms/presentation/cubit/classroom_cubit.dart';
import '../../features/classrooms/presentation/pages/classrooms_page.dart';
import '../../features/schedule/presentation/cubit/student_schedule_cubit.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/course_sections/presentation/cubit/course_section_cubit.dart';
import '../../features/course_sections/presentation/pages/course_sections_page.dart';
import '../../features/registration/presentation/cubit/registration_cubit.dart';
import '../../features/registration/presentation/pages/registration_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/cubit/student_cubit.dart';
import '../../features/semesters/presentation/cubit/semester_cubit.dart';
import '../storage/secure_storage.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',

    redirect: (context, state) async {
      final token = await SecureStorage.getToken();

      final loggedIn = token != null && token.isNotEmpty;

      final isLoginPage = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';

      // إذا لا يوجد توكن
      if (!loggedIn) {
        // اسمح فقط بصفحات تسجيل الدخول
        if (isLoginPage ||
            isSplash ||
            state.matchedLocation == '/forgot-password' ||
            state.matchedLocation == '/verify-otp' ||
            state.matchedLocation == '/reset-password') {
          return null;
        }

        return '/login';
      }

      // إذا المستخدم مسجل دخول
      if (loggedIn && (isLoginPage || isSplash)) {
        return '/home';
      }

      return null;
    },

    routes: [

      GoRoute(
        path: "/",
        builder: (_, __) => const SplashPage(),
      ),

      GoRoute(
        path: "/login",
        builder: (_, __) => const LoginPage(),
      ),

      GoRoute(
        path: "/forgot-password",
        builder: (_, __) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: "/verify-otp",
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

      // Home aggregates data from Student / Semester / Financial cubits,
      // so it provides them locally and kicks off their first fetch here.
      GoRoute(
        path: "/home",
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<StudentCubit>(
              create: (_) => sl<StudentCubit>()..getProfile(),
            ),
            BlocProvider<SemesterCubit>(
              create: (_) => sl<SemesterCubit>()..getSemesters(),
            ),
            BlocProvider<FinancialCubit>(
              create: (_) => sl<FinancialCubit>()..getFinancialAccount(),
            ),
            BlocProvider<PaymentCubit>(
              create: (_) => sl<PaymentCubit>()..getPayments(),
            ),
          ],
          child: const HomePage(),
        ),
      ),

      GoRoute(
        path: "/courses",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<CourseCubit>()..getCourses(),
          child: const CoursesPage(),
        ),
      ),

      // The list endpoint already returns full course data, so the
      // tapped CourseModel is forwarded via `extra` instead of
      // re-fetching it here.
      GoRoute(
        path: "/courses/:id",
        builder: (_, state) {

          final course = state.extra as CourseModel;

          return CourseDetailsPage(
            course: course,
          );
        },
      ),

      // `extra` is an optional CourseModel to scope the list to one
      // course (opened from CourseDetailsPage); null shows every section.
      GoRoute(
        path: "/course-sections",
        builder: (_, state) {

          final course = state.extra as CourseModel?;

          return BlocProvider(
            create: (_) => sl<CourseSectionCubit>()..getCourseSections(),
            child: CourseSectionsPage(course: course),
          );
        },
      ),

      GoRoute(
        path: "/registration",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RegistrationCubit>()..getAvailableCourses(),
          child: const RegistrationPage(),
        ),
      ),

      // Reference data — not linked from Home yet, will slot into
      // Timetable/SectionSchedule once those are built.
      GoRoute(
        path: "/classrooms",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<ClassroomCubit>()..getClassrooms(),
          child: const ClassroomsPage(),
        ),
      ),

      // PaymentSummaryCard and the purchase-hours action need
      // FinancialCubit too, so both are provided here together.
      GoRoute(
        path: "/payments",
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<PaymentCubit>(
              create: (_) => sl<PaymentCubit>()..getPayments(),
            ),
            BlocProvider<FinancialCubit>(
              create: (_) => sl<FinancialCubit>()..getFinancialAccount(),
            ),
          ],
          child: const PaymentPage(),
        ),
      ),

      GoRoute(
        path: "/schedule",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<StudentScheduleCubit>()..getSchedule(),
          child: const SchedulePage(),
        ),
      ),

      GoRoute(
        path: "/profile",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<StudentCubit>()..getProfile(),
          child: const ProfilePage(),
        ),
      ),

    ],
  );
}
