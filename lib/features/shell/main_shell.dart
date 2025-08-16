import 'package:flutter/material.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import '../dashboard/dashboard_screen.dart';
import '../market/market_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../news/news_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MarketScreen(),
    const AIAssistantScreen(),
    const NewsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: SafeArea(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}