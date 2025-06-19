import 'package:flutter/material.dart';
import 'game_wrapper.dart';
import 'pokedex_screen.dart';
import 'backpack_screen.dart';
import 'scores_screen.dart';
import 'settings_screen.dart';
import '../widgets/app_background.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        backgroundIndex: 1,
        overlayOpacity: 0.6,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '神将GO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            blurRadius: 10.0,
                            color: Colors.blueAccent,
                            offset: Offset(0, 0)),
                        Shadow(
                            blurRadius: 20.0,
                            color: Colors.blue,
                            offset: Offset(0, 0)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  _buildMenuButton(
                    context,
                    '开始游戏',
                    Icons.play_arrow,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameWrapper()),
                      );
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    '英雄图鉴',
                    Icons.menu_book,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PokedexScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    '背包',
                    Icons.backpack,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BackpackScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    '成绩',
                    Icons.leaderboard,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScoresScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    '设置',
                    Icons.settings,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: isPrimary ? 30 : 22),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isPrimary
            ? Colors.blue.shade700
            : Colors.blue.shade900.withOpacity(0.7),
        minimumSize: const Size(280, 60),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(
          fontSize: isPrimary ? 26 : 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: isPrimary ? Colors.blue.shade300 : Colors.blue.shade700,
            width: 2,
          ),
        ),
        elevation: 8,
        shadowColor: isPrimary ? Colors.blue.withOpacity(0.7) : Colors.black,
      ),
    );
  }
}
