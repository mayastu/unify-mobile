import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Faint icons and dots that slowly orbit in a ring around the logo.
/// Each icon counter-rotates against the ring's own rotation so it
/// stays upright while it revolves — like a small solar system.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<IconData> _icons = [
    Icons.school_outlined,
    Icons.mail_outline_rounded,
    Icons.people_outline_rounded,
    Icons.description_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.bar_chart_rounded,
    Icons.notifications_outlined,
    Icons.menu_book_outlined,
    Icons.calendar_today_outlined,
  ];

  static const List<_Dot> _dots = [
    _Dot(radiusFactor: .55, startAngle: .4, speedFactor: 1, size: 7, color: AppColors.primary),
    _Dot(radiusFactor: .82, startAngle: 2.1, speedFactor: -.7, size: 6, color: AppColors.secondary),
    _Dot(radiusFactor: .68, startAngle: 3.6, speedFactor: .8, size: 5, color: AppColors.border),
    _Dot(radiusFactor: .9, startAngle: 5.2, speedFactor: -1, size: 6, color: AppColors.secondary),
    _Dot(radiusFactor: .45, startAngle: 1.3, speedFactor: -.6, size: 5, color: AppColors.border),
    _Dot(radiusFactor: .78, startAngle: 4.4, speedFactor: .9, size: 7, color: AppColors.primary),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 46),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final ringRadius = width * 0.62;

    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, -0.32),
        child: SizedBox(
          width: ringRadius * 2,
          height: ringRadius * 2,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final baseAngle = _controller.value * 2 * math.pi;

              return Stack(
                alignment: Alignment.center,
                children: [
                  for (var i = 0; i < _icons.length; i++)
                    _OrbitingIcon(
                      icon: _icons[i],
                      radius: ringRadius,
                      angle: baseAngle +
                          (2 * math.pi / _icons.length) * i,
                    ),
                  for (final dot in _dots)
                    _OrbitingDot(
                      radius: ringRadius * dot.radiusFactor,
                      angle: baseAngle * dot.speedFactor + dot.startAngle,
                      size: dot.size,
                      color: dot.color,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrbitingIcon extends StatelessWidget {
  const _OrbitingIcon({
    required this.icon,
    required this.radius,
    required this.angle,
  });

  final IconData icon;
  final double radius;
  final double angle;

  @override
  Widget build(BuildContext context) {
    final offset = Offset(radius * math.cos(angle), radius * math.sin(angle));

    return Transform.translate(
      offset: offset,
      child: Icon(icon, size: 22, color: AppColors.icon),
    );
  }
}

class _OrbitingDot extends StatelessWidget {
  const _OrbitingDot({
    required this.radius,
    required this.angle,
    required this.size,
    required this.color,
  });

  final double radius;
  final double angle;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final offset = Offset(radius * math.cos(angle), radius * math.sin(angle));

    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Dot {
  const _Dot({
    required this.radiusFactor,
    required this.startAngle,
    required this.speedFactor,
    required this.size,
    required this.color,
  });

  final double radiusFactor;
  final double startAngle;
  final double speedFactor;
  final double size;
  final Color color;
}