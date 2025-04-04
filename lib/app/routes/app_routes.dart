import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/qr_code/qr_generator_screen.dart';
import '../screens/qr_code/qr_history_screen.dart';
import '../screens/encryption/encryption_screen.dart';
import '../screens/encryption/encryption_history_screen.dart';
import '../screens/word_count/word_count_screen.dart';
import '../screens/word_count/word_count_history_screen.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String qrGenerator = '/qr-generator';
  static const String qrHistory = '/qr-history';
  static const String encryption = '/encryption';
  static const String encryptionHistory = '/encryption-history';
  static const String wordCount = '/word-count';
  static const String wordCountHistory = '/word-count-history';

  // Route map
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    qrGenerator: (context) => const QrGeneratorScreen(),
    qrHistory: (context) => const QrHistoryScreen(),
    encryption: (context) => const EncryptionScreen(),
    encryptionHistory: (context) => const EncryptionHistoryScreen(),
    wordCount: (context) => const WordCountScreen(),
    wordCountHistory: (context) => const WordCountHistoryScreen(),
  };

  // Route generation
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Prevent instantiation
  AppRoutes._();
}
