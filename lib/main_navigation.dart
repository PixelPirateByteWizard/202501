import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'group_generator/group_generator_screen.dart';
import 'match_scorer/match_scorer_screen.dart';
import 'led_scroller/led_scroller_screen.dart';
import 'settings/settings_screen.dart';

/// 主导航界面，整合所有功能模块
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  static const MethodChannel _channel = MethodChannel('verzephronix/ads');

  // 所有功能模块的屏幕
  final List<Widget> _screens = [
    const GroupGeneratorScreen(),
    const MatchScorerScreen(),
    const LedScrollerScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          try {
            await _channel.invokeMethod('requestInterstitialAfterNav');
          } catch (_) {}
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Scorer'),
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'LED'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
