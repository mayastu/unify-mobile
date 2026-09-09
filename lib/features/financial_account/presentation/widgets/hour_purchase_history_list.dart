import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';

class HourPurchaseHistoryList extends StatelessWidget {
  const HourPurchaseHistoryList({
    super.key,
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FinancialCubit>().state;

    if (state is! FinancialSuccess) {
      return const SizedBox();
    }

    final purchases = state.purchases;

    if (purchases.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: palette.border,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: palette.waveBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: palette.primary,
                size: 25,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No purchase history',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your credit hour purchases will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: purchases.map((purchase) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: AppCard(
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: palette.waveBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.payments_rounded,
                    color: palette.primary,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${purchase.creditHours} Credit Hours',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: palette.textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              purchase.createdAt,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                color:
                                palette.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${purchase.totalAmount}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: palette.waveGold,
                        borderRadius:
                        BorderRadius.circular(7),
                      ),
                      child: Text(
                        '\$${purchase.pricePerHour}/hr',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: palette.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}