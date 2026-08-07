import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FinancialCubit>().state;

    if (state is! FinancialSuccess) {
      return const SizedBox();
    }

    final account = state.account;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Financial Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  "Balance",
                  "\$${account.availableBalance}",
                  Icons.account_balance_wallet_rounded,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  "Purchased",
                  "${account.purchasedCreditHours}",
                  Icons.shopping_cart_checkout_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  "Used",
                  "${account.usedCreditHours}",
                  Icons.menu_book_rounded,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  "Remaining",
                  "${account.remainingCreditHours}",
                  Icons.timelapse_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoItem(
      this.title,
      this.value,
      this.icon,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withOpacity(.1),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}