import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../course_sections/data/models/course_section_model.dart';
import '../../data/models/available_course_model.dart';

/// Section type -> chosen section id (or null if nothing picked yet).
typedef SectionSelection = Map<String, int?>;

class CourseSelectionCard extends StatelessWidget {
  const CourseSelectionCard({
    super.key,
    required this.availableCourse,
    required this.selection,
    required this.onSectionSelected,
  });

  final AvailableCourseModel availableCourse;
  final SectionSelection selection;
  final void Function(String type, int? sectionId) onSectionSelected;

  int get _selectedCount =>
      selection.values.where((id) => id != null).length;

  @override
  Widget build(BuildContext context) {
    final course = availableCourse.course;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            '${course.courseCode} · ${course.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            '${course.creditHours} credit hrs · ${course.displayCourseType}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: _selectedCount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_selectedCount selected',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                )
              : const Icon(
                  Icons.expand_more_rounded,
                  color: AppColors.textMuted,
                ),
          children: [
            if (availableCourse.theorySections.isNotEmpty)
              _SectionTypeGroup(
                label: 'Theory',
                sections: availableCourse.theorySections,
                selectedId: selection['theory'],
                onChanged: (id) => onSectionSelected('theory', id),
              ),
            if (availableCourse.practicalSections.isNotEmpty)
              _SectionTypeGroup(
                label: 'Practical',
                sections: availableCourse.practicalSections,
                selectedId: selection['practical'],
                onChanged: (id) => onSectionSelected('practical', id),
              ),
            if (availableCourse.projectSections.isNotEmpty)
              _SectionTypeGroup(
                label: 'Project',
                sections: availableCourse.projectSections,
                selectedId: selection['project'],
                onChanged: (id) => onSectionSelected('project', id),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionTypeGroup extends StatelessWidget {
  const _SectionTypeGroup({
    required this.label,
    required this.sections,
    required this.selectedId,
    required this.onChanged,
  });

  final String label;
  final List<CourseSectionModel> sections;
  final int? selectedId;
  final void Function(int? id) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...sections.map(
          (section) => RadioListTile<int>(
            value: section.id,
            groupValue: selectedId,
            onChanged: onChanged,
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
            title: Text(
              section.sectionName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              '${section.instructor?.fullName ?? 'Instructor TBA'} · ${section.capacity} seats',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
