import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../data/models/schedule_entry_model.dart';

class ScheduleEntryCard extends StatelessWidget {
  const ScheduleEntryCard({
    super.key,
    required this.entry,
    required this.palette,
  });

  final ScheduleEntryModel entry;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final sectionColor = _sectionColor(entry.sectionType);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 58,
            child: _TimeColumn(
              entry: entry,
              palette: palette,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: palette.border.withOpacity(.65),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.045),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.course.courseCode,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: palette.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.course.name,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.w800,
                                color:
                                palette.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: sectionColor.withOpacity(.14),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Text(
                          entry.displaySectionType,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: sectionColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: _InfoItem(
                          icon: Icons.person_outline_rounded,
                          text: entry.instructor?.name ??
                              'Instructor TBA',
                          palette: palette,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoItem(
                          icon: Icons.meeting_room_outlined,
                          text: entry.classroom.name,
                          palette: palette,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Divider(
                    height: 1,
                    color: palette.border.withOpacity(.55),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 17,
                        color: palette.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${entry.displayStartTime} — ${entry.displayEndTime}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: palette.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: palette.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _sectionColor(String type) {
    switch (type) {
      case 'theory':
        return palette.primary;

      case 'practical':
        return palette.secondary;

      default:
        return palette.textSecondary;
    }
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.entry,
    required this.palette,
  });

  final ScheduleEntryModel entry;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          entry.displayStartTime,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
        ),

        const SizedBox(height: 7),

        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: palette.secondary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: palette.secondary.withOpacity(.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),

        Container(
          width: 1.5,
          height: 55,
          color: palette.border,
        ),

        Text(
          entry.displayEndTime,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: palette.textSecondary,
          ),
        ),
      ],
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
      children: [
        Icon(
          icon,
          size: 17,
          color: palette.textSecondary,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: palette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}