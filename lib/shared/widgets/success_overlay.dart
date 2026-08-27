// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/success_overlay.dart
// Animated success overlay (Lottie tick or custom check) + message.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import 'partix_loader.dart';

class SuccessOverlay extends StatefulWidget {
  final String message;
  final VoidCallback? onDismiss;
  const SuccessOverlay({super.key, required this.message, this.onDismiss});

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.55),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieOrFallback(
                lottiePath: AppAssets.successTick,
                width: 120,
                height: 120,
                fallback: _AnimatedCheck(),
              ),
              const SizedBox(height: 16),
              Text(widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom animated checkmark used when no Lottie asset is present.
class _AnimatedCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 56)
          .animate()
          .scale(
            begin: const Offset(0.2, 0.2),
            end: const Offset(1, 1),
            duration: 500.ms,
            curve: Curves.elasticOut,
          ),
    );
  }
}
