import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../financial_account/presentation/cubit/financial_state.dart';

/// Home's version of the mockup's gold "Financial Overview" card.
///
/// The mockup shows a "Next Payment / due <date>" stat, but that isn't
/// backed by any field FinancialCubit/FinancialAccountModel actually
/// returns (payments here are a paid history, not a scheduled due
/// amount) — so, to avoid inventing data, the second stat shown here
/// is `remainingCreditHours`, which the account model does return.
class FinancialOverviewCard extends StatelessWidget {
  const FinancialOverviewCard({super.key, this.palette = AppPalette.light});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCubit, FinancialState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.push('/financial-account'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.waveGold, palette.surface],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: palette.secondary.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.show_chart_rounded,
                          size: 18, color: palette.secondary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Financial Overview',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: palette.secondary,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16, color: palette.secondary),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _buildContent(state, palette, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
      FinancialState state, AppPalette palette, BuildContext context) {
    if (state is FinancialLoading || state is FinancialInitial) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state is FinancialFailure) {
      return Text(
        'Unable to load your financial account',
        style: TextStyle(fontSize: 13, color: palette.textSecondary),
      );
    }

    if (state is FinancialSuccess) {
      final account = state.account;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _Stat(
              label: 'Current Balance',
              value: '\$${account.availableBalance.toStringAsFixed(2)}',
              palette: palette,
            ),
          ),
          Container(width: 1, height: 34, color: palette.border),
          const SizedBox(width: 16),
          Expanded(
            child: _Stat(
              label: 'Remaining Hours',
              value: '${account.remainingCreditHours} hrs',
              palette: palette,
            ),
          ),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.secondary.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward_rounded,
                size: 18, color: palette.secondary),
          ),
        ],
      );
    }

    return const SizedBox(height: 22);
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.palette});

  final String label;
  final String value;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: palette.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }
}
