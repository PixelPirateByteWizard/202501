import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/goal.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用SystemUiOverlayStyle实现沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF8FB3B0),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  innerBoxIsScrolled ? 'Statistics' : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  children: [
                    // 渐变背景
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8FB3B0), Color(0xFF6A9AB0)],
                        ),
                      ),
                    ),
                    // 装饰性圆形
                    Positioned(
                      top: -50,
                      right: -20,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // 标题和摘要
                    Positioned(
                      bottom: 60,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Activity Overview for ${DateFormat('MMMM yyyy').format(DateTime.now())}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                tabs: const [
                  Tab(text: 'Day'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDailyStatsView(),
            _buildWeeklyStatsView(),
            _buildMonthlyStatsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStatsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 20),
        _buildActivityBreakdownCard(),
        const SizedBox(height: 20),
        _buildGoalsCard(),
        const SizedBox(height: 20),
        _buildAchievementsCard(),
      ],
    );
  }

  Widget _buildWeeklyStatsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWeeklyProgressCard(),
        const SizedBox(height: 20),
        _buildWeeklyComparisonCard(),
        const SizedBox(height: 20),
        _buildWeeklyGoalsCard(),
      ],
    );
  }

  Widget _buildMonthlyStatsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMonthlyTrendsCard(),
        const SizedBox(height: 20),
        _buildMonthlyHighlightsCard(),
        const SizedBox(height: 20),
        _buildMonthlyGoalsCard(),
      ],
    );
  }

  // 玻璃拟态卡片基础组件
  Widget _buildGlassCard({required Widget child, double height = 200}) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // 今日概览卡片
  Widget _buildSummaryCard() {
    return _buildGlassCard(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Goal>>(
            future: _getGoals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF8FB3B0),
                    strokeWidth: 2,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No goal data available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                );
              }

              final goals = snapshot.data!;

              // 计算今日完成的目标数量
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final todayCompletedGoals = goals
                  .where((goal) =>
                      goal.updatedAt.isAfter(today) && goal.progress >= 0.95)
                  .length;

              // 计算今日活跃的目标数量
              final todayActiveGoals =
                  goals.where((goal) => goal.updatedAt.isAfter(today)).length;

              // 计算平均进度
              final averageProgress = goals.isEmpty
                  ? 0.0
                  : goals.fold(0.0, (sum, goal) => sum + goal.progress) /
                      goals.length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    icon: Icons.check_circle_outline,
                    value: '$todayCompletedGoals',
                    label: 'Completed Today',
                    color: const Color(0xFF8FB3B0),
                  ),
                  _buildSummaryItem(
                    icon: Icons.trending_up,
                    value: '$todayActiveGoals',
                    label: 'Active Today',
                    color: const Color(0xFFE07A5F),
                  ),
                  _buildSummaryItem(
                    icon: Icons.insert_chart,
                    value: '${(averageProgress * 100).toInt()}%',
                    label: 'Average Progress',
                    color: const Color(0xFF81B29A),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // 活动分布卡片
  Widget _buildActivityBreakdownCard() {
    return _buildGlassCard(
      height: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goal Type Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 统计不同类型的目标数量
                final Map<String, int> typeCount = {};
                for (var goal in goals) {
                  if (goal.type.isNotEmpty) {
                    typeCount[goal.type] = (typeCount[goal.type] ?? 0) + 1;
                  } else {
                    typeCount['其他'] = (typeCount['其他'] ?? 0) + 1;
                  }
                }

                // 如果没有数据，显示提示信息
                if (typeCount.isEmpty) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                // 准备饼图数据
                final List<PieChartSectionData> sections = [];
                final List<Color> colors = [
                  const Color(0xFF8FB3B0),
                  const Color(0xFF6A9AB0),
                  const Color(0xFFE07A5F),
                  const Color(0xFF81B29A),
                  Colors.purple.shade300,
                  Colors.amber.shade400,
                ];

                int colorIndex = 0;
                typeCount.forEach((type, count) {
                  final double percentage = count / goals.length * 100;
                  sections.add(
                    PieChartSectionData(
                      value: count.toDouble(),
                      title: '${percentage.toInt()}%',
                      color: colors[colorIndex % colors.length],
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                  colorIndex++;
                });

                return Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: sections,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 80,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            typeCount.length,
                            (index) {
                              final type = typeCount.keys.elementAt(index);
                              final color = colors[index % colors.length];
                              return _buildLegendItem(type, color);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: const BoxConstraints(minWidth: 80),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 目标达成卡片
  Widget _buildGoalsCard() {
    return _buildGlassCard(
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goal Achievement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;
                goals.sort((a, b) => b.progress.compareTo(a.progress));
                final topGoals = goals.take(3).toList();

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topGoals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final goal = topGoals[index];
                    return _buildGoalProgressItem(
                      label: goal.title,
                      current: (goal.progress * 100).toInt(),
                      target: 100,
                      color: _getColorForGoalType(goal.type),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 根据目标类型获取颜色
  Color _getColorForGoalType(String type) {
    switch (type) {
      case 'Personal':
        return const Color(0xFF8FB3B0);
      case 'Work':
        return const Color(0xFF6A9AB0);
      case 'Health':
        return const Color(0xFFE07A5F);
      case 'Learning':
        return const Color(0xFF81B29A);
      case 'Financial':
        return Colors.purple.shade300;
      default:
        return Colors.amber.shade400;
    }
  }

  Widget _buildGoalProgressItem({
    required String label,
    required int current,
    required int target,
    required Color color,
  }) {
    final double progress = current / target;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$current / $target',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 8,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // 成就卡片
  Widget _buildAchievementsCard() {
    return _buildGlassCard(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No achievements data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 找出最近完成的目标
                final completedGoals = goals
                    .where((goal) => goal.progress >= 0.95)
                    .toList()
                  ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                if (completedGoals.isEmpty) {
                  return const Center(
                    child: Text(
                      'No completed goals',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                // 显示最多3个最近完成的目标
                final recentCompletedGoals = completedGoals.take(3).toList();

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: recentCompletedGoals.map((goal) {
                    return _buildAchievementItem(
                      title: goal.title,
                      description: goal.description,
                      icon: _getIconForGoalType(goal.type),
                      color: _getColorForGoalType(goal.type),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 根据目标类型获取图标
  IconData _getIconForGoalType(String type) {
    switch (type) {
      case 'Personal':
        return Icons.person;
      case 'Work':
        return Icons.work;
      case 'Health':
        return Icons.favorite;
      case 'Learning':
        return Icons.school;
      case 'Financial':
        return Icons.attach_money;
      default:
        return Icons.star;
    }
  }

  // 成就项目组件
  Widget _buildAchievementItem({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 圆形进度组件
  Widget _buildCircularProgress({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Center(
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // 周视图卡片
  Widget _buildWeeklyProgressCard() {
    return _buildGlassCard(
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 获取本周的日期范围
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final weekDay = now.weekday;
                final firstDayOfWeek =
                    today.subtract(Duration(days: weekDay - 1));

                // 统计每天的活动数量
                final List<double> dailyActivities = List.filled(7, 0);

                for (var goal in goals) {
                  final updatedDate = DateTime(
                    goal.updatedAt.year,
                    goal.updatedAt.month,
                    goal.updatedAt.day,
                  );

                  // 计算更新日期与本周第一天的差距（天数）
                  final difference =
                      updatedDate.difference(firstDayOfWeek).inDays;

                  // 如果更新日期在本周内
                  if (difference >= 0 && difference < 7) {
                    dailyActivities[difference] += 1;
                  }
                }

                // 计算最大值，用于图表缩放
                final maxActivity =
                    dailyActivities.reduce((a, b) => a > b ? a : b);
                final maxY =
                    maxActivity > 0 ? (maxActivity * 1.2).ceilToDouble() : 5.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              const titles = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  titles[value.toInt()],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox();
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[300],
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      barGroups: List.generate(
                        7,
                        (index) =>
                            _buildBarGroup(index, dailyActivities[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF8FB3B0),
          width: 10,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 6,
            color: Colors.grey[200],
          ),
        ),
      ],
      barsSpace: 4,
    );
  }

  // 周对比卡片
  Widget _buildWeeklyComparisonCard() {
    return _buildGlassCard(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Goal Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 获取本周的日期范围
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final weekDay = now.weekday;
                final firstDayOfWeek =
                    today.subtract(Duration(days: weekDay - 1));

                // 统计本周完成的目标数量
                final completedThisWeek = goals
                    .where((goal) =>
                        goal.progress >= 0.95 &&
                        goal.updatedAt.isAfter(firstDayOfWeek))
                    .length;

                // 统计本周活跃的目标数量
                final activeThisWeek = goals
                    .where((goal) => goal.updatedAt.isAfter(firstDayOfWeek))
                    .length;

                // 计算本周新增的目标数量
                final newThisWeek = goals
                    .where((goal) => goal.createdAt.isAfter(firstDayOfWeek))
                    .length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildComparisonItem(
                      label: 'Completed Goals',
                      value: '$completedThisWeek',
                      isPositive: completedThisWeek > 0,
                    ),
                    _buildComparisonItem(
                      label: 'Active Goals',
                      value: '$activeThisWeek',
                      isPositive: activeThisWeek > 0,
                    ),
                    _buildComparisonItem(
                      label: 'New Goals',
                      value: '$newThisWeek',
                      isPositive: newThisWeek > 0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem({
    required String label,
    required String value,
    required bool isPositive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPositive
                ? const Color(0xFF81B29A).withOpacity(0.1)
                : const Color(0xFFE07A5F).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color:
                isPositive ? const Color(0xFF81B29A) : const Color(0xFFE07A5F),
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                isPositive ? const Color(0xFF81B29A) : const Color(0xFFE07A5F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 周目标卡片
  Widget _buildWeeklyGoalsCard() {
    return _buildGlassCard(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Goal Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 获取本周的日期范围
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final weekDay = now.weekday;
                final firstDayOfWeek =
                    today.subtract(Duration(days: weekDay - 1));

                // 获取本周活跃的目标
                final activeGoals = goals
                    .where((goal) => goal.updatedAt.isAfter(firstDayOfWeek))
                    .toList();

                // 如果没有活跃目标，显示所有目标
                final goalsToShow = activeGoals.isEmpty ? goals : activeGoals;

                // 按优先级排序
                goalsToShow.sort((a, b) => b.priority.compareTo(a.priority));

                // 取前三个目标
                final topGoals = goalsToShow.take(3).toList();

                if (topGoals.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: topGoals.map((goal) {
                    return _buildSmallCircularProgress(
                      label: goal.title.length > 8
                          ? '${goal.title.substring(0, 8)}...'
                          : goal.title,
                      percentage: goal.progress,
                      color: _getColorForGoalType(goal.type),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 添加一个更小的圆形进度组件
  Widget _buildSmallCircularProgress({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Center(
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 月度趋势卡片
  Widget _buildMonthlyTrendsCard() {
    return _buildGlassCard(
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 获取本月的日期范围
                final now = DateTime.now();
                final firstDayOfMonth = DateTime(now.year, now.month, 1);

                // 将本月分为4周
                final List<DateTime> weekStarts = [];
                for (int i = 0; i < 4; i++) {
                  weekStarts.add(
                    firstDayOfMonth.add(Duration(days: i * 7)),
                  );
                }

                // 添加下个月的第一天作为最后一周的结束
                final nextMonth = DateTime(now.year, now.month + 1, 1);
                weekStarts.add(nextMonth);

                // 统计每周完成的目标数量
                final List<double> weeklyCompletions = List.filled(4, 0);

                for (var goal in goals) {
                  if (goal.progress >= 0.95) {
                    for (int i = 0; i < 4; i++) {
                      if (goal.updatedAt.isAfter(weekStarts[i]) &&
                          goal.updatedAt.isBefore(weekStarts[i + 1])) {
                        weeklyCompletions[i] += 1;
                        break;
                      }
                    }
                  }
                }

                // 准备折线图数据
                final List<FlSpot> spots = [];
                for (int i = 0; i < 4; i++) {
                  spots.add(FlSpot(i.toDouble(), weeklyCompletions[i]));
                }

                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            const titles = [
                              'Week 1',
                              'Week 2',
                              'Week 3',
                              'Week 4'
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < titles.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  titles[value.toInt()],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: const Color(0xFF8FB3B0),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF8FB3B0).withOpacity(0.2),
                        ),
                      ),
                    ],
                    minY: 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 月度亮点卡片
  Widget _buildMonthlyHighlightsCard() {
    return _buildGlassCard(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Highlights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No monthly highlights',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 获取本月完成的目标
                final completedGoals =
                    goals.where((goal) => goal.progress >= 0.95).where((goal) {
                  final now = DateTime.now();
                  final thisMonth = DateTime(now.year, now.month);
                  return goal.updatedAt.isAfter(thisMonth);
                }).toList();

                // 如果没有未完成的目标，则使用第一个目标作为默认值
                Goal highestProgressGoal;
                final uncompletedGoals =
                    goals.where((goal) => goal.progress < 0.95).toList();
                if (uncompletedGoals.isNotEmpty) {
                  highestProgressGoal = uncompletedGoals
                      .reduce((a, b) => a.progress > b.progress ? a : b);
                } else {
                  highestProgressGoal = goals.first;
                }

                // 获取最近更新的目标
                final recentlyUpdatedGoal = goals
                    .reduce((a, b) => a.updatedAt.isAfter(b.updatedAt) ? a : b);

                return ListView(
                  children: [
                    if (completedGoals.isNotEmpty)
                      _buildHighlightItem(
                        date: '${completedGoals.length} goals',
                        title: 'Monthly Completed',
                        description:
                            'Congratulations! You completed ${completedGoals.length} goals',
                        icon: Icons.emoji_events,
                        color: const Color(0xFFE07A5F),
                      ),
                    const SizedBox(height: 12),
                    _buildHighlightItem(
                      date: '${(highestProgressGoal.progress * 100).toInt()}%',
                      title: 'Highest Progress Goal',
                      description: highestProgressGoal.title,
                      icon: Icons.trending_up,
                      color: const Color(0xFF8FB3B0),
                    ),
                    const SizedBox(height: 12),
                    _buildHighlightItem(
                      date: DateFormat('MMM d, yyyy')
                          .format(recentlyUpdatedGoal.updatedAt),
                      title: 'Recently Updated Goal',
                      description: recentlyUpdatedGoal.title,
                      icon: Icons.update,
                      color: const Color(0xFF6A9AB0),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem({
    required String date,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 月度目标卡片
  Widget _buildMonthlyGoalsCard() {
    return _buildGlassCard(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Goal Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: _getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8FB3B0),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No goal data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                final goals = snapshot.data!;

                // 计算目标完成情况
                final totalGoals = goals.length;
                final completedGoals =
                    goals.where((goal) => goal.progress >= 0.95).length;
                final inProgressGoals = goals
                    .where((goal) => goal.progress > 0 && goal.progress < 0.95)
                    .length;
                final notStartedGoals =
                    goals.where((goal) => goal.progress == 0).length;

                return Column(
                  children: [
                    _buildMonthlyGoalItem(
                      icon: Icons.check_circle,
                      title: 'Completed Goals',
                      current: completedGoals,
                      target: totalGoals,
                      color: const Color(0xFF81B29A),
                    ),
                    const SizedBox(height: 15),
                    _buildMonthlyGoalItem(
                      icon: Icons.trending_up,
                      title: 'In Progress',
                      current: inProgressGoals,
                      target: totalGoals,
                      color: const Color(0xFF6A9AB0),
                    ),
                    const SizedBox(height: 15),
                    _buildMonthlyGoalItem(
                      icon: Icons.hourglass_empty,
                      title: 'Not Started',
                      current: notStartedGoals,
                      target: totalGoals,
                      color: const Color(0xFFE07A5F),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGoalItem({
    required IconData icon,
    required String title,
    required int current,
    required int target,
    required Color color,
    String unit = '',
  }) {
    final double progress = target > 0 ? current / target : 0;
    final String unitText = unit.isNotEmpty ? unit : '';

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '$current / $target $unitText',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: MediaQuery.of(context).size.width * 0.7 * progress,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 获取目标数据
  Future<List<Goal>> _getGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalsJson = prefs.getStringList('goals') ?? [];

      if (goalsJson.isEmpty) {
        return [];
      }

      final goals =
          goalsJson.map((json) => Goal.fromJson(jsonDecode(json))).toList();

      // 按更新时间排序
      goals.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return goals;
    } catch (e) {
      debugPrint('Error loading goals: $e');
      return [];
    }
  }
}
