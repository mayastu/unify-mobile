import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../semesters/data/models/semester_model.dart';
import '../../../semesters/presentation/cubit/semester_cubit.dart';
import '../../../semesters/presentation/cubit/semester_state.dart';

class SemesterSummaryCard extends StatelessWidget {
  const SemesterSummaryCard({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SemesterCubit, SemesterState>(
      builder: (context, state) {
        if (compact) {
          return _buildCompact(state);
        }

        return _buildNormal(state);
      },
    );
  }

  Widget _buildCompact(SemesterState state) {
    if (state is SemesterLoading) {
      return const _LoadingText();
    }

    if (state is SemesterFailure) {
      return const _ValueText(
        value: 'Unable to load',
      );
    }

    if (state is SemesterSuccess) {
      final semester = _currentOrLatest(state.semesters);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current semester',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            semester?.name ?? 'No semesters yet',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildNormal(SemesterState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: _buildCompact(state),
    );
  }

  SemesterModel? _currentOrLatest(
      List<SemesterModel> semesters,
      ) {
    if (semesters.isEmpty) return null;

    for (final semester in semesters) {
      if (semester.isCurrent) {
        return semester;
      }
    }

    return semesters.first;
  }
}

class _LoadingText extends StatelessWidget {
  const _LoadingText();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText({
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
      ),
    );
  }
}