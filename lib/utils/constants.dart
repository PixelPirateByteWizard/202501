import 'package:flutter/material.dart';

class AppConstants {
  // App information
  static const String appName = 'Verzephronix';
  static const String appVersion = '1.2.0';

  // Feature names
  static const String groupGenerator = 'Group Generator';
  static const String matchScorer = 'Match Scorer';
  static const String ledScroller = 'LED Scroller';
  static const String settings = 'Settings';

  // Color palette
  static const Color spaceIndigo900 = Color(0xFF0A0E2A);
  static const Color spaceIndigo800 = Color(0xFF12173A);
  static const Color spaceIndigo700 = Color(0xFF1A237E);
  static const Color spaceIndigo600 = Color(0xFF283593);
  static const Color spaceIndigo500 = Color(0xFF3949AB);
  static const Color cosmicBlue = Color(0xFF00E5FF);
  static const Color stardustGold = Color(0xFFFFD700);
  static const Color nebulaPurple = Color(0xFF7C4DFF);

  // Sports types
  static const List<String> sportTypes = [
    'Tennis',
    'Badminton',
    'Table Tennis',
    'Basketball',
  ];

  // Sport scoring rules
  static const Map<String, Map<String, dynamic>> sportRules = {
    'Tennis': {
      'winningScore': 6,
      'minDifference': 2,
      'tiebreakAt': 6,
      'tiebreakWinningScore': 7,
      'description': 'First to 6 games with 2 game difference',
    },
    'Badminton': {
      'winningScore': 21,
      'minDifference': 2,
      'maxScore': 30,
      'description': 'First to 21 points with 2 point difference, max 30',
    },
    'Table Tennis': {
      'winningScore': 11,
      'minDifference': 2,
      'description': 'First to 11 points with 2 point difference',
    },
    'Basketball': {
      'quarterLength': 12, // minutes
      'description': 'Highest score after 4 quarters wins',
    },
  };

  // LED scroller templates
  static const Map<String, String> ledTemplates = {
    'Simple encouragement': 'GO TEAM GO!',
    'Defensive chant': 'DEFENSE!',
    'Confidence boost': 'VICTORY IS OURS!',
    'Energy booster': '🔥 UNSTOPPABLE! 🔥',
  };

  // Settings options
  static const List<String> settingsOptions = [
    'App Details',
    'Features Walkthrough',
    'License Agreement',
    'Privacy Policy',
    'Submit Feedback',
    'Version Information',
  ];
}
