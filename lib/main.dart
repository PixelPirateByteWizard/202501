import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/launch_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ClockworkLegacyApp());
}

class ClockworkLegacyApp extends StatelessWidget {
  const ClockworkLegacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Clockwork Legacy',
      theme: AppTheme.darkTheme,
      home: const LaunchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
