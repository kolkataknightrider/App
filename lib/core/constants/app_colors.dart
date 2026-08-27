// ════════════════════════════════════════════════════════════════
// FILE: lib/core/constants/app_colors.dart
// PARTIX brand color palette (Dark = primary, Light = secondary).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

/// Centralized color system for PARTIX.
class AppColors {
  AppColors._();

  // ── DARK THEME (Default & Primary) ────────────────────────
  static const Color darkBgPrimary = Color(0xFF09090F);
  static const Color darkBgSecondary = Color(0xFF13131F);
  static const Color darkBgTertiary = Color(0xFF1C1C2E);
  static const Color darkSurface = Color(0xFF252538);
  static const Color darkBorder = Color(0xFF2E2E45);

  // ── BRAND ─────────────────────────────────────────────────
  static const Color brandPrimary = Color(0xFF6C63FF); // Electric indigo
  static const Color brandSecondary = Color(0xFF8B5CF6); // Violet
  static const Color brandAccent = Color(0xFF06B6D4); // Cyan electric

  /// Brand gradient (indigo → cyan).
  static const Gradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPrimary, brandAccent],
  );

  // ── SEMANTIC ──────────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // ── TEXT (Dark theme) ─────────────────────────────────────
  static const Color textPrimary = Color(0xFFF1F1F6);
  static const Color textSecondary = Color(0xFF9B9BB5);
  static const Color textTertiary = Color(0xFF5F5F7A);

  // ── LIGHT THEME ──────────────────────────────────────────
  static const Color lightBgPrimary = Color(0xFFF8F8FF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightBorder = Color(0xFFE2E2EE);

  // ── RANK COLORS ───────────────────────────────────────────
  static const Color rankAssociate = Color(0xFF4FC3F7); // Light Blue
  static const Color rankExecutive = Color(0xFF4CAF50); // Green
  static const Color rankManager = Color(0xFFFFC107); // Amber/Yellow
  static const Color rankDirector = Color(0xFFFF6F00); // Deep Orange
  static const Color rankVicePresident = Color(0xFFE53935); // Red
  static const Color rankPresident = Color(0xFFB388FF); // Purple (shimmer)

  /// Gradient for the President (diamond) rank.
  static const Gradient rankPresidentGradient = LinearGradient(
    colors: [Color(0xFFB388FF), Color(0xFFEA80FC)],
  );

  /// Returns the color associated with a rank name (case-insensitive).
  static Color rankColor(String? rankName) {
    switch ((rankName ?? '').toLowerCase()) {
      case 'executive':
        return rankExecutive;
      case 'manager':
        return rankManager;
      case 'director':
        return rankDirector;
      case 'vice president':
      case 'vicepresident':
        return rankVicePresident;
      case 'president':
        return rankPresident;
      case 'associate':
      default:
        return rankAssociate;
    }
  }

  // ── EARNING CARD GRADIENTS ────────────────────────────────
  static const Gradient todayGradient =
      LinearGradient(colors: [Color(0xFF1E3A5F), Color(0xFF2E86AB)]);
  static const Gradient weekGradient =
      LinearGradient(colors: [Color(0xFF1B4332), Color(0xFF40916C)]);
  static const Gradient monthGradient =
      LinearGradient(colors: [Color(0xFF3D0066), Color(0xFF7B2FBE)]);
  static const Gradient lastMonthGradient =
      LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF4A4A8A)]);
  static const Gradient yearGradient =
      LinearGradient(colors: [Color(0xFF7F1D1D), Color(0xFFDC2626)]);
  static const Gradient teamGradient =
      LinearGradient(colors: [Color(0xFF0F3460), Color(0xFF533483)]);
  static const Gradient grossGradient = brandGradient;

  /// Earnings card gradient by key.
  static Gradient earningsGradient(String key) {
    switch (key) {
      case 'today':
        return todayGradient;
      case 'week':
        return weekGradient;
      case 'month':
        return monthGradient;
      case 'lastMonth':
        return lastMonthGradient;
      case 'year':
        return yearGradient;
      case 'team':
        return teamGradient;
      case 'gross':
      default:
        return grossGradient;
    }
  }
}
