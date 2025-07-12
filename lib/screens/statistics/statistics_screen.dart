import 'package:astrelexis/models/journal_entry.dart';
import 'package:astrelexis/models/todo_item.dart';
import 'package:astrelexis/services/storage_service.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:astrelexis/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StorageService _storageService = StorageService();
  List<JournalEntry> _entries = [];
  List<TodoItem> _todos = [];
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

    try {
      final entries = await _storageService.loadJournalEntries();
      final todos = await _storageService.loadTodoItems();

      setState(() {
        _entries = entries;
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, int> _getActivityData() {
    final Map<String, int> activityData = {};
    final now = DateTime.now();

    // Initialize last 4 weeks with 0
    for (int i = 3; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final weekKey = 'Week ${4 - i}';
      activityData[weekKey] = 0;
    }

    // Count activities for each week
    for (var entry in _entries) {
      final weeksSinceEntry = now.difference(entry.createdAt).inDays ~/ 7;
      if (weeksSinceEntry < 4) {
        final weekKey = 'Week ${4 - weeksSinceEntry}';
        activityData[weekKey] = (activityData[weekKey] ?? 0) + 1;
      }
    }

    return activityData;
  }

  List<Map<String, dynamic>> _getHeatmapData() {
    final List<Map<String, dynamic>> heatmapData = [];
    final now = DateTime.now();

    // Generate data for last 20 weeks (140 days)
    for (int i = 139; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      // Count activities for this date
      final entriesCount = _entries
          .where((entry) =>
              DateFormat('yyyy-MM-dd').format(entry.createdAt) == dateKey)
          .length;

      final completedTodosCount = _todos
          .where((todo) =>
              todo.isCompleted &&
              DateFormat('yyyy-MM-dd').format(todo.dueDate) == dateKey)
          .length;

      final totalActivity = entriesCount + completedTodosCount;

      heatmapData.add({
        'date': date,
        'intensity':
            totalActivity > 0 ? (totalActivity / 5).clamp(0.0, 1.0) : 0.0,
      });
    }

    return heatmapData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.accentTeal),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                color: AppColors.accentTeal,
                backgroundColor: AppColors.primaryBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _buildMoodHeatmap(),
                      const SizedBox(height: 24),
                      _buildActivityLog(),
                      const SizedBox(height: 24),
                      _buildGoalProgress(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMoodHeatmap() {
    final heatmapData = _getHeatmapData();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Heatmap',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          // Month labels
          const Padding(
            padding: EdgeInsets.only(left: 32.0, bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text('Mar',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12))),
                Expanded(
                    child: Text('Apr',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12))),
                Expanded(
                    child: Text('May',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12))),
                Expanded(
                    child: Text('Jun',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12))),
              ],
            ),
          ),
          Row(
            children: [
              // Day labels
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('M',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    SizedBox(height: 16),
                    Text('W',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    SizedBox(height: 16),
                    Text('F',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              // Heatmap grid
             Expanded(
               child: LayoutBuilder(
                 builder: (context, constraints) {
                   final itemSize = (constraints.maxWidth - (19 * 4)) / 20;
                   return GridView.builder(
                     gridDelegate:
                         const SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 20,
                       crossAxisSpacing: 4,
                       mainAxisSpacing: 4,
                     ),
                     itemCount: 140,
                     shrinkWrap: true,
                     physics: const NeverScrollableScrollPhysics(),
                     itemBuilder: (context, index) {
                       final intensity =
                           heatmapData[index]['intensity'] as double;
                       return Container(
                         width: itemSize,
                         height: itemSize,
                         decoration: BoxDecoration(
                           color: intensity > 0
                               ? AppColors.accentTeal
                                   .withOpacity(0.2 + (intensity * 0.6))
                               : AppColors.textSecondary.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(2),
                         ),
                       );
                     },
                   );
                 },
               ),
             ),
            ],
          ),
          const SizedBox(height: 8),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Less',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(width: 4),
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: AppColors.accentTeal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 2),
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: AppColors.accentTeal.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 2),
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: AppColors.accentTeal.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              const Text('More',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog() {
    final activityData = _getActivityData();
    final maxValue =
        activityData.values.fold(0, (max, value) => value > max ? value : max);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Log',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 180, // Increased height to accommodate the text below
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: activityData.entries.map((entry) {
                final height =
                    maxValue > 0 ? (entry.value / maxValue) * 120 : 0.0;
                return Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      mainAxisSize:
                          MainAxisSize.min, // Use minimum space needed
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32,
                          height: height,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.accentTeal, Color(0xFF64A1FF)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress() {
    final totalEntries = _entries.length;
    final completedTodos = _todos.where((todo) => todo.isCompleted).length;
    final totalTodos = _todos.length;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goal Progress',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            'Journal Entries',
            totalEntries / 50, // Assuming goal of 50 entries
            [AppColors.accentTeal, Colors.blue.shade300],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            'Completed Tasks',
            totalTodos > 0 ? completedTodos / totalTodos : 0.0,
            [Colors.purple.shade400, Colors.pink.shade300],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            'Daily Consistency',
            _entries.isNotEmpty ? _calculateConsistency() : 0.0,
            [Colors.orange.shade400, Colors.amber.shade300],
          ),
        ],
      ),
    );
  }

  double _calculateConsistency() {
    if (_entries.isEmpty) return 0.0;

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final recentEntries = _entries
        .where((entry) => entry.createdAt.isAfter(thirtyDaysAgo))
        .toList();

    final uniqueDays = recentEntries
        .map((entry) => DateFormat('yyyy-MM-dd').format(entry.createdAt))
        .toSet()
        .length;

    return (uniqueDays / 30).clamp(0.0, 1.0);
  }

  Widget _buildProgressBar(
      String title, double value, List<Color> gradientColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(gradientColors.first),
          ),
        ),
      ],
    );
  }
}
