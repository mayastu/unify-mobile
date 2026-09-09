import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/academic_page_header.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../data/models/course_model.dart';
import '../cubit/course_cubit.dart';
import '../cubit/course_state.dart';
import '../widgets/course_card.dart';

// Note: no bottomNavigationBar here — this page lives inside the
// Courses branch of AppShellScaffold (see core/router/app_router.dart),
// which already supplies the persistent nav bar.
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _selectedFilter = 'all';

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
            child: BlocBuilder<CourseCubit, CourseState>(
              builder: (context, state) {
                if (state is CourseLoading ||
                    state is CourseInitial) {
                  return _Loading(
                    palette: palette,
                  );
                }

                if (state is CourseFailure) {
                  return _ErrorState(
                    palette: palette,
                    message: state.message,
                    onRetry: () {
                      context
                          .read<CourseCubit>()
                          .getCourses();
                    },
                  );
                }

                final courses =
                    (state as CourseSuccess).courses;

                if (courses.isEmpty) {
                  return AppEmpty(
                    icon: Icons.school_outlined,
                    message: 'No courses available yet.',
                  );
                }

                final filteredCourses =
                _filterCourses(courses);

                return RefreshIndicator(
                  color: palette.primary,
                  onRefresh: () {
                    return context
                        .read<CourseCubit>()
                        .getCourses();
                  },
                  child: CustomScrollView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: AcademicPageHeader(
                          palette: palette,
                          title: 'Courses',
                          subtitle: 'Keep track of your academic journey.',
                          badgeText: '${courses.length} courses',
                          metaText: 'This semester',
                          icon: Icons.auto_stories_rounded,
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: _CourseTypeFilter(
                          palette: palette,
                          selected: _selectedFilter,
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value;
                            });
                          },
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            24,
                            20,
                            12,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _selectedFilter == 'all'
                                    ? 'Your courses'
                                    : _filterTitle(
                                  _selectedFilter,
                                ),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                  FontWeight.w800,
                                  color:
                                  palette.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${filteredCourses.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w800,
                                  color: palette.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (filteredCourses.isEmpty)
                        SliverToBoxAdapter(
                          child: _NoFilteredCourses(
                            palette: palette,
                            filter: _filterTitle(
                              _selectedFilter,
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding:
                          const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            30,
                          ),
                          sliver: SliverList.separated(
                            itemCount:
                            filteredCourses.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                            itemBuilder:
                                (context, index) {
                              final course =
                              filteredCourses[index];

                              return CourseCard(
                                course: course,
                                palette: palette,
                                index: index,
                                onTap: () {
                                  context.push(
                                    '/courses/${course.id}',
                                    extra: course,
                                  );
                                },
                              );
                            },
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

  List<CourseModel> _filterCourses(
      List<CourseModel> courses,
      ) {
    if (_selectedFilter == 'all') {
      return courses;
    }

    return courses
        .where(
          (course) =>
      course.courseType == _selectedFilter,
    )
        .toList();
  }

  String _filterTitle(String filter) {
    switch (filter) {
      case 'theory':
        return 'Theory';
      case 'theory_practical':
        return 'Theory & practical';
      case 'project':
        return 'Projects';
      default:
        return 'Your courses';
    }
  }
}

class _Loading extends StatelessWidget {
  const _Loading({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: palette.primary,
        strokeWidth: 2.5,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.palette,
    required this.message,
    required this.onRetry,
  });

  final AppPalette palette;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: palette.waveGold,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: palette.secondary,
                size: 29,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Unable to load courses',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}



class _CourseTypeFilter extends StatelessWidget {
  const _CourseTypeFilter({
    required this.palette,
    required this.selected,
    required this.onChanged,
  });

  final AppPalette palette;
  final String selected;
  final ValueChanged<String> onChanged;

  static const filters = [
    _FilterItem(
      value: 'all',
      label: 'All',
    ),
    _FilterItem(
      value: 'theory',
      label: 'Theory',
    ),
    _FilterItem(
      value: 'theory_practical',
      label: 'Theory + practical',
    ),
    _FilterItem(
      value: 'project',
      label: 'Projects',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          0,
        ),
        itemCount: filters.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected =
              selected == filter.value;

          return GestureDetector(
            onTap: () => onChanged(filter.value),
            child: AnimatedContainer(
              duration:
              const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? palette.primary
                    : palette.surface,
                borderRadius:
                BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? palette.primary
                      : palette.border,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: palette.primary
                        .withOpacity(0.16),
                    blurRadius: 10,
                    offset:
                    const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                filter.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : palette.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterItem {
  const _FilterItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}


class _NoFilteredCourses extends StatelessWidget {
  const _NoFilteredCourses({
    required this.palette,
    required this.filter,
  });

  final AppPalette palette;
  final String filter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        45,
        30,
        40,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.waveBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: palette.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No $filter courses',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no courses in this category yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
