import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const logo = TextStyle(
    fontSize: 46,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const title = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// The second line of every auth screen's title (e.g. "Back" in
  /// "Welcome Back", "Password" in "Forgot Password") — same size as
  /// [title] but in the gold accent color.
  static const titleAccent = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.secondary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );

  static const footer = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}