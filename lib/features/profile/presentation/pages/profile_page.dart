import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/student_cubit.dart';
import '../cubit/student_state.dart';
import '../widgets/profile_info_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
          title: const Text('Profile'),
        ),
        body: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading || state is StudentInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StudentFailure) {
              return AppEmpty(
                icon: Icons.wifi_off_rounded,
                message: state.message,
                actionText: 'Retry',
                onAction: () => context.read<StudentCubit>().getProfile(),
              );
            }

            final student = (state as StudentSuccess).student;
            final user = student.user;
            final initials =
                user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'S';

            return RefreshIndicator(
              onRefresh: () => context.read<StudentCubit>().getProfile(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            //gradient: AppColors.primaryGradient,
                          ),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${user.firstName} ${user.lastName}'.trim(),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            student.studentNumber,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Account details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phone ?? '',
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Username',
                    value: user.username,
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoTile(
                    icon: Icons.apartment_rounded,
                    label: 'Department',
                    value:
                        '${student.department.name} (${student.department.code})',
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Log out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.textSecondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
