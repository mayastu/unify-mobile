import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/splash_cubit.dart';
import 'features/notifications/presentation/cubit/notification_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await init();

  runApp(const MyApp());

  // Runs after the widget tree (and GoRouter) actually exist, so a
  // notification tap from a cold start has a router ready to navigate
  // on — calling this before runApp() risks pushing before any
  // navigator is attached.
  NotificationService.initialize();
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

        BlocProvider<NotificationCubit>(
          create: (_) => sl<NotificationCubit>(),
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