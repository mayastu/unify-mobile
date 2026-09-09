import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key, required this.palette});

  final AppPalette palette;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final referenceController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    referenceController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final palette = widget.palette;

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: palette.primary,
            onPrimary: Colors.white,
            surface: palette.surface,
            onSurface: palette.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (date != null) {
      setState(() {
        dateController.text =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      });
    }
  }

  InputDecoration _decoration(AppPalette palette, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: palette.primary, size: 20),
      filled: true,
      fillColor: palette.surfaceElevated,
      labelStyle: TextStyle(color: palette.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: palette.textPrimary, fontWeight: FontWeight.w600),
              decoration: _decoration(palette, 'Amount', Icons.payments_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter amount';
                if (double.tryParse(value) == null) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: referenceController,
              style: TextStyle(color: palette.textPrimary, fontWeight: FontWeight.w600),
              decoration: _decoration(palette, 'Reference number', Icons.receipt_long_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter reference';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: dateController,
              readOnly: true,
              onTap: pickDate,
              style: TextStyle(color: palette.textPrimary, fontWeight: FontWeight.w600),
              decoration: _decoration(palette, 'Payment date', Icons.calendar_month_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Choose payment date';
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  final submitting = state is PaymentLoading;

                  return FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: submitting
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            final studentId = await SecureStorage.getStudentId();

                            if (!context.mounted) return;

                            context.read<PaymentCubit>().createPayment(
                                  studentId: studentId,
                                  amount: double.parse(amountController.text),
                                  referenceNumber: referenceController.text,
                                  paymentDate: dateController.text,
                                );
                          },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: submitting
                          ? const SizedBox(
                              key: ValueKey('loading'),
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Pay now',
                              key: ValueKey('label'),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
