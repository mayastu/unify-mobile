import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_card.dart';
import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({
    super.key,
    required this.palette,
  });

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FinancialCubit>().state;

    if (state is! FinancialSuccess) {
      return const SizedBox();
    }

    final account = state.account;

    final purchased = account.purchasedCreditHours;
    final remaining = account.remainingCreditHours;
    final used = account.usedCreditHours;

    final progress = purchased <= 0
        ? 0.0
        : (remaining / purchased).clamp(0.0, 1.0);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────
            // Header
            // ─────────────────────────────────

            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: palette.primary.withOpacity(.09),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: palette.primary,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Your credit hour balance',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────
            // Main balance section
            // ─────────────────────────────────

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circle
                SizedBox(
                  width: 148,
                  height: 148,
                  child: CustomPaint(
                    painter: _CreditHoursPainter(
                      progress: progress,
                      primary: palette.primary,
                      trackColor:
                      palette.primary.withOpacity(.09),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$remaining',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: palette.textPrimary,
                              height: 1,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'remaining',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            'credit hours',
                            style: TextStyle(
                              fontSize: 10,
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 22),

                // Right side stats
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      _BalanceStat(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Available balance',
                        value: '\$${account.availableBalance}',
                        palette: palette,
                        highlight: true,
                      ),

                      const SizedBox(height: 14),

                      _BalanceStat(
                        icon: Icons.shopping_cart_checkout_rounded,
                        title: 'Purchased',
                        value: '$purchased hrs',
                        palette: palette,
                      ),

                      const SizedBox(height: 14),

                      _BalanceStat(
                        icon: Icons.menu_book_rounded,
                        title: 'Used',
                        value: '$used hrs',
                        palette: palette,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ─────────────────────────────────
            // Progress information
            // ─────────────────────────────────

            Row(
              children: [
                Expanded(
                  child: Text(
                    purchased == 0
                        ? 'No credit hours purchased'
                        : '$remaining of $purchased hours remaining',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
                    ),
                  ),
                ),

                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: palette.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor:
                palette.primary.withOpacity(.08),
                valueColor:
                AlwaysStoppedAnimation<Color>(
                  palette.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// Balance stat
// ═══════════════════════════════════════════════

class _BalanceStat extends StatelessWidget {
  const _BalanceStat({
    required this.icon,
    required this.title,
    required this.value,
    required this.palette,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final AppPalette palette;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: highlight
                ? palette.secondary.withOpacity(.16)
                : palette.primary.withOpacity(.07),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 17,
            color: highlight
                ? palette.secondary
                : palette.primary,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  color: palette.textSecondary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════
// Circular progress painter
// ═══════════════════════════════════════════════

class _CreditHoursPainter extends CustomPainter {
  const _CreditHoursPainter({
    required this.progress,
    required this.primary,
    required this.trackColor,
  });

  final double progress;
  final Color primary;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(size.width, size.height) / 2 - 9;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    // Progress
    final progressPaint = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Small end dot
    if (progress > 0) {
      final angle =
          startAngle + (2 * math.pi * progress);

      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final dotPaint = Paint()
        ..color = primary
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        dotCenter,
        5.5,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _CreditHoursPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress ||
        oldDelegate.primary != primary ||
        oldDelegate.trackColor != trackColor;
  }
}