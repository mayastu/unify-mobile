import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/success_overlay.dart';
import '../../data/models/available_course_model.dart';
import '../../data/models/course_registration_request.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import '../widgets/course_selection_card.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final Map<int, SectionSelection> _selections = {};

  void _onSectionSelected(
      int courseId,
      String type,
      int? sectionId,
      ) {
    setState(() {
      final selection = _selections.putIfAbsent(
        courseId,
            () => {},
      );

      selection[type] = sectionId;
    });
  }

  ({
  List<AvailableCourseModel> ready,
  List<AvailableCourseModel> incomplete,
  }) _evaluate(List<AvailableCourseModel> courses) {
    final ready = <AvailableCourseModel>[];
    final incomplete = <AvailableCourseModel>[];

    for (final course in courses) {
      final selection =
          _selections[course.course.id] ?? const {};

      if (!CourseSelectionCard.isTouched(selection)) {
        continue;
      }

      if (CourseSelectionCard.isComplete(
        course,
        selection,
      )) {
        ready.add(course);
      } else {
        incomplete.add(course);
      }
    }

    return (
    ready: ready,
    incomplete: incomplete,
    );
  }

  List<CourseRegistrationRequest> _buildRequests(
      List<AvailableCourseModel> ready,
      ) {
    return ready.map((course) {
      final selection =
          _selections[course.course.id] ?? const {};

      final sectionIds = selection.values
          .whereType<int>()
          .toList();

      return CourseRegistrationRequest(
        courseId: course.course.id,
        sectionIds: sectionIds,
      );
    }).toList();
  }

  void _submit(
      BuildContext context,
      List<AvailableCourseModel> courses,
      AppPalette palette,
      ) {
    final evaluation = _evaluate(courses);

    if (evaluation.incomplete.isNotEmpty) {
      final names = evaluation.incomplete
          .map((course) => course.course.courseCode)
          .join(', ');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: palette.secondary,
          content: Text(
            'Finish your section selection for: $names',
            style: TextStyle(
              color: palette.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      return;
    }

    if (evaluation.ready.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: palette.primary,
          content: const Text(
            'Choose at least one course before registering.',
          ),
        ),
      );

      return;
    }

    context.read<RegistrationCubit>().submitRegistration(
      _buildRequests(evaluation.ready),
    );
  }

  int _selectedCredits(
      List<AvailableCourseModel> courses,
      ) {
    var total = 0;

    for (final course in courses) {
      final selection =
          _selections[course.course.id] ?? const {};

      if (CourseSelectionCard.isComplete(
        course,
        selection,
      )) {
        total += course.course.creditHours;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette =
        isDark ? AppPalette.dark : AppPalette.light;

        return BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state is RegistrationSubmitSuccess) {
              setState(_selections.clear);

              SuccessOverlay.show(
                context,
                palette: palette,
                message: 'Registration submitted!',
                subtitle:
                'Your sections have been registered successfully.',
              );
            }

            if (state is RegistrationSubmitFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.message),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: palette.background,
            body: SafeArea(
              bottom: false,
              child: BlocBuilder<RegistrationCubit, RegistrationState>(
                builder: (context, state) {
                  if (state is RegistrationLoading ||
                      state is RegistrationInitial) {
                    return _RegistrationLoading(
                      palette: palette,
                    );
                  }

                  if (state is RegistrationLoadFailure) {
                    return AppEmpty(
                      icon: Icons.wifi_off_rounded,
                      message: state.message,
                      actionText: 'Retry',
                      onAction: () => context
                          .read<RegistrationCubit>()
                          .getAvailableCourses(),
                    );
                  }

                  final courses = state.availableCourses;

                  if (courses.isEmpty) {
                    return const AppEmpty(
                      icon: Icons.event_available_rounded,
                      message:
                      'No courses are open for registration right now.',
                    );
                  }

                  final evaluation = _evaluate(courses);
                  final readyCount = evaluation.ready.length;
                  final credits = _selectedCredits(courses);
                  final submitting =
                  state is RegistrationSubmitting;

                  return Stack(
                    children: [
                      RefreshIndicator(
                        color: palette.primary,
                        onRefresh: () => context
                            .read<RegistrationCubit>()
                            .getAvailableCourses(),
                        child: ListView(
                          physics:
                          const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            12,
                            20,
                            190,
                          ),
                          children: [
                            _RegistrationHeader(
                              palette: palette,
                            ),
                            const SizedBox(height: 22),

                            _RegistrationSummary(
                              palette: palette,
                              readyCount: readyCount,
                              totalCourses: courses.length,
                              credits: credits,
                            ),

                            const SizedBox(height: 22),

                            Text(
                              'Available courses',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: palette.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Choose the section that fits your schedule.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: palette.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 14),

                            ...courses.asMap().entries.map(
                                  (entry) {
                                final index = entry.key;
                                final availableCourse =
                                    entry.value;

                                final courseId =
                                    availableCourse.course.id;

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(
                                      begin: 0,
                                      end: 1,
                                    ),
                                    duration: Duration(
                                      milliseconds:
                                      260 + (index * 45),
                                    ),
                                    curve: Curves.easeOutCubic,
                                    builder:
                                        (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset: Offset(
                                            0,
                                            (1 - value) * 16,
                                          ),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: CourseSelectionCard(
                                      availableCourse:
                                      availableCourse,
                                      selection:
                                      _selections[courseId] ??
                                          const {},
                                      palette: palette,
                                      onSectionSelected:
                                          (type, sectionId) {
                                        _onSectionSelected(
                                          courseId,
                                          type,
                                          sectionId,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      _RegistrationBottomBar(
                        palette: palette,
                        readyCount: readyCount,
                        credits: credits,
                        submitting: submitting,
                        onPressed: () => _submit(
                          context,
                          courses,
                          palette,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RegistrationHeader extends StatelessWidget {
  const _RegistrationHeader({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.of(context).maybePop(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_rounded,
                color: palette.textPrimary,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Registration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Build your schedule for this semester',
                style: TextStyle(
                  fontSize: 12.5,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegistrationSummary extends StatelessWidget {
  const _RegistrationSummary({
    required this.palette,
    required this.readyCount,
    required this.totalCourses,
    required this.credits,
  });

  final AppPalette palette;
  final int readyCount;
  final int totalCourses;
  final int credits;

  @override
  Widget build(BuildContext context) {
    final progress =
    totalCourses == 0 ? 0.0 : readyCount / totalCourses;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.primary,
            Color.lerp(
              palette.primary,
              palette.waveBlue,
              0.35,
            ) ??
                palette.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  readyCount == 0
                      ? 'Ready when you are'
                      : '$readyCount course${readyCount == 1 ? '' : 's'} ready',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (credits > 0)
                _CreditBadge(
                  credits: credits,
                  palette: palette,
                ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: progress,
              ),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 7,
                  backgroundColor:
                  Colors.white.withOpacity(0.12),
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    palette.secondary,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              Text(
                '$readyCount of $totalCourses ready',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (readyCount == totalCourses)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: palette.secondary,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'All set',
                      style: TextStyle(
                        color: palette.secondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreditBadge extends StatelessWidget {
  const _CreditBadge({
    required this.credits,
    required this.palette,
  });

  final int credits;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: palette.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$credits credits',
        style: TextStyle(
          color: palette.primary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RegistrationBottomBar extends StatelessWidget {
  const _RegistrationBottomBar({
    required this.palette,
    required this.readyCount,
    required this.credits,
    required this.submitting,
    required this.onPressed,
  });

  final AppPalette palette;
  final int readyCount;
  final int credits;
  final bool submitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final canRegister = readyCount > 0;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          18,
        ),
        decoration: BoxDecoration(
          color: palette.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                palette.brightness == Brightness.dark
                    ? 0.20
                    : 0.06,
              ),
              blurRadius: 22,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      readyCount == 0
                          ? 'Nothing selected yet'
                          : '$readyCount course${readyCount == 1 ? '' : 's'} ready',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (credits > 0) ...[
                      const SizedBox(height: 3),
                      Text(
                        '$credits credit hours',
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed:
                  submitting ? null : onPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: canRegister
                        ? palette.primary
                        : palette.surfaceElevated,
                    foregroundColor: canRegister
                        ? Colors.white
                        : palette.textSecondary,
                    disabledBackgroundColor:
                    palette.primary.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration:
                    const Duration(milliseconds: 220),
                    transitionBuilder:
                        (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: submitting
                        ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 21,
                      height: 21,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      key: ValueKey(canRegister),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          canRegister
                              ? 'Register'
                              : 'Choose sections',
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                        if (canRegister) ...[
                          const SizedBox(width: 7),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegistrationLoading extends StatelessWidget {
  const _RegistrationLoading({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: palette.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: palette.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading available courses...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}