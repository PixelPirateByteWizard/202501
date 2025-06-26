import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/achievement_service.dart';
import '../models/game_stats_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final AchievementService _achievementService = AchievementService();
  late GameStats _stats;

  @override
  void initState() {
    super.initState();
    _stats = _achievementService.gameStats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Statistics',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                _buildOverviewSection(),
                const SizedBox(height: 24),

                // Detailed Stats
                _buildDetailedStatsSection(),
                const SizedBox(height: 24),

                // Recent Scores
                _buildRecentScoresSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events,
                title: 'Highest Score',
                value: _stats.highestScore.toString(),
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.flag,
                title: 'Levels Completed',
                value: _stats.totalLevelsCompleted.toString(),
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.games,
                title: 'Games Played',
                value: _stats.totalGamesPlayed.toString(),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_up,
                title: 'Average Score',
                value: _stats.averageScore.toInt().toString(),
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Statistics',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                'Total Score',
                _stats.totalScore.toString(),
                Icons.score,
              ),
              const Divider(color: AppColors.secondaryText, height: 32),
              _buildDetailRow(
                'Total Syntheses',
                _stats.totalSyntheses.toString(),
                Icons.science,
              ),
              const Divider(color: AppColors.secondaryText, height: 32),
              _buildDetailRow(
                'Total Matches',
                _stats.totalMatches.toString(),
                Icons.celebration,
              ),
              const Divider(color: AppColors.secondaryText, height: 32),
              _buildDetailRow(
                'Total Moves',
                _stats.totalMoves.toString(),
                Icons.touch_app,
              ),
              const Divider(color: AppColors.secondaryText, height: 32),
              _buildDetailRow(
                'Avg Moves/Level',
                _stats.averageMovesPerLevel.toStringAsFixed(1),
                Icons.speed,
              ),
              if (_stats.lastPlayedDate != null) ...[
                const Divider(color: AppColors.secondaryText, height: 32),
                _buildDetailRow(
                  'Last Played',
                  _formatDate(_stats.lastPlayedDate!),
                  Icons.schedule,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScoresSection() {
    final recentScores = _stats.levelScores.take(10).toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    if (recentScores.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Scores',
            style: SafeFonts.imFellEnglishSc(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.sports_esports,
                    size: 48,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No games played yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start playing to see your scores here!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Scores',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: recentScores.asMap().entries.map((entry) {
              final index = entry.key;
              final score = entry.value;
              final isLast = index == recentScores.length - 1;

              return Column(
                children: [
                  _buildScoreRow(score),
                  if (!isLast)
                    const Divider(
                      color: AppColors.secondaryText,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(LevelScore score) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'L${score.levelNumber}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score: ${score.score}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  'Moves: ${score.movesUsed} (${score.movesLeft} left)',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(score.completedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getEfficiencyColor(score.efficiency).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(score.efficiency * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getEfficiencyColor(score.efficiency),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 0.7) return Colors.green;
    if (efficiency >= 0.4) return Colors.orange;
    return Colors.red;
  }
}
