import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../financial_account/presentation/cubit/financial_state.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({super.key, this.palette = AppPalette.light});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCubit, FinancialState>(
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
                    Icons.account_balance_wallet_rounded,
                    size: 17,
                    color: palette.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Remaining hours',
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

  Widget _buildContent(FinancialState state) {
    // Purchase-flow states don't affect this summary; treat them
    // like "no data yet" rather than adding extra branches here.
    if (state is FinancialLoading) {
      return const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state is FinancialFailure) {
      return Text(
        'Unable to load',
        style: TextStyle(fontSize: 13, color: palette.textSecondary),
      );
    }

    if (state is FinancialSuccess) {
      return Text(
        '${state.account.remainingCreditHours} hrs',
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
}
