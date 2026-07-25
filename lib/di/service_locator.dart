import 'package:get_it/get_it.dart';
import 'package:unify/core/api/api_consumer.dart';
import 'package:unify/core/api/dio_consumer.dart';
import 'package:unify/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:unify/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:unify/features/auth/data/repositories/auth_repository.dart';
import 'package:unify/features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ApiConsumer>(
      () => DioConsumer());
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiConsumer>()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));
  sl.registerFactory(() => AuthCubit(
        sl<AuthRepository>(),
      ));
}
