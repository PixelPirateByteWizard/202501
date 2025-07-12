import 'package:astrelexis/screens/main_screen.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astrelexis',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryBg,
        primaryColor: AppColors.primaryBg,
        fontFamily: 'Inter',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBg,
          brightness: Brightness.dark,
          background: AppColors.primaryBg,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
