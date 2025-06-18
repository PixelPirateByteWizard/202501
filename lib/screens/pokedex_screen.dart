import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/enemy_type.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建一个包含玩家和所有敌人类型的列表
    final List<Map<String, dynamic>> characterList = [
      {
        'name': '你 (Player)',
        'icon': Icons.person,
        'color': Colors.yellow,
        'details': '初始刀锋: 10\n速度: 基础',
        'behavior': '由你操控的英雄，通过冲刺躲避和攻击。',
      },
      ...EnemyType.allTypes.map((type) => {
            'name': type.name,
            'icon': type.icon,
            'color': type.color,
            'details': '初始刀锋: ${type.baseBlades}\n速度: ${type.baseSpeed}',
            'behavior': '行为模式: ${type.behavior}',
          })
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      appBar: AppBar(
        title: const Text('英雄图鉴'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: characterList.length,
        itemBuilder: (context, index) {
          final character = characterList[index];
          return Card(
            color: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: character['color'].withOpacity(0.5)),
            ),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: character['color'].withOpacity(0.2),
                    child: Icon(
                      character['icon'],
                      size: 30,
                      color: character['color'],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: character['color'],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          character['details'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          character['behavior'],
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
