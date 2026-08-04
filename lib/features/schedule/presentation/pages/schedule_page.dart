import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
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
  // DateTime.weekday: 1 = Monday ... 7 = Sunday.
  const dartWeekdayToName = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  return dartWeekdayToName[DateTime.now().weekday - 1];
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String _selectedDay = _today();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('My schedule'),
      ),
      body: BlocBuilder<StudentScheduleCubit, StudentScheduleState>(
        builder: (context, state) {
          if (state is StudentScheduleLoading ||
              state is StudentScheduleInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentScheduleFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () =>
                  context.read<StudentScheduleCubit>().getSchedule(),
            );
          }

          final schedule =
              (state as StudentScheduleSuccess).schedule;

          final entries = List<ScheduleEntryModel>.from(
            schedule[_selectedDay] ?? const [],
          )..sort((a, b) => a.startTime.compareTo(b.startTime));

          return RefreshIndicator(
            onRefresh: () =>
                context.read<StudentScheduleCubit>().getSchedule(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: DaySelector(
                    days: _weekDays,
                    selectedDay: _selectedDay,
                    onSelected: (day) => setState(() => _selectedDay = day),
                    dayHasClasses: (day) =>
                        (schedule[day] ?? const []).isNotEmpty,
                  ),
                ),
                Expanded(
                  child: entries.isEmpty
                      ? AppEmpty(
                          icon: Icons.event_available_rounded,
                          message: 'No classes on $_selectedDay.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                          itemCount: entries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              ScheduleEntryCard(entry: entries[index]),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
