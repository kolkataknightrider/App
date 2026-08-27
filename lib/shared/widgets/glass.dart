// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/glass.dart
// Glassmorphism building blocks used across PARTIX.
// Frosted blur + translucent gradient fill + hairline light border.
// ════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/app_colors.dart';

/// A frosted-glass surface with a soft inner highlight and light border.
///
/// Use this instead of [Card] everywhere — it is the core visual language
/// of the app (rounded, translucent, blurred, subtly glowing).
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double blur;

  /// Optional accent used for the border glow + top highlight.
  final Color? accent;

  /// Extra translucent gradient painted above the blur.
  final Gradient? overlay;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Slight lift + glow while pressed.
  final bool interactive;

  /// Optional fixed size.
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.radius = 22,
    this.blur = 18,
    this.accent,
    this.overlay,
    this.onTap,
    this.onLongPress,
    this.interactive = true,
    this.width,
    this.height,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (!widget.interactive || widget.onTap == null) return;
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent ?? AppColors.brandPrimary;
    final radius = BorderRadius.circular(widget.radius);

    final surface = AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: widget.margin,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
            if (_pressed)
              BoxShadow(
                color: accent.withOpacity(0.35),
                blurRadius: 28,
                spreadRadius: -6,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: widget.overlay ??
                    LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.09),
                        Colors.white.withOpacity(0.03),
                      ],
                    ),
                border: Border.all(
                  color: Colors.white.withOpacity(_pressed ? 0.28 : 0.14),
                  width: 1,
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.onTap == null && widget.onLongPress == null) return surface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap!();
            },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            },
      child: surface,
    );
  }
}

/// Rounded pill used for chips, filters and small badges.
class GlassPill extends StatelessWidget {
  final Widget child;
  final Color? accent;
  final bool active;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GlassPill({
    super.key,
    required this.child,
    this.accent,
    this.active = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final a = accent ?? AppColors.brandPrimary;
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onTap!();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: padding,
        decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(colors: [a, a.withOpacity(0.65)])
              : LinearGradient(colors: [
                  Colors.white.withOpacity(0.07),
                  Colors.white.withOpacity(0.03),
                ]),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active ? Colors.transparent : Colors.white.withOpacity(0.12),
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: a.withOpacity(0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  )
                ]
              : null,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Scale + haptic feedback wrapper for any tappable element.
class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;

  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.94,
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap!();
            },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            },
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
