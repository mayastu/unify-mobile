import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/widgets/auth_background.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shared shell for every auth screen: the floating-icon background +
/// wave (from [AuthBackground]), an optional back button, a two-line
/// title where the second line is in the accent color, an optional
/// short accent underline, a subtitle, then the page's own content.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.titleLine1,
    required this.titleLine2,
    required this.subtitle,
    required this.child,
    this.showBackButton = true,
    this.showUnderline = true,
    this.onBack,
  });

  final String titleLine1;
  final String titleLine2;
  final String subtitle;
  final Widget child;
  final bool showBackButton;
  final bool showUnderline;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: showBackButton
                      ? _BackButton(onTap: onBack ?? () => context.pop())
                      : null,
                ),
                const SizedBox(height: 70),
                Text(titleLine1, style: AppTextStyles.title),
                Text(titleLine2, style: AppTextStyles.titleAccent),
                if (showUnderline) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(subtitle, style: AppTextStyles.subtitle),
                const SizedBox(height: 32),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.chevron_left_rounded, color: AppColors.primary),
        ),
      ),
    );
  }
}