import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_form.dart';
import '../widgets/payment_history_list.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/purchase_hours_card.dart';


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
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Payments",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment created successfully"),
                backgroundColor: Colors.green,
              ),
            );

          }
        },

        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  /// ===== Summary =====
                  PaymentSummaryCard(),

                  SizedBox(height: 20),

                  /// ===== Purchase credit hours =====
                  PurchaseHoursCard(),

                  SizedBox(height: 24),

                  Text(
                    "Create Payment",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  /// ===== Form =====
                  PaymentForm(),

                  SizedBox(height: 32),

                  Text(
                    "Recent Payments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  /// ===== History =====
                  PaymentHistoryList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}