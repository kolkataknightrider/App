// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/partix_loader.dart
// Custom mobile-friendly loaders + a Lottie-with-fallback wrapper.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';

/// Three bouncing PARTIX dots.
class PartixDotsLoader extends StatelessWidget {
  final double size;
  const PartixDotsLoader({super.key, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .moveY(
                begin: 0,
                end: -10,
                delay: (i * 120).ms,
                duration: 600.ms,
                curve: Curves.easeInOut,
              )
              .then(delay: 200.ms)
              .moveY(begin: -10, end: 0, duration: 600.ms, curve: Curves.easeInOut),
        );
      }),
    );
  }
}

/// Rotating gradient ring.
class PartixRingLoader extends StatelessWidget {
  final double size;
  const PartixRingLoader({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .rotate(duration: 1000.ms, curve: Curves.linear),
    );
  }
}

/// Convenience loader: ring + optional label.
class PartixLoader extends StatelessWidget {
  final String? label;
  final double size;
  const PartixLoader({super.key, this.label, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PartixRingLoader(size: size),
        if (label != null) ...[
          const SizedBox(height: 12),
          Text(label!,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ],
      ],
    );
  }
}

/// Renders a Lottie animation when the asset exists, otherwise falls
/// back to [fallback]. Keeps the build safe if JSON files are missing.
class LottieOrFallback extends StatelessWidget {
  final String? lottiePath;
  final Widget fallback;
  final double? width;
  final double? height;

  const LottieOrFallback({
    super.key,
    this.lottiePath,
    required this.fallback,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (lottiePath == null || lottiePath!.isEmpty) return fallback;
    return Lottie.asset(
      lottiePath!,
      width: width,
      height: height,
      errorBuilder: (context, error, stack) => fallback,
    );
  }
}
