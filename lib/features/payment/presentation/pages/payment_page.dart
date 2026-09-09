import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/success_overlay.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_form.dart';
import '../widgets/payment_history_list.dart';
import '../widgets/payment_summary_card.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentCubit>().getPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette = isDark ? AppPalette.dark : AppPalette.light;

        return BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }

            if (state is PaymentSuccess) {
              SuccessOverlay.show(
                context,
                palette: palette,
                message: 'Payment submitted!',
                subtitle: 'Your payment has been recorded successfully.',
              );
            }
          },
          child: Scaffold(
            backgroundColor: palette.background,
            appBar: AppBar(
              backgroundColor: palette.background,
              elevation: 0,
              foregroundColor: palette.textPrimary,
              title: const Text('Payments'),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => context.read<PaymentCubit>().getPayments(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ===== Summary =====
                      PaymentSummaryCard(palette: palette),

                      const SizedBox(height: 24),

                      Text(
                        'Create payment',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ===== Form =====
                      PaymentForm(palette: palette),

                      const SizedBox(height: 28),

                      Text(
                        'Recent payments',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ===== History =====
                      PaymentHistoryList(palette: palette),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
