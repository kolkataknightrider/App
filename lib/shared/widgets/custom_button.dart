// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/custom_button.dart
// PARTIX buttons — gradient fill, glow, light sweep, press physics,
// haptics and a morphing loading state.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';

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
    final glowColor = widget.backgroundColor ?? AppColors.brandPrimary;

    return GestureDetector(
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
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: disabled && !widget.isLoading ? 0.45 : 1,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: widget.backgroundColor != null
                  ? null
                  : (widget.gradient ??
                      const LinearGradient(
                        colors: [
                          AppColors.brandPrimary,
                          AppColors.brandSecondary,
                          AppColors.brandAccent,
                        ],
                      )),
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: glowColor.withOpacity(_down ? 0.55 : 0.38),
                        blurRadius: _down ? 26 : 18,
                        offset: Offset(0, _down ? 4 : 9),
                        spreadRadius: -4,
                      ),
                    ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
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
                                  Colors.white.withOpacity(0.20),
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
                              Icon(widget.icon, color: Colors.white, size: 20),
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
    );
  }
}

/// Outlined / ghost button with the same press physics.
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
    final c = widget.color ?? AppColors.brandPrimary;
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
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: AppDimensions.buttonHeightSmall,
          width: double.infinity,
          decoration: BoxDecoration(
            color: c.withOpacity(_down ? 0.18 : 0.08),
            border: Border.all(
                color: c.withOpacity(disabled ? 0.3 : 0.85), width: 1.4),
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
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
    );
  }
}
