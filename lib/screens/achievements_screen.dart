import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/achievement_service.dart';
import '../models/achievement_model.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  late TabController _tabController;

  final List<AchievementType> _categories = [
    AchievementType.synthesis,
    AchievementType.matching,
    AchievementType.level,
    AchievementType.score,
    AchievementType.efficiency,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Achievements',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Overview Section
          Container(
            padding: const EdgeInsets.all(16),
            child: _buildProgressOverview(),
          ),

          // Category Tabs
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.accent.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.accent,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.secondaryText,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: _categories.map((category) {
                return Tab(
                  text: _getCategoryName(category),
                  icon: Icon(_getCategoryIcon(category), size: 18),
                );
              }).toList(),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildCategoryView(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview() {
    final totalAchievements = _achievementService.achievements.length;
    final unlockedAchievements =
        _achievementService.achievements.where((a) => a.isUnlocked).length;
    final totalPoints = _achievementService.getTotalPoints();
    final completionPercentage = _achievementService.getCompletionPercentage();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress Circle
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: completionPercentage,
                  strokeWidth: 5,
                  backgroundColor: AppColors.secondaryText.withOpacity(0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
                Center(
                  child: Text(
                    '${(completionPercentage * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Progress Overview',
                  style: SafeFonts.imFellEnglishSc(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$unlockedAchievements of $totalAchievements unlocked',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
                Text(
                  '$totalPoints points earned',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryView(AchievementType category) {
    final achievements = _achievementService.getAchievementsByType(category);

    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 64,
              color: AppColors.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No achievements in this category',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAchievementCard(achievements[index]),
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppColors.accent.withOpacity(0.5)
              : AppColors.accent.withOpacity(0.2),
          width: achievement.isUnlocked ? 2 : 1,
        ),
        boxShadow: achievement.isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        children: [
          // Achievement Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: achievement.isUnlocked
                  ? AppColors.accent.withOpacity(0.2)
                  : AppColors.secondaryText.withOpacity(0.1),
              border: Border.all(
                color: achievement.isUnlocked
                    ? AppColors.accent
                    : AppColors.secondaryText.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              _getIconFromName(achievement.iconName),
              size: 24,
              color: achievement.isUnlocked
                  ? AppColors.accent
                  : AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: 16),

          // Achievement Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: achievement.isUnlocked
                              ? AppColors.primaryText
                              : AppColors.secondaryText,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${achievement.points} pts',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.secondaryText.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Progress Bar or Completion Status
                if (!achievement.isUnlocked) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: achievement.progressPercentage,
                            backgroundColor:
                                AppColors.secondaryText.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.accent),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${achievement.currentProgress}/${achievement.targetValue}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Completed!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(AchievementType type) {
    switch (type) {
      case AchievementType.synthesis:
        return 'Synthesis';
      case AchievementType.matching:
        return 'Matching';
      case AchievementType.level:
        return 'Levels';
      case AchievementType.score:
        return 'Scores';
      case AchievementType.efficiency:
        return 'Efficiency';
      case AchievementType.streak:
        return 'Streaks';
    }
  }

  IconData _getCategoryIcon(AchievementType type) {
    switch (type) {
      case AchievementType.synthesis:
        return Icons.science;
      case AchievementType.matching:
        return Icons.celebration;
      case AchievementType.level:
        return Icons.flag;
      case AchievementType.score:
        return Icons.trending_up;
      case AchievementType.efficiency:
        return Icons.speed;
      case AchievementType.streak:
        return Icons.whatshot;
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'stars':
        return Icons.stars;
      case 'celebration':
        return Icons.celebration;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'flag':
        return Icons.flag;
      case 'military_tech':
        return Icons.military_tech;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'trending_up':
        return Icons.trending_up;
      case 'show_chart':
        return Icons.show_chart;
      case 'speed':
        return Icons.speed;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.emoji_events;
    }
  }
}
