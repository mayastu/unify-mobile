import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_info_card.dart';
import '../widgets/student_info_card.dart';

class PaymentDetailsPage extends StatefulWidget {
  final int paymentId;

  const PaymentDetailsPage({super.key, required this.paymentId});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCubit>().getPayment(widget.paymentId);
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
            "Payment Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),

        body: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PaymentDetailsLoaded) {
              final payment = state.payment;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    PaymentInfoCard(
                      payment: payment,
                    ),

                    const SizedBox(height: 20),

                    StudentInfoCard(
                      payment: payment,
                    ),
                  ],
                ),
              );
            }

            if (state is PaymentFailure) {
              return Center(
                child: Text(state.message),
              );
            }

            return const SizedBox();
          },
        ));
  }
}