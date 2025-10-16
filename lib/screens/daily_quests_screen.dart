import 'package:flutter/material.dart';
import '../models/daily_quest.dart';
import '../services/daily_quest_service.dart';
import '../services/game_stats_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class DailyQuestsScreen extends StatefulWidget {
  const DailyQuestsScreen({super.key});

  @override
  State<DailyQuestsScreen> createState() => _DailyQuestsScreenState();
}

class _DailyQuestsScreenState extends State<DailyQuestsScreen>
    with TickerProviderStateMixin {
  final DailyQuestService _questService = DailyQuestService();
  final GameStatsService _statsService = GameStatsService();
  
  List<DailyQuest> _quests = [];
  bool _isLoading = true;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _loadQuests();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _loadQuests() async {
    // 首先更新任务进度
    final stats = await _statsService.getStats();
    await _questService.updateQuestProgress(
      storiesGenerated: stats.storiesGenerated,
      choicesMade: stats.choicesMade,
      locationsVisited: stats.locationsVisited.length,
      playTimeMinutes: stats.totalPlayTime.inMinutes,
    );

    // 然后加载任务
    final quests = await _questService.getDailyQuests();
    setState(() {
      _quests = quests;
      _isLoading = false;
    });
    
    _progressController.forward();
  }

  Future<void> _claimReward(DailyQuest quest) async {
    final success = await _questService.claimQuestReward(quest.id);
    if (success) {
      await _loadQuests();
      _showRewardDialog(quest);
    }
  }

  void _showRewardDialog(DailyQuest quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: const Row(
          children: [
            Icon(Icons.card_giftcard, color: AppColors.vintageGold),
            SizedBox(width: 8),
            Text(
              '任务完成！',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulations on completing: ${quest.title}',
              style: const TextStyle(color: AppColors.lavenderWhite),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rewards Received:',
              style: TextStyle(
                color: AppColors.vintageGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...quest.rewards.entries.map(
              (entry) => Text(
                '• ${entry.key}: ${entry.value}',
                style: const TextStyle(color: AppColors.statusOptimal),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Awesome!',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vintageGold),
        ),
      );
    }

    final completedQuests = _quests.where((q) => q.status == QuestStatus.completed).length;
    final totalQuests = _quests.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.lavenderWhite,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Daily Quests',
                            style: Theme.of(context).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Complete quests for rich rewards',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Progress Summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.vintageGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in,
                          color: AppColors.vintageGold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Progress',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$completedQuests/$totalQuests Quests Complete',
                              style: const TextStyle(
                                color: AppColors.vintageGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircularProgressIndicator(
                        value: totalQuests > 0 ? completedQuests / totalQuests : 0,
                        backgroundColor: AppColors.slateBlue,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.vintageGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quest List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _quests.length,
                  itemBuilder: (context, index) {
                    final quest = _quests[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildQuestCard(quest),
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

  Widget _buildQuestCard(DailyQuest quest) {
    final isCompleted = quest.status == QuestStatus.completed;
    final isClaimed = quest.status == QuestStatus.claimed;
    
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getQuestTypeColor(quest.type).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getQuestTypeIcon(quest.type),
                  color: _getQuestTypeColor(quest.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      quest.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (isClaimed)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.statusOptimal,
                  size: 24,
                )
              else if (isCompleted)
                GestureDetector(
                  onTap: () => _claimReward(quest),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.vintageGold,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Claim',
                      style: TextStyle(
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${quest.currentProgress}/${quest.targetValue}',
                    style: const TextStyle(
                      color: AppColors.lavenderWhite,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(quest.progressPercentage * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.vintageGold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: quest.progressPercentage * _progressController.value,
                    backgroundColor: AppColors.slateBlue,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getQuestTypeColor(quest.type),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Rewards
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.deepNavy.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rewards:',
                  style: TextStyle(
                    color: AppColors.vintageGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: quest.rewards.entries.map((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusOptimal.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.key} +${entry.value}',
                        style: const TextStyle(
                          color: AppColors.statusOptimal,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getQuestTypeColor(QuestType type) {
    switch (type) {
      case QuestType.generateStories:
        return AppColors.accentRose;
      case QuestType.makeChoices:
        return AppColors.vintageGold;
      case QuestType.visitLocations:
        return AppColors.statusOptimal;
      case QuestType.unlockAchievements:
        return AppColors.statusWarning;
      case QuestType.playTime:
        return AppColors.lavenderWhite;
    }
  }

  IconData _getQuestTypeIcon(QuestType type) {
    switch (type) {
      case QuestType.generateStories:
        return Icons.auto_stories;
      case QuestType.makeChoices:
        return Icons.psychology;
      case QuestType.visitLocations:
        return Icons.explore;
      case QuestType.unlockAchievements:
        return Icons.emoji_events;
      case QuestType.playTime:
        return Icons.access_time;
    }
  }
}