import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/achievement_service.dart';
import '../models/achievement.dart';
import '../widgets/achievement_notification.dart';

class AchievementTestScreen extends StatefulWidget {
  const AchievementTestScreen({super.key});

  @override
  State<AchievementTestScreen> createState() => _AchievementTestScreenState();
}

class _AchievementTestScreenState extends State<AchievementTestScreen> {
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);
    
    final achievements = await AchievementService.getAchievements();
    
    setState(() {
      _achievements = achievements;
      _isLoading = false;
    });
  }

  Future<void> _testAchievementUnlock() async {
    // 找一个未解锁的成就进行测试
    final unlockedAchievement = _achievements.firstWhere(
      (a) => !a.isUnlocked,
      orElse: () => _achievements.first,
    );

    if (unlockedAchievement.isUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('所有成就都已解锁！')),
      );
      return;
    }

    // 模拟解锁成就
    final updatedAchievement = unlockedAchievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
      currentValue: unlockedAchievement.targetValue,
    );

    // 显示成就通知
    AchievementNotificationManager.showAchievementUnlocked(
      context,
      updatedAchievement,
    );

    // 更新本地列表
    setState(() {
      final index = _achievements.indexWhere((a) => a.id == unlockedAchievement.id);
      if (index != -1) {
        _achievements[index] = updatedAchievement;
      }
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
              _buildTestButtons(),
              Expanded(
                child: _isLoading ? _buildLoadingWidget() : _buildAchievementsList(),
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
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
          ),
          const SizedBox(width: 8),
          const Text(
            '成就测试',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _testAchievementUnlock,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.backgroundDark,
            ),
            child: const Text('测试成就解锁通知'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await AchievementService.checkAndUpdateAchievements();
              await _loadAchievements();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('成就进度已更新')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('更新成就进度'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryGold),
    );
  }

  Widget _buildAchievementsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: achievement.isUnlocked 
            ? achievement.getRarityColor()
            : AppTheme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            achievement.icon,
            style: TextStyle(
              fontSize: 20,
              color: achievement.isUnlocked ? null : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: TextStyle(
                    color: achievement.isUnlocked ? AppTheme.textLight : AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${achievement.currentValue}/${achievement.targetValue}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            achievement.isUnlocked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: achievement.isUnlocked ? achievement.getRarityColor() : AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}