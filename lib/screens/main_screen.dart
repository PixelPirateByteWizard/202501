import 'package:flutter/material.dart';
import '../screens/quiz_forge_screen.dart';
import '../screens/tale_weaver_screen.dart';
import '../screens/style_sync_screen.dart';
import '../screens/settings_screen.dart';
import '../services/ad_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _tapCount = 0;
  DateTime? _lastTapTime;
  final AdService _adService = AdService();

  final List<Widget> _screens = [
    const QuizForgeScreen(),
    const TaleWeaverScreen(),
    const StyleSyncScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      // 切换页面时调用插页广告
      _adService.presentInterstitialAd();
      
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  
  void _handleScreenTap() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds < 3) {
      setState(() {
        _tapCount++;
      });
      
      if (_tapCount >= 10) {
        _showAdTestDialog();
        _tapCount = 0;
      }
    } else {
      setState(() {
        _tapCount = 1;
      });
    }
    _lastTapTime = now;
  }
  
  void _showAdTestDialog() {
    _adService.loadOtherAd();
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ad Test Panel",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        _buildAdButton("展示插页1", () => _adService.presentInterstitialAd1()),
                        _buildAdButton("展示插页2", () => _adService.presentInterstitialAd2()),
                        _buildAdButton("展示插页3", () => _adService.presentInterstitialAd3()),
                        _buildAdButton("展示视频1", () => _adService.playIncentiveVideo1()),
                        _buildAdButton("展示视频2", () => _adService.playIncentiveVideo2()),
                        _buildAdButton("展示视频3", () => _adService.playIncentiveVideo3()),
                        _buildAdButton("展示横幅", () => _adService.displayBannerAd()),
                        _buildAdButton("隐藏横幅", () => _adService.concealBannerAd()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAdButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        textStyle: const TextStyle(fontSize: 13),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleScreenTap,
      child: Scaffold(
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
      ),
    );
  }
}
