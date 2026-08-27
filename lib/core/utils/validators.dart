// ════════════════════════════════════════════════════════════════
// FILE: lib/core/utils/validators.dart
// Form input validators (SECTION 6 auth rules).
// ════════════════════════════════════════════════════════════════

class Validators {
  Validators._();

  /// Member ID format: PTX-YYYY-NNNNN  (e.g. PTX-2024-00001)
  static final RegExp memberIdRegex = RegExp(r'^PTX-\d{4}-\d{5}$');

  static bool isValidMemberId(String value) =>
      memberIdRegex.hasMatch(value.trim().toUpperCase());

  static String? validateMemberId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Member ID is required';
    }
    if (!isValidMemberId(value)) {
      return 'Format must be PTX-2024-00001';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateAmount(String? value, {double? maxAllowed}) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter an amount';
    }
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null) return 'Enter a valid amount';
    if (parsed <= 0) return 'Amount must be greater than 0';
    if (maxAllowed != null && parsed > maxAllowed) {
      return 'Amount exceeds available balance';
    }
    return null;
  }

  static String? validateUpi(String? value) {
    if (value == null || value.trim().isEmpty) return 'UPI ID required';
    final upiRegex = RegExp(r'^[\w.\-]{2,256}@[a-zA-Z]{2,64}$');
    if (!upiRegex.hasMatch(value.trim())) return 'Invalid UPI ID';
    return null;
  }

  static String? validateIfsc(String? value) {
    if (value == null || value.trim().isEmpty) return 'IFSC required';
    final ifsc = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifsc.hasMatch(value.trim().toUpperCase())) return 'Invalid IFSC';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
