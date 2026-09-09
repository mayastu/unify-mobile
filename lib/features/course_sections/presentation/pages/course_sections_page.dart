import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/academic_page_header.dart';
import '../../../../core/widgets/app_empty.dart';

import '../../../courses/data/models/course_model.dart';
import '../cubit/course_section_cubit.dart';
import '../cubit/course_section_state.dart';
import '../widgets/course_section_card.dart';

class CourseSectionsPage extends StatelessWidget {
  const CourseSectionsPage({
    super.key,
    this.course,
  });

  final CourseModel? course;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette =
        isDark ? AppPalette.dark : AppPalette.light;

        return Scaffold(
          backgroundColor: palette.background,

          body: SafeArea(
            bottom: false,
            child: BlocBuilder<CourseSectionCubit, CourseSectionState>(
              builder: (context, state) {
                if (state is CourseSectionLoading ||
                    state is CourseSectionInitial) {
                  return _SectionsLoading(
                    palette: palette,
                  );
                }

                if (state is CourseSectionFailure) {
                  return AppEmpty(
                    icon: Icons.wifi_off_rounded,
                    message: state.message,
                    actionText: 'Retry',
                    onAction: () => context
                        .read<CourseSectionCubit>()
                        .getCourseSections(),
                  );
                }

                final allSections =
                    (state as CourseSectionSuccess).sections;

                final sections = course == null
                    ? allSections
                    : allSections
                    .where(
                      (section) =>
                  section.course?.id == course!.id,
                )
                    .toList();

                if (sections.isEmpty) {
                  return const AppEmpty(
                    icon: Icons.event_busy_rounded,
                    message: 'No sections offered yet.',
                  );
                }

                final title = course == null
                    ? 'Course Sections'
                    : course!.courseCode;

                final subtitle = course == null
                    ? 'Explore available sections this semester.'
                    : course!.name;

                return RefreshIndicator(
                  color: palette.primary,
                  onRefresh: () => context
                      .read<CourseSectionCubit>()
                      .getCourseSections(),

                  child: ListView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),

                    padding: const EdgeInsets.fromLTRB(
                      0,
                      0,
                      0,
                      40,
                    ),

                    children: [
                      AcademicPageHeader(
                        palette: palette,
                        title: title,
                        subtitle: subtitle,
                        badgeText:
                        '${sections.length} ${sections.length == 1 ? 'section' : 'sections'}',
                        metaText: 'Available',
                        icon: Icons.view_list_rounded,
                      ),

                      const SizedBox(height: 22),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Available sections',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: palette.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${sections.length}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: sections
                              .asMap()
                              .entries
                              .map(
                                (entry) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child:
                                TweenAnimationBuilder<
                                    double>(
                                  tween: Tween(
                                    begin: 0,
                                    end: 1,
                                  ),
                                  duration: Duration(
                                    milliseconds:
                                    260 +
                                        (entry.key *
                                            45),
                                  ),
                                  curve:
                                  Curves.easeOutCubic,
                                  builder: (
                                      context,
                                      value,
                                      child,
                                      ) {
                                    return Opacity(
                                      opacity: value,
                                      child:
                                      Transform.translate(
                                        offset: Offset(
                                          0,
                                          (1 - value) * 14,
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: CourseSectionCard(
                                    section: entry.value,
                                    showCourseName:
                                    course == null,
                                  ),
                                ),
                              );
                            },
                          )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SectionsLoading extends StatelessWidget {
  const _SectionsLoading({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AcademicPageHeader(
          palette: palette,
          title: 'Course Sections',
          subtitle: 'Explore available sections this semester.',
          badgeText: 'Loading',
          icon: Icons.view_list_rounded,
        ),

        const SizedBox(height: 30),

        CircularProgressIndicator(
          color: palette.primary,
          strokeWidth: 2.5,
        ),
      ],
    );
  }
}