import 'package:flutter/material.dart';

/// Central color palette for the app.
///
/// Derived from the existing splash screen identity
/// (navy gradient + gold accent) so every new screen
/// stays visually consistent with it.
class AppColors {
  AppColors._();

  static const Color primaryDark = Color(0xFF18216D);
  static const Color primary = Color(0xFF283593);
  static const Color accent = Color(0xFFFDB813);

  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1B1B2F);
  static const Color textSecondary = Color(0xFF6B6B80);
  static const Color textMuted = Color(0xFFA0A0B2);

  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);

  static const Color border = Color(0xFFE7E7F0);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );
}
