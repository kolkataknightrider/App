// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/themes/dark_theme.dart
// Dark CLAYMORPHISM theme (primary) — deep clay + pastel accents.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_text_styles.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/clay_palette.dart';

ThemeData buildDarkTheme() {
  const bg = ClayPalette.bgDark;
  const onBg = Color(0xFFF1EEFA);
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: bg,
    primaryColor: ClayPalette.clayIndigo,
    colorScheme: const ColorScheme.dark(
      primary: ClayPalette.clayIndigo,
      secondary: ClayPalette.clayMint,
      surface: ClayPalette.surfaceDark,
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
      color: ClayPalette.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ClayPalette.bgDarkAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide: const BorderSide(color: Color(0xFF3A3360)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide:
            const BorderSide(color: ClayPalette.clayLavender, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(
          color: Color(0xFF9B93C4), fontFamily: 'Poppins'),
      hintStyle: const TextStyle(
          color: Color(0xFF5F5880), fontFamily: 'Poppins'),
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ClayPalette.clayLavender,
        textStyle: const TextStyle(fontFamily: 'Poppins'),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ClayPalette.surfaceDark,
      selectedItemColor: ClayPalette.clayLavender,
      unselectedItemColor: Color(0xFF5F5880),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: true,
    ),
    dividerColor: const Color(0xFF3A3360),
    textTheme: const TextTheme(
      displaySmall: AppTextStyles.display,
      headlineMedium: AppTextStyles.h1,
      titleLarge: AppTextStyles.h2,
      titleMedium: AppTextStyles.h3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.body,
      labelSmall: AppTextStyles.caption,
    ),
  );
}
