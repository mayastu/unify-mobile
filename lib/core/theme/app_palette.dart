import 'package:flutter/material.dart';

/// A self-contained light/dark color set for the *redesigned* screens
/// (starting with Home). Deliberately not merged into [AppColors]:
/// that class is `static const` and referenced inside dozens of
/// `const TextStyle(...)` / `const BoxDecoration(...)` calls across
/// screens we haven't touched yet — turning it into something
/// brightness-aware would require editing every one of those call
/// sites in the same pass, which is out of scope for now and risks
/// breaking screens nobody asked to change.
///
/// As each screen gets redesigned, it switches from `AppColors.x` to
/// `palette.x` (obtained via [AppThemeController]). Once every screen
/// has migrated, this can simply become the new AppColors.
class AppPalette {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color primary;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color iconFaint;
  final Color waveBlue;
  final Color waveGold;
  final Brightness brightness;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.iconFaint,
    required this.waveBlue,
    required this.waveGold,
    required this.brightness,
  });

  static const light = AppPalette(
    background: Color(0xFFF8FAFC),
    surface: Colors.white,
    surfaceElevated: Color(0xFFF3F5FC),
    primary: Color(0xFF1A237E),
    secondary: Color(0xFFFFB300),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF64748B),
    border: Color(0xFFE5E7EB),
    iconFaint: Color(0xFFD9DCEC),
    waveBlue: Color(0xFFE7E9FF),
    waveGold: Color(0xFFFFF4DA),
    brightness: Brightness.light,
  );

  static const dark = AppPalette(
    background: Color(0xFF0E1121),
    surface: Color(0xFF171B30),
    surfaceElevated: Color(0xFF20254A),
    primary: Color(0xFF8C9EFF),
    secondary: Color(0xFFFFC24B),
    textPrimary: Color(0xFFF1F3FB),
    textSecondary: Color(0xFF9AA3C4),
    border: Color(0xFF2A2F52),
    iconFaint: Color(0xFF2A2F52),
    waveBlue: Color(0xFF232A52),
    waveGold: Color(0xFF3A2E18),
    brightness: Brightness.dark,
  );
}
