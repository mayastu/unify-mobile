import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.route,
    this.accent = AppColors.primary,
  });

  final String label;
  final IconData icon;
  final String? route;
  final Color accent;
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      route: '/profile',
    ),
    _QuickAction(
      label: 'Courses',
      icon: Icons.menu_book_outlined,
      route: '/courses',
    ),
    _QuickAction(
      label: 'Register',
      icon: Icons.add_circle_outline_rounded,
      route: '/registration',
      accent: AppColors.secondary,
    ),
    _QuickAction(
      label: 'My Courses',
      icon: Icons.auto_stories_outlined,
      route: '/my-courses',
    ),
    _QuickAction(
      label: 'Schedule',
      icon: Icons.calendar_month_outlined,
      route: '/schedule',
    ),
    _QuickAction(
      label: 'Academic Record',
      icon: Icons.bar_chart_outlined,
      route: '/grades',
      accent: AppColors.secondary,
    ),
    _QuickAction(
      label: 'Financial Account',
      icon: Icons.account_balance_wallet_outlined,
      route: '/financial-account',
    ),
    _QuickAction(
      label: 'Payments',
      icon: Icons.credit_card_outlined,
      route: '/payments',
      accent: AppColors.secondary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.12,
      ),
      itemBuilder: (context, index) {
        final action = _actions[index];

        return _ActionCard(
          action: action,
          onTap: () {
            if (action.route == null) return;

            context.push(action.route!);
          },
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.action,
    required this.onTap,
  });

  final _QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.border.withOpacity(.42),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.035),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: action.accent.withOpacity(.075),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      size: 29,
                      color: action.accent,
                    ),
                  ),

                  if (action.label == 'Register' ||
                      action.label == 'Payments')
                    Positioned(
                      top: -1,
                      right: -1,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}