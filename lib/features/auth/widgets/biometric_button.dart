// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/widgets/biometric_button.dart
// Fingerprint login (only rendered after one successful password
// login on this device). Glass pill + pulsing fingerprint.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/services/biometric_service.dart';
import 'package:partix/core/firebase/auth_service.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/glass.dart';

class BiometricButton extends ConsumerStatefulWidget {
  const BiometricButton({super.key});

  @override
  ConsumerState<BiometricButton> createState() => _BiometricButtonState();
}

class _BiometricButtonState extends ConsumerState<BiometricButton> {
  bool _available = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final ok = await BiometricService.isAvailable() &&
        await AuthService.instance.canUseBiometrics();
    if (mounted) setState(() => _available = ok);
  }

  Future<void> _authenticate() async {
    final ok = await BiometricService.authenticate(
        reason: 'Authenticate to sign in to Partix');
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    final auth = ref.read(authProvider);
    await auth.loginWithBiometrics();
    if (mounted) {
      setState(() => _busy = false);
      if (auth.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Text(auth.error!),
            backgroundColor: AppColors.error,
          ),
        );
        auth.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_available) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.md),
      child: Column(
        children: [
          // divider with label
          Row(
            children: [
              Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
            ],
          ),
          const SizedBox(height: 14),
          TapScale(
            onTap: _busy ? null : _authenticate,
            child: Container(
              width: double.infinity,
              height: AppDimensions.buttonHeightSmall,
              decoration: BoxDecoration(
                color: AppColors.brandAccent.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                border: Border.all(
                    color: AppColors.brandAccent.withOpacity(0.45), width: 1.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_busy)
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.brandAccent),
                    )
                  else
                    const Icon(Icons.fingerprint_rounded,
                            color: AppColors.brandAccent, size: 22)
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scaleXY(
                            end: 1.15,
                            duration: 1200.ms,
                            curve: Curves.easeInOut),
                  const SizedBox(width: 10),
                  Text(
                    _busy ? 'Authenticating…' : AppStrings.biometricButton,
                    style: const TextStyle(
                      color: AppColors.brandAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          .animate()
          .fadeIn(delay: 950.ms, duration: 500.ms)
          .slideY(begin: 0.3, end: 0),
    );
  }
}
