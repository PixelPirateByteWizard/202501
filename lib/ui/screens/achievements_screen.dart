import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../../core/game_engine.dart';
import '../../core/achievements_manager.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final _achievementsManager = AchievementsManager();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await _achievementsManager.initialize();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史成就'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重置进度',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('重置进度'),
                  content: const Text('确定要重置所有游戏进度和成就吗？此操作不可撤销。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _achievementsManager.resetProgress();
                        setState(() {});
                      },
                      child: const Text(
                        '重置',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
                  ],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSection(
                    title: '游戏记录',
                    children: GameDifficulty.values.map((difficulty) {
                      final record = _achievementsManager.records[difficulty];
                      return _buildDifficultyCard(
                        context,
                        difficulty: difficulty,
                        bestTime: record?.bestTime,
                        bestMoves: record?.bestMoves,
                        achievedAt: record?.achievedAt,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: '成就',
                    children:
                        _achievementsManager.achievements.map((achievement) {
                      return _buildAchievementCard(
                        context,
                        achievement: achievement,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context, {
    required GameDifficulty difficulty,
    Duration? bestTime,
    int? bestMoves,
    DateTime? achievedAt,
  }) {
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.grid_4x4,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  difficulty.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${difficulty.gridSize}x${difficulty.gridSize}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (bestTime != null) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.timer,
                    label: '最佳时间',
                    value: formatDuration(bestTime),
                  ),
                  _buildStatItem(
                    icon: Icons.directions_walk,
                    label: '最少步数',
                    value: bestMoves.toString(),
                  ),
                ],
              ),
              if (achievedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '达成于 ${_formatDateTime(achievedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  '尚未完成',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
    BuildContext context, {
    required Achievement achievement,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(
          achievement.icon,
          color:
              achievement.isUnlocked ? AppTheme.primaryColor : Colors.grey[400],
          size: 32,
        ),
        title: Text(
          achievement.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: achievement.isUnlocked ? null : Colors.grey[400],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              style: TextStyle(
                color: achievement.isUnlocked
                    ? Colors.grey[600]
                    : Colors.grey[400],
              ),
            ),
            if (achievement.isUnlocked && achievement.unlockedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '解锁于 ${_formatDateTime(achievement.unlockedAt!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
        trailing: achievement.isUnlocked
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.lock,
                color: Colors.grey[400],
              ),
      ),
    );
  }
}
