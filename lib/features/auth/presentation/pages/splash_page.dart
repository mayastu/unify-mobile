import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/bottom_wave.dart';
import '../widgets/loading_bar.dart';
import '../widgets/splash_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Stack(
        children: [
          AnimatedBackground(),
          BottomWave(),
          Center(
            child: SplashLogo(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: Center(
              child: LoadingBar(),
            ),
          ),
        ],
      ),
    );
  }
}