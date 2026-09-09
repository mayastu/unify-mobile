import 'package:get_it/get_it.dart';
import 'package:unify/core/api/api_consumer.dart';
import 'package:unify/core/api/dio_consumer.dart';
import 'package:unify/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:unify/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:unify/features/auth/data/repositories/auth_repository.dart';
import 'package:unify/features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/splash_cubit.dart';
import '../features/courses/data/data_source/course_remote_datasource.dart';
import '../features/courses/data/data_source/course_remote_datasource_impl.dart';
import '../features/courses/data/repositories/course_repository.dart';
import '../features/courses/data/repositories/course_repository_impl.dart';
import '../features/courses/presentation/cubit/course_cubit.dart';
import '../features/course_sections/data/data_source/course_section_remote_datasource.dart';
import '../features/course_sections/data/data_source/course_section_remote_datasource_impl.dart';
import '../features/course_sections/data/repositories/course_section_repository.dart';
import '../features/course_sections/data/repositories/course_section_repository_impl.dart';
import '../features/classrooms/data/data_source/classroom_remote_datasource.dart';
import '../features/classrooms/data/data_source/classroom_remote_datasource_impl.dart';
import '../features/classrooms/data/repositories/classroom_repository.dart';
import '../features/classrooms/data/repositories/classroom_repository_impl.dart';
import '../features/classrooms/presentation/cubit/classroom_cubit.dart';
import '../features/grades/data/datasource/grades_remote_datasource.dart';
import '../features/grades/data/datasource/grades_remote_datasource_impl.dart';
import '../features/grades/data/repositories/grades_repository.dart';
import '../features/grades/data/repositories/grades_repository_impl.dart';
import '../features/grades/presentation/cubit/grades_cubit.dart';
import '../features/grades/presentation/cubit/grade_breakdown_cubit.dart';
import '../features/grade_objections/data/data_source/grade_objection_remote_datasource.dart';
import '../features/grade_objections/data/data_source/grade_objection_remote_datasource_impl.dart';
import '../features/grade_objections/data/repositories/grade_objection_repository.dart';
import '../features/grade_objections/data/repositories/grade_objection_repository_impl.dart';
import '../features/grade_objections/presentation/cubit/grade_objection_cubit.dart';
import '../features/grade_objections/presentation/cubit/my_objections_cubit.dart';
import '../features/course_materials/data/data_source/course_material_remote_datasource.dart';
import '../features/course_materials/data/data_source/course_material_remote_datasource_impl.dart';
import '../features/course_materials/data/repositories/course_material_repository.dart';
import '../features/course_materials/data/repositories/course_material_repository_impl.dart';
import '../features/course_materials/data/services/material_download_service.dart';
import '../features/course_materials/presentation/cubit/course_material_cubit.dart';
import '../features/attendance/data/datasource/attendance_remote_datasource.dart';
import '../features/attendance/data/datasource/attendance_remote_datasource_impl.dart';
import '../features/attendance/data/repositories/attendance_repository.dart';
import '../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../features/attendance/presentation/cubit/attendance_summary_cubit.dart';
import '../features/notifications/data/data_source/notification_remote_datasource.dart';
import '../features/notifications/data/data_source/notification_remote_datasource_impl.dart';
import '../features/notifications/data/repositories/notification_repository.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/presentation/cubit/notification_cubit.dart';
import '../features/announcements/data/data_source/announcement_remote_datasource.dart';
import '../features/announcements/data/data_source/announcement_remote_datasource_impl.dart';
import '../features/announcements/data/repositories/announcement_repository.dart';
import '../features/announcements/data/repositories/announcement_repository_impl.dart';
import '../features/announcements/presentation/cubit/announcement_cubit.dart';
import '../features/system_settings/data/data_source/system_settings_remote_datasource.dart';
import '../features/system_settings/data/data_source/system_settings_remote_datasource_impl.dart';
import '../features/system_settings/data/repositories/system_settings_repository.dart';
import '../features/system_settings/data/repositories/system_settings_repository_impl.dart';
import '../features/system_settings/presentation/cubit/system_settings_cubit.dart';
import '../features/schedule/data/data_source/student_schedule_remote_datasource.dart';
import '../features/schedule/data/data_source/student_schedule_remote_datasource_impl.dart';
import '../features/schedule/data/repositories/student_schedule_repository.dart';
import '../features/schedule/data/repositories/student_schedule_repository_impl.dart';
import '../features/schedule/presentation/cubit/student_schedule_cubit.dart';
import '../features/course_sections/presentation/cubit/course_section_cubit.dart';
import '../features/registration/data/data_source/registration_remote_datasource.dart';
import '../features/registration/data/data_source/registration_remote_datasource_impl.dart';
import '../features/registration/data/repositories/registration_repository.dart';
import '../features/registration/data/repositories/registration_repository_impl.dart';
import '../features/registration/presentation/cubit/registration_cubit.dart';
import '../features/student_courses/data/data_source/student_course_remote_datasource.dart';
import '../features/student_courses/data/data_source/student_course_remote_datasource_impl.dart';
import '../features/student_courses/data/repositories/student_course_repository.dart';
import '../features/student_courses/data/repositories/student_course_repository_impl.dart';
import '../features/student_courses/presentation/cubit/student_course_cubit.dart';
import '../features/financial_account/data/data_source/financial_remote_datasource.dart';
import '../features/financial_account/data/data_source/financial_remote_datasource_impl.dart';
import '../features/financial_account/data/repositories/financial_repository.dart';
import '../features/financial_account/data/repositories/financial_repository_impl.dart';
import '../features/financial_account/presentation/cubit/financial_cubit.dart';
import '../features/payment/data/data_source/payment_remote_datasource.dart';
import '../features/payment/data/data_source/payment_remote_datasource_impl.dart';
import '../features/payment/data/repositories/payment_repository.dart';
import '../features/payment/data/repositories/payment_repository_impl.dart';
import '../features/payment/presentation/cubit/payment_cubit.dart';
import '../features/profile/data/data_source/student_remote_datasource.dart';
import '../features/profile/data/data_source/student_remote_datasource_impl.dart';
import '../features/profile/data/repositories/student_repository.dart';
import '../features/profile/data/repositories/student_repository_impl.dart';
import '../features/profile/presentation/cubit/student_cubit.dart';
import '../features/semesters/data/datasource/semester_remote_datasource.dart';
import '../features/semesters/data/datasource/semester_remote_datasource_impl.dart';
import '../features/semesters/data/repositories/semester_repository.dart';
import '../features/semesters/data/repositories/semester_repository_impl.dart';
import '../features/semesters/presentation/cubit/semester_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer());
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiConsumer>()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));
  sl.registerFactory(() => AuthCubit(
        sl<AuthRepository>(),
      ));
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(),
  );

  // DataSource
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(sl()),
  );

// Repository
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(sl()),
  );

// Cubit
  sl.registerFactory(
    () => StudentCubit(sl()),
  );

  sl.registerLazySingleton<SemesterRemoteDataSource>(
    () => SemesterRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<SemesterRepository>(
    () => SemesterRepositoryImpl(sl()),
  );

  sl.registerFactory(
    () => SemesterCubit(sl()),
  );

  // DataSource
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl()),
  );

// Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );

// Cubit
  sl.registerFactory(
    () => PaymentCubit(sl()),
  );

  sl.registerLazySingleton<FinancialRemoteDataSource>(
        () => FinancialRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<FinancialRepository>(
        () => FinancialRepositoryImpl(sl()),
  );

  sl.registerFactory(
        () => FinancialCubit(sl()),
  );

  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(sl()),
  );

  sl.registerFactory(
    () => CourseCubit(sl()),
  );

  sl.registerLazySingleton<CourseSectionRemoteDataSource>(
    () => CourseSectionRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CourseSectionRepository>(
    () => CourseSectionRepositoryImpl(sl()),
  );

  sl.registerFactory(
    () => CourseSectionCubit(sl()),
  );

  sl.registerLazySingleton<RegistrationRemoteDataSource>(
    () => RegistrationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepositoryImpl(sl()),
  );

  sl.registerFactory(
    () => RegistrationCubit(sl()),
  );

  sl.registerLazySingleton<StudentCourseRemoteDataSource>(
    () => StudentCourseRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<StudentCourseRepository>(
    () => StudentCourseRepositoryImpl(sl()),
  );

  // Also takes RegistrationRepository — withdrawing hits the
  // registration module's endpoint, so this cubit reuses that
  // repository instead of duplicating the withdraw call.
  sl.registerFactory(
    () => StudentCourseCubit(sl(), sl()),
  );

  sl.registerLazySingleton<ClassroomRemoteDataSource>(
    () => ClassroomRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(sl()),
  );

  sl.registerFactory(
    () => ClassroomCubit(sl()),
  );

  sl.registerLazySingleton<StudentScheduleRemoteDataSource>(
    () => StudentScheduleRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<StudentScheduleRepository>(
    () => StudentScheduleRepositoryImpl(sl()),
  );

  sl.registerFactory(
    () => StudentScheduleCubit(sl()),
  );

  sl.registerLazySingleton<GradesRemoteDataSource>(
        () => GradesRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<GradesRepository>(
        () => GradesRepositoryImpl(sl()),
  );

  sl.registerFactory(
        () => GradesCubit(sl()),
  );

  sl.registerFactory(
        () => GradeBreakdownCubit(sl()),
  );

  sl.registerLazySingleton<GradeObjectionRemoteDataSource>(
        () => GradeObjectionRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<GradeObjectionRepository>(
        () => GradeObjectionRepositoryImpl(sl()),
  );

  sl.registerFactory(
        () => GradeObjectionCubit(sl()),
  );

  sl.registerFactory(
        () => MyObjectionsCubit(sl()),
  );

  sl.registerLazySingleton<CourseMaterialRemoteDataSource>(
        () => CourseMaterialRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CourseMaterialRepository>(
        () => CourseMaterialRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
        () => MaterialDownloadService(),
  );

  sl.registerFactory(
        () => CourseMaterialCubit(sl(), sl()),
  );

  sl.registerLazySingleton<AttendanceRemoteDataSource>(
        () => AttendanceRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AttendanceRepository>(
        () => AttendanceRepositoryImpl(sl()),
  );

  sl.registerFactory(
        () => AttendanceSummaryCubit(sl()),
  );

  // Registered as a singleton (not a factory) — the badge on Home and
  // the notifications list page must share the exact same cubit
  // instance so unread-count updates show up everywhere at once.
  sl.registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<NotificationCubit>(
        () => NotificationCubit(sl()),
  );

  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
        () => AnnouncementRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AnnouncementRepository>(
        () => AnnouncementRepositoryImpl(sl()),
  );

  sl.registerFactory(
        () => AnnouncementCubit(sl()),
  );

  sl.registerLazySingleton<SystemSettingsRemoteDataSource>(
        () => SystemSettingsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<SystemSettingsRepository>(
        () => SystemSettingsRepositoryImpl(sl()),
  );

  sl.registerFactory(
        () => SystemSettingsCubit(sl()),
  );
}
