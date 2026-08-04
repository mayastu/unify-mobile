import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    this.route,
  });

  final String label;
  final IconData icon;

  /// Left null until the destination page is built.
  /// Tapping shows a "coming soon" snackbar instead of navigating.
  final String? route;
}

/// Entry points to every major section of the student journey.
///
/// Add the route once its page exists — nothing else needs to change
/// here or in the router besides wiring that one screen.
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
      icon: Icons.menu_book_rounded,
      route: '/courses',
    ),
    _QuickAction(
      label: 'Register',
      icon: Icons.assignment_turned_in_outlined,
      route: '/registration',
    ),
    _QuickAction(label: 'My courses', icon: Icons.fact_check_outlined),
    _QuickAction(
      label: 'Schedule',
      icon: Icons.schedule_rounded,
      route: '/schedule',
    ),
    _QuickAction(
      label: 'Financial account',
      icon: Icons.account_balance_rounded,
      route: '/payments',
    ),
    _QuickAction(label: 'Payments', icon: Icons.payments_outlined,route: '/payments'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final action = _actions[index];

        return AppCard(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          onTap: () => _handleTap(context, action),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, _QuickAction action) {
    if (action.route != null) {
      context.push(action.route!);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${action.label} — coming soon')),
    );
  }
}
