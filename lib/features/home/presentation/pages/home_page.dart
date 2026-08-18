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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go('/login');
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              const _HomeDecorations(),

              RefreshIndicator(
                color: AppColors.secondary,
                backgroundColor: Colors.white,
                onRefresh: () => Future.wait([
                  context.read<StudentCubit>().getProfile(),
                  context.read<SemesterCubit>().getSemesters(),
                  context.read<FinancialCubit>().getFinancialAccount(),
                ]),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    40,
                  ),
                  children: [
                    HomeHeader(
                      onLogout: () => _confirmLogout(context),
                    ),

                    const SizedBox(height: 28),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: const [
                            _TodayOverviewCard(),

                            SizedBox(height: 28),

                            _SectionHeader(
                              title: 'Quick Actions',
                              actionText: 'View all',
                            ),

                            SizedBox(height: 14),

                            QuickActionsGrid(),

                            SizedBox(height: 28),

                            _SectionHeader(
                              title: 'Financial Overview',
                              actionText: 'View details',
                            ),

                            SizedBox(height: 14),

                            FinancialSummaryCard(),

                            SizedBox(height: 16),

                            _RegistrationBanner(),

                            SizedBox(height: 20),

                            _UniversityFooter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                authCubit.logout();
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TodayOverviewCard extends StatelessWidget {
  const _TodayOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withOpacity(.45),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _IconCircle(
                icon: Icons.calendar_month_rounded,
                color: AppColors.primary,
                background: Color(0xffF0F1FF),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () => context.push('/schedule'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF8E8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'View',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffFAFAFE),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border.withOpacity(.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF7E6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: AppColors.secondary,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: SemesterSummaryCard(
                    compact: true,
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffFAFAFE),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border.withOpacity(.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xffF0F1FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: FinancialSummaryCard(
                    compact: true,
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
  });

  final String title;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        Text(
          actionText,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: AppColors.secondary,
        ),
      ],
    );
  }
}

class _RegistrationBanner extends StatelessWidget {
  const _RegistrationBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/registration'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.border.withOpacity(.45),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.035),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffFFF7E5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: AppColors.secondary,
                size: 25,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration is open',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Register now and secure your spot.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _UniversityFooter extends StatelessWidget {
  const _UniversityFooter();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Your University. ',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: 'Unified.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Academic Excellence & Community',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}

class _HomeDecorations extends StatelessWidget {
  const _HomeDecorations();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 45,
            right: 18,
            child: _softDot(
              size: 7,
              color: AppColors.secondary,
            ),
          ),
          Positioned(
            top: 210,
            left: 8,
            child: _softDot(
              size: 6,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            top: 340,
            right: 12,
            child: _softDot(
              size: 8,
              color: const Color(0xffD8D5EE),
            ),
          ),
          Positioned(
            bottom: 180,
            left: 12,
            child: _softDot(
              size: 7,
              color: AppColors.secondary,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 30,
            child: _softDot(
              size: 5,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _softDot({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(.55),
        shape: BoxShape.circle,
      ),
    );
  }
}