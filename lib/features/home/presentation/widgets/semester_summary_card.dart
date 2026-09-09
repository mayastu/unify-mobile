import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../semesters/data/models/semester_model.dart';
import '../../../semesters/presentation/cubit/semester_cubit.dart';
import '../../../semesters/presentation/cubit/semester_state.dart';

class SemesterSummaryCard extends StatelessWidget {
  const SemesterSummaryCard({super.key, this.palette = AppPalette.light});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SemesterCubit, SemesterState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 17,
                    color: palette.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Current semester',
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildContent(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(SemesterState state) {
    if (state is SemesterLoading) {
      return const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state is SemesterFailure) {
      return Text(
        'Unable to load',
        style: TextStyle(fontSize: 13, color: palette.textSecondary),
      );
    }

    if (state is SemesterSuccess) {
      final SemesterModel? current = _currentOrLatest(state.semesters);

      if (current == null) {
        return Text(
          'No semesters yet',
          style: TextStyle(fontSize: 13, color: palette.textSecondary),
        );
      }

      return Text(
        current.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
      );
    }

    return const SizedBox(height: 22);
  }

  SemesterModel? _currentOrLatest(List<SemesterModel> semesters) {
    if (semesters.isEmpty) return null;

    for (final semester in semesters) {
      if (semester.isCurrent) return semester;
    }

    return semesters.first;
  }
}
