import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/about_screen.dart';
import 'screens/user_agreement_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/help_screen.dart';
import 'screens/feedback_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SanguoHuiquanApp());
}

class SanguoHuiquanApp extends StatelessWidget {
  const SanguoHuiquanApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: '烽尘绘谱',
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        // 在这里应用响应式主题
        return Theme(data: AppTheme.getResponsiveTheme(context), child: child!);
      },
      home: const SplashScreen(),
      routes: {
        '/about': (context) => const AboutScreen(),
        '/user-agreement': (context) => const UserAgreementScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
        '/help': (context) => const HelpScreen(),
        '/feedback': (context) => const FeedbackScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
