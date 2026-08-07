import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Two soft, overlapping wave layers pinned to the bottom of the
/// screen, blending from waveBlue to waveGold.
class BottomWave extends StatelessWidget {
  const BottomWave({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: SizedBox(
          height: 260,
          width: double.infinity,
          child: CustomPaint(painter: _WavePainter()),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.waveBlue, AppColors.waveGold],
      ).createShader(Offset.zero & size);

    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.waveBlue.withOpacity(0.85),
          AppColors.waveGold.withOpacity(0.85),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawPath(_wavePath(size, liftFactor: 0.34, dip: 0.16), backPaint);
    canvas.drawPath(_wavePath(size, liftFactor: 0.22, dip: 0.24), frontPaint);
  }

  Path _wavePath(Size size, {required double liftFactor, required double dip}) {
    final w = size.width;
    final h = size.height;
    final top = h * liftFactor;

    return Path()
      ..moveTo(0, top + h * dip)
      ..quadraticBezierTo(w * 0.25, top - h * dip, w * 0.5, top)
      ..quadraticBezierTo(w * 0.75, top + h * dip, w, top - h * dip * 0.4)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}