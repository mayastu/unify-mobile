import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../data/models/attendance_summary_model.dart';
import '../cubit/attendance_summary_cubit.dart';
import '../cubit/attendance_summary_state.dart';

class AttendanceSummaryPage extends StatelessWidget {
  const AttendanceSummaryPage({
    super.key,
    required this.studentCourseId,
    required this.courseName,
    required this.courseCode,
  });

  final int studentCourseId;
  final String courseName;
  final String courseCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          courseCode.isEmpty ? courseName : '$courseCode • $courseName',
        ),
      ),
      body: BlocBuilder<AttendanceSummaryCubit, AttendanceSummaryState>(
        builder: (context, state) {
          if (state is AttendanceSummaryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceSummaryFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () => context
                  .read<AttendanceSummaryCubit>()
                  .load(studentCourseId),
            );
          }

          final summary = (state as AttendanceSummarySuccess).summary;

          return RefreshIndicator(
            onRefresh: () =>
                context.read<AttendanceSummaryCubit>().load(studentCourseId),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _StatusBanner(summary: summary),
                const SizedBox(height: 12),
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: 'Present',
                          value: '${summary.presentSessions}',
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _StatTile(
                          label: 'Absent',
                          value: '${summary.absentSessions}',
                          color: Colors.red,
                        ),
                      ),
                      Expanded(
                        child: _StatTile(
                          label: 'Max absences',
                          value: '${summary.maxAbsences}',
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (summary.sessions.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Sessions',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Column(
                      children: summary.sessions
                          .map((s) => _SessionRow(session: s))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.summary});

  final AttendanceSummaryModel summary;

  Color get _color {
    switch (summary.attendanceStatus) {
      case 'denied':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'good':
      default:
        return Colors.green;
    }
  }

  IconData get _icon {
    switch (summary.attendanceStatus) {
      case 'denied':
        return Icons.block_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'good':
      default:
        return Icons.check_circle_rounded;
    }
  }

  String get _label {
    switch (summary.attendanceStatus) {
      case 'denied':
        return 'Denied — you\'ve exceeded the allowed absences.';
      case 'warning':
        return 'Warning — you\'re close to the absence limit.';
      case 'good':
      default:
        return 'Good standing.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: TextStyle(fontWeight: FontWeight.w700, color: _color),
                ),
                if (summary.remainingAbsences != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${summary.remainingAbsences} absence(s) remaining · '
                    '${summary.attendancePercentage.toStringAsFixed(0)}% attendance',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final AttendanceSessionEntryModel session;

  bool get _isPresent => session.status.toLowerCase() == 'present';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            _isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 18,
            color: _isPresent ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              session.sessionDate,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          Text(
            session.status,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _isPresent ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
