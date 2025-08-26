import 'package:flutter/material.dart';
import '../settings/about_screen.dart';
import '../settings/features_screen.dart';
import '../settings/terms_screen.dart';
import '../settings/privacy_screen.dart';
import '../settings/feedback_screen.dart';
import '../settings/version_screen.dart';

class AppRoutes {
  // Define route names as constants
  static const String about = '/about';
  static const String features = '/features';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String feedback = '/feedback';
  static const String version = '/version';

  // Define the route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case features:
        return MaterialPageRoute(builder: (_) => const FeaturesScreen());
      case terms:
        return MaterialPageRoute(builder: (_) => const TermsScreen());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyScreen());
      case feedback:
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());
      case version:
        return MaterialPageRoute(builder: (_) => const VersionScreen());
      default:
        // If the route is not defined, show an error page
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
