import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_theme_controller.dart';
import '../../../../core/widgets/academic_page_header.dart';
import '../../../../core/widgets/app_empty.dart';

import '../../../home/presentation/widgets/financial_summary_card.dart';
import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';
import '../widgets/hour_purchase_history_list.dart';
import '../widgets/purchase_credit_hours_card.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinancialCubit>().getFinancialAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette =
        isDark ? AppPalette.dark : AppPalette.light;

        return Scaffold(
          backgroundColor: palette.background,

          body: SafeArea(
            bottom: false,

            child: BlocConsumer<FinancialCubit, FinancialState>(
              listener: (context, state) {
                if (state is FinancialFailure) {
                  _showMessage(
                    context,
                    state.message,
                    palette,
                  );
                }

                if (state is PurchaseSuccess) {
                  _showMessage(
                    context,
                    'Credit hours purchased successfully.',
                    palette,
                    success: true,
                  );
                }

                if (state is PurchaseFailure) {
                  _showMessage(
                    context,
                    state.message,
                    palette,
                  );
                }
              },

              builder: (context, state) {
                // ─────────────────────────────
                // Loading
                // ─────────────────────────────

                if (state is FinancialLoading ||
                    state is FinancialInitial) {
                  return _FinancialLoading(
                    palette: palette,
                  );
                }

                // ─────────────────────────────
                // Failure
                // ─────────────────────────────

                if (state is FinancialFailure) {
                  return AppEmpty(
                    icon: Icons.account_balance_wallet_outlined,
                    message: state.message,
                    actionText: 'Retry',
                    onAction: () {
                      context
                          .read<FinancialCubit>()
                          .getFinancialAccount();
                    },
                  );
                }

                // ─────────────────────────────
                // Content
                // ─────────────────────────────

                return RefreshIndicator(
                  color: palette.primary,

                  onRefresh: () {
                    return context
                        .read<FinancialCubit>()
                        .getFinancialAccount();
                  },

                  child: ListView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),

                    padding: const EdgeInsets.only(
                      bottom: 40,
                    ),

                    children: [
                      // ─────────────────────────
                      // Header
                      // ─────────────────────────

                      AcademicPageHeader(
                        palette: palette,
                        title: 'Financial Account',
                        subtitle:
                        'Manage your credit hours and balance.',
                        badgeText: 'Student account',
                        metaText: 'Financial',
                        icon:
                        Icons.account_balance_wallet_rounded,
                      ),

                      const SizedBox(height: 22),

                      // ─────────────────────────
                      // Balance
                      // ─────────────────────────

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: FinancialSummaryCard(
                          palette: palette,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ─────────────────────────
                      // Purchase section title
                      // ─────────────────────────

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buy credit hours',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight:
                                FontWeight.w800,
                                color:
                                palette.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              'Add credit hours to your academic account.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color:
                                palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 13),

                      // ─────────────────────────
                      // Purchase card
                      // ─────────────────────────

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: PurchaseCreditHoursCard(
                          palette: palette,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ─────────────────────────
                      // History title
                      // ─────────────────────────

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Purchase history',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight:
                                      FontWeight.w800,
                                      color:
                                      palette.textPrimary,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    'Your previous credit hour purchases.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                      palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: palette.surface,
                                borderRadius:
                                BorderRadius.circular(13),
                                border: Border.all(
                                  color: palette.border,
                                ),
                              ),
                              child: Icon(
                                Icons.history_rounded,
                                size: 20,
                                color:
                                palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 13),

                      // ─────────────────────────
                      // History
                      // ─────────────────────────

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: HourPurchaseHistoryList(
                          palette: palette,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showMessage(
      BuildContext context,
      String message,
      AppPalette palette, {
        bool success = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: success
              ? palette.primary
              : Theme.of(context)
              .colorScheme
              .error,
          content: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
  }
}

// ═══════════════════════════════════════════════
// Loading
// ═══════════════════════════════════════════════

class _FinancialLoading extends StatelessWidget {
  const _FinancialLoading({
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AcademicPageHeader(
          palette: palette,
          title: 'Financial Account',
          subtitle:
          'Manage your credit hours and balance.',
          badgeText: 'Loading',
          metaText: 'Financial',
          icon:
          Icons.account_balance_wallet_rounded,
        ),

        const SizedBox(height: 40),

        CircularProgressIndicator(
          color: palette.primary,
          strokeWidth: 2.5,
        ),
      ],
    );
  }
}