import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color
  static const Color primary = Color(0xFF6E48AA);
  static const Color primaryLight = Color(0xFF9170D6);
  static const Color primaryDark = Color(0xFF523680);

  // Secondary colors
  static const Color secondary = Color(0xFF7FB5FF);
  static const Color secondaryLight = Color(0xFFACD2FF);
  static const Color secondaryDark = Color(0xFF4285F4);

  // Background & surface colors
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1FA);

  // Text colors
  static const Color textDark = Color(0xFF303043);
  static const Color textMedium = Color(0xFF636378);
  static const Color textLight = Color(0xFF9999AA);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF2196F3);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF7B52C0),
    Color(0xFF5E3D99),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF7FB5FF),
    Color(0xFF3683FC),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFB28DFF),
    Color(0xFF9F6FFF),
  ];

  // Prevent instantiation
  AppColors._();
}
