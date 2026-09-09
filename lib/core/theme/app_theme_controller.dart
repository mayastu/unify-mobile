import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';
import 'app_palette.dart';

/// Single source of truth for the app's light/dark mode.
///
/// Deliberately a plain explicit toggle (no `ThemeMode.system`) — see
/// [AppPalette] for why. Screens that have been redesigned should
/// wrap themselves in a `ValueListenableBuilder<bool>` on
/// [AppThemeController.instance] and read [palette] to pick colors.
class AppThemeController extends ValueNotifier<bool> {
  AppThemeController._() : super(false);

  static final AppThemeController instance = AppThemeController._();

  bool get isDark => value;

  AppPalette get palette => value ? AppPalette.dark : AppPalette.light;

  /// Restores the saved preference. Call once, before the first
  /// screen that reads [palette] is built (see main.dart).
  Future<void> load() async {
    final saved = await SecureStorage.getThemeMode();
    if (saved != null) {
      value = saved == 'dark';
    }
  }

  Future<void> toggle() async {
    value = !value;
    await SecureStorage.saveThemeMode(value ? 'dark' : 'light');
  }
}
