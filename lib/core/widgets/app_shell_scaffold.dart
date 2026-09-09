import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme_controller.dart';
import 'app_bottom_nav_bar.dart';

/// Shell for the four main tabs (Home / Courses / Schedule / Profile).
///
/// Used as the `builder` of a `StatefulShellRoute.indexedStack` in
/// app_router.dart. Each branch keeps its own Navigator (and its
/// cubit state) alive in the background, so switching tabs no longer
/// re-fetches or stacks a new page on top — it really is "switch
/// tab", not "push a page". [navigationShell.currentIndex] is the
/// single source of truth for which nav item is highlighted, so it's
/// always correct for whatever route is actually on screen.
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppThemeController.instance,
      builder: (context, isDark, _) {
        final palette = isDark ? AppPalette.dark : AppPalette.light;

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: SafeArea(
            top: false,
            child: AppBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              palette: palette,
              onTap: (index) => navigationShell.goBranch(
                index,
                // Tapping the tab you're already on pops that branch
                // back to its root instead of doing nothing — the
                // usual bottom-nav convention.
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
          ),
        );
      },
    );
  }
}
