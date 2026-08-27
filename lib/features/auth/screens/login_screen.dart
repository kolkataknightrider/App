// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/screens/login_screen.dart
// Complete login screen (SECTION 6 UI + logic).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/animated_logo.dart';
import 'package:partix/features/auth/widgets/login_form_widget.dart';
import 'package:partix/features/auth/widgets/biometric_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0D1A), Color(0xFF1A237E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.xl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    // ── Logo + tagline ──
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const PulseOrb(size: 160),
                        Column(
                          children: [
                            const AnimatedLogo(size: 36)
                                .animate()
                                .fadeIn(duration: 500.ms)
                                .scaleXY(
                                  begin: 0.8,
                                  end: 1,
                                  duration: 500.ms,
                                  curve: Curves.easeOutBack,
                                ),
                            const SizedBox(height: AppDimensions.sm),
                            const Text(
                              AppStrings.tagline,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xl),

                    // ── Glassmorphism card ──
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.loginTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppDimensions.lg),
                          LoginFormWidget(),
                          BiometricButton(),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.lg),
                    if (auth.lockoutMinutes > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          AppStrings.lockoutRemaining.replaceAll(
                              '{minutes}', '${auth.lockoutMinutes}'),
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    const SizedBox(height: AppDimensions.md),
                    const Text(
                      AppStrings.adminCredentialsNote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    const Text(
                      '${AppStrings.appName} ${AppStrings.appVersion}',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
