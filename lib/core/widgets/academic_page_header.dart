import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

class AcademicPageHeader extends StatelessWidget {
  const AcademicPageHeader({
    super.key,
    required this.palette,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.badgeText,
    this.metaText,
    this.icon = Icons.auto_stories_rounded,
    this.showSparkle = true,
    this.height = 205,
    this.margin = const EdgeInsets.fromLTRB(20, 14, 20, 0),
  });

  final AppPalette palette;

  final String title;
  final String subtitle;

  /// Optional small label above the title.
  /// Example: "MY ACADEMICS"
  final String? eyebrow;

  /// Optional highlighted badge.
  /// Example: "10 courses"
  final String? badgeText;

  /// Optional text next to the badge.
  /// Example: "This semester"
  final String? metaText;

  final IconData icon;
  final bool showSparkle;

  final double height;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 25,
            bottom: -70,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: palette.secondary.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 24,
            top: 24,
            child: Transform.rotate(
              angle: 0.18,
              child: Icon(
                icon,
                size: 72,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Optional eyebrow
                if (eyebrow != null)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.school_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              eyebrow!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      if (showSparkle)
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: palette.secondary,
                          size: 21,
                        ),
                    ],
                  )
                else
                  Align(
                    alignment: Alignment.topRight,
                    child: showSparkle
                        ? Icon(
                      Icons.auto_awesome_rounded,
                      color: palette.secondary,
                      size: 21,
                    )
                        : const SizedBox(),
                  ),

                const Spacer(),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 12.5,
                  ),
                ),

                if (badgeText != null || metaText != null) ...[
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: palette.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              color: palette.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                      if (badgeText != null &&
                          metaText != null)
                        const SizedBox(width: 8),

                      if (metaText != null)
                        Text(
                          metaText!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}