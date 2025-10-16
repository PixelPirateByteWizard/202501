import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/progress_bar.dart';
import '../models/achievement.dart';


class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {

  List<Achievement> _achievements = [];
  bool _isLoading = true;
  AchievementType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _achievements = _getDefaultAchievements();
      _isLoading = false;
    });
  }

  List<Achievement> _getDefaultAchievements() {
    return [
      // Exploration Achievements
      Achievement(
        id: 'first_expedition',
        name: 'First Steps',
        description: 'Complete your first expedition',
        icon: '🚶',
        type: AchievementType.exploration,
        rarity: AchievementRarity.common,
        maxProgress: 1,
        currentProgress: 1,
        isUnlocked: true,
        unlockedDate: DateTime.now().subtract(const Duration(days: 2)),
        rewards: {'energy': 50, 'experience': 100},
      ),
      Achievement(
        id: 'district_explorer',
        name: 'District Explorer',
        description: 'Explore all locations in Old Town District',
        icon: '🗺️',
        type: AchievementType.exploration,
        rarity: AchievementRarity.rare,
        maxProgress: 5,
        currentProgress: 3,
        rewards: {'stardust': 10, 'experience': 500},
      ),
      Achievement(
        id: 'master_explorer',
        name: 'Master Explorer',
        description: 'Discover all hidden locations in the city',
        icon: '🏆',
        type: AchievementType.exploration,
        rarity: AchievementRarity.legendary,
        maxProgress: 25,
        currentProgress: 8,
        rewards: {'legendary_gear': 1, 'experience': 2000},
        prerequisites: ['district_explorer'],
      ),

      // Crafting Achievements
      Achievement(
        id: 'apprentice_crafter',
        name: 'Apprentice Crafter',
        description: 'Craft your first 10 items',
        icon: '🔨',
        type: AchievementType.crafting,
        rarity: AchievementRarity.common,
        maxProgress: 10,
        currentProgress: 7,
        rewards: {'brass_ingot': 100, 'experience': 200},
      ),
      Achievement(
        id: 'master_craftsman',
        name: 'Master Craftsman',
        description: 'Craft 100 different items',
        icon: '⚒️',
        type: AchievementType.crafting,
        rarity: AchievementRarity.epic,
        maxProgress: 100,
        currentProgress: 23,
        rewards: {'master_tools': 1, 'experience': 1500},
        prerequisites: ['apprentice_crafter'],
      ),

      // Story Achievements
      Achievement(
        id: 'truth_seeker',
        name: 'Truth Seeker',
        description: 'Analyze 20 clues in the Truth Table',
        icon: '🔍',
        type: AchievementType.story,
        rarity: AchievementRarity.rare,
        maxProgress: 20,
        currentProgress: 12,
        rewards: {'insight_points': 50, 'experience': 800},
      ),
      Achievement(
        id: 'conspiracy_unraveled',
        name: 'Conspiracy Unraveled',
        description: 'Uncover the truth behind the Clockwork Guild',
        icon: '🕵️',
        type: AchievementType.story,
        rarity: AchievementRarity.legendary,
        maxProgress: 1,
        currentProgress: 0,
        rewards: {'story_unlock': 'final_chapter', 'experience': 5000},
        prerequisites: ['truth_seeker'],
      ),

      // Collection Achievements
      Achievement(
        id: 'resource_hoarder',
        name: 'Resource Hoarder',
        description: 'Collect 10,000 total resources',
        icon: '💰',
        type: AchievementType.collection,
        rarity: AchievementRarity.rare,
        maxProgress: 10000,
        currentProgress: 3247,
        rewards: {'storage_upgrade': 1, 'experience': 1000},
      ),
      Achievement(
        id: 'stardust_collector',
        name: 'Stardust Collector',
        description: 'Collect 100 Stardust',
        icon: '✨',
        type: AchievementType.collection,
        rarity: AchievementRarity.epic,
        maxProgress: 100,
        currentProgress: 12,
        rewards: {'cosmic_gear': 1, 'experience': 2000},
      ),

      // Efficiency Achievements
      Achievement(
        id: 'efficiency_expert',
        name: 'Efficiency Expert',
        description: 'Maintain 95% workshop efficiency for 24 hours',
        icon: '⚡',
        type: AchievementType.efficiency,
        rarity: AchievementRarity.epic,
        maxProgress: 24,
        currentProgress: 18,
        rewards: {'efficiency_boost': 1, 'experience': 1200},
      ),
      Achievement(
        id: 'automation_master',
        name: 'Automation Master',
        description: 'Build and upgrade 20 workstations',
        icon: '🤖',
        type: AchievementType.efficiency,
        rarity: AchievementRarity.rare,
        maxProgress: 20,
        currentProgress: 4,
        rewards: {'automation_core': 1, 'experience': 800},
      ),
    ];
  }

  List<Achievement> get filteredAchievements {
    if (_selectedFilter == null) return _achievements;
    return _achievements.where((a) => a.type == _selectedFilter).toList();
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return AppColors.lavenderWhite;
      case AchievementRarity.rare:
        return AppColors.vintageGold;
      case AchievementRarity.epic:
        return AppColors.accentRose;
      case AchievementRarity.legendary:
        return AppColors.statusOptimal;
    }
  }

  IconData _getTypeIcon(AchievementType type) {
    switch (type) {
      case AchievementType.exploration:
        return Icons.explore;
      case AchievementType.crafting:
        return Icons.build;
      case AchievementType.story:
        return Icons.book;
      case AchievementType.collection:
        return Icons.inventory;
      case AchievementType.efficiency:
        return Icons.speed;
    }
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Row(
          children: [
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                achievement.name,
                style: TextStyle(
                  color: _getRarityColor(achievement.rarity),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement.description,
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
              const SizedBox(height: 16),
              
              // Progress
              Text(
                'Progress: ${achievement.currentProgress}/${achievement.maxProgress}',
                style: const TextStyle(
                  color: AppColors.vintageGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomProgressBar(
                value: achievement.progressPercentage,
                color: _getRarityColor(achievement.rarity),
              ),
              const SizedBox(height: 16),

              // Rarity
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRarityColor(achievement.rarity).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getRarityColor(achievement.rarity)),
                ),
                child: Text(
                  achievement.rarity.name.toUpperCase(),
                  style: TextStyle(
                    color: _getRarityColor(achievement.rarity),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Rewards
              if (achievement.rewards.isNotEmpty) ...[
                const Text(
                  'Rewards:',
                  style: TextStyle(
                    color: AppColors.vintageGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...achievement.rewards.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text(
                      '• ${entry.key}: ${entry.value}',
                      style: const TextStyle(color: AppColors.statusOptimal),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Prerequisites
              if (achievement.prerequisites.isNotEmpty) ...[
                const Text(
                  'Prerequisites:',
                  style: TextStyle(
                    color: AppColors.accentRose,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...achievement.prerequisites.map(
                  (prereq) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text(
                      '• ${prereq.replaceAll('_', ' ').toUpperCase()}',
                      style: const TextStyle(color: AppColors.lavenderWhite),
                    ),
                  ),
                ),
              ],

              // Unlock date
              if (achievement.isUnlocked && achievement.unlockedDate != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Unlocked: ${_formatDate(achievement.unlockedDate!)}',
                  style: TextStyle(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    final totalCount = _achievements.length;

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
                            'Achievements',
                            style: Theme.of(context).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '$unlockedCount / $totalCount Unlocked',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.vintageGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Filter Chips
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedFilter == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = null;
                          });
                        },
                        backgroundColor: AppColors.deepNavy,
                        selectedColor: AppColors.vintageGold,
                        labelStyle: TextStyle(
                          color: _selectedFilter == null
                              ? AppColors.deepNavy
                              : AppColors.lavenderWhite,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...AchievementType.values.map((type) {
                        final isSelected = _selectedFilter == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getTypeIcon(type),
                                  size: 16,
                                  color: isSelected
                                      ? AppColors.deepNavy
                                      : AppColors.lavenderWhite,
                                ),
                                const SizedBox(width: 4),
                                Text(type.name),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = selected ? type : null;
                              });
                            },
                            backgroundColor: AppColors.deepNavy,
                            selectedColor: AppColors.vintageGold,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.deepNavy
                                  : AppColors.lavenderWhite,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Achievements List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredAchievements.length,
                  itemBuilder: (context, index) {
                    final achievement = filteredAchievements[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () => _showAchievementDetails(achievement),
                        child: Opacity(
                          opacity: achievement.isUnlocked ? 1.0 : 0.7,
                          child: Row(
                            children: [
                              // Icon and rarity indicator
                              Stack(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.deepNavy,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getRarityColor(achievement.rarity),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        achievement.icon,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  if (achievement.isUnlocked)
                                    Positioned(
                                      top: -2,
                                      right: -2,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: AppColors.statusOptimal,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: AppColors.deepNavy,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),

                              // Achievement info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            achievement.name,
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: achievement.isUnlocked
                                                  ? _getRarityColor(achievement.rarity)
                                                  : AppColors.lavenderWhite,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          _getTypeIcon(achievement.type),
                                          size: 16,
                                          color: AppColors.vintageGold.withValues(alpha: 0.7),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      achievement.description,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.lavenderWhite.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Progress bar
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomProgressBar(
                                            value: achievement.progressPercentage,
                                            color: _getRarityColor(achievement.rarity),
                                            height: 6,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${achievement.currentProgress}/${achievement.maxProgress}',
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
}