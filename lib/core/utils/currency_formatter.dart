// ════════════════════════════════════════════════════════════════
// FILE: lib/core/utils/currency_formatter.dart
// ₹ formatting with Indian number grouping (1,23,456.00).
// ════════════════════════════════════════════════════════════════

import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _inrCompact = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Full ₹ format, e.g. ₹ 1,23,456.00
  static String format(double value) => _inr.format(value);

  /// No-decimal ₹ format, e.g. ₹ 1,23,456
  static String formatCompact(double value) => _inrCompact.format(value);

  /// Signed format for deltas, e.g. +₹ 1,250.00 / -₹ 500.00
  static String formatSigned(double value) {
    final sign = value >= 0 ? '+' : '-';
    return '$sign${_inr.format(value.abs())}';
  }

  /// Plain number with Indian grouping (no symbol), e.g. 1,23,456
  static String number(double value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2)
          .format(value)
          .trim();

  /// Compact for large figures: 1.2L, 8.75L, 54.0K
  static String compact(double value) {
    if (value >= 10000000) return '${(value / 10000000).toStringAsFixed(2)}Cr';
    if (value >= 100000) return '${(value / 100000).toStringAsFixed(2)}L';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}
