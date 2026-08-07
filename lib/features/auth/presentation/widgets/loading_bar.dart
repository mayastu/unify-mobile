import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Three gold dots that gently pulse in sequence — a quiet "something
/// is loading" signal, no text.
class LoadingBar extends StatefulWidget {
  const LoadingBar({super.key});

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final phase = (_controller.value + i / 3) % 1.0;
              final pulse = 0.5 - 0.5 * math.cos(2 * math.pi * phase);

              return Opacity(
                opacity: 0.35 + 0.65 * pulse,
                child: Transform.scale(
                  scale: 0.65 + 0.35 * pulse,
                  child: const _Dot(),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
    );
  }
}