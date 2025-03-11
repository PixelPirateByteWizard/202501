import 'package:flutter/material.dart';
import '../screens/quiz_forge_screen.dart';
import '../screens/tale_weaver_screen.dart';
import '../screens/style_sync_screen.dart';
import '../screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const QuizForgeScreen(),
    const TaleWeaverScreen(),
    const StyleSyncScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.quiz),
            label: 'QuizForge',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories),
            label: 'TaleWeaver',
          ),
          NavigationDestination(
            icon: Icon(Icons.style),
            label: 'StyleSync',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
