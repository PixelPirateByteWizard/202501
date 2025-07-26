import 'package:flutter/material.dart';

class GameConstants {
  static const double bottleWidth = 55.0;
  static const double bottleHeight = 200.0;
  static const double liquidHeight = 40.0;
  static const int maxLiquid = 4;
  static const int initialUndoCount = 5;
  static const int maxBottles = 10;
  
  static const Duration animationDuration = Duration(milliseconds: 800);
  static const Duration shakeDuration = Duration(milliseconds: 500);
  
  static const Color backgroundColor = Color(0xFFF0E8F8);
  static const Color shelfColor = Color(0xFFCDAA7D);
  static const Color shelfShadowColor = Color(0xFFB9967D);
  
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const double bottleSpacing = 25.0;
  static const int maxBottlesPerRow = 5;
}