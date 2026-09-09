import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../data/models/course_model.dart';

// Note: no bottomNavigationBar here — this is a drill-down page
// pushed on top of the Courses tab (see /courses/:id in
// app_router.dart), outside AppShellScaffold, so the bar hiding here
// is intentional. It reappears automatically once the user pops back
// to the Courses tab.
class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({
    super.key,
    required this.course,
  });

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette = isDark
            ? AppPalette.dark
            : AppPalette.light;

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _CourseHero(
                    course: course,
                    palette: palette,
                  ),
                ),

                SliverToBoxAdapter(
                  child: _SectionTitle(
                    title: 'Course overview',
                    palette: palette,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: _StatsGrid(
                      course: course,
                      palette: palette,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      24,
                      20,
                      0,
                    ),
                    child: _SectionsButton(
                      course: course,
                      palette: palette,
                    ),
                  ),
                ),

                if (course.departments.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _SectionTitle(
                      title: 'Offered to',
                      palette: palette,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      4,
                    ),
                    sliver: SliverList.separated(
                      itemCount:
                      course.departments.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final department =
                        course.departments[index];

                        return _DepartmentCard(
                          department: department,
                          palette: palette,
                        );
                      },
                    ),
                  ),
                ],

                if (course.prerequisites.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _SectionTitle(
                      title: 'Prerequisites',
                      palette: palette,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      30,
                    ),
                    sliver: SliverList.separated(
                      itemCount:
                      course.prerequisites.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final prerequisite =
                        course.prerequisites[index];

                        return _PrerequisiteCard(
                          course: prerequisite,
                          palette: palette,
                          onTap: () {
                            context.push(
                              '/courses/${prerequisite.id}',
                              extra: prerequisite,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],

                if (course.prerequisites.isEmpty)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 30),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _CourseHero extends StatelessWidget {
  const _CourseHero({
    required this.course,
    required this.palette,
  });

  final CourseModel course;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      height: 225,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 15,
            bottom: -70,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                color: palette.secondary.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 28,
            top: 30,
            child: Icon(
              Icons.auto_stories_rounded,
              size: 78,
              color: Colors.white.withOpacity(0.08),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                          Colors.white.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: palette.secondary,
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Text(
                        course.displayCourseType
                            .toUpperCase(),
                        style: TextStyle(
                          color: palette.primary,
                          fontSize: 9,
                          fontWeight:
                          FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  course.courseCode,
                  style: TextStyle(
                    color: palette.secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  course.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.course,
    required this.palette,
  });

  final CourseModel course;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '${course.creditHours}',
            label: 'Credits',
            icon: Icons.workspace_premium_rounded,
            palette: palette,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '${course.contactHours}',
            label: 'Contact hrs',
            icon: Icons.schedule_rounded,
            palette: palette,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '${course.maxAbsences}',
            label: 'Max absences',
            icon: Icons.event_busy_rounded,
            palette: palette,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.palette,
  });

  final String value;
  final String label;
  final IconData icon;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        13,
        10,
        12,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: palette.waveBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: palette.primary,
              size: 15,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionsButton extends StatelessWidget {
  const _SectionsButton({
    required this.course,
    required this.palette,
  });

  final CourseModel course;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          context.push(
            '/course-sections',
            extra: course,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.groups_2_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offered sections',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Choose a section for this course',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: palette.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: palette.primary,
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


class _DepartmentCard extends StatelessWidget {
  const _DepartmentCard({
    required this.department,
    required this.palette,
  });

  final dynamic department;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.waveGold,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.apartment_rounded,
              color: palette.secondary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  department.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${department.studyYear} · ${department.studySemester}',
                  style: TextStyle(
                    fontSize: 11,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrerequisiteCard extends StatelessWidget {
  const _PrerequisiteCard({
    required this.course,
    required this.palette,
    required this.onTap,
  });

  final CourseModel course;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: palette.waveBlue,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: palette.primary,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseCode,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        color: palette.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.displayCourseType,
                      style: TextStyle(
                        fontSize: 10,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: palette.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: palette.textSecondary,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.palette,
  });

  final String title;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        12,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: palette.textPrimary,
        ),
      ),
    );
  }
}
