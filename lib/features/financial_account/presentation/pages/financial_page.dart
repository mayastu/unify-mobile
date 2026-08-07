import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/financial_summary_card.dart';
import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';
import '../widgets/hour_purchase_history_list.dart';
import '../widgets/purchase_credit_hours_card.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinancialCubit>().getFinancialAccount();
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
          "Financial Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: BlocConsumer<FinancialCubit, FinancialState>(
        listener: (context, state) {
          if (state is FinancialFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is PurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Credit hours purchased successfully",
                ),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state is PurchaseFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        builder: (context, state) {
          if (state is FinancialLoading ||
              state is FinancialInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context
                  .read<FinancialCubit>()
                  .getFinancialAccount(),
              child: SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: const [

                    /// ===== Account Summary =====
                    FinancialSummaryCard(),

                    SizedBox(height: 20),

                    /// ===== Buy Hours =====
                    PurchaseCreditHoursCard(),

                    SizedBox(height: 30),

                    Text(
                      "Purchase History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16),

                    /// ===== History =====
                    HourPurchaseHistoryList(),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}