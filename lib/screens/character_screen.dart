// lib/screens/character_screen.dart
import 'package:flutter/material.dart';
import '../models/character.dart'; // 导入角色模型

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bj/xybj1.png'), // Set to the new background image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 返回按钮和标题
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.yellow), // Updated icon color to yellow
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      '幻世角色',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow, // Updated text color to yellow
                        fontFamily:
                            'CustomFont', // Use a custom font for aesthetics
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    return GestureDetector(
                      onTap: () {
                        _showCharacterDetails(context, character);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.yellow,
                              width: 2), // Updated border color to yellow
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade100.withOpacity(0.5),
                              Colors.blue.shade200.withOpacity(0.5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                character.imagePath,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                              child: Container(
                                color: Colors.black54,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  character.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCharacterDetails(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            character.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  character.description,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                _buildProgressBar('Attack Power', character.attackPower, 130),
                const SizedBox(height: 8),
                _buildProgressBar('Mana', character.mana, 120),
                const SizedBox(height: 8),
                _buildProgressBar('Level', character.level, 6),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(String label, int value, int maxValue) {
    // 将标签转换为中文
    String translatedLabel;
    switch (label) {
      case 'Attack Power':
        translatedLabel = '攻击力';
        break;
      case 'Mana':
        translatedLabel = '法力';
        break;
      case 'Level':
        translatedLabel = '等级';
        break;
      default:
        translatedLabel = label;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$translatedLabel: $value',
          style: const TextStyle(color: Colors.white),
        ),
        LinearProgressIndicator(
          value: value / maxValue,
          backgroundColor: Colors.grey[300],
          color: Colors.blueAccent,
        ),
      ],
    );
  }
}
