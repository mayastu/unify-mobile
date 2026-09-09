import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unify/features/financial_account/presentation/pages/financial_page.dart';
import '../../di/service_locator.dart';
import '../../features/grades/presentation/cubit/grades_cubit.dart';
import '../../features/grades/presentation/pages/grades_page.dart';
import '../../features/grades/presentation/cubit/grade_breakdown_cubit.dart';
import '../../features/grades/presentation/pages/grade_breakdown_page.dart';
import '../../features/grade_objections/presentation/cubit/my_objections_cubit.dart';
import '../../features/grade_objections/presentation/pages/my_objections_page.dart';
import '../../features/course_materials/presentation/cubit/course_material_cubit.dart';
import '../../features/course_materials/presentation/pages/course_materials_page.dart';
import '../../features/course_sections/data/models/course_section_model.dart';
import '../../features/grades/data/models/current_semester_grades_model.dart';
import '../../features/attendance/presentation/cubit/attendance_summary_cubit.dart';
import '../../features/attendance/presentation/pages/attendance_summary_page.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/announcements/data/models/announcement_model.dart';
import '../../features/announcements/presentation/cubit/announcement_cubit.dart';
import '../../features/system_settings/presentation/cubit/system_settings_cubit.dart';
import '../../features/announcements/presentation/pages/announcement_details_page.dart';
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
import '../../features/student_courses/presentation/cubit/student_course_cubit.dart';
import '../../features/student_courses/presentation/pages/my_courses_page.dart';
import '../../features/student_courses/data/models/student_course_model.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/cubit/student_cubit.dart';
import '../../features/semesters/presentation/cubit/semester_cubit.dart';
import '../storage/secure_storage.dart';
import '../widgets/app_shell_scaffold.dart';

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

      // Home / Courses / Schedule / Profile share one persistent
      // bottom nav via AppShellScaffold. Each branch keeps its own
      // Navigator + cubit state alive, so switching tabs never
      // re-stacks a page or re-triggers a fetch, and the active tab
      // always matches whatever branch is actually on screen.
      //
      // Everything else (course details, payments, grades, ...)
      // stays a plain top-level GoRoute below, pushed on top of the
      // shell — the bar hiding on those is intentional drill-down
      // behavior, not a bug.
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            AppShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              // Home aggregates data from Student / Semester / Financial
              // cubits, so it provides them locally and kicks off their
              // first fetch here.
              GoRoute(
                path: "/home",
                builder: (_, __) {
                  sl<NotificationCubit>().getUnreadCount();
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<StudentCubit>(
                        create: (_) =>
                        sl<StudentCubit>()
                          ..getProfile(),
                      ),
                      BlocProvider<SemesterCubit>(
                        create: (_) =>
                        sl<SemesterCubit>()
                          ..getSemesters(),
                      ),
                      BlocProvider<FinancialCubit>(
                        create: (_) =>
                        sl<FinancialCubit>()
                          ..getFinancialAccount(),
                      ),
                      BlocProvider<PaymentCubit>(
                        create: (_) =>
                        sl<PaymentCubit>()
                          ..getPayments(),
                      ),
                      BlocProvider<StudentScheduleCubit>(
                        create: (_) =>
                        sl<StudentScheduleCubit>()
                          ..getSchedule(),
                      ),
                      BlocProvider<AnnouncementCubit>(
                        create: (_) =>
                        sl<AnnouncementCubit>()
                          ..getAnnouncements(),
                      ),
                      BlocProvider<RegistrationCubit>(
                        create: (_) =>
                        sl<RegistrationCubit>()
                          ..getAvailableCourses(),
                      ),
                    ],
                    child: const HomePage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/courses",
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<CourseCubit>()..getCourses(),
                  child: const CoursesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/schedule",
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<StudentScheduleCubit>()..getSchedule(),
                  child: const SchedulePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/profile",
                builder: (_, __) => BlocProvider(
                  create: (_) => sl<StudentCubit>()..getProfile(),
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
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

      GoRoute(
        path: "/my-courses",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<StudentCourseCubit>()..getStudentCourses(),
          child: const MyCoursesPage(),
        ),
      ),

      // Attendance summary for one enrollment. `extra` carries the
      // StudentCourseModel (already loaded on MyCoursesPage) so this
      // doesn't have to re-fetch it just for the course name/code.
      GoRoute(
        path: "/my-courses/:studentCourseId/attendance",
        builder: (_, state) {
          final studentCourse = state.extra as StudentCourseModel;

          return BlocProvider(
            create: (_) =>
                sl<AttendanceSummaryCubit>()..load(studentCourse.id),
            child: AttendanceSummaryPage(
              studentCourseId: studentCourse.id,
              courseName: studentCourse.course.name,
              courseCode: studentCourse.course.courseCode,
            ),
          );
        },
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
        path: "/financial-account",
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<FinancialCubit>(
              create: (_) => sl<FinancialCubit>()..getFinancialAccount(),
            ),
            BlocProvider<SystemSettingsCubit>(
              create: (_) => sl<SystemSettingsCubit>()..getSettings(),
            ),
          ],
          child: const FinancialPage(),
        ),
      ),

      GoRoute(
        path: "/grades",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<GradesCubit>()..getCurrentSemesterGrades(),
          child: const GradesPage(),
        ),
      ),

      // Per-course component breakdown, opened by tapping a course on
      // GradesPage. Calls `.../student-grades` (grouped by
      // section_type) directly — this is the endpoint that also
      // carries the grade-entry `id` needed for the objection
      // ("اعتراض") feature. The theory_practical bug that used to
      // make this endpoint unusable (fixed 2026-08-15+) is resolved.
      GoRoute(
        path: "/grades/:courseId",
        builder: (_, state) {
          final course = state.extra as GradeCourseModel;
          final courseId = int.parse(state.pathParameters["courseId"]!);

          return BlocProvider(
            create: (_) => sl<GradeBreakdownCubit>()..loadBreakdown(courseId),
            child: GradeBreakdownPage(
              courseId: courseId,
              courseName: course.courseName,
              courseCode: course.courseCode,
            ),
          );
        },
      ),

      // NotificationCubit is provided globally in main.dart.
      // AnnouncementCubit is provided here since this route is the
      // only place that needs it — the Announcements tab lives inside
      // this same page. `extra` (an int) picks which tab opens first,
      // so a push notification with screen: "announcements" can land
      // directly on that tab instead of always defaulting to
      // Notifications — see NotificationService._navigate.
      GoRoute(
        path: "/notifications",
        builder: (_, state) => BlocProvider(
          create: (_) => sl<AnnouncementCubit>(),
          child: NotificationsPage(initialTab: state.extra as int? ?? 0),
        ),
      ),

      // The list endpoint already returns the full announcement (title,
      // body, media), so the tapped AnnouncementModel is forwarded via
      // `extra` instead of re-fetching it here — same pattern as
      // /courses/:id.
      GoRoute(
        path: "/announcements/:id",
        builder: (_, state) {
          final announcement = state.extra as AnnouncementModel;

          return AnnouncementDetailsPage(
            announcement: announcement,
          );
        },
      ),

      GoRoute(
        path: "/grade-objections",
        builder: (_, __) => BlocProvider(
          create: (_) => sl<MyObjectionsCubit>(),
          child: const MyObjectionsPage(),
        ),
      ),

      // Materials the instructor uploaded for one course section.
      // `extra` (a CourseSectionModel) is only used for the app-bar
      // title — everything else is fetched fresh by courseSectionId.
      GoRoute(
        path: "/course-sections/:courseSectionId/materials",
        builder: (_, state) {
          final section = state.extra as CourseSectionModel?;
          final courseSectionId =
              int.parse(state.pathParameters["courseSectionId"]!);

          final title = section == null
              ? 'Materials'
              : (section.course == null
                  ? section.sectionName
                  : '${section.course!.courseCode} • ${section.sectionName}');

          return BlocProvider(
            create: (_) => sl<CourseMaterialCubit>(),
            child: CourseMaterialsPage(
              courseSectionId: courseSectionId,
              title: title,
            ),
          );
        },
      ),
    ],
  );
}
