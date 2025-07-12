import 'dart:ui';
import 'package:astrelexis/screens/astra/astra_screen.dart';
import 'package:astrelexis/screens/journal/journal_screen.dart';
import 'package:astrelexis/screens/settings/settings_screen.dart';
import 'package:astrelexis/screens/statistics/statistics_screen.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _journalRefreshTrigger = 0;

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          JournalScreen(key: ValueKey(_journalRefreshTrigger)),
          const StatisticsScreen(),
          const AstraScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(48.0),
        topRight: Radius.circular(48.0),
        bottomLeft: Radius.circular(48.0),
        bottomRight: Radius.circular(48.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bookOpen),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartPie),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.star),
              label: 'Astra',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cog),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.bottomNavBg,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.accentTeal,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
