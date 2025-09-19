import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_progress.dart';
import '../services/game_data_service.dart';
import 'generals_screen.dart';
import 'journey_screen.dart';
import 'inventory_screen.dart';
import 'settings_screen.dart';
import 'formation_screen.dart';
import 'shop_screen.dart';
import 'achievements_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GameProgress? _gameProgress;

  @override
  void initState() {
    super.initState();
    _loadGameProgress();
  }

  Future<void> _loadGameProgress() async {
    final progress = await GameDataService.getGameProgress();
    setState(() {
      _gameProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      if (_gameProgress != null) _buildProgressCard(),
                      const SizedBox(height: 20),
                      _buildGameMenu(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '烽尘绘谱',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            icon: const Icon(
              Icons.settings,
              color: AppTheme.primaryGold,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Column(
      children: [
        // 宣传语
       

        // 当前进度
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.book, color: AppTheme.primaryGold, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '当前进度',
                    style: TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '第${_gameProgress!.currentChapter}章·第${_gameProgress!.currentStage}节',
                style: const TextStyle(color: AppTheme.textLight, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person,
                          color: AppTheme.primaryGold,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '武将 ${_gameProgress!.unlockedGenerals.length}人',
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppTheme.primaryGold,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '等级 ${_gameProgress!.playerLevel}',
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameMenu() {
    final menuItems = [
      {
        'title': '征程',
        'description': '挑战三国名将',
        'icon': Icons.flag,
        'color': Colors.red,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JourneyScreen()),
        ),
      },
      {
        'title': '武将',
        'description': '查看和管理武将',
        'icon': Icons.groups,
        'color': Colors.blue,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GeneralsScreen()),
        ),
      },
      {
        'title': '阵型',
        'description': '布置战斗阵型',
        'icon': Icons.grid_view,
        'color': Colors.green,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationScreen()),
        ),
      },
      {
        'title': '背包',
        'description': '装备和道具管理',
        'icon': Icons.inventory_2,
        'color': Colors.orange,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InventoryScreen()),
        ),
      },
      {
        'title': '商店',
        'description': '购买装备和道具',
        'icon': Icons.store,
        'color': Colors.purple,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        ),
      },
      {
        'title': '成就',
        'description': '查看游戏成就',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFDAA520),
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AchievementsScreen()),
        ),
      },
    ];

    return Column(
      children: [
        // 第一行：征程和武将
        Row(
          children: [
            Expanded(
              child: _buildLargeMenuCard(
                title: menuItems[0]['title'] as String,
                description: menuItems[0]['description'] as String,
                icon: menuItems[0]['icon'] as IconData,
                color: menuItems[0]['color'] as Color,
                onTap: menuItems[0]['onTap'] as VoidCallback,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLargeMenuCard(
                title: menuItems[1]['title'] as String,
                description: menuItems[1]['description'] as String,
                icon: menuItems[1]['icon'] as IconData,
                color: menuItems[1]['color'] as Color,
                onTap: menuItems[1]['onTap'] as VoidCallback,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 第二行：阵型和背包
        Row(
          children: [
            Expanded(
              child: _buildLargeMenuCard(
                title: menuItems[2]['title'] as String,
                description: menuItems[2]['description'] as String,
                icon: menuItems[2]['icon'] as IconData,
                color: menuItems[2]['color'] as Color,
                onTap: menuItems[2]['onTap'] as VoidCallback,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLargeMenuCard(
                title: menuItems[3]['title'] as String,
                description: menuItems[3]['description'] as String,
                icon: menuItems[3]['icon'] as IconData,
                color: menuItems[3]['color'] as Color,
                onTap: menuItems[3]['onTap'] as VoidCallback,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 第三行：商店和成就
        Row(
          children: [
            Expanded(
              child: _buildLargeMenuCard(
                title: menuItems[4]['title'] as String,
                description: menuItems[4]['description'] as String,
                icon: menuItems[4]['icon'] as IconData,
                color: menuItems[4]['color'] as Color,
                onTap: menuItems[4]['onTap'] as VoidCallback,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLargeMenuCard(
                title: menuItems[5]['title'] as String,
                description: menuItems[5]['description'] as String,
                icon: menuItems[5]['icon'] as IconData,
                color: menuItems[5]['color'] as Color,
                onTap: menuItems[5]['onTap'] as VoidCallback,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLargeMenuCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature功能即将上线'),
        backgroundColor: AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
