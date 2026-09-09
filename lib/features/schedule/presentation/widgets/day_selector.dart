import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../data/models/schedule_entry_model.dart';

/// A fixed weekly pattern (same "Monday" every week, no calendar
/// dates involved) — so this only ever shows day names, never a
/// day-of-month number that would incorrectly imply one specific
/// week.
class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.schedule,
    required this.palette,
    required this.onSelected,
  });

  final List<String> days;
  final String selectedDay;
  final Map<String, List<ScheduleEntryModel>> schedule;
  final AppPalette palette;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final selected = day == selectedDay;
          final hasClasses = (schedule[day] ?? const []).isNotEmpty;

          return GestureDetector(
            onTap: () => onSelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 58,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selected ? palette.surface : palette.surface.withOpacity(.72),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? palette.primary.withOpacity(.18) : palette.border,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: palette.primary.withOpacity(.10),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: selected ? palette.primary : palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: hasClasses ? 6 : 0,
                    height: 6,
                    decoration: BoxDecoration(
                      color: hasClasses ? palette.secondary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
