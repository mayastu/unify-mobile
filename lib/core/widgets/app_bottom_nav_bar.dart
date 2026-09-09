import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class AppNavItem {
  const AppNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Persistent bottom navigation bar for the four main tabs
/// (Home / Courses / Schedule / Profile).
///
/// Unlike the earlier `HomeBottomNavBar`, this is index-driven rather
/// than route-driven: it's meant to be used as the bottom bar of a
/// `StatefulShellRoute.indexedStack` (see AppShellScaffold), which is
/// what makes it stay mounted and correctly highlighted while
/// switching tabs, instead of being pushed/popped per page.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.palette = AppPalette.light,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final AppPalette palette;

  static const _items = [
    AppNavItem(icon: Icons.home_rounded, label: 'Home'),
    AppNavItem(icon: Icons.menu_book_rounded, label: 'Courses'),
    AppNavItem(icon: Icons.calendar_month_rounded, label: 'Schedule'),
    AppNavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 76,
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: _NavButton(
                item: _items[i],
                active: i == currentIndex,
                onTap: () => onTap(i),
                palette: palette,
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
    required this.palette,
  });

  final AppNavItem item;
  final bool active;
  final VoidCallback onTap;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 76,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (!active)
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 23,
                      color: Colors.white.withOpacity(0.55),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),
            if (active)
              Positioned(
                top: -22,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The primary-colored border blends the raised
                    // circle into the bar, giving the "cut out" look
                    // from the reference mockup without a second ring.
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: palette.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: palette.primary, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(item.icon, size: 21, color: palette.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: palette.secondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
