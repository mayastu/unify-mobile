import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/cubit/student_cubit.dart';
import '../../../profile/presentation/cubit/student_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        final loading = state is StudentLoading;

        String name = 'Student';
        String subtitle = '';
        String initials = 'S';

        if (state is StudentSuccess) {
          final user = state.student.user;
          name = '${user.firstName} ${user.lastName}'.trim();
          subtitle =
              '${state.student.department.name} · ${state.student.studentNumber}';
          initials = user.firstName.isNotEmpty
              ? user.firstName[0].toUpperCase()
              : 'S';
        }

        return Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loading
                      ? _shimmerLine(width: 130)
                      : Text(
                          'Welcome, $name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                  const SizedBox(height: 6),
                  loading
                      ? _shimmerLine(width: 90, height: 10)
                      : Text(
                          subtitle.isEmpty ? ' ' : subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ],
              ),
            ),
            IconButton(
              onPressed: onLogout,
              tooltip: 'Log out',
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _shimmerLine({required double width, double height = 14}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
