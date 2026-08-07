import 'package:flutter/material.dart';

import '../../data/models/payment_model.dart';
import 'info_row.dart';

class StudentInfoCard extends StatelessWidget {
  final PaymentModel payment;

  const StudentInfoCard({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {

    final student = payment.student;

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
                Icon(Icons.person),
                SizedBox(width: 8),
                Text(
                  "Student Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            InfoRow(
              icon: Icons.person_outline,
              title: "Name",
              value:
              "${student.user.firstName} ${student.user.lastName}",
            ),

            InfoRow(
              icon: Icons.badge,
              title: "Student Number",
              value: student.studentNumber,
            ),

            InfoRow(
              icon: Icons.school,
              title: "Department",
              value: student.department.name,
            ),

            InfoRow(
              icon: Icons.phone,
              title: "Phone",
              value: student.user.phone ?? '',
            ),

            InfoRow(
              icon: Icons.email,
              title: "Email",
              value: student.user.email,
            ),
          ],
        ),
      ),
    );
  }
}