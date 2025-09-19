import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'providers/event_provider.dart';
import 'providers/ai_provider.dart';
import 'services/navigation_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SolakaiApp());
}

class SolakaiApp extends StatelessWidget {
  const SolakaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: MaterialApp(
        title: 'Solakai - Smart Calendar',
        theme: AppTheme.darkTheme,
        navigatorKey: NavigationService().navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
