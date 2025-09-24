import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/general.dart';
import '../models/item.dart';

class GeneralDetailsScreen extends StatefulWidget {
  final General general;
  final List<Item> items;

  const GeneralDetailsScreen({
    super.key,
    required this.general,
    required this.items,
  });

  @override
  State<GeneralDetailsScreen> createState() => _GeneralDetailsScreenState();
}

class _GeneralDetailsScreenState extends State<GeneralDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _imageScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  void _startAnimations() {
    _imageAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/BG_5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCharacterImage(),
                        _buildCharacterInfo(),
                        _buildStatsSection(),
                        _buildSkillsSection(),
                        _buildEquipmentSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.general.name,
              style: const TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterImage() {
    return AnimatedBuilder(
      animation: _imageScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _imageScaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 背景装饰
                Container(
                  width: 280,
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: RadialGradient(
                      colors: [
                        _getRarityColor(
                          widget.general.rarity,
                        ).withValues(alpha: 0.2),
                        _getRarityColor(
                          widget.general.rarity,
                        ).withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // 角色图片
                Container(
                  width: 240,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getRarityColor(widget.general.rarity),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getRarityColor(
                          widget.general.rarity,
                        ).withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      widget.general.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.cardBackgroundDark,
                          child: Center(
                            child: Text(
                              widget.general.avatar,
                              style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 稀有度装饰
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        widget.general.rarity,
                        (index) => Icon(
                          Icons.star,
                          color: _getRarityColor(widget.general.rarity),
                          size: 16,
                        ),
                      ),
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

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 3:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 1:
      default:
        return Colors.grey;
    }
  }

  Widget _buildCharacterInfo() {
    return SlideTransition(
      position: _contentSlideAnimation,
      child: FadeTransition(
        opacity: _contentOpacityAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration.copyWith(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.cardBackgroundDark.withValues(alpha: 0.9),
                AppTheme.cardBackgroundDark.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.general.position,
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (widget.general.specialty != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              widget.general.specialty!,
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Lv.${widget.general.level}',
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.general.description,
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return SlideTransition(
      position: _contentSlideAnimation,
      child: FadeTransition(
        opacity: _contentOpacityAnimation,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '属性',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      '攻击',
                      widget.general.getTotalAttack(widget.items),
                      widget.general.attack,
                      Icons.sports_martial_arts,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      '防御',
                      widget.general.getTotalDefense(widget.items),
                      widget.general.defense,
                      Icons.shield,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      '智力',
                      widget.general.getTotalIntelligence(widget.items),
                      widget.general.intelligence,
                      Icons.psychology,
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      '速度',
                      widget.general.getTotalSpeed(widget.items),
                      widget.general.speed,
                      Icons.flash_on,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    int totalValue,
    int baseValue,
    IconData icon,
    Color color,
  ) {
    final hasBonus = totalValue > baseValue;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                totalValue.toString(),
                style: TextStyle(
                  color: hasBonus ? Colors.green : AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasBonus) ...[
                const SizedBox(width: 4),
                Text(
                  '(+${totalValue - baseValue})',
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return SlideTransition(
      position: _contentSlideAnimation,
      child: FadeTransition(
        opacity: _contentOpacityAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '技能',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.general.skills
                    .map((skill) => _buildSkillChip(skill))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withValues(alpha: 0.2),
            AppTheme.primaryGold.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGold.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_fix_high, color: AppTheme.primaryGold, size: 16),
          const SizedBox(width: 8),
          Text(
            skill,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSection() {
    return SlideTransition(
      position: _contentSlideAnimation,
      child: FadeTransition(
        opacity: _contentOpacityAnimation,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '装备',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildEquipmentSlot(
                      '武器',
                      'weapon',
                      Icons.sports_martial_arts,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEquipmentSlot('护甲', 'armor', Icons.shield),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEquipmentSlot(
                      '饰品',
                      'accessory',
                      Icons.diamond,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentSlot(String label, String slot, IconData icon) {
    final itemId = widget.general.equipment[slot];
    final hasEquipment = itemId != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasEquipment
              ? AppTheme.primaryGold.withValues(alpha: 0.5)
              : AppTheme.textLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: hasEquipment ? AppTheme.primaryGold : AppTheme.textLight,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            hasEquipment ? '已装备' : '未装备',
            style: TextStyle(
              color: hasEquipment ? AppTheme.primaryGold : AppTheme.textLight,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
