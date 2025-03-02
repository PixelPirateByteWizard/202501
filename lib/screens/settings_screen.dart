// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'game_introduction_screen.dart';
import 'suggestions_screen.dart';
import 'game_strategy_screen.dart';
import 'contact_us_screen.dart';
import 'privacy_protection_screen.dart';
import 'player_manual_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with a loading indicator
          FutureBuilder(
            future:
                precacheImage(const AssetImage('assets/bj/xybj7.png'), context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bj/xybj7.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode.darken,
                      ),
                    ),
                  ),
                );
              } else {
                // Show a placeholder while loading
                return Container(
                  color: Colors.black54, // Placeholder color
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          // Content
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0, // 添加状态栏高度和额外边距
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.yellow),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Text(
                        '设置',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48), // Adjust width as needed
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildListTile(context, '游戏介绍', Icons.info,
                          GameIntroductionScreen()),
                      _buildListTile(context, '建议与意见', Icons.feedback,
                          SuggestionsScreen()),
                      _buildListTile(context, '游戏攻略', Icons.sports_esports,
                          GameStrategyScreen()),
                      _buildListTile(context, '联系我们', Icons.contact_mail,
                          ContactUsScreen()),
                      _buildListTile(context, '隐私保护', Icons.privacy_tip,
                          PrivacyProtectionScreen()),
                      _buildListTile(
                          context, '玩家手册', Icons.book, PlayerManualScreen()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, String title, IconData icon, Widget destination) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.yellow),
        title: Text(title,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}

// Placeholder screens for navigation
