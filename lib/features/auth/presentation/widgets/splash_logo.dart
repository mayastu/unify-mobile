import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constant/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

/// The Unify wordmark, animated in on entrance:
/// - the navy "U" drops in from above,
/// - the gold accent piece slides in from the side once the U has
///   nearly landed, completing the mark,
/// - "nify" and the tagline fade in right after.
class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key, this.markSize = 88});

  final double markSize;

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _uFade;
  late final Animation<double> _uDy;

  late final Animation<double> _accentFade;
  late final Animation<double> _accentDx;

  late final Animation<double> _nifyFade;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _uFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.30, curve: Curves.easeOut),
    );
    _uDy = Tween<double>(begin: -70, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _accentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.65, curve: Curves.easeOut),
    );
    _accentDx = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.75, curve: Curves.easeOutBack),
      ),
    );

    _nifyFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
    );
    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.85, 1, curve: Curves.easeOut),
    );

    _controller.forward(from: 0);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markWidth = widget.markSize;
    final markHeight = widget.markSize * (272 / 208);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: markWidth,
                  height: markHeight,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: _uFade.value,
                        child: Transform.translate(
                          offset: Offset(0, _uDy.value),
                          child: SvgPicture.asset(AppAssets.logoU),
                        ),
                      ),
                      Opacity(
                        opacity: _accentFade.value,
                        child: Transform.translate(
                          offset: Offset(_accentDx.value, 0),
                          child: SvgPicture.asset(AppAssets.logoAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: _nifyFade.value,
                  child: Text(
                    'nify',
                    style: TextStyle(
                      fontSize: widget.markSize * 0.44,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      letterSpacing: -0.3,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Opacity(
              opacity: _taglineFade.value,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(text: 'Your University. '),
                    TextSpan(
                      text: 'Unified.',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}