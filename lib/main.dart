import 'package:flutter/material.dart';
import 'screens/app_features_page.dart';
import 'screens/app_introduction_page.dart';
import 'screens/contact_us_page.dart';
import 'screens/feedback_page.dart';
import 'screens/privacy_policy_page.dart';
import 'screens/settings_page.dart';
import 'screens/user_manual_page.dart';
import 'screens/knowledge_page.dart';
import 'screens/share_page.dart';
import 'screens/waste_sorting_page.dart';
import 'screens/launch_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gelro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const LaunchScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/app_introduction': (context) => const AppIntroductionPage(),
        '/user_manual': (context) => const UserManualPage(),
        '/app_features': (context) => const AppFeaturesPage(),
        '/feedback': (context) => const FeedbackPage(),
        '/contact_us': (context) => const ContactUsPage(),
        '/privacy_policy': (context) => const PrivacyPolicyPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const KnowledgePage(),
    const SharePage(),
    const WasteSortingPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF8B6BF3),
          unselectedItemColor: Colors.white.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 0,
          items: [
            _buildNavItem(Icons.book_rounded, 'Knowledge'),
            _buildNavItem(Icons.share_rounded, 'Share'),
            _buildNavItem(Icons.delete_outline_rounded, 'Sort'),
            _buildNavItem(Icons.settings_rounded, 'Settings'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    final isSelected = _selectedIndex == _getIndexFromLabel(label);
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF8B6BF3),
                    Color(0xFF6B4DE3),
                  ],
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B6BF3).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          size: 24,
        ),
      ),
      label: label,
    );
  }

  int _getIndexFromLabel(String label) {
    switch (label) {
      case 'Knowledge':
        return 0;
      case 'Share':
        return 1;
      case 'Sort':
        return 2;
      case 'Settings':
        return 3;
      default:
        return 0;
    }
  }
}
