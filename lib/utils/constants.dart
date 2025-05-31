import 'package:flutter/material.dart';

class AppConstants {
  // Color constants
  static const Color primaryColor = Color(0xFFFBBF24); // Gold
  static const Color secondaryColor = Color(0xFF5B21B6); // Purple
  static const Color backgroundColor = Color(0xFF1E3A8A); // Dark blue
  static const Color darkPurple = Color(0xFF3730A3); // Dark purple
  static const Color surfaceColor = Color(0xFF2F2F4A);
  static const Color darkTextColor = Color(0xFF422006); // Dark brown

  // Gradient color configurations
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)], // Gold gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient startScreenGradient = LinearGradient(
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF3730A3),
      Color(0xFF5B21B6)
    ], // Blue-purple gradient
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient gameGradient = LinearGradient(
    colors: [
      Color(0xFF064E3B),
      Color(0xFF065F46),
      Color(0xFF047857)
    ], // Dark green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF4A044E),
      Color(0xFF3B0764),
      Color(0xFF2A0A3B)
    ], // Dark purple
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient upgradeScreenGradient = LinearGradient(
    colors: [
      Color(0xFF4A044E),
      Color(0xFF3B0764),
      Color(0xFF2A0A3B)
    ], // Dark purple
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient gameOverScreenGradient = LinearGradient(
    colors: [
      Color(0xFF334155),
      Color(0xFF1E293B),
      Color(0xFF0F172A)
    ], // Deep gray-blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [
      Color(0xFF334155),
      Color(0xFF1E293B),
      Color(0xFF0F172A)
    ], // Deep gray-blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFA78BFA), Color(0xFFFBBF24)], // Purple to gold
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient progressBarGradient = LinearGradient(
    colors: [Color(0xFFA78BFA), Color(0xFFFBBF24)], // Purple to gold
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Text style constants
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(1, 1),
        blurRadius: 3,
      ),
    ],
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  // Border and shape constants
  static BorderRadius get defaultBorderRadius => BorderRadius.circular(12);
  static BorderRadius get largeBorderRadius => BorderRadius.circular(20);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(16);
  static BorderRadius get borderRadiusSmall => BorderRadius.circular(8);
  static Border get defaultBorder =>
      Border.all(color: primaryColor.withOpacity(0.3), width: 1);

  // Animation duration constants
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Spacing constants
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Size constants
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 64.0;

  // Other constants
  static const String appName = 'Spirit Dream';
}
