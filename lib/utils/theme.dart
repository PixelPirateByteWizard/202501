import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppConstants.spaceIndigo700,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.spaceIndigo700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: AppConstants.spaceIndigo700,
        secondary: AppConstants.cosmicBlue,
        tertiary: AppConstants.nebulaPurple,
        surface: Colors.white,
        background: Colors.grey[100]!,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppConstants.spaceIndigo900),
        displayMedium: TextStyle(color: AppConstants.spaceIndigo900),
        displaySmall: TextStyle(color: AppConstants.spaceIndigo900),
        headlineLarge: TextStyle(color: AppConstants.spaceIndigo900),
        headlineMedium: TextStyle(color: AppConstants.spaceIndigo900),
        headlineSmall: TextStyle(color: AppConstants.spaceIndigo900),
        titleLarge: TextStyle(color: AppConstants.spaceIndigo900),
        titleMedium: TextStyle(color: AppConstants.spaceIndigo900),
        titleSmall: TextStyle(color: AppConstants.spaceIndigo900),
        bodyLarge: TextStyle(color: AppConstants.spaceIndigo900),
        bodyMedium: TextStyle(color: AppConstants.spaceIndigo900),
        bodySmall: TextStyle(color: AppConstants.spaceIndigo900),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.spaceIndigo700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 4,
        ),
      ),
    );
  }

  // Dark theme (default theme as per design)
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppConstants.spaceIndigo700,
      scaffoldBackgroundColor: AppConstants.spaceIndigo900,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.spaceIndigo800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.spaceIndigo700,
        secondary: AppConstants.cosmicBlue,
        tertiary: AppConstants.nebulaPurple,
        surface: AppConstants.spaceIndigo800,
        background: AppConstants.spaceIndigo900,
      ),
      cardTheme: CardThemeData(
        color: AppConstants.spaceIndigo800.withOpacity(0.3),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0x1A00E5FF),
          ), // 10% opacity cosmic blue
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Color(0xFFE0E0FF)), // Light blue-white
        bodyMedium: TextStyle(color: Color(0xFFE0E0FF)),
        bodySmall: TextStyle(
          color: Color(0xFFA0A0FF),
        ), // Lighter blue for smaller text
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.spaceIndigo700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 4,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.spaceIndigo800,
        selectedItemColor: AppConstants.cosmicBlue,
        unselectedItemColor: Color(0xFF8A8AC9), // Muted blue from design
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.spaceIndigo700.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0x3300E5FF),
          ), // 20% opacity cosmic blue
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x3300E5FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppConstants.cosmicBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
      ),
    );
  }

  // Primary button style (cosmic blue gradient)
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppConstants.cosmicBlue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    elevation: 4,
  );
}
