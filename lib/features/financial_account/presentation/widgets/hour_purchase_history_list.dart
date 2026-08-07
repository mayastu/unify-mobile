import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';

class HourPurchaseHistoryList extends StatelessWidget {
  const HourPurchaseHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FinancialCubit>().state;

    if (state is! FinancialSuccess) {
      return const SizedBox();
    }

    final purchases = state.purchases;

    if (purchases.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No purchase history yet.",
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purchases.length,
      separatorBuilder: (_, __) =>
      const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final purchase = purchases[index];

        return AppCard(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                AppColors.primary.withOpacity(.1),
                child: const Icon(
                  Icons.payments_rounded,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${purchase.creditHours} Credit Hours",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      purchase.createdAt,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${purchase.totalAmount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  Text(
                    "\$${purchase.pricePerHour}/hr",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}