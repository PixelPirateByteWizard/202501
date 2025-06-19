import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/app_background.dart';

class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  GameStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await StorageService.getGameStats();
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('成绩'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 3.0,
            tabs: [
              Tab(icon: Icon(Icons.bar_chart), text: '统计数据'),
              Tab(icon: Icon(Icons.emoji_events), text: '成就'),
            ],
          ),
        ),
        body: AppBackground(
          backgroundIndex: 5,
          overlayOpacity: 0.7,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildStatsPage(_stats!),
                    _buildAchievementsPage(_stats!),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildStatsPage(GameStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildStatCard(
            '最高纪录',
            stats.highScore.toString(),
            Icons.star,
            Colors.yellow,
            isLarge: true,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('最长生存', '${stats.longestTimeInSeconds} 秒',
                  Icons.timer, Colors.cyan),
              _buildStatCard('游戏局数', stats.totalGamesPlayed.toString(),
                  Icons.gamepad, Colors.green),
              _buildStatCard('击败敌人', stats.totalEnemiesDefeated.toString(),
                  Icons.group_off, Colors.red),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color,
      {bool isLarge = false}) {
    return Card(
      color: color.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isLarge ? 48 : 32, color: color),
            const SizedBox(height: 12),
            Text(value,
                style: TextStyle(
                    fontSize: isLarge ? 40 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsPage(GameStats stats) {
    final allAchievements = StorageService.getAllAchievements();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allAchievements.length,
      itemBuilder: (context, index) {
        final achievement = allAchievements[index];
        final isUnlocked =
            stats.unlockedAchievementIds.contains(achievement.id);
        return Card(
          color: isUnlocked
              ? Colors.amber.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color:
                    isUnlocked ? Colors.amber : Colors.grey.withOpacity(0.3)),
          ),
          child: ListTile(
            leading: Icon(
              achievement.icon,
              size: 36,
              color: isUnlocked ? Colors.amber : Colors.grey,
            ),
            title: Text(
              achievement.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.white : Colors.white54,
              ),
            ),
            subtitle: Text(
              achievement.description,
              style: TextStyle(
                color:
                    isUnlocked ? Colors.white.withOpacity(0.7) : Colors.white38,
              ),
            ),
          ),
        );
      },
    );
  }
}
