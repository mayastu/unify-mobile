import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'bottom_wave.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.background,
        ),

        /// Same wave shape used on the splash screen, for consistency
        /// across the app instead of the flat decorative circles.
        const BottomWave(),

        /// Background Icons
        const Positioned(
          top: 120,
          left: 40,
          child: _BackgroundIcon(
            icon: Icons.calendar_month_outlined,
          ),
        ),

        const Positioned(
          top: 120,
          right: 50,
          child: _BackgroundIcon(
            icon: Icons.mail_outline,
          ),
        ),

        const Positioned(
          top: 65,
          child: Align(
            alignment: Alignment.topCenter,
            child: _BackgroundIcon(
              icon: Icons.school_outlined,
            ),
          ),
        ),

        const Positioned(
          top: 250,
          left: 35,
          child: _BackgroundIcon(
            icon: Icons.menu_book_outlined,
          ),
        ),

        const Positioned(
          top: 250,
          right: 35,
          child: _BackgroundIcon(
            icon: Icons.people_outline,
          ),
        ),

        const Positioned(
          bottom: 170,
          left: 50,
          child: _BackgroundIcon(
            icon: Icons.bar_chart_outlined,
          ),
        ),

        const Positioned(
          bottom: 170,
          right: 50,
          child: _BackgroundIcon(
            icon: Icons.chat_bubble_outline,
          ),
        ),

        const Positioned(
          bottom: 290,
          left: 25,
          child: _BackgroundIcon(
            icon: Icons.notifications_none,
          ),
        ),

        child,

        /// Decorative Dots
        const _Dot(
          top: 170,
          left: 110,
          color: AppColors.primary,
        ),

        const _Dot(
          top: 210,
          right: 80,
          color: AppColors.secondary,
        ),

        const _Dot(
          bottom: 230,
          right: 110,
          color: AppColors.primary,
        ),

        const _Dot(
          bottom: 190,
          left: 100,
          color: AppColors.secondary,
        ),

        const _Dot(
          top: 320,
          left: 75,
        ),

        const _Dot(
          top: 150,
          right: 150,
        ),

        const _Dot(
          bottom: 120,
          right: 40,
        ),
      ],
    );
  }
}

class _BackgroundIcon extends StatelessWidget {
  final IconData icon;

  const _BackgroundIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -3, end: 3),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: Icon(
        icon,
        color: AppColors.icon,
        size: 38,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;

  const _Dot({
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.color = const Color(0xffD7DBEB),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}