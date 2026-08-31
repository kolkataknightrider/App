// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/screens/login_screen.dart
// Cinematic CLAY login: drifting clay blobs, magnetic clay hero
// puck, flip-text tagline, staggered clay card entry, spotlight
// glow and an animated lock-out notice.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/clay_palette.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/clay.dart';
import 'package:partix/shared/widgets/clay_animations.dart';
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
      body: ClayBlobBackground(
        cycleSeconds: 16,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppDimensions.lg,
              size.height * 0.04,
              AppDimensions.lg,
              AppDimensions.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  // ══ HERO ══════════════════════════════════════
                  const SizedBox(height: 8),
                  const Magnetic(
                    child: ClayContainer(
                      radius: 40,
                      elevation: 1.6,
                      gradient: ClayPalette.brandClayGradient,
                      padding: EdgeInsets.all(24),
                      child: Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 40),
                    ),
                  )
                      .animate()
                      .scaleXY(
                          begin: 0.4,
                          end: 1,
                          duration: 900.ms,
                          curve: Curves.easeOutBack)
                      .fadeIn(duration: 600.ms)
                      .then()
                      .shimmer(
                          duration: 1400.ms,
                          color: Colors.white.withOpacity(0.5)),

                  const SizedBox(height: 22),

                  const ShimmerText(
                    text: 'PARTIX',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8,
                      color: Colors.white,
                      height: 1,
                    ),
                  ).animate().fadeIn(duration: 700.ms, curve: Curves.easeOut),

                  const SizedBox(height: 12),

                  // Flip-text tagline
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
                  ),

                  const SizedBox(height: 26),

                  // ══ LOGIN CARD ════════════════════════════════
                  Spotlight(
                    radius: 180,
                    opacity: 0.10,
                    child: ClayContainer(
                      radius: 30,
                      elevation: 1.3,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const ClayContainer(
                                radius: 18,
                                elevation: 1.4,
                                gradient: ClayPalette.brandClayGradient,
                                padding: EdgeInsets.all(11),
                                child: Icon(Icons.lock_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.loginTitle,
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                        color: ClayColors.text(context),
                                      ),
                                    ),
                                    Text(
                                      'Sign in to your member account',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ClayColors.textDim(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          const LoginFormWidget(),
                          const BiometricButton(),
                        ],
                      ),
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
                        ? ClayContainer(
                            radius: 18,
                            color: AppColors.error.withOpacity(0.14),
                            padding: const EdgeInsets.all(14),
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
                          size: 13, color: ClayColors.textDim(context)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          AppStrings.adminCredentialsNote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ClayColors.textDim(context),
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
                        color: ClayColors.textDim(context), fontSize: 11),
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
