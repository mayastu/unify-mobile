import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../financial_account/presentation/cubit/financial_cubit.dart';
import '../../../financial_account/presentation/cubit/financial_state.dart';
import '../../../payment/presentation/cubit/payment_cubit.dart';
import '../../../payment/presentation/cubit/payment_state.dart';
import '../../../registration/presentation/cubit/registration_cubit.dart';
import '../../../registration/presentation/cubit/registration_state.dart';

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    this.route,
    this.staticSubtitle,
  });

  final String label;
  final IconData icon;

  /// Left null until the destination page is built.
  /// Tapping shows a "coming soon" snackbar instead of navigating.
  final String? route;

  /// Subtitle shown when no cubit-backed value applies to this tile.
  final String? staticSubtitle;
}

/// Entry points to every major section of the student journey,
/// laid out as a 3x2 grid to match the mockup.
///
/// Add the route once its page exists — nothing else needs to change
/// here or in the router besides wiring that one screen.
///
/// Note: the mockup's 6th tile is "Attendance" with an aggregate
/// "% Present" figure, but there is no home-level attendance summary
/// (AttendanceSummaryCubit only loads per-enrollment, via
/// /my-courses/:id/attendance) — showing a percentage here would mean
/// inventing an aggregate the API doesn't provide. "Grades" stands in
/// its place since it's a real, already-working top-level route.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key, this.palette = AppPalette.light});

  final AppPalette palette;

  static const List<_QuickAction> _actions = [
    _QuickAction(
      label: 'My Courses',
      icon: Icons.menu_book_rounded,
      route: '/my-courses',
    ),
    _QuickAction(
      label: 'Schedule',
      icon: Icons.calendar_month_rounded,
      route: '/schedule',
      staticSubtitle: 'Today',
    ),
    _QuickAction(
      label: 'Grades',
      icon: Icons.grade_outlined,
      route: '/grades',
      staticSubtitle: 'This semester',
    ),
    _QuickAction(
      label: 'Register',
      icon: Icons.assignment_turned_in_outlined,
      route: '/registration',
    ),
    _QuickAction(
      label: 'Payments',
      icon: Icons.payments_outlined,
      route: '/payments',
    ),
    _QuickAction(
      label: 'Financial Account',
      icon: Icons.account_balance_rounded,
      route: '/financial-account',
    ),
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
        childAspectRatio: 0.86,
      ),
      itemBuilder: (context, index) {
        final action = _actions[index];

        return Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _handleTap(context, action),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: palette.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(action.icon, color: palette.primary, size: 20),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _Subtitle(action: action, palette: palette),
                ],
              ),
            ),
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

/// Renders each tile's subtitle. Cubit-backed tiles read whichever
/// cubit is already provided on the Home route (Financial, Payment,
/// Registration) — nothing new is fetched here, this only reads
/// state that's already being loaded for the other Home cards.
class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.action, required this.palette});

  final _QuickAction action;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    switch (action.label) {
      case 'Financial Account':
        return BlocBuilder<FinancialCubit, FinancialState>(
          builder: (context, state) {
            final text = state is FinancialSuccess
                ? '\$${state.account.availableBalance.toStringAsFixed(2)}'
                : '';
            return _text(text);
          },
        );

      case 'Payments':
        return BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            final text =
                state is PaymentLoaded ? '${state.payments.length} records' : '';
            return _text(text);
          },
        );

      case 'Register':
        return BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            final text = state is RegistrationLoaded
                ? (state.availableCourses.isNotEmpty ? 'Open' : 'Closed')
                : '';
            return _text(text);
          },
        );

      default:
        return _text(action.staticSubtitle ?? '');
    }
  }

  Widget _text(String value) {
    if (value.isEmpty) return const SizedBox(height: 13);

    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: palette.textSecondary,
      ),
    );
  }
}
