import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../financial_account/presentation/cubit/financial_state.dart';

class PurchaseHoursCard extends StatefulWidget {
  const PurchaseHoursCard({super.key});

  @override
  State<PurchaseHoursCard> createState() => _PurchaseHoursCardState();
}

class _PurchaseHoursCardState extends State<PurchaseHoursCard> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final hours = int.parse(_hoursController.text);

    context.read<FinancialCubit>().purchaseCreditHours(hours);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinancialCubit, FinancialState>(
      listenWhen: (previous, current) =>
          current is PurchaseSuccess || current is PurchaseFailure,
      listener: (context, state) {
        if (state is PurchaseSuccess) {
          _hoursController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Credit hours purchased successfully.'),
              backgroundColor: AppColors.textSecondary,
            ),
          );
        }

        if (state is PurchaseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final submitting = state is PurchaseLoading;

        return AppCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Purchase credit hours',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Top up your credit hours to register for more sections.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hoursController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hours',
                          prefixIcon: Icon(Icons.add_circle_outline),
                        ),
                        validator: (value) {
                          final hours = int.tryParse(value ?? '');

                          if (hours == null || hours <= 0) {
                            return 'Enter a valid number of hours';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: submitting ? null : () => _submit(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Purchase'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
