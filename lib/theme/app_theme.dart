import 'package:flutter/material.dart';

class AppTheme {
  // 主色调
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFFFD700);
  static const Color darkBlue = Color(0xFF1A365D);
  static const Color mediumBlue = Color(0xFF2D3748);
  static const Color lightBlue = Color(0xFF4A5568);
  static const Color textLight = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardBackground = Color(0xFF2A4365);
  static const Color cardBackgroundDark = Color(0xFF1A365D);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.amber,
      primaryColor: primaryGold,
      scaffoldBackgroundColor: darkBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: primaryGold,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryGold.withValues(alpha: 0.3)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: darkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: primaryGold,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          color: primaryGold,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textLight, fontSize: 16),
        bodyMedium: TextStyle(color: textLight, fontSize: 14),
        bodySmall: TextStyle(color: textLight, fontSize: 12),
      ),
    );
  }

  static BoxDecoration get gradientBackground {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkBlue, mediumBlue, lightBlue],
      ),
    );
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cardBackground.withValues(alpha: 0.9),
          cardBackgroundDark.withValues(alpha: 0.7),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: primaryGold.withValues(alpha: 0.3)),
    );
  }

  static BoxDecoration get goldGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryGold, lightGold],
      ),
    );
  }
}
