import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
        ),

        BlocProvider<SplashCubit>(
          create: (_) => sl<SplashCubit>(),
        ),

      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Unify',
        theme: ThemeData(
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}