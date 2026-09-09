import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../financial_account/presentation/cubit/financial_state.dart';

/// Shows the live financial account (from FinancialCubit) instead of
/// placeholder numbers — balance and credit hours reflect the real
/// account, and refresh automatically after a purchase or payment.
class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.primary, palette.primary.withOpacity(0.78)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BlocBuilder<FinancialCubit, FinancialState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Financial account',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildBody(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(FinancialState state) {
    if (state is FinancialLoading || state is FinancialInitial) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    if (state is FinancialFailure) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      );
    }

    // Purchase-flow states carry no account snapshot of their own; the
    // card simply keeps showing the last known FinancialSuccess data.
    if (state is FinancialSuccess) {
      final account = state.account;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available balance',
            style: TextStyle(color: Colors.white70, fontSize: 12.5),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${account.availableBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInfo('Purchased', account.purchasedCreditHours)),
              Expanded(child: _buildInfo('Used', account.usedCreditHours)),
              Expanded(child: _buildInfo('Remaining', account.remainingCreditHours)),
            ],
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildInfo(String title, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 11.5),
        ),
        const SizedBox(height: 4),
        Text(
          '$value hrs',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
