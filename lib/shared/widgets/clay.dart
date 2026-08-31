// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/clay.dart
// CLAYMORPHISM CORE — the tactile "clay" primitive.
//
// Claymorphism = big rounded corners + a soft OUTER drop shadow +
// an INNER highlight (light top-left) + an INNER shade (bottom-right),
// giving the surface a squishy, pressable 3D look.
//
//   • ClayContainer  — base clay surface (with press-squish & 3D tilt)
//   • ClayCard       — clay surface with optional title chrome
//   • ClayColors     — theme-aware clay colour resolver
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/clay_palette.dart';

/// Resolves theme-aware clay colours from the ambient [BuildContext].
class ClayColors {
  ClayColors._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext context) =>
      isDark(context) ? ClayPalette.bgDark : ClayPalette.bgLight;

  static Color surface(BuildContext context) =>
      isDark(context) ? ClayPalette.surfaceDark : ClayPalette.surfaceLight;

  static Color text(BuildContext context) =>
      isDark(context) ? const Color(0xFFF1EEFA) : const Color(0xFF2B2740);

  static Color textDim(BuildContext context) =>
      isDark(context) ? const Color(0xFF9B93C4) : const Color(0xFF6E6888);

  /// The colour of the soft outer drop shadow (theme aware).
  static Color shadow(BuildContext context) =>
      isDark(context) ? const Color(0xFF0A0718) : const Color(0xFFB7AFD6);

  /// The colour used for the top-left inner highlight.
  static Color highlight(BuildContext context) => Colors.white;
}

/// The signature clay shadow recipe: outer drop + soft ambient.
List<BoxShadow> clayShadows({
  required Color shadowColor,
  double elevation = 1.0,
  double radius = 26,
}) {
  return [
    // Directional drop shadow (bottom-right).
    BoxShadow(
      color: shadowColor.withOpacity(0.30 * elevation),
      offset: Offset(8 * elevation, 12 * elevation),
      blurRadius: 30 * elevation,
      spreadRadius: -4,
    ),
    // Soft ambient shadow.
    BoxShadow(
      color: shadowColor.withOpacity(0.16),
      offset: const Offset(0, 18),
      blurRadius: 44,
      spreadRadius: -8,
    ),
  ];
}

/// Core clay surface. Wrap any content to make it look like pressed clay.
class ClayContainer extends StatefulWidget {
  final Widget child;

  /// Squish scale when pressed.
  final double pressScale;

  /// Whether press feedback (squish + haptic) is enabled.
  final bool pressable;

  /// Whether the surface tilts in 3D toward the pointer.
  final bool tilt;

  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double elevation;
  final Color? color;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final Duration duration;

  const ClayContainer({
    super.key,
    required this.child,
    this.pressScale = 0.97,
    this.pressable = false,
    this.tilt = false,
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.radius = 26,
    this.elevation = 1.0,
    this.color,
    this.gradient,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 240),
  });

  @override
  State<ClayContainer> createState() => _ClayContainerState();
}

class _ClayContainerState extends State<ClayContainer> {
  bool _pressed = false;
  double _tiltX = 0;
  double _tiltY = 0;

  void _setPressed(bool v) {
    if (widget.pressable && _pressed != v) setState(() => _pressed = v);
  }

  void _onPointerMove(Offset local, Size size) {
    if (!widget.tilt) return;
    final dx = (local.dx / size.width) * 2 - 1;
    final dy = (local.dy / size.height) * 2 - 1;
    setState(() {
      _tiltX = dy * -0.09;
      _tiltY = dx * 0.09;
    });
  }

  void _onPointerExit() {
    if (_tiltX != 0 || _tiltY != 0) {
      setState(() {
        _tiltX = 0;
        _tiltY = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = ClayColors.isDark(context);
    final radius = BorderRadius.circular(widget.radius);
    final elevation = _pressed ? widget.elevation * 0.5 : widget.elevation;
    final baseColor = widget.color ?? ClayColors.surface(context);

    Widget surface = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: widget.gradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(baseColor, Colors.white, dark ? 0.05 : 0.55)!,
                baseColor,
                Color.lerp(baseColor, Colors.black, dark ? 0.20 : 0.06)!,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
        boxShadow: clayShadows(
          shadowColor: ClayColors.shadow(context),
          elevation: elevation,
          radius: widget.radius.toDouble(),
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // ── Inner highlight (top-left) + inner shade (bottom-right) ──
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ClayColors.highlight(context)
                            .withOpacity(dark ? 0.10 : 0.75),
                        Colors.white.withOpacity(0.0),
                        Colors.black.withOpacity(dark ? 0.28 : 0.10),
                      ],
                      stops: const [0.0, 0.52, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        ),
      ),
    );

    // ── Press squish ──
    surface = AnimatedScale(
      scale: _pressed ? widget.pressScale : 1.0,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: surface,
    );

    // ── 3D tilt ──
    surface = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_tiltX)
        ..rotateY(_tiltY),
      transformAlignment: Alignment.center,
      child: surface,
    );

    if (!widget.pressable && !widget.tilt && widget.onTap == null) {
      return surface;
    }

    return MouseRegion(
      onHover: widget.tilt
          ? (e) =>
              _onPointerMove(e.localPosition, context.size ?? const Size(1, 1))
          : null,
      onExit: widget.tilt ? (_) => _onPointerExit() : null,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (_) {
          if (widget.tilt) _setPressed(true);
        },
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        onPointerMove: widget.tilt
            ? (e) => _onPointerMove(
                e.localPosition, context.size ?? const Size(1, 1))
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.pressable ? (_) => _setPressed(true) : null,
          onTapUp: widget.pressable ? (_) => _setPressed(false) : null,
          onTapCancel: widget.pressable ? () => _setPressed(false) : null,
          onTap: () {
            if (widget.pressable) HapticFeedback.lightImpact();
            widget.onTap?.call();
          },
          child: surface,
        ),
      ),
    );
  }
}

/// Clay card with optional title + trailing chrome (replaces glass cards).
class ClayCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double elevation;
  final Color? color;
  final Gradient? gradient;
  final bool pressable;
  final bool tilt;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.radius = 26,
    this.elevation = 1.0,
    this.color,
    this.gradient,
    this.pressable = false,
    this.tilt = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      padding: padding,
      margin: margin,
      radius: radius,
      elevation: elevation,
      color: color,
      gradient: gradient,
      pressable: pressable,
      tilt: tilt,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Chunky clay accent bar.
                    Container(
                      width: 5,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: ClayPalette.brandClayGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ClayColors.text(context),
                      ),
                    ),
                  ],
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}
