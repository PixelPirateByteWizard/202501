import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/progress_bar.dart';
import '../services/game_data_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> with TickerProviderStateMixin {
  final GameDataService _gameDataService = GameDataService();
  late TabController _tabController;
  Map<String, dynamic> _gameProgress = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadGameProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGameProgress() async {
    final progress = await _gameDataService.getGameProgress();
    setState(() {
      _gameProgress = progress;
      _isLoading = false;
    });
  }

  List<DailyTask> _getDailyTasks() {
    return [
      DailyTask(
        id: 'daily_craft',
        name: 'Daily Crafting',
        description: 'Craft 3 items',
        icon: '🔨',
        currentProgress: 2,
        maxProgress: 3,
        rewards: {'experience': 100, 'brass_ingot': 50},
        isCompleted: false,
      ),
      DailyTask(
        id: 'daily_expedition',
        name: 'Daily Exploration',
        description: 'Complete 1 expedition',
        icon: '🗺️',
        currentProgress: 1,
        maxProgress: 1,
        rewards: {'experience': 150, 'stardust': 2},
        isCompleted: true,
      ),
      DailyTask(
        id: 'daily_efficiency',
        name: 'Efficiency Check',
        description: 'Maintain 80% efficiency for 2 hours',
        icon: '⚡',
        currentProgress: 1,
        maxProgress: 2,
        rewards: {'experience': 75, 'energy': 100},
        isCompleted: false,
      ),
      DailyTask(
        id: 'daily_resources',
        name: 'Resource Collection',
        description: 'Collect 500 total resources',
        icon: '💰',
        currentProgress: 347,
        maxProgress: 500,
        rewards: {'experience': 80, 'gears': 10},
        isCompleted: false,
      ),
    ];
  }

  Widget _buildDailyTab() {
    final tasks = _getDailyTasks();
    final completedTasks = tasks.where((t) => t.isCompleted).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Progress Summary
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.today,
                      color: AppColors.vintageGold,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Daily Progress',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.vintageGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.vintageGold),
                      ),
                      child: Text(
                        '$completedTasks/${tasks.length}',
                        style: const TextStyle(
                          color: AppColors.vintageGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomProgressBar(
                  value: completedTasks / tasks.length,
                  color: AppColors.vintageGold,
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete all daily tasks for bonus rewards!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Daily Tasks
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              child: Opacity(
                opacity: task.isCompleted ? 0.7 : 1.0,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? AppColors.statusOptimal.withValues(alpha: 0.2)
                            : AppColors.deepNavy,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: task.isCompleted
                              ? AppColors.statusOptimal
                              : AppColors.vintageGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              task.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          if (task.isCompleted)
                            const Positioned(
                              top: 2,
                              right: 2,
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.statusOptimal,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Text(
                            task.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: CustomProgressBar(
                                  value: task.currentProgress / task.maxProgress,
                                  color: task.isCompleted
                                      ? AppColors.statusOptimal
                                      : AppColors.vintageGold,
                                  height: 6,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${task.currentProgress}/${task.maxProgress}',
                                style: TextStyle(
                                  color: AppColors.vintageGold.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    final weeklyGoals = _gameProgress['weeklyGoals'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_view_week,
                      color: AppColors.accentRose,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Weekly Goals',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Complete weekly goals for enhanced rewards and experience bonuses.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ...weeklyGoals.entries.map((entry) {
            final goalData = entry.value as Map<String, dynamic>;
            final current = goalData['current'] as int;
            final target = goalData['target'] as int;
            final progress = current / target;
            final isCompleted = current >= target;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key.replaceAll('_', ' ').toUpperCase(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? AppColors.statusOptimal
                                  : AppColors.lavenderWhite,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.statusOptimal,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomProgressBar(
                      value: progress.clamp(0.0, 1.0),
                      color: isCompleted ? AppColors.statusOptimal : AppColors.accentRose,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$current / $target',
                          style: const TextStyle(
                            color: AppColors.vintageGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(progress * 100).clamp(0, 100).toInt()}%',
                          style: TextStyle(
                            color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab() {
    final monthlyGoals = _gameProgress['monthlyGoals'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: AppColors.statusOptimal,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Monthly Challenges',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Long-term goals that provide significant rewards and unlock new content.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ...monthlyGoals.entries.map((entry) {
            final goalData = entry.value as Map<String, dynamic>;
            final current = goalData['current'] as int;
            final target = goalData['target'] as int;
            final progress = current / target;
            final isCompleted = current >= target;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key.replaceAll('_', ' ').toUpperCase(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? AppColors.statusOptimal
                                  : AppColors.lavenderWhite,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.statusOptimal,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomProgressBar(
                      value: progress.clamp(0.0, 1.0),
                      color: isCompleted ? AppColors.statusOptimal : AppColors.statusOptimal,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$current / $target',
                          style: const TextStyle(
                            color: AppColors.vintageGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(progress * 100).clamp(0, 100).toInt()}%',
                          style: TextStyle(
                            color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSeasonalTab() {
    final seasonalEvents = _gameProgress['seasonalEvents'] as Map<String, dynamic>? ?? {};
    final eventProgress = (seasonalEvents['event_progress'] as double? ?? 0.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: AppColors.accentRose,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Seasonal Events',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentRose.withValues(alpha: 0.2),
                        AppColors.vintageGold.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentRose),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clockwork Festival',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.accentRose,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A celebration of mechanical marvels! Complete special tasks to earn exclusive rewards.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Event Progress',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomProgressBar(
                        value: eventProgress,
                        color: AppColors.accentRose,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(eventProgress * 100).toInt()}% Complete',
                        style: const TextStyle(
                          color: AppColors.vintageGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Event Tasks
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Festival Tasks',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildEventTask(
                  'Craft Festival Decorations',
                  'Create 5 special decorative gears',
                  '🎨',
                  3,
                  5,
                  {'festival_tokens': 50, 'experience': 200},
                ),
                const SizedBox(height: 12),
                _buildEventTask(
                  'Explore Festival Grounds',
                  'Visit all festival locations',
                  '🎪',
                  2,
                  4,
                  {'festival_tokens': 75, 'rare_blueprint': 1},
                ),
                const SizedBox(height: 12),
                _buildEventTask(
                  'Festival Grand Prize',
                  'Complete all festival activities',
                  '🏆',
                  0,
                  1,
                  {'legendary_automaton': 1, 'festival_tokens': 200},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTask(
    String name,
    String description,
    String icon,
    int current,
    int max,
    Map<String, dynamic> rewards,
  ) {
    final isCompleted = current >= max;
    final progress = current / max;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.deepNavy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? AppColors.statusOptimal
              : AppColors.accentRose.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? AppColors.statusOptimal : AppColors.lavenderWhite,
                  ),
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.statusOptimal,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          CustomProgressBar(
            value: progress.clamp(0.0, 1.0),
            color: isCompleted ? AppColors.statusOptimal : AppColors.accentRose,
            height: 6,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$current / $max',
                style: const TextStyle(
                  color: AppColors.vintageGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rewards: ${rewards.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
                style: TextStyle(
                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ],
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
                        'Goals & Events',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.deepNavy.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Daily'),
                    Tab(text: 'Weekly'),
                    Tab(text: 'Monthly'),
                    Tab(text: 'Events'),
                  ],
                  labelColor: AppColors.vintageGold,
                  unselectedLabelColor: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  indicator: BoxDecoration(
                    color: AppColors.vintageGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDailyTab(),
                    _buildWeeklyTab(),
                    _buildMonthlyTab(),
                    _buildSeasonalTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyTask {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int currentProgress;
  final int maxProgress;
  final Map<String, dynamic> rewards;
  final bool isCompleted;

  const DailyTask({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.currentProgress,
    required this.maxProgress,
    required this.rewards,
    required this.isCompleted,
  });
}