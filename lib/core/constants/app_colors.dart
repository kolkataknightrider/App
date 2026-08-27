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

  /// Premium accent used for money/earnings highlights.
  static const Color gold = Color(0xFFFFC857);

  /// Frosted-glass surface fill + hairline border (glassmorphism).
  static const Color glassFill = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x1FFFFFFF);

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
  static const Gradient todayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF22D3EE)],
  );
  static const Gradient weekGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF34D399)],
  );
  static const Gradient monthGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFC084FC)],
  );
  static const Gradient lastMonthGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF475569), Color(0xFF94A3B8)],
  );
  static const Gradient yearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDC2626), Color(0xFFFB923C)],
  );
  static const Gradient teamGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
  );
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
