// ════════════════════════════════════════════════════════════════
// FILE: lib/core/constants/app_dimensions.dart
// Spacing & radius system (SECTION 12).
// ════════════════════════════════════════════════════════════════

class AppDimensions {
  AppDimensions._();

  // ── SPACING ───────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // ── RADIUS ────────────────────────────────────────────────
  static const double radiusButton = 16.0;
  static const double radiusCard = 22.0;
  static const double radiusInput = 16.0;
  static const double radiusChip = 100.0; // fully rounded
  static const double radiusBottomSheet = 24.0;

  // ── COMPONENT SIZES ──────────────────────────────────────
  static const double buttonHeight = 54.0;
  static const double buttonHeightSmall = 48.0;
  static const double inputHeight = 54.0;
  static const double earningCardHeight = 110.0;
  static const double profilePhotoSize = 100.0;
  static const double avatarSize = 40.0;

  // ── ANIMATION DURATIONS ──────────────────────────────────
  static const Duration screenTransition = Duration(milliseconds: 300);
  static const Duration cardEntry = Duration(milliseconds: 400);
  static const Duration counter = Duration(milliseconds: 800);
  static const Duration chart = Duration(milliseconds: 600);
  static const Duration buttonPress = Duration(milliseconds: 150);

  // ── PAGINATION ───────────────────────────────────────────
  static const int pageSize = 20;
}
