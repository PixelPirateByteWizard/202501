import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kaelix/screens/forge_screen.dart';
import 'package:kaelix/providers/event_provider.dart';
import 'package:kaelix/providers/ai_provider.dart';

void main() {
  group('ForgeScreen Tests', () {
    testWidgets('Quick action buttons should be responsive', (WidgetTester tester) async {
      // Build the widget with providers
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => EventProvider()),
              ChangeNotifierProvider(create: (_) => AIProvider()),
            ],
            child: const ForgeScreen(),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Find the quick action buttons
      expect(find.text('Add Focus Time'), findsOneWidget);
      expect(find.text('Optimize Schedule'), findsOneWidget);
      expect(find.text('Find Free Time'), findsOneWidget);
      expect(find.text('Resolve Conflicts'), findsOneWidget);

      // Test button tap
      await tester.tap(find.text('Add Focus Time'));
      await tester.pumpAndSettle();

      // Verify loading state appears
      expect(find.text('Processing...'), findsOneWidget);
    });

    testWidgets('Buttons should show loading state when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => EventProvider()),
              ChangeNotifierProvider(create: (_) => AIProvider()),
            ],
            child: const ForgeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the Optimize Schedule button
      await tester.tap(find.text('Optimize Schedule'));
      await tester.pump();

      // Should show loading state
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });
}