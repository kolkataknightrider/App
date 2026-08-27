// ════════════════════════════════════════════════════════════════
// FILE: lib/features/splash/splash_screen.dart
// Cinematic splash: aurora backdrop, glowing ring, logo reveal and
// a progress sweep — then auto-redirect (router handles auth).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/shared/widgets/aurora_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) context.go(AppRoutes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        cycleSeconds: 12,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const GlowRing(size: 260),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (r) => const LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFB9B4FF),
                              Color(0xFF7FE7FF),
                            ],
                          ).createShader(r),
                          child: const Text(
                            'PARTIX',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 9,
                              color: Colors.white,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .scaleXY(
                                begin: 0.7,
                                end: 1,
                                duration: 900.ms,
                                curve: Curves.easeOutBack)
                            .then()
                            .shimmer(
                                duration: 1400.ms,
                                color: Colors.white.withOpacity(0.9)),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.tagline.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                            letterSpacing: 5,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 700.ms)
                            .slideY(begin: 0.8, end: 0),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Sweeping progress bar ──
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 150,
                  height: 3,
                  color: Colors.white.withOpacity(0.10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).slideX(
                          begin: -1.6,
                          end: 2.6,
                          duration: 1300.ms,
                          curve: Curves.easeInOut,
                        ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
