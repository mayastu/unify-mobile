import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    this.route,
  });

  final String label;
  final IconData icon;
  final String? route;
}

/// Bottom navigation styled like the provided mockup.
///
/// The active item floats above the navigation bar inside
/// a circular button using the app's secondary color.
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    this.palette = AppPalette.light,
  });

  final AppPalette palette;

  static const _items = [
    _NavItem(
      label: 'Home',
      icon: Icons.home_rounded,
    ),
    _NavItem(
      label: 'Courses',
      icon: Icons.menu_book_rounded,
      route: '/courses',
    ),
    _NavItem(
      label: 'Schedule',
      icon: Icons.calendar_month_rounded,
      route: '/schedule',
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_rounded,
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 76,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              palette.brightness == Brightness.dark ? 0.25 : 0.08,
            ),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final item in _items)
            Expanded(
              child: _NavButton(
                item: item,
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
    required this.palette,
  });

  final _NavItem item;
  final AppPalette palette;

  bool get _isActive => item.route == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (item.route != null) {
          context.push(item.route!);
        }
      },
      child: SizedBox(
        height: 76,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Normal item
            if (!_isActive)
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 23,
                      color: palette.iconFaint,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // Active item
            if (_isActive)
              Positioned(
                top: -30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Floating active circle
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: palette.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              palette.brightness == Brightness.dark
                                  ? 0.3
                                  : 0.10,
                            ),
                            blurRadius: 14,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: palette.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            size: 23,
                            color: palette.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

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