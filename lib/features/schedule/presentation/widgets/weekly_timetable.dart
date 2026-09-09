import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../data/models/schedule_entry_model.dart';

class WeeklyTimetable extends StatelessWidget {
  const WeeklyTimetable({
    super.key,
    required this.entries,
    required this.palette,
  });

  final List<ScheduleEntryModel> entries;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < entries.length; i++)
          _TimelineItem(
            entry: entries[i],
            palette: palette,
            isLast: i == entries.length - 1,
            index: i,
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.entry,
    required this.palette,
    required this.isLast,
    required this.index,
  });

  final ScheduleEntryModel entry;
  final AppPalette palette;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry.displayStartTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.displayEndTime,
                    style: TextStyle(
                      fontSize: 10,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            SizedBox(
              width: 18,
              child: Column(
                children: [
                  const SizedBox(height: 2),

                  _TimelineDot(
                    color: palette.secondary,
                  ),

                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: palette.border.withOpacity(.65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ClassCard(
                  entry: entry,
                  palette: palette,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color.withOpacity(.16),
        shape: BoxShape.circle,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.entry,
    required this.palette,
  });

  final ScheduleEntryModel entry;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: palette.border.withOpacity(.7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                palette.brightness == Brightness.dark ? .10 : .045,
              ),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.course.courseCode,
                        style: TextStyle(
                          color: palette.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                _SectionBadge(
                  text: entry.displaySectionType,
                  palette: palette,
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                _InfoItem(
                  icon: Icons.person_outline_rounded,
                  text: entry.instructor?.name ?? 'Instructor TBA',
                  palette: palette,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.meeting_room_outlined,
                    text: entry.classroom.name,
                    palette: palette,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              height: 1,
              color: palette.border.withOpacity(.6),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: palette.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  '${entry.displayStartTime} — ${entry.displayEndTime}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: palette.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({
    required this.text,
    required this.palette,
  });

  final String text;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: palette.secondary.withOpacity(.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: palette.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.text,
    required this.palette,
  });

  final IconData icon;
  final String text;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: palette.textSecondary,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: palette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}