import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';
import '../../../profile/presentation/cubit/student_cubit.dart';
import '../../../profile/presentation/cubit/student_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onLogout,
  });

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        final loading = state is StudentLoading;

        String name = 'Student';
        String subtitle = 'Welcome back';
        String initials = 'S';

        if (state is StudentSuccess) {
          final user = state.student.user;

          name = '${user.firstName} ${user.lastName}'.trim();

          subtitle =
          '${state.student.department.name} • ${state.student.studentNumber}';

          initials = user.firstName.isNotEmpty
              ? user.firstName[0].toUpperCase()
              : 'S';
        }

        final hour = DateTime.now().hour;

        final greeting = hour < 12
            ? 'Good morning,'
            : hour < 18
            ? 'Good afternoon,'
            : 'Good evening,';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  loading
                      ? _shimmer(
                    width: 150,
                    height: 34,
                  )
                      : Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 30,
                            height: 1.15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '👋',
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  loading
                      ? _shimmer(
                    width: 180,
                    height: 12,
                  )
                      : Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Column(
              children: [
                Row(
                  children: [
                    const NotificationBadge(),

                    const SizedBox(width: 6),

                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffE7E8F5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.07),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xffEEF0FF),
                              Color(0xffDCDFFA),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                GestureDetector(
                  onTap: onLogout,
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _shimmer({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(.5),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}