import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// A short-lived, centered success overlay: a scaling checkmark burst
/// + a message, auto-dismissing. Meant for moments that deserve more
/// weight than a SnackBar (registration submitted, payment recorded)
/// without pulling in a new animation/confetti package.
///
/// Usage: `SuccessOverlay.show(context, palette: palette, message: '...');`
class SuccessOverlay {
  static void show(
    BuildContext context, {
    required AppPalette palette,
    required String message,
    String? subtitle,
    Duration visibleFor = const Duration(milliseconds: 1800),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _SuccessOverlayContent(
        palette: palette,
        message: message,
        subtitle: subtitle,
        visibleFor: visibleFor,
        onDone: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _SuccessOverlayContent extends StatefulWidget {
  const _SuccessOverlayContent({
    required this.palette,
    required this.message,
    required this.subtitle,
    required this.visibleFor,
    required this.onDone,
  });

  final AppPalette palette;
  final String message;
  final String? subtitle;
  final Duration visibleFor;
  final VoidCallback onDone;

  @override
  State<_SuccessOverlayContent> createState() => _SuccessOverlayContentState();
}

class _SuccessOverlayContentState extends State<_SuccessOverlayContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.4, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(widget.visibleFor, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Positioned.fill(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _fade,
          child: Container(
            color: Colors.black.withOpacity(0.35),
            alignment: Alignment.center,
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 48),
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 26),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CheckBurst(color: palette.secondary),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5, color: palette.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckBurst extends StatefulWidget {
  const _CheckBurst({required this.color});

  final Color color;

  @override
  State<_CheckBurst> createState() => _CheckBurstState();
}

class _CheckBurstState extends State<_CheckBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ringController,
            builder: (context, _) {
              final t = _ringController.value;
              return Opacity(
                opacity: 1 - t,
                child: Transform.scale(
                  scale: 0.7 + (t * 0.6),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.color, width: 2),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: widget.color, size: 30),
          ),
        ],
      ),
    );
  }
}
