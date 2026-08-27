// ════════════════════════════════════════════════════════════════
// FILE: lib/core/utils/encryption_helper.dart
// AES encryption for sensitive bank data (encrypt: ^5.0.3).
// ════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart';

/// Encrypts/decrypts sensitive strings (bank account numbers) using AES-256.
///
/// NOTE: In production, the key should be derived from a device-bound
/// secret (e.g. flutter_secure_storage value) — never hardcoded. This
/// helper keeps a fixed key for local-at-rest masking as described in
/// SECTION 4 (account number stored encrypted, displayed last 4).
class EncryptionHelper {
  EncryptionHelper._();

  static final enc.Key _key = enc.Key.fromUtf8(_buildKey());
  static final enc.IV _iv = enc.IV.fromLength(16);
  static final _encrypter = enc.Encrypter(enc.AES(_key));

  /// Builds a 32-byte key from a fixed passphrase (sha256).
  static String _buildKey() {
    const passphrase = 'PARTIX_SECURE_KEY_V1';
    final digest = sha256.convert(utf8.encode(passphrase));
    return digest.toString();
  }

  /// Encrypt plaintext → base64 ciphertext.
  static String encrypt(String plainText) {
    if (plainText.isEmpty) return '';
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt base64 ciphertext → plaintext. Returns '' on failure.
  static String decrypt(String cipherText) {
    if (cipherText.isEmpty) return '';
    try {
      final decrypted = _encrypter.decrypt64(cipherText, iv: _iv);
      return decrypted;
    } catch (_) {
      return '';
    }
  }

  /// Masks an account number, showing only the last 4 digits.
  static String maskAccountNumber(String fullNumber) {
    final trimmed = fullNumber.replaceAll(' ', '');
    if (trimmed.length <= 4) return trimmed;
    return 'XXXX XXXX ${trimmed.substring(trimmed.length - 4)}';
  }

  /// Generates a random numeric transaction/earning id suffix.
  static String randomId(int length) {
    const chars = '0123456789';
    final rnd = Random();
    return List.generate(length, (_) => chars[rnd.nextInt(chars.length)])
        .join();
  }
}
