import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/academic_page_header.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/grades_cubit.dart';
import '../cubit/grades_state.dart';
import '../widgets/grade_course_card.dart';
import '../widgets/grade_summary_card.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

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
            child: BlocBuilder<GradesCubit, GradesState>(
              builder: (context, state) {
                if (state is GradesLoading ||
                    state is GradesInitial) {
                  return _Loading(
                    palette: palette,
                  );
                }

                if (state is GradesFailure) {
                  return AppEmpty(
                    icon: Icons.school_outlined,
                    message: state.message,
                    actionText: 'Retry',
                    onAction: () => context
                        .read<GradesCubit>()
                        .getCurrentSemesterGrades(),
                  );
                }

                final grades =
                    (state as GradesSuccess).grades;

                if (grades.courses.isEmpty) {
                  return const AppEmpty(
                    icon: Icons.grade_outlined,
                    message:
                    'No grades yet for this semester.',
                  );
                }

                return RefreshIndicator(
                  color: palette.primary,
                  onRefresh: () => context
                      .read<GradesCubit>()
                      .getCurrentSemesterGrades(),
                  child: ListView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),
                    children: [
                      AcademicPageHeader(
                        palette: palette,
                        title: 'Academic Record',
                        subtitle:
                        'Track your grades and academic performance.',
                        eyebrow: 'My academics',
                        badgeText:
                        '${grades.courses.length} courses',
                        metaText:
                        grades.semester.name,
                        icon: Icons.school_rounded,
                      ),

                      const SizedBox(height: 22),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: GradeSummaryCard(
                          grades: grades,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your courses',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight:
                                      FontWeight.w800,
                                      color:
                                      palette.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap a course to view its grade breakdown.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                      palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: palette.surface,
                                borderRadius:
                                BorderRadius.circular(12),
                                border: Border.all(
                                  color: palette.border,
                                ),
                              ),
                              child: Text(
                                '${grades.courses.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w800,
                                  color:
                                  palette.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            for (int i = 0;
                            i < grades.courses.length;
                            i++) ...[
                              Builder(
                                builder: (context) {
                                  final course =
                                  grades.courses[i];

                                  final courseId =
                                  int.tryParse(
                                    course.courseId,
                                  );

                                  return GradeCourseCard(
                                    course: course,
                                    onTap:
                                    courseId == null
                                        ? null
                                        : () => context.push(
                                      '/grades/$courseId',
                                      extra: course,
                                    ),
                                  );
                                },
                              ),

                              if (i !=
                                  grades.courses.length - 1)
                                const SizedBox(height: 10),
                            ],
                          ],
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

class _Loading extends StatelessWidget {
  const _Loading({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AcademicPageHeader(
          palette: palette,
          title: 'Academic Record',
          subtitle:
          'Track your grades and academic performance.',
          badgeText: 'Loading',
          metaText: 'My academics',
          icon: Icons.school_rounded,
        ),
        const SizedBox(height: 40),
        CircularProgressIndicator(
          color: palette.primary,
          strokeWidth: 2.5,
        ),
      ],
    );
  }
}