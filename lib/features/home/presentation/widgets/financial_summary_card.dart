import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../financial_account/presentation/cubit/financial_state.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCubit, FinancialState>(
      builder: (context, state) {
        if (compact) {
          return _buildCompact(state);
        }

        return _buildLarge(state);
      },
    );
  }

  Widget _buildCompact(FinancialState state) {
    if (state is FinancialLoading) {
      return const _LoadingText();
    }

    if (state is FinancialFailure) {
      return const _ValueText(
        value: 'Unable to load',
      );
    }

    if (state is FinancialSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Remaining hours',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${state.account.remainingCreditHours} hrs',
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

  Widget _buildLarge(FinancialState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffffffff),
            Color(0xfffffbf1),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.secondary.withOpacity(.14),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xfffff3d8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.secondary,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Financial Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.secondary,
              ),
            ],
          ),

          const SizedBox(height: 22),

          const Text(
            'Remaining Credit Hours',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          _buildLargeValue(state),

          const SizedBox(height: 18),

          Container(
            height: 1,
            color: AppColors.secondary.withOpacity(.12),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  state is FinancialSuccess
                      ? 'Your current academic financial information'
                      : 'Financial information',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeValue(FinancialState state) {
    if (state is FinancialLoading) {
      return const SizedBox(
        height: 38,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.secondary,
            ),
          ),
        ),
      );
    }

    if (state is FinancialFailure) {
      return const Text(
        'Unable to load',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      );
    }

    if (state is FinancialSuccess) {
      return Text(
        '${state.account.remainingCreditHours} hrs',
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      );
    }

    return const SizedBox(height: 38);
  }
}

class _LoadingText extends StatelessWidget {
  const _LoadingText();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
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