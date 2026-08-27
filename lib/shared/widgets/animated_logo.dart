// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/animated_logo.dart
// Glowing, pulsing PARTIX logo built purely with flutter_animate.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final bool glow;
  const AnimatedLogo({super.key, this.size = 40, this.glow = true});

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.5,
        vertical: size * 0.3,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.4),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: AppColors.brandPrimary.withOpacity(0.6),
                  blurRadius: size,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Text(
        'PARTIX',
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: FontWeight.w700,
          letterSpacing: size * 0.1,
        ),
      ),
    );

    return logo
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(end: 1.06, duration: 1200.ms, curve: Curves.easeInOut)
        .then()
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.6));
  }
}

/// A soft pulsing gradient orb used behind hero elements.
class PulseOrb extends StatelessWidget {
  final double size;
  const PulseOrb({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.brandPrimary.withOpacity(0.6),
            AppColors.brandAccent.withOpacity(0.0),
          ],
        ),
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 0.85, end: 1.15, duration: 1600.ms, curve: Curves.easeInOut)
        .fadeIn(duration: 600.ms);
  }
}
