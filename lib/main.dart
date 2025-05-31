import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spirit Dream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansTC',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3730A3),
          primary: const Color(0xFFFBBF24),
          secondary: const Color(0xFF5B21B6),
          background: const Color(0xFF1E3A8A),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFBBF24),
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
          headlineMedium: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFBBF24),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFBBF24),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBBF24),
            foregroundColor: const Color(0xFF422006),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFFDE68A), width: 1),
            ),
            elevation: 4,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.black87.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF4B5563), width: 1),
          ),
          elevation: 8,
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}
