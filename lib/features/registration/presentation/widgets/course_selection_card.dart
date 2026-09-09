import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../course_sections/data/models/course_section_model.dart';
import '../../data/models/available_course_model.dart';

typedef SectionSelection = Map<String, int?>;

class CourseSelectionCard extends StatefulWidget {
  const CourseSelectionCard({
    super.key,
    required this.availableCourse,
    required this.selection,
    required this.onSectionSelected,
    this.palette = AppPalette.light,
    this.initiallyExpanded = false,
  });

  final AvailableCourseModel availableCourse;
  final SectionSelection selection;
  final void Function(String type, int? sectionId)
  onSectionSelected;
  final AppPalette palette;
  final bool initiallyExpanded;

  static bool needsBothTheoryAndPractical(
      AvailableCourseModel course,
      ) {
    return course.theorySections.isNotEmpty &&
        course.practicalSections.isNotEmpty;
  }

  static bool isComplete(
      AvailableCourseModel course,
      SectionSelection selection,
      ) {
    final hasTheory = course.theorySections.isNotEmpty;
    final hasPractical =
        course.practicalSections.isNotEmpty;
    final hasProject = course.projectSections.isNotEmpty;

    if (hasTheory && hasPractical) {
      return selection['theory'] != null &&
          selection['practical'] != null;
    }

    if (hasTheory) {
      return selection['theory'] != null;
    }

    if (hasPractical) {
      return selection['practical'] != null;
    }

    if (hasProject) {
      return selection['project'] != null;
    }

    return false;
  }

  static bool isTouched(
      SectionSelection selection,
      ) {
    return selection.values.any(
          (id) => id != null,
    );
  }

  @override
  State<CourseSelectionCard> createState() =>
      _CourseSelectionCardState();
}

class _CourseSelectionCardState
    extends State<CourseSelectionCard> {
  late bool _expanded =
      widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final course = widget.availableCourse.course;
    final selection = widget.selection;

    final complete = CourseSelectionCard.isComplete(
      widget.availableCourse,
      selection,
    );

    final touched = CourseSelectionCard.isTouched(
      selection,
    );

    final incomplete = touched && !complete;

    final needsBoth =
    CourseSelectionCard.needsBothTheoryAndPractical(
      widget.availableCourse,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: complete
              ? palette.secondary
              : incomplete
              ? palette.secondary.withOpacity(0.55)
              : palette.border,
          width: complete || incomplete ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              palette.brightness ==
                  Brightness.dark
                  ? 0.14
                  : 0.035,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _CourseHeader(
            course: course,
            palette: palette,
            complete: complete,
            incomplete: incomplete,
            expanded: _expanded,
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),

          AnimatedSize(
            duration:
            const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: _expanded
                ? Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  if (needsBoth) ...[
                    const SizedBox(height: 2),
                    _PairingHint(
                      palette: palette,
                      incomplete: incomplete,
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (widget
                      .availableCourse
                      .theorySections
                      .isNotEmpty)
                    _SectionTypeGroup(
                      label: 'Theory',
                      sections: widget
                          .availableCourse
                          .theorySections,
                      selectedId:
                      selection['theory'],
                      palette: palette,
                      onChanged: (id) =>
                          widget.onSectionSelected(
                            'theory',
                            id,
                          ),
                    ),

                  if (widget
                      .availableCourse
                      .practicalSections
                      .isNotEmpty)
                    _SectionTypeGroup(
                      label: 'Practical',
                      sections: widget
                          .availableCourse
                          .practicalSections,
                      selectedId:
                      selection['practical'],
                      palette: palette,
                      onChanged: (id) =>
                          widget.onSectionSelected(
                            'practical',
                            id,
                          ),
                    ),

                  if (widget
                      .availableCourse
                      .projectSections
                      .isNotEmpty)
                    _SectionTypeGroup(
                      label: 'Project',
                      sections: widget
                          .availableCourse
                          .projectSections,
                      selectedId:
                      selection['project'],
                      palette: palette,
                      onChanged: (id) =>
                          widget.onSectionSelected(
                            'project',
                            id,
                          ),
                    ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _CourseHeader extends StatelessWidget {
  const _CourseHeader({
    required this.course,
    required this.palette,
    required this.complete,
    required this.incomplete,
    required this.expanded,
    required this.onTap,
  });

  final dynamic course;
  final AppPalette palette;
  final bool complete;
  final bool incomplete;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            12,
            16,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration:
                const Duration(milliseconds: 220),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: complete
                      ? palette.secondary
                      .withOpacity(0.14)
                      : palette.primary
                      .withOpacity(0.07),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  complete
                      ? Icons.check_rounded
                      : Icons.menu_book_rounded,
                  color: complete
                      ? palette.secondary
                      : palette.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${course.courseCode} · ${course.name}',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${course.creditHours} credit hrs · ${course.displayCourseType}',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color:
                        palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              if (complete)
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: 1,
                  ),
                  duration:
                  const Duration(milliseconds: 350),
                  curve: Curves.elasticOut,
                  builder:
                      (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: palette.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: palette.primary,
                      size: 18,
                    ),
                  ),
                )
              else if (incomplete)
                Icon(
                  Icons.info_outline_rounded,
                  color: palette.secondary,
                  size: 21,
                ),

              const SizedBox(width: 4),

              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration:
                const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                child: Icon(
                  Icons.expand_more_rounded,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairingHint extends StatelessWidget {
  const _PairingHint({
    required this.palette,
    required this.incomplete,
  });

  final AppPalette palette;
  final bool incomplete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: incomplete
            ? palette.secondary.withOpacity(0.14)
            : palette.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: incomplete
              ? palette.secondary.withOpacity(0.35)
              : palette.border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            incomplete
                ? Icons.info_outline_rounded
                : Icons.link_rounded,
            size: 17,
            color: incomplete
                ? palette.secondary
                : palette.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This course requires both a theory section and a practical section.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
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

class _SectionTypeGroup extends StatelessWidget {
  const _SectionTypeGroup({
    required this.label,
    required this.sections,
    required this.selectedId,
    required this.palette,
    required this.onChanged,
  });

  final String label;
  final List<CourseSectionModel> sections;
  final int? selectedId;
  final AppPalette palette;
  final void Function(int? id) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: palette.primary
                      .withOpacity(0.06),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  'Choose one',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                    FontWeight.w700,
                    color: palette.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        ...sections.map(
              (section) => Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: _SectionOption(
              section: section,
              selected:
              selectedId == section.id,
              palette: palette,
              onTap: () {
                onChanged(
                  selectedId == section.id
                      ? null
                      : section.id,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 4),
      ],
    );
  }
}

class _SectionOption extends StatelessWidget {
  const _SectionOption({
    required this.section,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final CourseSectionModel section;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final capacity = section.capacity;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(17),
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected
                ? palette.primary
                .withOpacity(0.055)
                : palette.surfaceElevated,
            borderRadius:
            BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? palette.primary
                  : palette.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              _AnimatedRadio(
                selected: selected,
                palette: palette,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.sectionName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color:
                        palette.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      section.instructor
                          ?.fullName ??
                          'Instructor TBA',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color:
                        palette.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _CapacityIndicator(
                      capacity: capacity,
                      palette: palette,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              AnimatedSwitcher(
                duration:
                const Duration(milliseconds: 180),
                child: selected
                    ? Icon(
                  Icons.check_circle_rounded,
                  key: const ValueKey('selected'),
                  color: palette.secondary,
                  size: 21,
                )
                    : Icon(
                  Icons.arrow_forward_ios_rounded,
                  key: const ValueKey('idle'),
                  color:
                  palette.textSecondary
                      .withOpacity(0.45),
                  size: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedRadio extends StatelessWidget {
  const _AnimatedRadio({
    required this.selected,
    required this.palette,
  });

  final bool selected;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      width: 23,
      height: 23,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? palette.secondary
            : Colors.transparent,
        border: Border.all(
          color: selected
              ? palette.secondary
              : palette.textSecondary,
          width: 1.7,
        ),
      ),
      child: AnimatedScale(
        duration:
        const Duration(milliseconds: 180),
        scale: selected ? 1 : 0,
        child: Icon(
          Icons.check_rounded,
          color: palette.primary,
          size: 15,
        ),
      ),
    );
  }
}

class _CapacityIndicator extends StatelessWidget {
  const _CapacityIndicator({
    required this.capacity,
    required this.palette,
  });

  final int capacity;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.people_alt_outlined,
          size: 15,
          color: palette.textSecondary,
        ),
        const SizedBox(width: 5),
        Text(
          '$capacity seats',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: palette.textSecondary,
          ),
        ),
      ],
    );
  }
}