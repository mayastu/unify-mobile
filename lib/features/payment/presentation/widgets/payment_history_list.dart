import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import 'payment_history_tile.dart';

class PaymentHistoryList extends StatelessWidget {
  const PaymentHistoryList({super.key, required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoading || state is PaymentInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (state is PaymentLoaded) {
          if (state.payments.isEmpty) {
            return const AppEmpty(
              icon: Icons.receipt_long_outlined,
              message: "You haven't made any payments yet.",
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => PaymentHistoryTile(
              payment: state.payments[index],
              palette: palette,
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: state.payments.length,
          );
        }

        return const SizedBox();
      },
    );
  }
}
