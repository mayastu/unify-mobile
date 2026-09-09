import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Sits behind [HomeHeader]: a soft two-tone wave (same motif as
/// [BottomWave] on the splash screen) plus a handful of faint,
/// fixed-position icons — the same "floating campus icons" idea as
/// the splash screen's [AnimatedBackground], just static here since
/// Home already redraws often (pull-to-refresh, live cubit data) and
/// a second continuous animation would fight for attention instead
/// of staying in the background.
class HomeWaveHeader extends StatelessWidget {
  const HomeWaveHeader({super.key, required this.palette, required this.height});

  final AppPalette palette;
  final double height;

  static const _icons = [
    (Icons.school_outlined, Alignment(0.78, -0.85), 22.0),
    (Icons.mail_outline_rounded, Alignment(0.15, -0.55), 18.0),
    (Icons.calendar_today_outlined, Alignment(0.92, -0.15), 18.0),
    (Icons.people_outline_rounded, Alignment(-0.85, -0.25), 18.0),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _HeaderWavePainter(palette)),
          ),
          for (final (icon, alignment, size) in _icons)
            Align(
              alignment: alignment,
              child: Icon(icon, size: size, color: palette.iconFaint),
            ),
        ],
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  const _HeaderWavePainter(this.palette);

  final AppPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [palette.waveBlue, palette.waveGold],
      ).createShader(Offset.zero & size);

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.28, h * 0.85, w * 0.55, h * 0.6)
      ..quadraticBezierTo(w * 0.8, h * 0.4, w, h * 0.62)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeaderWavePainter oldDelegate) =>
      oldDelegate.palette != palette;
}
