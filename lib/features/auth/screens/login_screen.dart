// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/screens/login_screen.dart
// Cinematic login: aurora backdrop, glowing hero mark, frosted
// card, staggered field entry and an animated lock-out notice.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/aurora_background.dart';
import 'package:partix/shared/widgets/glass.dart';
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuroraBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppDimensions.lg,
              size.height * 0.05,
              AppDimensions.lg,
              AppDimensions.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  // ══ HERO ══════════════════════════════════════
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const GlowRing(size: 230),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Wordmark
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
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 8,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                                .scaleXY(
                                    begin: 0.75,
                                    end: 1,
                                    duration: 800.ms,
                                    curve: Curves.easeOutBack)
                                .then(delay: 200.ms)
                                .shimmer(
                                    duration: 1600.ms,
                                    color: Colors.white.withOpacity(0.85)),
                            const SizedBox(height: 10),
                            // Animated underline
                            Container(
                              height: 2,
                              width: 120,
                              decoration: BoxDecoration(
                                gradient: AppColors.brandGradient,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ).animate().scaleX(
                                begin: 0,
                                end: 1,
                                delay: 450.ms,
                                duration: 700.ms,
                                curve: Curves.easeOutCubic),
                            const SizedBox(height: 12),
                            Text(
                              AppStrings.tagline.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.72),
                                fontSize: 11.5,
                                letterSpacing: 5,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 700.ms, duration: 700.ms)
                                .slideY(begin: 0.6, end: 0),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ══ LOGIN CARD ════════════════════════════════
                  GlassCard(
                    radius: 28,
                    blur: 24,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                    interactive: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: AppColors.brandGradient,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandPrimary
                                        .withOpacity(0.45),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                    spreadRadius: -4,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.lock_rounded,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    AppStrings.loginTitle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Sign in to your member account',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: 500.ms, duration: 500.ms)
                            .slideY(begin: 0.25, end: 0),
                        const SizedBox(height: 22),
                        const LoginFormWidget(),
                        const BiometricButton(),
                      ],
                    ),
                  ).animate().fadeIn(delay: 350.ms, duration: 650.ms).slideY(
                      begin: 0.22,
                      end: 0,
                      delay: 350.ms,
                      duration: 700.ms,
                      curve: Curves.easeOutCubic),

                  const SizedBox(height: AppDimensions.md),

                  // ══ LOCKOUT NOTICE ════════════════════════════
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: auth.lockoutMinutes > 0
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.error.withOpacity(0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined,
                                    color: AppColors.error, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    AppStrings.lockoutRemaining.replaceAll(
                                        '{minutes}', '${auth.lockoutMinutes}'),
                                    style: const TextStyle(
                                        color: AppColors.error, fontSize: 12.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .fadeIn(duration: 900.ms)
                        : const SizedBox(width: double.infinity),
                  ),

                  const SizedBox(height: AppDimensions.md),

                  // ══ FOOTER ════════════════════════════════════
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_outlined,
                          size: 13, color: Colors.white.withOpacity(0.45)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          AppStrings.adminCredentialsNote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
                  const SizedBox(height: 8),
                  Text(
                    'v${AppStrings.appVersion}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 11),
                  ).animate().fadeIn(delay: 1000.ms),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
