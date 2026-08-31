// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/themes/light_theme.dart
// Light CLAYMORPHISM theme — soft pastel clay surfaces.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/clay_palette.dart';

ThemeData buildLightTheme() {
  const bg = ClayPalette.bgLight;
  const onBg = Color(0xFF2B2740);
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: bg,
    primaryColor: ClayPalette.clayIndigo,
    colorScheme: const ColorScheme.light(
      primary: ClayPalette.clayIndigo,
      secondary: ClayPalette.clayMint,
      surface: ClayPalette.surfaceLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSurface: onBg,
    ),
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: onBg),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onBg,
      ),
    ),
    cardTheme: CardTheme(
      color: ClayPalette.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ClayPalette.bgLightAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide: const BorderSide(color: Color(0xFFD7D1EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide: const BorderSide(color: ClayPalette.clayIndigo, width: 1.8),
      ),
      labelStyle:
          const TextStyle(color: Color(0xFF6E6888), fontFamily: 'Poppins'),
      hintStyle:
          const TextStyle(color: Color(0xFF9B93B8), fontFamily: 'Poppins'),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ClayPalette.clayIndigo,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: ClayPalette.clayIndigo.withOpacity(0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        ),
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ClayPalette.surfaceLight,
      selectedItemColor: ClayPalette.clayIndigo,
      unselectedItemColor: Color(0xFF9B93B8),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: true,
    ),
    dividerColor: const Color(0xFFD7D1EA),
  );
}
