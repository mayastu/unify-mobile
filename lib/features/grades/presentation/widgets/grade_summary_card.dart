import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/current_semester_grades_model.dart';

class GradeSummaryCard extends StatelessWidget {
  const GradeSummaryCard({
    super.key,
    required this.grades,
  });

  final CurrentSemesterGradesModel grades;

  @override
  Widget build(BuildContext context) {
    final gpa = double.tryParse(grades.gpa) ?? 0;

    // Assuming a 4.0 GPA scale.
    // If your university uses another scale, change this value.
    final progress = (gpa / 4.0).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grades.semester.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Academic performance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(.12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_graph_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Current',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              SizedBox(
                width: 118,
                height: 118,
                child: CustomPaint(
                  painter: _GpaRingPainter(
                    progress: progress,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          grades.gpa,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'GPA',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 22),

              Expanded(
                child: Column(
                  children: [
                    _SummaryStat(
                      icon: Icons.menu_book_rounded,
                      label: 'Registered',
                      value: grades.registeredCreditHours,
                    ),
                    const SizedBox(height: 12),
                    _SummaryStat(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Earned',
                      value: grades.earnedCreditHours,
                    ),
                    const SizedBox(height: 12),
                    _SummaryStat(
                      icon: Icons.close_rounded,
                      label: 'Failed',
                      value: grades.failedCreditHours,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            height: 1,
            color: Colors.white.withOpacity(.10),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                _performanceIcon(progress),
                size: 17,
                color: Colors.white70,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _performanceLabel(progress),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.school_rounded,
                size: 16,
                color: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _performanceIcon(double progress) {
    if (progress >= .875) return Icons.emoji_events_rounded;
    if (progress >= .75) return Icons.trending_up_rounded;
    if (progress >= .5) return Icons.insights_rounded;
    return Icons.warning_amber_rounded;
  }

  String _performanceLabel(double progress) {
    if (progress >= .875) return 'Excellent academic performance';
    if (progress >= .75) return 'Strong academic performance';
    if (progress >= .5) return 'Keep working on your performance';
    return 'Your academic performance needs attention';
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _GpaRingPainter extends CustomPainter {
  const _GpaRingPainter({
    required this.progress,
  });

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = math.min(
      size.width,
      size.height,
    ) /
        2 -
        8;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(.12);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GpaRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}