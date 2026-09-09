import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../schedule/data/models/schedule_entry_model.dart';
import '../../../schedule/presentation/cubit/student_schedule_cubit.dart';
import '../../../schedule/presentation/cubit/student_schedule_state.dart';

const _weekdayNames = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];

class TodayScheduleCard extends StatelessWidget {
  const TodayScheduleCard({super.key, required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final today = _weekdayNames[DateTime.now().weekday - 1];

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.calendar_month_rounded, size: 17, color: palette.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Today's schedule",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/schedule'),
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: palette.secondary,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 16, color: palette.secondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<StudentScheduleCubit, StudentScheduleState>(
            builder: (context, state) {
              if (state is StudentScheduleLoading || state is StudentScheduleInitial) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              if (state is StudentScheduleFailure) {
                return Text(
                  'Unable to load your schedule',
                  style: TextStyle(fontSize: 13, color: palette.textSecondary),
                );
              }

              final entries = (state as StudentScheduleSuccess).schedule[today] ?? [];

              if (entries.isEmpty) {
                return Text(
                  'No classes today 🎉',
                  style: TextStyle(fontSize: 13, color: palette.textSecondary),
                );
              }

              final sorted = [...entries]
                ..sort((a, b) => a.displayStartTime.compareTo(b.displayStartTime));

              return Column(
                children: [
                  for (var i = 0; i < sorted.length; i++) ...[
                    if (i > 0) Divider(height: 20, color: palette.border),
                    _ScheduleRow(entry: sorted[i], palette: palette),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.entry, required this.palette});

  final ScheduleEntryModel entry;
  final AppPalette palette;

  bool get _isNow {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    final start = _toMinutes(entry.displayStartTime);
    final end = _toMinutes(entry.displayEndTime);
    if (start == null || end == null) return false;

    return nowMinutes >= start && nowMinutes < end;
  }

  int? _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  @override
  Widget build(BuildContext context) {
    final isNow = _isNow;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 40,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: isNow ? palette.secondary : palette.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 52,
          child: Text(
            entry.displayStartTime,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.course.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${entry.instructor?.name ?? entry.displaySectionType} · Room ${entry.classroom.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: palette.textSecondary),
              ),
            ],
          ),
        ),
        if (isNow)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: palette.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Now',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: palette.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
