import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/enemy_type.dart';
import '../widgets/app_background.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  // Helper method to get image path based on character name
  String _getCharacterImagePath(String name) {
    switch (name) {
      case 'Scout':
        return 'assets/role/Hero_1.png';
      case 'Brute':
        return 'assets/role/Hero_2.png';
      case 'Hunter':
        return 'assets/role/Hero_3.png';
      case 'Assassin':
        return 'assets/role/Hero_4.png';
      case 'Titan':
        return 'assets/role/Hero_5.png';
      case '你 (Player)':
        return 'assets/role/Hero_6.png';
      case '幽灵行者':
        return 'assets/role/Hero_7.png';
      case '雷霆使者':
        return 'assets/role/Hero_8.png';
      case '守望者':
        return 'assets/role/Hero_9.png';
      case '暗影猎手':
        return 'assets/role/Hero_10.png';
      case '炎魔':
        return 'assets/role/Hero_11.png';
      case '冰霜巨人':
        return 'assets/role/Hero_12.png';
      case '风暴领主':
        return 'assets/role/Hero_13.png';
      case '机械战警':
        return 'assets/role/Hero_14.png';
      case '虚空行者':
        return 'assets/role/Hero_15.png';
      case '光明骑士':
        return 'assets/role/Hero_16.png';
      case '深海巨兽':
        return 'assets/role/Hero_17.png';
      case '自然守卫':
        return 'assets/role/Hero_18.png';
      case '时空旅者':
        return 'assets/role/Hero_19.png';
      default:
        // For any other character, use a default image
        return 'assets/role/Hero_7.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 创建一个包含玩家和所有敌人类型的列表，以及额外的角色
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
          }),
      // 额外的角色
      {
        'name': '幽灵行者',
        'icon': Icons.visibility_off,
        'color': Colors.deepPurple,
        'details': '初始刀锋: 15\n速度: 3.5',
        'behavior': '行为模式: 隐形，突然接近玩家进行攻击。',
      },
      {
        'name': '雷霆使者',
        'icon': Icons.bolt,
        'color': Colors.amber,
        'details': '初始刀锋: 20\n速度: 2.8',
        'behavior': '行为模式: 闪电冲刺，可以瞬间移动短距离。',
      },
      {
        'name': '守望者',
        'icon': Icons.remove_red_eye,
        'color': Colors.teal,
        'details': '初始刀锋: 30\n速度: 1.5',
        'behavior': '行为模式: 远程攻击，保持距离。',
      },
      {
        'name': '暗影猎手',
        'icon': Icons.nightlight_round,
        'color': Colors.indigo,
        'details': '初始刀锋: 22\n速度: 2.5',
        'behavior': '行为模式: 夜间更强，白天较弱。',
      },
      {
        'name': '炎魔',
        'icon': Icons.local_fire_department,
        'color': Colors.deepOrange,
        'details': '初始刀锋: 35\n速度: 1.8',
        'behavior': '行为模式: 火焰攻击，接近时造成额外伤害。',
      },
      {
        'name': '冰霜巨人',
        'icon': Icons.ac_unit,
        'color': Colors.lightBlue,
        'details': '初始刀锋: 40\n速度: 1.0',
        'behavior': '行为模式: 减速敌人，移动缓慢但防御强大。',
      },
      {
        'name': '风暴领主',
        'icon': Icons.cloud,
        'color': Colors.blueGrey,
        'details': '初始刀锋: 25\n速度: 2.2',
        'behavior': '行为模式: 创造风暴，扰乱周围敌人。',
      },
      {
        'name': '机械战警',
        'icon': Icons.security,
        'color': Colors.grey,
        'details': '初始刀锋: 28\n速度: 1.9',
        'behavior': '行为模式: 精确打击，追踪目标。',
      },
      {
        'name': '虚空行者',
        'icon': Icons.blur_on,
        'color': Colors.deepPurple,
        'details': '初始刀锋: 18\n速度: 3.0',
        'behavior': '行为模式: 短距离传送，难以捉摸。',
      },
      {
        'name': '光明骑士',
        'icon': Icons.light_mode,
        'color': Colors.amber,
        'details': '初始刀锋: 32\n速度: 2.0',
        'behavior': '行为模式: 光明护盾，减少伤害。',
      },
      {
        'name': '深海巨兽',
        'icon': Icons.water,
        'color': Colors.blue,
        'details': '初始刀锋: 45\n速度: 0.9',
        'behavior': '行为模式: 水下移动更快，陆地缓慢。',
      },
      {
        'name': '自然守卫',
        'icon': Icons.nature,
        'color': Colors.green,
        'details': '初始刀锋: 26\n速度: 2.1',
        'behavior': '行为模式: 生命恢复，持久战斗。',
      },
      {
        'name': '时空旅者',
        'icon': Icons.timelapse,
        'color': Colors.cyan,
        'details': '初始刀锋: 23\n速度: 2.7',
        'behavior': '行为模式: 时间扭曲，偶尔减慢敌人速度。',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('英雄图鉴'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        backgroundIndex: 3,
        overlayOpacity: 0.7,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: characterList.length,
          itemBuilder: (context, index) {
            final character = characterList[index];
            final imagePath = _getCharacterImagePath(character['name']);

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
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: character['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
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
      ),
    );
  }
}
