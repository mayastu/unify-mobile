import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../data/models/course_model.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.palette,
    required this.index,
    this.onTap,
  });

  final CourseModel course;
  final AppPalette palette;
  final int index;
  final VoidCallback? onTap;

  // Was a purely decorative "01 / 02 / ..." index + dot before — same
  // spot now carries the course type instead, so it actually helps
  // scan a long list instead of just filling space.
  ({IconData icon, Color bg, Color fg}) get _typeStyle {
    switch (course.courseType) {
      case 'project':
        return (
          icon: Icons.rocket_launch_rounded,
          bg: palette.waveGold,
          fg: palette.secondary,
        );
      case 'theory_practical':
        return (
          icon: Icons.science_rounded,
          bg: palette.waveBlue,
          fg: palette.primary,
        );
      case 'theory':
      default:
        return (
          icon: Icons.menu_book_rounded,
          bg: palette.waveBlue,
          fg: palette.primary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeStyle = _typeStyle;

    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: palette.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeStyle.bg,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  typeStyle.icon,
                  color: typeStyle.fg,
                  size: 22,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseCode,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: palette.primary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        _InfoPill(
                          icon: Icons.credit_card_rounded,
                          text:
                          '${course.creditHours} Credits',
                          palette: palette,
                        ),

                        const SizedBox(width: 6),

                        Flexible(
                          child: _InfoPill(
                            icon: typeStyle.icon,
                            text:
                            course.displayCourseType,
                            palette: palette,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: palette.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    required this.palette,
  });

  final IconData icon;
  final String text;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: palette.textSecondary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
