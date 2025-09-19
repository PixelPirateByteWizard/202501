import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';

class AchievementDetailsScreen extends StatefulWidget {
  final Achievement achievement;

  const AchievementDetailsScreen({
    super.key,
    required this.achievement,
  });

  @override
  State<AchievementDetailsScreen> createState() => _AchievementDetailsScreenState();
}

class _AchievementDetailsScreenState extends State<AchievementDetailsScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  List<Achievement> _allAchievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadAchievements();
    
    if (widget.achievement.isUnlocked) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    final achievements = await AchievementService.getAchievements();
    setState(() {
      _allAchievements = achievements;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildAchievementIcon(),
                      const SizedBox(height: 24),
                      _buildAchievementInfo(),
                      const SizedBox(height: 24),
                      _buildProgressSection(),
                      const SizedBox(height: 24),
                      _buildRewardsSection(),
                      const SizedBox(height: 24),
                      if (widget.achievement.prerequisites.isNotEmpty)
                        _buildPrerequisitesSection(),
                      const SizedBox(height: 24),
                      _buildRelatedAchievements(),
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
          Expanded(
            child: Text(
              widget.achievement.name,
              style: const TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.achievement.getRarityColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.achievement.getRarityName(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementIcon() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: widget.achievement.isUnlocked ? _rotationAnimation.value * 0.1 : 0,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: widget.achievement.isUnlocked 
                  ? widget.achievement.getRarityColor().withValues(alpha: 0.2)
                  : AppTheme.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: widget.achievement.isUnlocked 
                    ? widget.achievement.getRarityColor()
                    : AppTheme.textSecondary,
                  width: 4,
                ),
                boxShadow: widget.achievement.isUnlocked ? [
                  BoxShadow(
                    color: widget.achievement.getRarityColor().withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  widget.achievement.icon,
                  style: TextStyle(
                    fontSize: 48,
                    color: widget.achievement.isUnlocked ? null : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.achievement.isUnlocked 
            ? widget.achievement.getRarityColor().withValues(alpha: 0.5)
            : AppTheme.primaryGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.achievement.getTypeIcon(),
                color: AppTheme.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.achievement.getTypeName(),
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.achievement.isUnlocked) ...[
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 4),
                const Text(
                  '已完成',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.achievement.description,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          if (widget.achievement.isUnlocked && widget.achievement.unlockedAt != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '完成时间：${_formatDateTime(widget.achievement.unlockedAt!)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '进度',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (widget.achievement.isUnlocked) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '成就已完成！',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '当前进度',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${widget.achievement.currentValue} / ${widget.achievement.targetValue}',
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: widget.achievement.progressPercentage,
              backgroundColor: AppTheme.textSecondary.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.achievement.getRarityColor(),
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '完成度：${(widget.achievement.progressPercentage * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: widget.achievement.getRarityColor(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    if (widget.achievement.rewards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.card_giftcard, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '奖励',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.achievement.rewards.entries.map((entry) {
            return _buildRewardItem(entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String type, dynamic value) {
    IconData icon;
    String label;
    Color color;

    switch (type) {
      case 'gold':
        icon = Icons.monetization_on;
        label = '金币';
        color = AppTheme.primaryGold;
        break;
      case 'experience':
        icon = Icons.star;
        label = '经验';
        color = Colors.blue;
        break;
      case 'items':
        icon = Icons.inventory;
        label = '物品';
        color = Colors.purple;
        break;
      default:
        icon = Icons.card_giftcard;
        label = type;
        color = AppTheme.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrerequisitesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.link, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '前置成就',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.achievement.prerequisites.map((prerequisiteId) {
            final prerequisite = _allAchievements.firstWhere(
              (a) => a.id == prerequisiteId,
              orElse: () => Achievement(
                id: prerequisiteId,
                name: '未知成就',
                description: '',
                icon: '❓',
                type: AchievementType.special,
                rarity: AchievementRarity.common,
                targetValue: 1,
              ),
            );
            return _buildPrerequisiteItem(prerequisite);
          }),
        ],
      ),
    );
  }

  Widget _buildPrerequisiteItem(Achievement prerequisite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: prerequisite.isUnlocked 
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            prerequisite.icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              prerequisite.name,
              style: TextStyle(
                color: prerequisite.isUnlocked ? Colors.green : Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            prerequisite.isUnlocked ? Icons.check_circle : Icons.lock,
            color: prerequisite.isUnlocked ? Colors.green : Colors.orange,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedAchievements() {
    if (_isLoading) return const SizedBox.shrink();
    
    final relatedAchievements = _allAchievements
        .where((a) => 
          a.id != widget.achievement.id && 
          a.type == widget.achievement.type)
        .take(3)
        .toList();

    if (relatedAchievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.category, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '相关成就',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...relatedAchievements.map((achievement) {
            return _buildRelatedAchievementItem(achievement);
          }),
        ],
      ),
    );
  }

  Widget _buildRelatedAchievementItem(Achievement achievement) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AchievementDetailsScreen(achievement: achievement),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: achievement.isUnlocked 
            ? achievement.getRarityColor().withValues(alpha: 0.1)
            : AppTheme.textSecondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 20,
                color: achievement.isUnlocked ? null : AppTheme.textSecondary,
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
                      color: achievement.isUnlocked ? AppTheme.textLight : AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!achievement.isUnlocked) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${achievement.currentValue}/${achievement.targetValue}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              achievement.isUnlocked ? Icons.check_circle : Icons.arrow_forward_ios,
              color: achievement.isUnlocked ? achievement.getRarityColor() : AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}