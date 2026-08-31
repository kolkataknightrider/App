// ════════════════════════════════════════════════════════════════
// FILE: lib/core/constants/clay_palette.dart
// CLAYMORPHISM PALETTE — soft pastel "clay" colour tokens.
// Replaces the glassmorphism palette for the new design language.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

/// Soft, tactile clay tones used across the whole app.
class ClayPalette {
  ClayPalette._();

  // ── LIGHT CLAY BACKGROUNDS ────────────────────────────────
  static const Color bgLight = Color(0xFFE7E3F3); // soft lavender-grey clay
  static const Color bgLightAlt = Color(0xFFF1EEF9);
  static const Color surfaceLight = Color(0xFFEEECF6); // raised clay surface

  // ── DARK CLAY BACKGROUNDS ─────────────────────────────────
  static const Color bgDark = Color(0xFF1A1730);
  static const Color bgDarkAlt = Color(0xFF221D3E);
  static const Color surfaceDark = Color(0xFF2B2549);

  // ── ACCENT CLAYS (pastel, chunky) ─────────────────────────
  static const Color clayIndigo = Color(0xFF7C6FE0);
  static const Color clayLavender = Color(0xFFB9A9FF);
  static const Color clayMint = Color(0xFF8FE3C7);
  static const Color clayPeach = Color(0xFFFFC9A3);
  static const Color claySky = Color(0xFF9AD4FF);
  static const Color clayRose = Color(0xFFFFB3C7);
  static const Color clayLemon = Color(0xFFFFE3A3);

  /// Drifting blob colours for animated clay backgrounds.
  static const List<Color> blobColors = [
    clayIndigo,
    clayMint,
    clayPeach,
    claySky,
    clayRose,
  ];

  /// Primary brand gradient (indigo → lavender → mint).
  static const Gradient brandClayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [clayIndigo, clayLavender, clayMint],
  );

  /// Gradient used for money/earnings highlights.
  static const Gradient goldClayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [clayLemon, clayPeach],
  );
}
