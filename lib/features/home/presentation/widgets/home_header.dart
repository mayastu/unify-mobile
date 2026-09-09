import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';
import '../../../profile/presentation/cubit/student_cubit.dart';
import '../../../profile/presentation/cubit/student_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onLogout,
    required this.palette,
    required this.isDark,
    required this.onToggleTheme,
  });

  final VoidCallback onLogout;
  final AppPalette palette;
  final bool isDark;
  final VoidCallback onToggleTheme;

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
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.primary, palette.primary.withOpacity(0.7)],
                ),
              ),
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
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
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  loading
                      ? _shimmerLine(width: 90, height: 10)
                      : Text(
                    subtitle.isEmpty ? ' ' : subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _HeaderIconButton(
              palette: palette,
              tooltip: isDark ? 'Light mode' : 'Dark mode',
              icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              onPressed: onToggleTheme,
            ),
            const SizedBox(width: 6),
            const NotificationBadge(),
            const SizedBox(width: 2),
            _HeaderIconButton(
              palette: palette,
              tooltip: 'Log out',
              icon: Icons.logout_rounded,
              onPressed: onLogout,
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
        color: palette.border,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.palette,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final AppPalette palette;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, color: palette.textSecondary, size: 21),
    );
  }
}
