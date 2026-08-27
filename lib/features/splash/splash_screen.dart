// ════════════════════════════════════════════════════════════════
// FILE: lib/features/splash/splash_screen.dart
// Animated splash screen with auto-login redirection.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/shared/widgets/animated_logo.dart';
import 'package:partix/shared/widgets/partix_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) context.go(AppRoutes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0D1A), Color(0xFF1A237E)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PulseOrb(size: 240),
              const SizedBox(height: 24),
              const AnimatedLogo(size: 40)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms),
              const SizedBox(height: AppDimensions.lg),
              const Text(
                AppStrings.tagline,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
              const SizedBox(height: AppDimensions.xl),
              const PartixDotsLoader(size: 12),
            ],
          ),
        ),
      ),
    );
  }
}
