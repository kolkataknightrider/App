// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/custom_button.dart
// CLAYMORPHISM BUTTONS — chunky clay surface, magnetic pull toward
// the pointer, glow, moving light sweep, press squish + haptics,
// and a morphing loading state.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/clay_palette.dart';
import 'package:partix/shared/widgets/clay.dart';
import 'package:partix/shared/widgets/clay_animations.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;

  /// Solid colour override (skips the brand gradient).
  final Color? backgroundColor;

  /// Custom gradient override.
  final Gradient? gradient;

  final double height;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.backgroundColor,
    this.gradient,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  bool _down = false;

  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled || widget.isLoading;
    final glowColor = widget.backgroundColor ?? ClayPalette.clayIndigo;
    final gradient = widget.backgroundColor != null
        ? null
        : (widget.gradient ?? ClayPalette.brandClayGradient);

    return Magnetic(
      strength: disabled ? 0 : 14,
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _down = true),
        onTapUp: disabled ? null : (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: disabled
            ? null
            : () {
                HapticFeedback.mediumImpact();
                widget.onPressed?.call();
              },
        child: AnimatedScale(
          scale: _down ? 0.96 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: disabled && !widget.isLoading ? 0.5 : 1,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              height: widget.height,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: gradient,
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                boxShadow: disabled
                    ? null
                    : [
                        BoxShadow(
                          color: glowColor.withOpacity(_down ? 0.6 : 0.42),
                          blurRadius: _down ? 30 : 20,
                          offset: Offset(0, _down ? 5 : 10),
                          spreadRadius: -4,
                        ),
                        BoxShadow(
                          color: glowColor.withOpacity(0.18),
                          blurRadius: 44,
                          offset: const Offset(0, 20),
                        ),
                      ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ── Inner clay highlight (top-left) ──
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusButton),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.35),
                              Colors.white.withOpacity(0.0),
                              Colors.black.withOpacity(0.14),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Moving light sweep ──
                  if (!disabled)
                    AnimatedBuilder(
                      animation: _sweep,
                      builder: (context, _) {
                        final x = -1.6 + 3.2 * _sweep.value;
                        return Align(
                          alignment: Alignment(x, 0),
                          child: Transform.rotate(
                            angle: 0.45,
                            child: Container(
                              width: 60,
                              height: widget.height * 2.4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0),
                                    Colors.white.withOpacity(0.28),
                                    Colors.white.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // ── Content (morphs to a spinner while loading) ──
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: widget.isLoading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.6,
                            ),
                          )
                        : Row(
                            key: ValueKey(widget.label),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(widget.icon,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                              ],
                              Text(
                                widget.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined / ghost clay button with the same press physics.
class CustomSecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const CustomSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
  });

  @override
  State<CustomSecondaryButton> createState() => _CustomSecondaryButtonState();
}

class _CustomSecondaryButtonState extends State<CustomSecondaryButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? ClayPalette.clayIndigo;
    final disabled = widget.onPressed == null;
    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _down = true),
      onTapUp: disabled ? null : (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: disabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onPressed!();
            },
      child: Magnetic(
        strength: disabled ? 0 : 10,
        child: AnimatedScale(
          scale: _down ? 0.96 : 1,
          duration: const Duration(milliseconds: 140),
          child: ClayContainer(
            pressable: false,
            height: AppDimensions.buttonHeightSmall,
            radius: AppDimensions.radiusButton,
            color: c.withOpacity(0.16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: c),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: c,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
