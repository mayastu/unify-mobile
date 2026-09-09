import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/academic_page_header.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../data/models/schedule_entry_model.dart';
import '../cubit/student_schedule_cubit.dart';
import '../cubit/student_schedule_state.dart';
import '../widgets/day_selector.dart';
import '../widgets/schedule_entry_card.dart';

const List<String> _weekDays = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

String _today() {
  const names = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  return names[DateTime.now().weekday - 1];
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String _selectedDay = _today();

  void _selectDay(String day) {
    if (day == _selectedDay) return;

    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette =
        isDark ? AppPalette.dark : AppPalette.light;

        return Scaffold(
          backgroundColor: palette.background,
          body: BlocBuilder<StudentScheduleCubit,
              StudentScheduleState>(
            builder: (context, state) {
              if (state is StudentScheduleLoading ||
                  state is StudentScheduleInitial) {
                return _LoadingView(palette: palette);
              }

              if (state is StudentScheduleFailure) {
                return SafeArea(
                  child: AppEmpty(
                    icon: Icons.wifi_off_rounded,
                    message: state.message,
                    actionText: 'Retry',
                    onAction: () => context
                        .read<StudentScheduleCubit>()
                        .getSchedule(),
                  ),
                );
              }

              final schedule =
                  (state as StudentScheduleSuccess).schedule;

              final entries = List<ScheduleEntryModel>.from(
                schedule[_selectedDay] ?? const <ScheduleEntryModel>[],
              )..sort(
                    (a, b) => a.startTime.compareTo(b.startTime),
              );

              return RefreshIndicator(
                color: palette.primary,
                onRefresh: () => context
                    .read<StudentScheduleCubit>()
                    .getSchedule(),
                child: CustomScrollView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: AcademicPageHeader(
                        palette: palette,
                        title: 'Schedule',
                        subtitle: 'Keep track of your weekly classes.',
                        badgeText: _selectedDay,
                        metaText: '${entries.length} classes',
                        icon: Icons.calendar_month_rounded,
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                        ),
                        child: DaySelector(
                          days: _weekDays,
                          selectedDay: _selectedDay,
                          schedule: schedule,
                          palette: palette,
                          onSelected: _selectDay,
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          28,
                          18,
                          28,
                          10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$_selectedDay classes',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: palette.textPrimary,
                                ),
                              ),
                            ),
                            _ClassCountBadge(
                              count: entries.length,
                              palette: palette,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (entries.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppEmpty(
                          icon: Icons.event_available_rounded,
                          message:
                          'No classes on $_selectedDay.',
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          120,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final entry = entries[index];

                              return _AnimatedEntry(
                                key: ValueKey(
                                  '${_selectedDay}_${entry.course.id}_${entry.startTime}',
                                ),
                                index: index,
                                child: ScheduleEntryCard(
                                  entry: entry,
                                  palette: palette,
                                ),
                              );
                            },
                            childCount: entries.length,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}







class _ClassCountBadge extends StatelessWidget {
  const _ClassCountBadge({
    required this.count,
    required this.palette,
  });

  final int count;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: palette.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        '$count ${count == 1 ? 'class' : 'classes'}',
        style: TextStyle(
          color: palette.primary,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 300 + (index * 80),
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              20 * (1 - value),
              0,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AcademicPageHeader(
          palette: palette,
          title: 'Schedule',
          subtitle: 'Keep track of your weekly classes.',
          badgeText: 'Loading',
          icon: Icons.calendar_month_rounded,
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

