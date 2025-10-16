import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clockworklegacy/screens/about_screen.dart';
import 'package:clockworklegacy/screens/terms_of_service_screen.dart';
import 'package:clockworklegacy/screens/privacy_policy_screen.dart';
import 'package:clockworklegacy/screens/help_screen.dart';
import 'package:clockworklegacy/screens/feedback_screen.dart';
import 'package:clockworklegacy/theme/app_theme.dart';

void main() {
  group('Settings Pages Tests', () {
    testWidgets('AboutScreen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const AboutScreen(),
        ),
      );

      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Clockwork Legacy'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
    });

    testWidgets('TermsOfServiceScreen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const TermsOfServiceScreen(),
        ),
      );

      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Agreement Overview'), findsOneWidget);
    });

    testWidgets('PrivacyPolicyScreen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const PrivacyPolicyScreen(),
        ),
      );

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Your Privacy Matters'), findsOneWidget);
    });

    testWidgets('HelpScreen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const HelpScreen(),
        ),
      );

      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('Welcome to Help Center'), findsOneWidget);
    });

    testWidgets('FeedbackScreen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const FeedbackScreen(),
        ),
      );

      expect(find.text('Feedback & Suggestions'), findsOneWidget);
      expect(find.text('We Value Your Input'), findsOneWidget);
      expect(find.text('Submit Feedback'), findsOneWidget);
    });

    testWidgets('FeedbackScreen rating should work', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const FeedbackScreen(),
        ),
      );

      // Find and tap the first star (rating 1)
      final starFinder = find.byIcon(Icons.star).first;
      await tester.tap(starFinder);
      await tester.pump();

      // Should show rating text for 1 star
      expect(find.text('Poor - Needs significant improvement'), findsOneWidget);
    });
  });
}