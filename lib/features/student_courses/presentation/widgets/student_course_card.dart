import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../course_sections/data/models/course_section_model.dart';
import '../../data/models/student_course_model.dart';

class StudentCourseCard extends StatelessWidget {
  const StudentCourseCard({
    super.key,
    required this.studentCourse,
    required this.isWithdrawing,
    required this.onWithdraw,
  });

  final StudentCourseModel studentCourse;
  final bool isWithdrawing;
  final VoidCallback onWithdraw;

  Color get _statusColor {
    switch (studentCourse.status) {
      case 'enrolled':
        return AppColors.primary;
      case 'completed':
        return const Color(0xFF16A34A);
      case 'failed':
        return const Color(0xFFDC2626);
      case 'withdrawn':
      default:
        return AppColors.textSecondary;
    }
  }

  void _openMaterials(BuildContext context) {
    final sections = studentCourse.sections;
    if (sections.isEmpty) return;

    // Most enrollments are in a single section — go straight there.
    // A `theory_practical` course can enroll the student in two
    // (theory + practical), so only then ask which one.
    if (sections.length == 1) {
      _goToSection(context, sections.first);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: sections.map((section) {
            return ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: Text(section.displaySectionType),
              subtitle: Text(section.sectionName),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _goToSection(context, section);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _goToSection(BuildContext context, CourseSectionModel section) {
    context.push('/course-sections/${section.id}/materials', extra: section);
  }

  @override
  Widget build(BuildContext context) {
    final course = studentCourse.course;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${course.courseCode} · ${course.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${studentCourse.semester.name} · Attempt ${studentCourse.attemptNo}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: studentCourse.displayStatus,
                color: _statusColor,
              ),
            ],
          ),
          if (studentCourse.finalGrade != null) ...[
            const SizedBox(height: 12),
            Text(
              'Final grade: ${studentCourse.finalGrade}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            children: [
              TextButton.icon(
                onPressed: () => context.push(
                  '/my-courses/${studentCourse.id}/attendance',
                  extra: studentCourse,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(Icons.event_available_outlined, size: 16),
                label: const Text('Attendance'),
              ),
              if (studentCourse.sections.isNotEmpty)
                TextButton.icon(
                  onPressed: () => _openMaterials(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.folder_open_outlined, size: 16),
                  label: const Text('Materials'),
                ),
            ],
          ),
          if (studentCourse.canWithdraw) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isWithdrawing ? null : onWithdraw,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: isWithdrawing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFDC2626),
                        ),
                      )
                    : const Icon(Icons.close_rounded, size: 16),
                label: Text(isWithdrawing ? 'Withdrawing…' : 'Withdraw'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
