// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/themes/app_theme.dart
// Theme aggregator + theme-mode persistence helper.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/shared/themes/dark_theme.dart';
import 'package:partix/shared/themes/light_theme.dart';

/// PARTIX theme manager.
class AppTheme {
  AppTheme._();

  static ThemeData get light => buildLightTheme();
  static ThemeData get dark => buildDarkTheme();

  /// Resolve a [ThemeMode] from the persisted theme string.
  static ThemeMode modeFromName(String name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  static String nameFromMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.dark:
      default:
        return 'dark';
    }
  }
}
