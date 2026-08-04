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
}
