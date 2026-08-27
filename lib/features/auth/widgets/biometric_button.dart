// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/widgets/biometric_button.dart
// Fingerprint login button (shown only after first password login).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/providers/providers.dart';

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
          SnackBar(content: Text(auth.error!), backgroundColor: Colors.redAccent),
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
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeightSmall,
        child: OutlinedButton.icon(
          onPressed: _busy ? null : _authenticate,
          icon: _busy
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.fingerprint),
          label: Text(_busy ? 'Authenticating...' : AppStrings.biometricButton),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.brandPrimary),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusButton),
            ),
          ),
        ),
      ),
    );
  }
}
