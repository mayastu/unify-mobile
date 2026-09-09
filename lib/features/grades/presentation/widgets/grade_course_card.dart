import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/current_semester_grades_model.dart';

class GradeCourseCard extends StatelessWidget {
  const GradeCourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  final GradeCourseModel course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final gradeColor = _gradeColor(course.letter);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: gradeColor.withOpacity(.12),
              ),
            ),
            child: Text(
              course.letter,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: gradeColor,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      course.courseCode,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      '${course.creditHours} credit hours',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (onTap != null) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _gradeColor(String grade) {
    final value = grade.toUpperCase().trim();

    if (value.startsWith('A')) {
      return Colors.green;
    }

    if (value.startsWith('B')) {
      return Colors.blue;
    }

    if (value.startsWith('C')) {
      return Colors.orange;
    }

    if (value.startsWith('D')) {
      return Colors.deepOrange;
    }

    if (value.startsWith('F')) {
      return Colors.red;
    }

    return AppColors.primary;
  }
}