import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../profile/presentation/cubit/student_cubit.dart';
import '../../../semesters/presentation/cubit/semester_cubit.dart';
import '../widgets/financial_summary_card.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/semester_summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go('/login');
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.wait([
              context.read<StudentCubit>().getProfile(),
              context.read<SemesterCubit>().getSemesters(),
              context.read<FinancialCubit>().getFinancialAccount(),
            ]),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                HomeHeader(onLogout: () => _confirmLogout(context)),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: SemesterSummaryCard()),
                    SizedBox(width: 12),
                    Expanded(child: FinancialSummaryCard()),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Quick actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const QuickActionsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              authCubit.logout();
            },
            child: const Text(
              'Log out',
              style: TextStyle(color: AppColors.waveBlue),
            ),
          ),
        ],
      ),
    );
  }
}
