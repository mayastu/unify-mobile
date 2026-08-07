import 'package:flutter/material.dart';

import '../../data/models/payment_model.dart';
import 'info_row.dart';

class PaymentInfoCard extends StatelessWidget {
  final PaymentModel payment;

  const PaymentInfoCard({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            const Row(
              children: [
                Icon(Icons.payments),
                SizedBox(width: 8),
                Text(
                  "Payment Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            InfoRow(
              icon: Icons.attach_money,
              title: "Amount",
              value: payment.amount,
            ),

            InfoRow(
              icon: Icons.receipt_long,
              title: "Reference",
              value: payment.referenceNumber,
            ),

            InfoRow(
              icon: Icons.credit_card,
              title: "Method",
              value: payment.paymentMethod,
            ),

            InfoRow(
              icon: Icons.calendar_today,
              title: "Payment Date",
              value: payment.paymentDate,
            ),

            InfoRow(
              icon: Icons.schedule,
              title: "Created At",
              value: payment.createdAt,
            ),
          ],
        ),
      ),
    );
  }
}