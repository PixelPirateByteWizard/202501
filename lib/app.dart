import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';
import 'utils/routes.dart';
import 'main_navigation.dart';

class VerzephronixApp extends StatelessWidget {
  const VerzephronixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme as per design
      home: const MainNavigationScreen(),
      onGenerateRoute: AppRoutes.generateRoute, // Add route generator
    );
  }
}
