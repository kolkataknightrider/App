// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/glass.dart
// CLAYMORPHISM building blocks (class names kept for compatibility).
//
// GlassCard is the core surface used across EVERY screen — it now
// renders a tactile clay surface instead of frosted glass, so the
// whole app adopts the clay look in one place.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/shared/widgets/clay.dart';

/// A clay surface with a soft inner highlight + outer drop shadow.
///
/// This is the core visual language of the app. It keeps the old
/// glassmorphism API (`blur`, `accent`, `overlay`, `interactive`) so
/// every existing screen adopts clay automatically.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double blur; // retained for API compatibility (unused in clay)

  /// Optional accent used for the top highlight + border tint.
  final Color? accent;

  /// Extra gradient painted over the clay surface.
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
    final base = ClayColors.surface(context);

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
          boxShadow: clayShadows(
            shadowColor: ClayColors.shadow(context),
            elevation: _pressed ? 0.55 : 1.0,
            radius: widget.radius.toDouble(),
          ),
        ),
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: widget.overlay ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(base, Colors.white, 0.06)!,
                    base,
                    Color.lerp(base, Colors.black, 0.08)!,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
            border: Border.all(
              color: accent.withOpacity(_pressed ? 0.35 : 0.14),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                // Inner clay highlight (top-left) + shade (bottom-right).
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(
                                ClayColors.isDark(context) ? 0.10 : 0.65),
                            Colors.white.withOpacity(0.0),
                            Colors.black.withOpacity(
                                ClayColors.isDark(context) ? 0.26 : 0.10),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                widget.child,
              ],
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

/// Rounded clay pill used for chips, filters and small badges.
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
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                        ClayColors.surface(context), Colors.white, 0.08)!,
                    ClayColors.surface(context),
                  ],
                ),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: active ? Colors.transparent : a.withOpacity(0.20),
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
            color: active ? Colors.white : ClayColors.textDim(context),
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
