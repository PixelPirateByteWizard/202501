import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../models/daily_checkin.dart';
import '../services/daily_checkin_service.dart';

class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});

  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen>
    with TickerProviderStateMixin {
  DailyCheckinData? _checkinData;
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;
  late AnimationController _breatheController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _breatheAnimation;
  bool _isLoading = false;
  int _consecutiveDays = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _breatheAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    _loadCheckinData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  Future<void> _loadCheckinData() async {
    final data = await DailyCheckinService.getCheckinData();
    setState(() {
      _checkinData = data;
      _consecutiveDays = data.consecutiveDays;
    });
    _animationController.forward();
  }

  Future<void> _performCheckin() async {
    if (_isLoading || _checkinData?.hasCheckedToday == true) return;

    setState(() {
      _isLoading = true;
    });

    final success = await DailyCheckinService.performCheckin();
    if (success) {
      await _loadCheckinData();
      _showCheckinSuccess();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showCheckinSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CheckinSuccessDialog(
        consecutiveDays: _consecutiveDays,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A), // 深蓝黑色
              Color(0xFF1B263B), // 深蓝色
              Color(0xFF415A77), // 中蓝色
              Color(0xFF778DA9), // 浅蓝灰色
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // 背景图片
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg/BG_1.png'),
                  fit: BoxFit.cover,
                  opacity: 0.2,
                ),
              ),
            ),
            // 粒子效果
            _buildParticleEffect(),
            // 主要内容
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _checkinData == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryGold,
                            ),
                          )
                        : _buildContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleEffect() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particleAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGold.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppTheme.primaryGold,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              '新人福利',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainSection(),
          const SizedBox(height: 30),
          _buildActionButtons(),
          const SizedBox(height: 20),
          _buildMonthlyCalendar(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMainSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 500, // 固定高度确保人物能完整显示
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            AppTheme.primaryGold.withValues(alpha: 0.3),
            Colors.red.withValues(alpha: 0.2),
            Colors.purple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppTheme.primaryGold.withValues(alpha: 0.8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 背景人物图片（居中显示，让人物完整可见）
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            bottom: 120, // 留空间给底部签到卡片
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: 0.7, // 增加透明度让人物更清晰
                      child: Image.asset(
                        'assets/role/Role_4.png',
                        fit: BoxFit.contain, // 改为contain确保人物完整显示
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.primaryGold.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // 顶部标题
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
                      end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
                      colors: const [
                        Colors.transparent,
                        AppTheme.primaryGold,
                        Colors.transparent,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Column(
                    children: [
                      Text(
                        '上线签到领1000抽',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '十连抽必得五星神豪武将',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 底部签到奖励网格
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildRewardsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsGrid() {
    return Container(
      height: 120, // 增加高度
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGold.withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // 标题
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryGold.withValues(alpha: 0.8),
                  AppTheme.lightGold.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppTheme.darkBlue,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '7日签到奖励 (连续${_consecutiveDays}天)',
                  style: const TextStyle(
                    color: AppTheme.darkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 奖励列表
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _checkinData!.rewards.length,
                itemBuilder: (context, index) {
                  final reward = _checkinData!.rewards[index];
                  final isCurrentDay = reward.day == _checkinData!.currentDay;
                  final isCompleted =
                      reward.day < _checkinData!.currentDay ||
                      (isCurrentDay && _checkinData!.hasCheckedToday);

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < _checkinData!.rewards.length - 1 ? 8 : 0,
                    ),
                    child: SizedBox(
                      width: 70, // 固定宽度
                      child: _buildRewardCard(
                        reward,
                        isCurrentDay,
                        isCompleted,
                        index + 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(
    DailyCheckinReward reward,
    bool isCurrentDay,
    bool isCompleted,
    int dayNumber,
  ) {
    return AnimatedBuilder(
      animation: isCurrentDay ? _breatheAnimation : _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isCurrentDay ? _breatheAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isCurrentDay
                    ? [
                        AppTheme.primaryGold.withValues(alpha: 0.9),
                        AppTheme.lightGold.withValues(alpha: 0.7),
                        Colors.orange.withValues(alpha: 0.5),
                      ]
                    : isCompleted
                    ? [
                        Colors.green.withValues(alpha: 0.7),
                        Colors.green.shade600.withValues(alpha: 0.5),
                      ]
                    : [
                        Colors.grey.withValues(alpha: 0.6),
                        Colors.grey.shade700.withValues(alpha: 0.4),
                      ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrentDay
                    ? AppTheme.primaryGold
                    : isCompleted
                    ? Colors.green
                    : AppTheme.primaryGold.withValues(alpha: 0.3),
                width: isCurrentDay ? 2 : 1,
              ),
              boxShadow: isCurrentDay
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryGold.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // 顶部标签
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: isCurrentDay
                            ? AppTheme.primaryGold
                            : isCompleted
                            ? Colors.green
                            : Colors.grey.shade700,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                      ),
                      child: Text(
                        '第$dayNumber天',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isCurrentDay
                              ? AppTheme.darkBlue
                              : Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 物品区域
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 物品图片
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.primaryGold.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    reward.itemImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        reward.isSpecial
                                            ? Icons.stars
                                            : Icons.card_giftcard,
                                        color: AppTheme.primaryGold,
                                        size: 16,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // 物品信息
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  reward.itemName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'x${reward.quantity}',
                                  style: TextStyle(
                                    color: AppTheme.primaryGold.withValues(
                                      alpha: 0.9,
                                    ),
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // 特殊标记
                if (reward.isSpecial)
                  Positioned(
                    top: -1,
                    left: -1,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
                // 已完成标记
                if (isCompleted)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    final canCheckin = !(_checkinData?.hasCheckedToday ?? true);

    return Column(
      children: [
        // 签到按钮
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: AnimatedBuilder(
            animation: canCheckin ? _breatheAnimation : _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: canCheckin ? _breatheAnimation.value * 0.05 + 0.95 : 1.0,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: canCheckin
                          ? [
                              AppTheme.primaryGold,
                              AppTheme.lightGold,
                              Colors.orange.shade300,
                            ]
                          : [
                              Colors.grey.shade600,
                              Colors.grey.shade700,
                              Colors.grey.shade800,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: canCheckin
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGold.withValues(
                                alpha: 0.6,
                              ),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: AppTheme.primaryGold.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: canCheckin ? _performCheckin : null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: canCheckin
                                ? AppTheme.primaryGold.withValues(alpha: 0.8)
                                : Colors.grey.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppTheme.darkBlue,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      canCheckin
                                          ? Icons.touch_app
                                          : Icons.check_circle,
                                      color: AppTheme.darkBlue,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      canCheckin ? '立即签到' : '今日已签到',
                                      style: const TextStyle(
                                        color: AppTheme.darkBlue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // 签到统计信息
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryGold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '连续签到',
                '${_consecutiveDays}天',
                Icons.calendar_today,
              ),
              Container(
                width: 1,
                height: 30,
                color: AppTheme.primaryGold.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                '本月签到',
                '${_checkinData?.currentDay ?? 1}天',
                Icons.event_note,
              ),
              Container(
                width: 1,
                height: 30,
                color: AppTheme.primaryGold.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                '总签到',
                '${_checkinData?.totalDays ?? 0}天',
                Icons.star,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.primaryGold, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.primaryGold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textLight.withValues(alpha: 0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyCalendar() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = endOfMonth.day;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${now.year}年${now.month}月签到记录',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 星期标题
          Row(
            children: ['日', '一', '二', '三', '四', '五', '六'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: AppTheme.textLight.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // 日历网格
          ...List.generate(6, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dayNumber =
                      weekIndex * 7 + dayIndex + 1 - startOfMonth.weekday % 7;

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const Expanded(child: SizedBox());
                  }

                  final date = DateTime(now.year, now.month, dayNumber);
                  final isToday = date.day == now.day;
                  final isChecked = _isDateChecked(date);

                  return Expanded(
                    child: Container(
                      height: 32,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppTheme.primaryGold.withValues(alpha: 0.3)
                            : isChecked
                            ? Colors.green.withValues(alpha: 0.6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isToday
                              ? AppTheme.primaryGold
                              : isChecked
                              ? Colors.green
                              : Colors.transparent,
                          width: isToday ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              dayNumber.toString(),
                              style: TextStyle(
                                color: isToday
                                    ? AppTheme.primaryGold
                                    : isChecked
                                    ? Colors.white
                                    : AppTheme.textLight.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isChecked && !isToday)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }).take(6).toList(),
        ],
      ),
    );
  }

  bool _isDateChecked(DateTime date) {
    // 这里应该根据实际的签到记录来判断
    // 为了演示目的，我们假设随机几天已签到
    final today = DateTime.now();
    if (date.isAfter(today)) return false;

    // 示例：假设已经签到了几天
    final checkedDays = [1, 3, 5, 7, 9, 12, 15, 18, 21, 23];
    return checkedDays.contains(date.day) && date.day <= today.day;
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // 创建随机粒子
    final random = math.Random(42); // 固定种子确保一致性
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y =
          (random.nextDouble() * size.height +
              animationValue * size.height * 0.1) %
          size.height;

      final opacity =
          (math.sin(animationValue * 2 * math.pi + i) * 0.5 + 0.5) * 0.4;
      paint.color = AppTheme.primaryGold.withValues(alpha: opacity);

      final radius = random.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // 绘制光效
    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.primaryGold.withValues(alpha: 0.3),
          AppTheme.primaryGold.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int i = 0; i < 3; i++) {
      final centerX = size.width * (0.2 + i * 0.3);
      final centerY =
          size.height *
          (0.3 + math.sin(animationValue * 2 * math.pi + i) * 0.1);
      final radius = 80 + math.sin(animationValue * 2 * math.pi + i) * 20;

      canvas.drawCircle(Offset(centerX, centerY), radius, lightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CheckinSuccessDialog extends StatefulWidget {
  final int consecutiveDays;
  final VoidCallback onDismiss;

  const _CheckinSuccessDialog({
    required this.consecutiveDays,
    required this.onDismiss,
  });

  @override
  State<_CheckinSuccessDialog> createState() => _CheckinSuccessDialogState();
}

class _CheckinSuccessDialogState extends State<_CheckinSuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _sparkleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1a237e),
                    Color(0xFF3949ab),
                    Color(0xFF5c6bc0),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primaryGold.withValues(alpha: 0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 闪烁粒子效果
                  AnimatedBuilder(
                    animation: _sparkleAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: SparkleEffectPainter(_sparkleAnimation.value),
                        size: const Size(200, 200),
                      );
                    },
                  ),
                  // 主要内容
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 成功图标
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _sparkleAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _sparkleAnimation.value * 2 * math.pi,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppTheme.primaryGold.withValues(
                                          alpha: 0.8,
                                        ),
                                        AppTheme.primaryGold.withValues(
                                          alpha: 0.4,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryGold,
                            size: 64,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // 成功文本
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [
                              AppTheme.primaryGold,
                              AppTheme.lightGold,
                              Colors.orange,
                            ],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          '签到成功！',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 连续签到提示
                      if (widget.consecutiveDays > 1)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryGold.withValues(alpha: 0.8),
                                AppTheme.lightGold.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '连续签到 ${widget.consecutiveDays} 天！',
                            style: const TextStyle(
                              color: AppTheme.darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '奖励已发放到背包',
                        style: TextStyle(
                          color: AppTheme.textLight.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 确定按钮
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryGold, AppTheme.lightGold],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGold.withValues(
                                alpha: 0.5,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: widget.onDismiss,
                            child: const Center(
                              child: Text(
                                '太棒了！',
                                style: TextStyle(
                                  color: AppTheme.darkBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SparkleEffectPainter extends CustomPainter {
  final double animationValue;

  SparkleEffectPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final angle = (animationValue * 2 * math.pi) + (i * 0.3);
      final radius = 40 + math.sin(animationValue * 2 * math.pi + i) * 20;
      final x = size.width / 2 + math.cos(angle) * radius;
      final y = size.height / 2 + math.sin(angle) * radius;

      final opacity =
          (math.sin(animationValue * 2 * math.pi + i) * 0.5 + 0.5) * 0.8;
      paint.color = AppTheme.primaryGold.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
