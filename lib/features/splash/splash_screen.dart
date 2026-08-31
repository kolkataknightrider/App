// ════════════════════════════════════════════════════════════════
// FILE: lib/features/splash/splash_screen.dart
// Cinematic CLAY splash: drifting clay blobs, glowing clay logo
// puck, flip-text tagline and a sweeping progress bar — then
// auto-redirect (router handles auth).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/clay_palette.dart';
import 'package:partix/shared/widgets/clay.dart';
import 'package:partix/shared/widgets/clay_animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted) context.go(AppRoutes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: ClayBlobBackground(
        cycleSeconds: 12,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ══ CLAY LOGO PUCK ═══════════════════════════════
              TiltCard(
                child: ClayContainer(
                  pressable: true,
                  radius: 46,
                  elevation: 1.6,
                  gradient: ClayPalette.brandClayGradient,
                  padding: const EdgeInsets.all(30),
                  child: const Text(
                    'P',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
                  .animate()
                  .scaleXY(begin: 0.4, end: 1, duration: 900.ms,
                      curve: Curves.easeOutBack)
                  .fadeIn(duration: 600.ms)
                  .then()
                  .shake(hz: 3, duration: 500.ms, curve: Curves.easeOut),

              const SizedBox(height: 28),

              // ══ WORDMARK with shimmer ═════════════════════════
              ShimmerText(
                text: 'PARTIX',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 9,
                  color: dark ? Colors.white : const Color(0xFF2B2740),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 700.ms),

              const SizedBox(height: 14),

              // ══ FLIP-TEXT TAGLINE ═════════════════════════════
              FlipText(
                words: const [
                  'EARN SMART',
                  'GROW TOGETHER',
                  'STAY TRANSPARENT',
                ],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 4,
                  color: ClayColors.textDim(context),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

              const SizedBox(height: 34),

              // ══ SWEEPING PROGRESS BAR ════════════════════════
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 160,
                  height: 4,
                  color: ClayColors.surface(context),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 64,
                      decoration: BoxDecoration(
                        gradient: ClayPalette.brandClayGradient,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).slideX(
                          begin: -1.7,
                          end: 2.7,
                          duration: 1300.ms,
                          curve: Curves.easeInOut,
                        ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 18),
              Text(
                AppStrings.appVersion,
                style: TextStyle(
                  color: ClayColors.textDim(context),
                  fontSize: 11,
                ),
              ).animate().fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
