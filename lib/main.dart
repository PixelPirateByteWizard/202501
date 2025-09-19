import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FengChenHuiPuApp());
}

class FengChenHuiPuApp extends StatelessWidget {
  const FengChenHuiPuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '烽尘绘谱',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
