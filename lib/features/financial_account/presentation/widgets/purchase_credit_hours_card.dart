import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/financial_cubit.dart';

class PurchaseCreditHoursCard extends StatefulWidget {
  const PurchaseCreditHoursCard({super.key});

  @override
  State<PurchaseCreditHoursCard> createState() =>
      _PurchaseCreditHoursCardState();
}

class _PurchaseCreditHoursCardState
    extends State<PurchaseCreditHoursCard> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Buy Credit Hours",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Credit Hours",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Purchase"),
              onPressed: () {
                final hours =
                int.tryParse(controller.text);

                if (hours == null || hours <= 0) {
                  return;
                }

                context
                    .read<FinancialCubit>()
                    .purchaseCreditHours(hours);
              },
            ),
          ),
        ],
      ),
    );
  }
}