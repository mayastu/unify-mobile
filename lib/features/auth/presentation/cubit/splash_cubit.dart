import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unify/features/auth/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {

  SplashCubit() : super(SplashInitial());

  Future<void> start() async {

    await Future.delayed(
      const Duration(milliseconds: 2600),
    );

    // لاحقاً سنفحص وجود Token

    emit(SplashNavigateLogin());

  }

}


late AnimationController controller;

late Animation<double> fadeAnimation;

late Animation<double> scaleAnimation;

late Animation<Offset> slideAnimation;