import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: .7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    context.read<SplashCubit>().start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<SplashCubit, SplashState>(

      listener: (context, state) {

        if (state is SplashNavigateLogin) {

          context.go("/login");

        }

      },

      child: Scaffold(

        body: Stack(

          children: [

            /// Background
            Container(

              decoration: const BoxDecoration(

                gradient: LinearGradient(

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                  colors: [

                    Color(0xff18216D),

                    Color(0xff283593),

                  ],

                ),

              ),

            ),

            /// Background Circles

            Positioned(
              top: -80,
              right: -60,
              child: _circle(260, Colors.white10),
            ),

            Positioned(
              left: -60,
              bottom: 70,
              child: _circle(170, Colors.white10),
            ),

            Positioned(
              top: 150,
              left: 30,
              child: _circle(100, Colors.white10),
            ),

            SafeArea(

              child: Column(

                children: [

                  const Spacer(),

                  ScaleTransition(

                    scale: _scaleAnimation,

                    child: FadeTransition(

                      opacity: _fadeAnimation,

                      child: Container(

                        padding: const EdgeInsets.all(22),

                        decoration: BoxDecoration(

                          color: Colors.white.withOpacity(.08),

                          borderRadius: BorderRadius.circular(28),

                          border: Border.all(
                            color: Colors.white24,
                          ),

                        ),

                        child: Image.asset(

                          "assets/images/logo.svg",

                          width: 95,

                        ),

                      ),

                    ),

                  ),

                  const SizedBox(height: 30),

                  SlideTransition(

                    position: _slideAnimation,

                    child: FadeTransition(

                      opacity: _fadeAnimation,

                      child: const Text(

                        "Unify",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 44,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                    ),

                  ),

                  const SizedBox(height: 10),

                  FadeTransition(

                    opacity: _fadeAnimation,

                    child: const Text(

                      "Your Academic Life, Unified",

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 16,

                      ),

                    ),

                  ),

                  const Spacer(),

                  const _LoadingDots(),

                  const SizedBox(height: 25),

                  const Text(

                    "v1.0.0",

                    style: TextStyle(

                      color: Colors.white54,

                    ),

                  ),

                  const SizedBox(height: 25),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

  Widget _circle(double size, Color color) {

    return Container(

      width: size,

      height: size,

      decoration: BoxDecoration(

        color: color,

        shape: BoxShape.circle,

      ),

    );

  }

}

class _LoadingDots extends StatefulWidget {

  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();

}

class _LoadingDotsState extends State<_LoadingDots> {

  int index = 0;

  @override
  void initState() {

    super.initState();

    Future.doWhile(() async {

      await Future.delayed(
        const Duration(milliseconds: 350),
      );

      if (!mounted) return false;

      setState(() {

        index++;

      });

      return true;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(

        4,

            (i) {

          return AnimatedContainer(

            duration: const Duration(milliseconds: 250),

            margin: const EdgeInsets.symmetric(horizontal: 5),

            width: i == index % 4 ? 12 : 8,

            height: i == index % 4 ? 12 : 8,

            decoration: BoxDecoration(

              color: i == index % 4
                  ? const Color(0xffFDB813)
                  : Colors.white30,

              shape: BoxShape.circle,

            ),

          );

        },

      ),

    );

  }

}