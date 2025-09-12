import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/achievement.dart';
import '../models/game_state.dart';

class AchievementScreen extends StatefulWidget {
  final GameState gameState;

  const AchievementScreen({super.key, required this.gameState});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '战斗', '收集', '剧情', '武将'];

  @override
  Widget build(BuildContext context) {
    final achievements = _getAchievements();
    final filteredAchievements = _getFilteredAchievements(achievements);
    final completedCount = achievements.where((a) => a.isCompleted).length;

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: Text('成就 ($completedCount/${achievements.length})'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 进度统计
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '成就进度',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: achievements.isNotEmpty ? completedCount / achievements.length : 0,
                      backgroundColor: AppTheme.lightColor.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '已完成：$completedCount / ${achievements.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // 分类筛选
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: AppTheme.accentColor.withOpacity(0.3),
                      checkmarkColor: AppTheme.accentColor,
                    ),
                  )).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 成就列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = filteredAchievements[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAchievementCard(achievement),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      child: InkWell(
        onTap: () => _showAchievementDetails(achievement),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 成就图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: achievement.isCompleted 
                      ? AppTheme.accentColor 
                      : AppTheme.lightColor.withOpacity(0.3),
                ),
                child: Icon(
                  _getAchievementIcon(achievement.type),
                  color: achievement.isCompleted 
                      ? AppTheme.primaryColor 
                      : AppTheme.lightColor.withOpacity(0.7),
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 成就信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: achievement.isCompleted 
                            ? AppTheme.accentColor 
                            : AppTheme.lightColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // 进度条
                    if (!achievement.isCompleted) ...[
                      LinearProgressIndicator(
                        value: achievement.progress,
                        backgroundColor: AppTheme.lightColor.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${achievement.currentValue}/${achievement.targetValue}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '已完成',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // 奖励图标
              if (achievement.rewards.isNotEmpty)
                Column(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      color: AppTheme.accentColor,
                      size: 24,
                    ),
                    Text(
                      '奖励',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: achievement.isCompleted 
                        ? AppTheme.accentColor 
                        : AppTheme.lightColor.withOpacity(0.3),
                  ),
                  child: Icon(
                    _getAchievementIcon(achievement.type),
                    color: achievement.isCompleted 
                        ? AppTheme.primaryColor 
                        : AppTheme.lightColor.withOpacity(0.7),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        _getAchievementTypeName(achievement.type),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 描述
            Text(
              '描述',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            const SizedBox(height: 24),
            
            // 进度
            Text(
              '进度',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (achievement.isCompleted) ...[
              const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.accentColor),
                  SizedBox(width: 8),
                  Text('已完成', style: TextStyle(color: AppTheme.accentColor)),
                ],
              ),
            ] else ...[
              LinearProgressIndicator(
                value: achievement.progress,
                backgroundColor: AppTheme.lightColor.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              const SizedBox(height: 8),
              Text('${achievement.currentValue} / ${achievement.targetValue}'),
            ],
            
            // 奖励
            if (achievement.rewards.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                '奖励',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              ...achievement.rewards.map((reward) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      _getRewardIcon(reward.type),
                      color: AppTheme.accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('${_getRewardName(reward.type)} x${reward.amount}'),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  List<Achievement> _getAchievements() {
    // 这里应该从游戏状态中获取成就数据
    // 现在返回一些示例成就
    return [
      Achievement(
        id: 'first_victory',
        name: '初战告捷',
        description: '赢得你的第一场战斗',
        type: AchievementType.battle,
        targetValue: 1,
        currentValue: widget.gameState.playerStats.battlesWon,
        isCompleted: widget.gameState.playerStats.battlesWon >= 1,
        rewards: [
          AchievementReward(type: AchievementRewardType.coins, amount: 500),
          AchievementReward(type: AchievementRewardType.experience, amount: 100),
        ],
      ),
      Achievement(
        id: 'battle_veteran',
        name: '战场老兵',
        description: '赢得10场战斗',
        type: AchievementType.battle,
        targetValue: 10,
        currentValue: widget.gameState.playerStats.battlesWon,
        isCompleted: widget.gameState.playerStats.battlesWon >= 10,
        rewards: [
          AchievementReward(type: AchievementRewardType.coins, amount: 2000),
        ],
      ),
      Achievement(
        id: 'collector',
        name: '收藏家',
        description: '收集5件装备',
        type: AchievementType.collection,
        targetValue: 5,
        currentValue: widget.gameState.playerStats.equipmentCollected,
        isCompleted: widget.gameState.playerStats.equipmentCollected >= 5,
        rewards: [
          AchievementReward(type: AchievementRewardType.coins, amount: 1000),
        ],
      ),
      Achievement(
        id: 'general_master',
        name: '武将大师',
        description: '招募3名武将',
        type: AchievementType.general,
        targetValue: 3,
        currentValue: widget.gameState.playerStats.generalsRecruited,
        isCompleted: widget.gameState.playerStats.generalsRecruited >= 3,
        rewards: [
          AchievementReward(type: AchievementRewardType.coins, amount: 1500),
        ],
      ),
      Achievement(
        id: 'level_up',
        name: '初露锋芒',
        description: '达到5级',
        type: AchievementType.level,
        targetValue: 5,
        currentValue: widget.gameState.playerStats.level,
        isCompleted: widget.gameState.playerStats.level >= 5,
        rewards: [
          AchievementReward(type: AchievementRewardType.coins, amount: 800),
        ],
      ),
    ];
  }

  List<Achievement> _getFilteredAchievements(List<Achievement> achievements) {
    if (_selectedCategory == '全部') {
      return achievements;
    }
    
    final typeMap = {
      '战斗': AchievementType.battle,
      '收集': AchievementType.collection,
      '剧情': AchievementType.story,
      '武将': AchievementType.general,
    };
    
    final targetType = typeMap[_selectedCategory];
    if (targetType == null) return achievements;
    
    return achievements.where((a) => a.type == targetType).toList();
  }

  IconData _getAchievementIcon(AchievementType type) {
    switch (type) {
      case AchievementType.battle:
        return Icons.sports_martial_arts;
      case AchievementType.collection:
        return Icons.inventory;
      case AchievementType.story:
        return Icons.auto_stories;
      case AchievementType.general:
        return Icons.people;
      case AchievementType.equipment:
        return Icons.shield;
      case AchievementType.level:
        return Icons.trending_up;
    }
  }

  String _getAchievementTypeName(AchievementType type) {
    switch (type) {
      case AchievementType.battle:
        return '战斗成就';
      case AchievementType.collection:
        return '收集成就';
      case AchievementType.story:
        return '剧情成就';
      case AchievementType.general:
        return '武将成就';
      case AchievementType.equipment:
        return '装备成就';
      case AchievementType.level:
        return '等级成就';
    }
  }

  IconData _getRewardIcon(AchievementRewardType type) {
    switch (type) {
      case AchievementRewardType.coins:
        return Icons.monetization_on;
      case AchievementRewardType.experience:
        return Icons.star;
      case AchievementRewardType.equipment:
        return Icons.shield;
      case AchievementRewardType.general:
        return Icons.person;
    }
  }

  String _getRewardName(AchievementRewardType type) {
    switch (type) {
      case AchievementRewardType.coins:
        return '金币';
      case AchievementRewardType.experience:
        return '经验值';
      case AchievementRewardType.equipment:
        return '装备';
      case AchievementRewardType.general:
        return '武将';
    }
  }
}