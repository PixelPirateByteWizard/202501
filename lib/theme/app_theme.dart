import 'package:flutter/material.dart';

class AppColors {
  static const Color deepNavy = Color(0xFF0A192F);
  static const Color slateBlue = Color(0xFF172A46);
  static const Color vintageGold = Color(0xFFD4AF37);
  static const Color lavenderWhite = Color(0xFFE6E6FA);
  static const Color accentRose = Color(0xFFE85D75);
  static const Color glassBg = Color(0x99172A46);
  static const Color glassBorder = Color(0x33D4AF37);
  static const Color statusOptimal = Color(0xFF10B981);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusError = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.vintageGold,
      scaffoldBackgroundColor: AppColors.deepNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.vintageGold,
        secondary: AppColors.accentRose,
        surface: AppColors.slateBlue,
        onPrimary: AppColors.deepNavy,
        onSecondary: AppColors.lavenderWhite,
        onSurface: AppColors.lavenderWhite,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'serif',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.vintageGold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'serif',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.vintageGold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'serif',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.vintageGold,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'serif',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.vintageGold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'serif',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.vintageGold,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'serif',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.vintageGold,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16,
          color: AppColors.lavenderWhite,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: AppColors.lavenderWhite,
        ),
        bodySmall: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: AppColors.lavenderWhite,
        ),
        labelLarge: TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lavenderWhite,
        ),
        labelMedium: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.lavenderWhite,
        ),
        labelSmall: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.lavenderWhite,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vintageGold,
          foregroundColor: AppColors.deepNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.glassBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.slateBlue,
        foregroundColor: AppColors.lavenderWhite,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
