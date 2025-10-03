import 'package:flutter/material.dart';
import 'dart:math';
import '../../data/repositories/local_game_repository.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  final _repository = LocalGameRepository();
  bool _isLoading = true;
  int _bestScore = 0;
  int _maxTileValue = 0;
  int _totalGamesPlayed = 0;
  int _gamesWon = 0;
  Duration _totalPlayTime = const Duration();
  Duration _bestGameTime = const Duration(hours: 99);
  Map<int, int> _tileMergeCount = {};
  List<int> _recentScores = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _loadStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final bestScore = await _repository.loadBestScore();
    final stats = await _repository.loadStats();

    // If no real data is available, generate mock data for demonstration
    if (stats.totalGamesPlayed == 0) {
      _generateMockData();
    } else {
      setState(() {
        _bestScore = bestScore;
        _maxTileValue = stats.maxTileValue;
        _totalGamesPlayed = stats.totalGamesPlayed;
        _gamesWon = stats.gamesWon;
        _totalPlayTime = stats.totalPlayTime;
        _bestGameTime = stats.bestGameTime;
        _tileMergeCount = stats.tileMergeCount;
        _recentScores = stats.recentScores;
        _isLoading = false;
      });
    }

    // Start animations after data is loaded
    _animationController.forward();
  }

  void _generateMockData() {
    // Generate realistic mock data for demonstration
    final random = Random();

    // Generate best score (between 500 and 2000)
    _bestScore = 500 + random.nextInt(1500);

    // Generate max tile value (common values: 24, 48, 96)
    final possibleTiles = [24, 24, 48, 48, 48, 96, 96, 192];
    _maxTileValue = possibleTiles[random.nextInt(possibleTiles.length)];

    // Generate games played (between 10 and 50)
    _totalGamesPlayed = 10 + random.nextInt(40);

    // Generate games won (less than games played)
    _gamesWon = random.nextInt(_totalGamesPlayed ~/ 2);

    // Generate total play time (between 1 and 10 hours)
    _totalPlayTime = Duration(minutes: 60 + random.nextInt(540));

    // Generate best game time (between 2 and 15 minutes)
    _bestGameTime = Duration(minutes: 2 + random.nextInt(13));

    // Generate tile merge counts
    _tileMergeCount = {};
    for (int i = 3; i <= _maxTileValue; i *= 2) {
      // Higher tiles have fewer merges
      final mergeCount = max(1, (200 / i).round() + random.nextInt(20));
      _tileMergeCount[i] = mergeCount;
    }

    // Add special case for 1+2=3 merges
    _tileMergeCount[3] = 30 + random.nextInt(50);

    // Generate recent scores (5-10 games)
    final gameCount = 5 + random.nextInt(6);
    _recentScores = List.generate(gameCount, (index) {
      // Generate a score with an upward trend
      return 100 + (index * 50) + random.nextInt(200);
    });

    setState(() {
      _isLoading = false;
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours >= 99) {
      return '--';
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  double _calculateAverageScore() {
    if (_recentScores.isEmpty) {
      return 0.0;
    }
    final sum = _recentScores.reduce((a, b) => a + b);
    return sum / _recentScores.length;
  }

  double _calculateWinRate() {
    if (_totalGamesPlayed == 0) {
      return 0.0;
    }
    return (_gamesWon / _totalGamesPlayed) * 100;
  }

  int _calculateTotalMerges() {
    if (_tileMergeCount.isEmpty) {
      return 0;
    }
    return _tileMergeCount.values.reduce((a, b) => a + b);
  }

  String _formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: UIConstants.BACKGROUND_COLOR,
        body: Center(
          child: CircularProgressIndicator(color: UIConstants.PURPLE_COLOR),
        ),
      );
    }

    // Sort tile merge counts by value
    final sortedTileMerges = _tileMergeCount.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Find the maximum merge count for scaling the bars
    final maxMergeCount = _tileMergeCount.values.isEmpty
        ? 1
        : _tileMergeCount.values.reduce((a, b) => a > b ? a : b);

    // Calculate additional statistics
    final averageScore = _calculateAverageScore();
    final winRate = _calculateWinRate();
    final totalMerges = _calculateTotalMerges();

    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(UIConstants.SPACING_SMALL),
                    borderRadius: BorderRadius.circular(
                      UIConstants.BORDER_RADIUS_XLARGE,
                    ),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      TextConstants.STATS,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance for the back button
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  UIConstants.SPACING_MEDIUM,
                  0,
                  UIConstants.SPACING_MEDIUM,
                  UIConstants.SPACING_LARGE,
                ),
                child: Column(
                  children: [
                    // Best score card with animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_animationController),
                        child: GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_LARGE,
                          ),
                          backgroundColor: const Color(0x40805AD5),
                          child: Column(
                            children: [
                              Text(
                                TextConstants.HIGHEST_SCORE,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: UIConstants.SPACING_SMALL),
                              TweenAnimationBuilder<int>(
                                duration: const Duration(seconds: 1),
                                tween: IntTween(begin: 0, end: _bestScore),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toString(),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Recent Performance Card
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  0.1,
                                  0.9,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Recent Performance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: UIConstants.SPACING_MEDIUM,
                              ),
                              _recentScores.isNotEmpty
                                  ? Container(
                                      height: 120,
                                      padding: const EdgeInsets.only(
                                        right: UIConstants.SPACING_SMALL,
                                        top: UIConstants.SPACING_SMALL,
                                      ),
                                      child: LineChart(
                                        LineChartData(
                                          gridData: FlGridData(show: false),
                                          titlesData: FlTitlesData(show: false),
                                          borderData: FlBorderData(show: false),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: _recentScores
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (entry) => FlSpot(
                                                      entry.key.toDouble(),
                                                      entry.value.toDouble(),
                                                    ),
                                                  )
                                                  .toList(),
                                              isCurved: true,
                                              color: UIConstants.PURPLE_COLOR,
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(
                                                show: true,
                                                getDotPainter:
                                                    (
                                                      spot,
                                                      percent,
                                                      barData,
                                                      index,
                                                    ) {
                                                      return FlDotCirclePainter(
                                                        radius: 4,
                                                        color: UIConstants
                                                            .CYAN_COLOR,
                                                        strokeWidth: 1,
                                                        strokeColor:
                                                            Colors.white,
                                                      );
                                                    },
                                              ),
                                              belowBarData: BarAreaData(
                                                show: true,
                                                color: UIConstants.PURPLE_COLOR
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                          ],
                                          minY: 0,
                                          lineTouchData: LineTouchData(
                                            enabled: true,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          UIConstants.SPACING_MEDIUM,
                                        ),
                                        child: Text(
                                          'No recent games data',
                                          style: TextStyle(
                                            color: UIConstants
                                                .TEXT_SECONDARY_COLOR,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Stats grid
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  0.2,
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Max tile value
                                Expanded(
                                  child: _buildStatCard(
                                    label: TextConstants.MAX_TILE,
                                    value: _maxTileValue.toString(),
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),

                                // Total games played
                                Expanded(
                                  child: _buildStatCard(
                                    label: TextConstants.TOTAL_GAMES,
                                    value: _totalGamesPlayed.toString(),
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),

                                // Total play time
                                Expanded(
                                  child: _buildStatCard(
                                    label: TextConstants.TOTAL_TIME,
                                    value: _formatDuration(_totalPlayTime),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: UIConstants.SPACING_MEDIUM),
                            Row(
                              children: [
                                // Win rate
                                Expanded(
                                  child: _buildStatCard(
                                    label: "Win Rate",
                                    value: _formatPercentage(winRate),
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),

                                // Average score
                                Expanded(
                                  child: _buildStatCard(
                                    label: "Avg Score",
                                    value: averageScore.toStringAsFixed(0),
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),

                                // Best game time
                                Expanded(
                                  child: _buildStatCard(
                                    label: "Best Time",
                                    value: _formatDuration(_bestGameTime),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Tile merge stats with animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  0.3,
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    TextConstants.TILE_MERGE_STATS,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Total: $totalMerges',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: UIConstants.TEXT_SECONDARY_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: UIConstants.SPACING_MEDIUM,
                              ),

                              // Display merge stats as bars
                              if (sortedTileMerges.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      UIConstants.SPACING_LARGE,
                                    ),
                                    child: Text(
                                      'No merge data yet',
                                      style: TextStyle(
                                        color: UIConstants.TEXT_SECONDARY_COLOR,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  children: sortedTileMerges.map((entry) {
                                    final tileValue = entry.key;
                                    final mergeCount = entry.value;
                                    final barWidth =
                                        mergeCount / maxMergeCount * 100;

                                    // Choose color based on tile value
                                    Color barColor;
                                    Color tileColor;
                                    if (tileValue == 1) {
                                      tileColor = UIConstants.TILE_ONE_COLOR;
                                      barColor = UIConstants.TILE_ONE_COLOR;
                                    } else if (tileValue == 2) {
                                      tileColor = UIConstants.TILE_TWO_COLOR;
                                      barColor = UIConstants.TILE_TWO_COLOR;
                                    } else if (tileValue <= 12) {
                                      tileColor =
                                          UIConstants.TILE_THREE_PLUS_COLOR;
                                      barColor = Colors.green;
                                    } else if (tileValue <= 48) {
                                      tileColor =
                                          UIConstants.TILE_THREE_PLUS_COLOR;
                                      barColor = UIConstants.CYAN_COLOR;
                                    } else if (tileValue <= 96) {
                                      tileColor =
                                          UIConstants.TILE_THREE_PLUS_COLOR;
                                      barColor = UIConstants.PURPLE_COLOR;
                                    } else {
                                      tileColor =
                                          UIConstants.TILE_THREE_PLUS_COLOR;
                                      barColor = Colors.red;
                                    }

                                    return TweenAnimationBuilder<double>(
                                      duration: Duration(
                                        milliseconds: 800 + (entry.key * 50),
                                      ),
                                      tween: Tween<double>(
                                        begin: 0,
                                        end: barWidth,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, animValue, child) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: UIConstants.SPACING_SMALL,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: tileColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        UIConstants
                                                            .BORDER_RADIUS_SMALL,
                                                      ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: tileColor
                                                          .withOpacity(0.3),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  tileValue.toString(),
                                                  style: TextStyle(
                                                    color: tileValue >= 3
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width:
                                                    UIConstants.SPACING_SMALL,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 16,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          UIConstants
                                                              .BORDER_RADIUS_SMALL,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            animValue.clamp(
                                                              0,
                                                              100,
                                                            ) *
                                                            0.01 *
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.5,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              barColor,
                                                              barColor
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                UIConstants
                                                                    .BORDER_RADIUS_SMALL,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: barColor
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                              blurRadius: 4,
                                                              spreadRadius: 0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width:
                                                    UIConstants.SPACING_SMALL,
                                              ),
                                              SizedBox(
                                                width: 40,
                                                child: TweenAnimationBuilder<int>(
                                                  duration: const Duration(
                                                    milliseconds: 1200,
                                                  ),
                                                  tween: IntTween(
                                                    begin: 0,
                                                    end: mergeCount,
                                                  ),
                                                  builder: (context, value, child) {
                                                    return Text(
                                                      value.toString(),
                                                      style: const TextStyle(
                                                        color: UIConstants
                                                            .TEXT_SECONDARY_COLOR,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Achievements section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  0.4,
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Achievements",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: UIConstants.SPACING_MEDIUM,
                              ),
                              _buildAchievementItem(
                                title: "Fusion Master",
                                description: "Merge tiles 100 times",
                                progress: min(totalMerges / 100, 1.0),
                                isComplete: totalMerges >= 100,
                              ),
                              _buildAchievementItem(
                                title: "High Scorer",
                                description: "Reach a score of 1000",
                                progress: min(_bestScore / 1000, 1.0),
                                isComplete: _bestScore >= 1000,
                              ),
                              _buildAchievementItem(
                                title: "Dedicated Player",
                                description: "Play 10 games",
                                progress: min(_totalGamesPlayed / 10, 1.0),
                                isComplete: _totalGamesPlayed >= 10,
                              ),
                              _buildAchievementItem(
                                title: "Tile Collector",
                                description:
                                    "Create a tile with value 48 or higher",
                                progress: min(_maxTileValue / 48, 1.0),
                                isComplete: _maxTileValue >= 48,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem({
    required String title,
    required String description,
    required double progress,
    required bool isComplete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.SPACING_MEDIUM),
      child: Row(
        children: [
          // Achievement icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isComplete ? UIConstants.PURPLE_COLOR : Colors.grey[800],
              shape: BoxShape.circle,
              boxShadow: isComplete
                  ? [
                      BoxShadow(
                        color: UIConstants.PURPLE_COLOR.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isComplete ? Icons.emoji_events : Icons.lock_outline,
              color: isComplete ? Colors.white : Colors.grey[400],
              size: 20,
            ),
          ),
          const SizedBox(width: UIConstants.SPACING_SMALL),
          // Achievement details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isComplete ? Colors.white : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isComplete
                        ? UIConstants.TEXT_SECONDARY_COLOR
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                // Progress bar
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween<double>(begin: 0.0, end: progress),
                  curve: Curves.easeOutCubic,
                  builder: (context, animValue, child) {
                    return Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 6,
                            width:
                                MediaQuery.of(context).size.width *
                                0.6 *
                                animValue,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  UIConstants.CYAN_COLOR,
                                  UIConstants.PURPLE_COLOR,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: isComplete
                                  ? [
                                      BoxShadow(
                                        color: UIConstants.CYAN_COLOR
                                            .withOpacity(0.3),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    Color? highlightColor,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
      backgroundColor: highlightColor,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: UIConstants.TEXT_SECONDARY_COLOR,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween<double>(begin: 0.5, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
