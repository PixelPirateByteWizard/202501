import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'QuantizerNewestHeroHandler.dart';
import 'dart:ui';

class SkillItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imagePath;
  final String category;
  final int level;

  const SkillItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.level,
  });
}

class SkillShopView extends StatefulWidget {
  const SkillShopView({Key? key}) : super(key: key);

  @override
  _SkillShopViewState createState() => _SkillShopViewState();
}

class _SkillShopViewState extends State<SkillShopView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 定义游戏风格的主题颜色
  static const primaryColor = Color(0xFFFFD700); // 金色
  static const secondaryColor = Color(0xFFFFA500); // 橙色
  static const backgroundColor = Color(0xFF1A1A2F); // 深蓝色背景
  static const surfaceColor = Color(0xFF2A2A40); // 稍浅的蓝色
  static const accentColor = Color(0xFFE6B800); // 暗金色

  // 技能类别
  final List<String> _categories = [
    'Attack Skills',
    'Defense Skills',
    'Support Skills',
    'Special Skills'
  ];

  // 道具列表
  final List<SkillItem> _skillItems = [
    // 攻击技能
    SkillItem(
      id: 'attack_1',
      name: 'Flame Palm',
      description: 'Deals massive fire damage to enemies',
      price: 500,
      imagePath: 'assets/images/skills/fire_palm.png',
      category: 'Attack Skills',
      level: 1,
    ),
    SkillItem(
      id: 'attack_2',
      name: 'Frost Sword Qi',
      description: 'Freezes enemies and deals continuous ice damage',
      price: 800,
      imagePath: 'assets/images/skills/ice_sword.png',
      category: 'Attack Skills',
      level: 2,
    ),
    SkillItem(
      id: 'attack_3',
      name: 'Thunder Strike',
      description:
          'Calls down lightning to damage all enemies with chance to stun',
      price: 1200,
      imagePath: 'assets/images/skills/thunder.png',
      category: 'Attack Skills',
      level: 3,
    ),

    // 防御技能
    SkillItem(
      id: 'defense_1',
      name: 'Golden Bell Shield',
      description: 'Reduces physical damage taken',
      price: 600,
      imagePath: 'assets/images/skills/golden_shield.png',
      category: 'Defense Skills',
      level: 1,
    ),
    SkillItem(
      id: 'defense_2',
      name: 'Frost Shield',
      description: 'Blocks magic attacks and reflects some damage',
      price: 900,
      imagePath: 'assets/images/skills/ice_shield.png',
      category: 'Defense Skills',
      level: 2,
    ),
    SkillItem(
      id: 'defense_3',
      name: 'Elemental Protection',
      description: 'Enhances all defensive capabilities',
      price: 1500,
      imagePath: 'assets/images/skills/elemental_shield.png',
      category: 'Defense Skills',
      level: 3,
    ),

    // 辅助技能
    SkillItem(
      id: 'support_1',
      name: 'Light Body Technique',
      description: 'Increases movement speed and jump height',
      price: 400,
      imagePath: 'assets/images/skills/light_body.png',
      category: 'Support Skills',
      level: 1,
    ),
    SkillItem(
      id: 'support_2',
      name: 'Rejuvenation',
      description: 'Restores health over time',
      price: 700,
      imagePath: 'assets/images/skills/healing.png',
      category: 'Support Skills',
      level: 2,
    ),
    SkillItem(
      id: 'support_3',
      name: 'Spirit Recovery',
      description: 'Quickly restores spirit energy for immediate skill use',
      price: 1000,
      imagePath: 'assets/images/skills/mana_recovery.png',
      category: 'Support Skills',
      level: 3,
    ),

    // 特殊技能
    SkillItem(
      id: 'special_1',
      name: 'Invisibility',
      description: 'Become invisible to enemies for a short duration',
      price: 800,
      imagePath: 'assets/images/skills/invisibility.png',
      category: 'Special Skills',
      level: 1,
    ),
    SkillItem(
      id: 'special_2',
      name: 'Immortal Flight',
      description: 'Gain temporary flight ability to reach high places',
      price: 1200,
      imagePath: 'assets/images/skills/flying.png',
      category: 'Special Skills',
      level: 2,
    ),
    SkillItem(
      id: 'special_3',
      name: 'Divine Sight',
      description: 'Reveal hidden treasures and enemies',
      price: 1800,
      imagePath: 'assets/images/skills/divine_eye.png',
      category: 'Special Skills',
      level: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 设置横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handlePurchase(SkillItem item) {
    // 直接购买，不检查仙玉余额
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryColor.withOpacity(0.5), width: 2),
        ),
        title: Text(
          'Purchase Successful',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Image.asset(
                item.imagePath,
                width: 60,
                height: 60,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.auto_awesome,
                  color: primaryColor,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You have successfully purchased ${item.name}',
              style: const TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cost ${item.price} Spirit Gems',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/store_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              backgroundColor.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildGameStoreHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    final categoryItems = _skillItems
                        .where((item) => item.category == category)
                        .toList();
                    return _buildSkillGrid(categoryItems);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameStoreHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Skill & Item Store',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: primaryColor,
        indicatorWeight: 3,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        tabs: _categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  Widget _buildSkillGrid(List<SkillItem> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildSkillCard(items[index]),
    );
  }

  Widget _buildSkillCard(SkillItem item) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handlePurchase(item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSkillIcon(item),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.price} Spirit Gems',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                _buildLevelIndicator(item.level),
                const SizedBox(height: 8),
                _buildPurchaseButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillIcon(SkillItem item) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          item.imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.auto_awesome,
            color: primaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildLevelIndicator(int level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          Icon(
            Icons.star,
            color: i < level ? primaryColor : Colors.grey.withOpacity(0.3),
            size: 16,
          ),
      ],
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            accentColor,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'Buy',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
