// ════════════════════════════════════════════════════════════════
// FILE: lib/core/services/biometric_service.dart
// Fingerprint / face unlock via local_auth (SECTION 6).
// ════════════════════════════════════════════════════════════════

import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  BiometricService._();

  static final LocalAuthentication _auth = LocalAuthentication();

  /// Whether the device has usable biometrics enrolled.
  static Future<bool> isAvailable() async {
    try {
      final canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      final enrolled = await _auth.getAvailableBiometrics();
      return canAuthenticate && enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Prompts the OS biometric prompt. Returns true on success.
  static Future<bool> authenticate(
      {String reason = 'Authenticate to continue'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      // Device has no biometric hardware, none enrolled, or the OS
      // refused the prompt — fall back to password login.
      return false;
    } catch (_) {
      return false;
    }
  }
}
