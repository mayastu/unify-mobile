import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../announcements/presentation/cubit/announcement_cubit.dart';
import '../../../announcements/presentation/widgets/announcement_promo_banner.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../profile/presentation/cubit/student_cubit.dart';
import '../../../registration/presentation/cubit/registration_cubit.dart';
import '../../../semesters/presentation/cubit/semester_cubit.dart';
import '../widgets/financial_overview_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_wave_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/registration_banner.dart';
import '../widgets/today_schedule_card.dart';

// Note: the bottom nav bar is no longer built here — AppShellScaffold
// (see core/router/app_router.dart) now owns it, so it stays mounted
// and correctly highlighted while switching between Home / Courses /
// Schedule / Profile instead of being pushed/popped per page.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette = isDark ? AppPalette.dark : AppPalette.light;

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
            backgroundColor: palette.background,
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () => Future.wait([
                  context.read<StudentCubit>().getProfile(),
                  context.read<SemesterCubit>().getSemesters(),
                  context.read<FinancialCubit>().getFinancialAccount(),
                  context.read<AnnouncementCubit>().getAnnouncements(),
                  context.read<RegistrationCubit>().getAvailableCourses(),
                ]),
                child: Stack(
                  children: [
                    HomeWaveHeader(palette: palette, height: 150),
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      children: [
                        HomeHeader(
                          onLogout: () => _confirmLogout(context, palette),
                          palette: palette,
                          isDark: isDark,
                          onToggleTheme: () => AppThemeController.instance.toggle(),
                        ),
                        const SizedBox(height: 22),
                        TodayScheduleCard(palette: palette),
                        const SizedBox(height: 20),
                        Text(
                          'Quick actions',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        QuickActionsGrid(palette: palette),
                        const SizedBox(height: 20),
                        FinancialOverviewCard(palette: palette),
                        const SizedBox(height: 16),
                        RegistrationBanner(palette: palette),
                        const SizedBox(height: 12),
                        AnnouncementPromoBanner(palette: palette),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AppPalette palette) {
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: palette.surface,
        title: Text('Log out', style: TextStyle(color: palette.textPrimary)),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: palette.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: TextStyle(color: palette.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              authCubit.logout();
            },
            child: Text(
              'Log out',
              style: TextStyle(color: palette.secondary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
