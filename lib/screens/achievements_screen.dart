import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/achievement.dart';
import 'achievement_details_screen.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with TickerProviderStateMixin {
  List<Achievement> _achievements = [];
  AchievementStatistics? _statistics;
  AchievementType? _selectedType;
  bool _showOnlyUnlocked = false;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AchievementType.values.length + 1, vsync: this);
    _loadAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);
    
    try {
      // 创建硬编码的成就列表
      final achievements = _getHardcodedAchievements();
      
      // 计算统计信息
      final statistics = _calculateStatistics(achievements);
      
      setState(() {
        _achievements = achievements;
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // 显示错误信息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载成就失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Achievement> _getFilteredAchievements() {
    var filtered = _achievements.where((achievement) {
      if (_selectedType != null && achievement.type != _selectedType) {
        return false;
      }
      if (_showOnlyUnlocked && !achievement.isUnlocked) {
        return false;
      }
      return true;
    }).toList();

    // 排序：已解锁的在前，然后按稀有度排序
    filtered.sort((a, b) {
      if (a.isUnlocked != b.isUnlocked) {
        return a.isUnlocked ? -1 : 1;
      }
      return b.rarity.index.compareTo(a.rarity.index);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/BG_8.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                if (_statistics != null) _buildStatisticsCard(),
                _buildFilterTabs(),
                _buildFilterOptions(),
                Expanded(
                  child: _isLoading ? _buildLoadingWidget() : _buildAchievementsList(),
                ),
              ],
            ),
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
            '成就',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _loadAchievements,
            icon: const Icon(Icons.refresh, color: AppTheme.primaryGold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '完成度',
                  '${_statistics!.completionPercentage.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  AppTheme.primaryGold,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '总积分',
                  '${_statistics!.totalPoints}',
                  Icons.star,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '已解锁',
                  '${_statistics!.unlockedAchievements}',
                  Icons.lock_open,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '总数量',
                  '${_statistics!.totalAchievements}',
                  Icons.emoji_events,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              _selectedType = null;
            } else {
              _selectedType = AchievementType.values[index - 1];
            }
          });
        },
        indicator: BoxDecoration(
          color: AppTheme.primaryGold,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.backgroundDark,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: [
          const Tab(text: '全部'),
          ...AchievementType.values.map((type) {
            return Tab(text: _getTypeDisplayName(type));
          }),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            '筛选选项：',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(width: 12),
          FilterChip(
            label: const Text('仅显示已解锁'),
            selected: _showOnlyUnlocked,
            onSelected: (selected) {
              setState(() {
                _showOnlyUnlocked = selected;
              });
            },
            selectedColor: AppTheme.primaryGold.withValues(alpha: 0.3),
            checkmarkColor: AppTheme.primaryGold,
            labelStyle: TextStyle(
              color: _showOnlyUnlocked ? AppTheme.primaryGold : AppTheme.textSecondary,
            ),
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
    final filteredAchievements = _getFilteredAchievements();
    
    if (filteredAchievements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              '暂无符合条件的成就',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredAchievements.length,
      itemBuilder: (context, index) {
        final achievement = filteredAchievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AchievementDetailsScreen(achievement: achievement),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackgroundDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: achievement.isUnlocked 
              ? achievement.getRarityColor().withValues(alpha: 0.8)
              : AppTheme.textSecondary.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: achievement.isUnlocked ? [
            BoxShadow(
              color: achievement.getRarityColor().withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 成就图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked 
                    ? achievement.getRarityColor().withValues(alpha: 0.2)
                    : AppTheme.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: achievement.isUnlocked 
                      ? achievement.getRarityColor()
                      : AppTheme.textSecondary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    achievement.icon,
                    style: TextStyle(
                      fontSize: 24,
                      color: achievement.isUnlocked ? null : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // 成就信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            achievement.name,
                            style: TextStyle(
                              color: achievement.isUnlocked ? AppTheme.textLight : AppTheme.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: achievement.getRarityColor(),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            achievement.getRarityName(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        color: achievement.isUnlocked ? AppTheme.textSecondary : AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // 进度条
                    if (!achievement.isUnlocked) ...[
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: achievement.progressPercentage,
                              backgroundColor: AppTheme.textSecondary.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                achievement.getRarityColor(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${achievement.currentValue}/${achievement.targetValue}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: achievement.getRarityColor(),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '已完成',
                            style: TextStyle(
                              color: achievement.getRarityColor(),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (achievement.unlockedAt != null) ...[
                            const Spacer(),
                            Text(
                              _formatDate(achievement.unlockedAt!),
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeDisplayName(AchievementType type) {
    switch (type) {
      case AchievementType.battle:
        return '战斗';
      case AchievementType.collection:
        return '收集';
      case AchievementType.progress:
        return '进度';
      case AchievementType.social:
        return '社交';
      case AchievementType.special:
        return '特殊';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}';
  }

  // 硬编码的成就列表
  List<Achievement> _getHardcodedAchievements() {
    return [
      // 进度成就
      Achievement(
        id: 'reach_level_5',
        name: '初出茅庐',
        description: '达到5级',
        icon: '🌱',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 5,
        currentValue: 1, // 模拟当前进度
        rewards: {'gold': 100, 'experience': 50},
      ),
      Achievement(
        id: 'reach_level_10',
        name: '小有名气',
        description: '达到10级',
        icon: '⭐',
        type: AchievementType.progress,
        rarity: AchievementRarity.rare,
        targetValue: 10,
        currentValue: 1,
        rewards: {'gold': 300, 'experience': 150},
        prerequisites: ['reach_level_5'],
      ),
      Achievement(
        id: 'reach_level_20',
        name: '声名远扬',
        description: '达到20级',
        icon: '🌟',
        type: AchievementType.progress,
        rarity: AchievementRarity.epic,
        targetValue: 20,
        currentValue: 1,
        rewards: {'gold': 1000, 'experience': 500},
        prerequisites: ['reach_level_10'],
      ),
      
      // 章节成就
      Achievement(
        id: 'complete_chapter_1',
        name: '桃园三结义',
        description: '完成第一章',
        icon: '🍑',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 1,
        currentValue: 1,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
        rewards: {'gold': 200, 'experience': 100},
      ),
      Achievement(
        id: 'complete_chapter_3',
        name: '三分天下',
        description: '完成第三章',
        icon: '⚔️',
        type: AchievementType.progress,
        rarity: AchievementRarity.epic,
        targetValue: 1,
        currentValue: 0,
        rewards: {'gold': 1500, 'experience': 800},
      ),
      
      // 关卡成就
      Achievement(
        id: 'complete_10_stages',
        name: '征战四方',
        description: '完成10个关卡',
        icon: '🏰',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 10,
        currentValue: 3,
        rewards: {'gold': 500, 'experience': 200},
      ),
      Achievement(
        id: 'complete_50_stages',
        name: '百战不殆',
        description: '完成50个关卡',
        icon: '🏆',
        type: AchievementType.progress,
        rarity: AchievementRarity.epic,
        targetValue: 50,
        currentValue: 3,
        rewards: {'gold': 2000, 'experience': 1000},
      ),
      
      // 收集成就
      Achievement(
        id: 'collect_5_generals',
        name: '招贤纳士',
        description: '收集5名武将',
        icon: '👥',
        type: AchievementType.collection,
        rarity: AchievementRarity.common,
        targetValue: 5,
        currentValue: 3,
        rewards: {'gold': 300, 'experience': 100},
      ),
      Achievement(
        id: 'collect_10_generals',
        name: '人才济济',
        description: '收集10名武将',
        icon: '👑',
        type: AchievementType.collection,
        rarity: AchievementRarity.rare,
        targetValue: 10,
        currentValue: 3,
        rewards: {'gold': 800, 'experience': 300},
      ),
      Achievement(
        id: 'collect_all_shu_generals',
        name: '蜀汉五虎',
        description: '收集所有蜀国武将',
        icon: '🐅',
        type: AchievementType.collection,
        rarity: AchievementRarity.legendary,
        targetValue: 5,
        currentValue: 3,
        rewards: {'gold': 3000, 'experience': 1500},
      ),
      
      // 物品收集
      Achievement(
        id: 'collect_100_items',
        name: '收藏家',
        description: '收集100件物品',
        icon: '📦',
        type: AchievementType.collection,
        rarity: AchievementRarity.rare,
        targetValue: 100,
        currentValue: 25,
        rewards: {'gold': 1000, 'experience': 400},
      ),
      Achievement(
        id: 'collect_legendary_weapon',
        name: '神兵利器',
        description: '获得传说级武器',
        icon: '⚡',
        type: AchievementType.collection,
        rarity: AchievementRarity.legendary,
        targetValue: 1,
        currentValue: 0,
        rewards: {'gold': 2000, 'experience': 800},
      ),
      
      // 战斗成就
      Achievement(
        id: 'win_first_battle',
        name: '初战告捷',
        description: '赢得第一场战斗',
        icon: '🎯',
        type: AchievementType.battle,
        rarity: AchievementRarity.common,
        targetValue: 1,
        currentValue: 1,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
        rewards: {'gold': 50, 'experience': 25},
      ),
      Achievement(
        id: 'win_10_battles',
        name: '连战连胜',
        description: '赢得10场战斗',
        icon: '🔥',
        type: AchievementType.battle,
        rarity: AchievementRarity.common,
        targetValue: 10,
        currentValue: 3,
        rewards: {'gold': 400, 'experience': 150},
      ),
      Achievement(
        id: 'win_100_battles',
        name: '百战百胜',
        description: '赢得100场战斗',
        icon: '💎',
        type: AchievementType.battle,
        rarity: AchievementRarity.epic,
        targetValue: 100,
        currentValue: 3,
        rewards: {'gold': 2500, 'experience': 1200},
      ),
      
      // 财富成就
      Achievement(
        id: 'earn_1000_gold',
        name: '小富即安',
        description: '拥有1000金币',
        icon: '💰',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 1,
        currentValue: 1,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(hours: 12)),
        rewards: {'experience': 100},
      ),
      Achievement(
        id: 'earn_10000_gold',
        name: '富甲一方',
        description: '拥有10000金币',
        icon: '💎',
        type: AchievementType.progress,
        rarity: AchievementRarity.rare,
        targetValue: 1,
        currentValue: 0,
        rewards: {'experience': 500},
      ),
      Achievement(
        id: 'spend_5000_gold',
        name: '挥金如土',
        description: '累计消费5000金币',
        icon: '💸',
        type: AchievementType.special,
        rarity: AchievementRarity.rare,
        targetValue: 5000,
        currentValue: 1200,
        rewards: {'gold': 1000, 'experience': 300},
      ),
      
      // 商店成就
      Achievement(
        id: 'first_purchase',
        name: '初次购物',
        description: '在商店购买第一件物品',
        icon: '🛒',
        type: AchievementType.special,
        rarity: AchievementRarity.common,
        targetValue: 1,
        currentValue: 1,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(hours: 6)),
        rewards: {'gold': 100, 'experience': 50},
      ),
      Achievement(
        id: 'shopaholic',
        name: '购物狂',
        description: '在商店购买50次',
        icon: '🛍️',
        type: AchievementType.special,
        rarity: AchievementRarity.epic,
        targetValue: 50,
        currentValue: 8,
        rewards: {'gold': 1500, 'experience': 600},
      ),
      
      // 武将成就
      Achievement(
        id: 'max_level_general',
        name: '武将大师',
        description: '将一名武将升到满级',
        icon: '🎖️',
        type: AchievementType.special,
        rarity: AchievementRarity.legendary,
        targetValue: 1,
        currentValue: 0,
        rewards: {'gold': 5000, 'experience': 2000},
      ),
    ];
  }

  // 计算成就统计
  AchievementStatistics _calculateStatistics(List<Achievement> achievements) {
    final totalAchievements = achievements.length;
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).length;
    
    // 计算总积分（根据稀有度）
    int totalPoints = 0;
    for (final achievement in achievements.where((a) => a.isUnlocked)) {
      switch (achievement.rarity) {
        case AchievementRarity.common:
          totalPoints += 10;
          break;
        case AchievementRarity.rare:
          totalPoints += 25;
          break;
        case AchievementRarity.epic:
          totalPoints += 50;
          break;
        case AchievementRarity.legendary:
          totalPoints += 100;
          break;
      }
    }
    
    // 类型统计
    final typeBreakdown = <AchievementType, int>{};
    for (final type in AchievementType.values) {
      typeBreakdown[type] = achievements
          .where((a) => a.type == type && a.isUnlocked)
          .length;
    }
    
    // 稀有度统计
    final rarityBreakdown = <AchievementRarity, int>{};
    for (final rarity in AchievementRarity.values) {
      rarityBreakdown[rarity] = achievements
          .where((a) => a.rarity == rarity && a.isUnlocked)
          .length;
    }
    
    // 最近解锁的成就
    final recentUnlocked = achievements
        .where((a) => a.isUnlocked && a.unlockedAt != null)
        .toList()
      ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));
    
    return AchievementStatistics(
      totalAchievements: totalAchievements,
      unlockedAchievements: unlockedAchievements,
      totalPoints: totalPoints,
      typeBreakdown: typeBreakdown,
      rarityBreakdown: rarityBreakdown,
      recentUnlocked: recentUnlocked.take(5).toList(),
    );
  }
}