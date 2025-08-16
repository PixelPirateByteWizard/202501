import 'package:flutter/material.dart';
import 'core/services/storage_service.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/main_shell.dart';

class CoinVerseApp extends StatelessWidget {
  const CoinVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinVerse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color(0xFF1A1E2D),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE6EDF3)),
          bodyMedium: TextStyle(color: Color(0xFFE6EDF3)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1E2D),
          foregroundColor: Color(0xFFE6EDF3),
          elevation: 0,
        ),
      ),
      home: const AppInitializer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _isOnboardingComplete = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final isComplete = await StorageService.isOnboardingComplete();
    setState(() {
      _isOnboardingComplete = isComplete;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1117),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          ),
        ),
      );
    }

    return _isOnboardingComplete ? const MainShell() : const OnboardingScreen();
  }
}