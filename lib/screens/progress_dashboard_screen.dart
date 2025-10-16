import 'package:flutter/material.dart';
import '../services/game_stats_service.dart';
import '../services/achievement_service.dart';
import '../models/achievement.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProgressDashboardScreen extends StatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  State<ProgressDashboardScreen> createState() => _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen>
    with TickerProviderStateMixin {
  final GameStatsService _statsService = GameStatsService();
  final AchievementService _achievementService = AchievementService();
  
  GameStats? _stats;
  List<Achievement> _achievements = [];
  bool _isLoading = true;
  late AnimationController _progressController;
  late AnimationController _achievementController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _achievementController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _achievementController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final stats = await _statsService.getStats();
    final achievements = await _achievementService.getAchievements();
    
    setState(() {
      _stats = stats;
      _achievements = achievements;
      _isLoading = false;
    });
    
    _progressController.forward();
    _achievementController.forward();
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

    final unlockedAchievements = _achievements.where((a) => a.isUnlocked).length;
    final totalPoints = _achievements
        .where((a) => a.isUnlocked)
        .fold<int>(0, (sum, a) => sum + (a.rewards['points'] as int? ?? 0));

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
                      child: Text(
                        'Game Progress',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Overall Progress
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  color: AppColors.vintageGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Overall Progress',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Stories Generated',
                                    '${_stats!.storiesGenerated}',
                                    Icons.auto_stories,
                                    AppColors.accentRose,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    'Choices Made',
                                    '${_stats!.choicesMade}',
                                    Icons.psychology,
                                    AppColors.statusOptimal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Play Time',
                                    _stats!.formattedPlayTime,
                                    Icons.access_time,
                                    AppColors.vintageGold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    'Locations Explored',
                                    '${_stats!.locationsVisited.length}',
                                    Icons.explore,
                                    AppColors.statusWarning,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Achievement Summary
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: AppColors.vintageGold,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Achievement Overview',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '$unlockedAchievements/${_achievements.length}',
                                        style: const TextStyle(
                                          color: AppColors.vintageGold,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Unlocked Achievements',
                                        style: TextStyle(
                                          color: AppColors.lavenderWhite,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '$totalPoints',
                                        style: const TextStyle(
                                          color: AppColors.accentRose,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Achievement Points',
                                        style: TextStyle(
                                          color: AppColors.lavenderWhite,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                final progress = (unlockedAchievements / _achievements.length) * _progressController.value;
                                return Column(
                                  children: [
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: AppColors.slateBlue,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.vintageGold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${(progress * 100).toInt()}% Complete',
                                      style: const TextStyle(
                                        color: AppColors.lavenderWhite,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Recent Achievements
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.new_releases,
                                  color: AppColors.accentRose,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Recent Achievements',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._achievements
                                .where((a) => a.isUnlocked)
                                .take(3)
                                .map((achievement) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _buildAchievementItem(achievement),
                                    )),
                            if (_achievements.where((a) => a.isUnlocked).isEmpty)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.deepNavy.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppColors.statusWarning,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Continue playing to unlock your first achievement!',
                                      style: TextStyle(
                                        color: AppColors.lavenderWhite,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Play Statistics
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.analytics,
                                  color: AppColors.statusOptimal,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Game Statistics',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow('First Played', _formatDate(_stats!.firstPlayed)),
                            _buildStatRow('Last Played', _formatDate(_stats!.lastPlayed)),
                            _buildStatRow('Game Sessions', '${_stats!.sessionsPlayed} times'),
                            _buildStatRow('Average Session', '${_stats!.averageSessionTime.toInt()} min'),
                          ],
                        ),
                      ),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.lavenderWhite,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.deepNavy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getRarityColor(achievement.rarity).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRarityColor(achievement.rarity).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(achievement.icon),
              color: _getRarityColor(achievement.rarity),
              size: 20,
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
                    color: _getRarityColor(achievement.rarity),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    color: AppColors.lavenderWhite,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${achievement.rewards['points'] ?? 0}',
            style: const TextStyle(
              color: AppColors.vintageGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.lavenderWhite,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.vintageGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return AppColors.lavenderWhite;
      case AchievementRarity.rare:
        return AppColors.statusOptimal;
      case AchievementRarity.epic:
        return AppColors.accentRose;
      case AchievementRarity.legendary:
        return AppColors.vintageGold;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'auto_stories':
        return Icons.auto_stories;
      case 'explore':
        return Icons.explore;
      case 'psychology':
        return Icons.psychology;
      case 'psychology_alt':
        return Icons.psychology_alt;
      case 'public':
        return Icons.public;
      case 'map':
        return Icons.map;
      case 'adventure':
        return Icons.explore;
      default:
        return Icons.emoji_events;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}