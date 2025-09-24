import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/general.dart';
import '../models/item.dart';
import '../services/game_data_service.dart';
import 'general_details_screen.dart';

class GeneralsScreen extends StatefulWidget {
  const GeneralsScreen({super.key});

  @override
  State<GeneralsScreen> createState() => _GeneralsScreenState();
}

class _GeneralsScreenState extends State<GeneralsScreen>
    with TickerProviderStateMixin {
  List<General> _generals = [];
  List<Item> _items = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  String _sortBy =
      'level'; // level, attack, defense, intelligence, speed, rarity

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final generals = await GameDataService.getGenerals();
    final items = await GameDataService.getInventory();
    setState(() {
      _generals = _sortGenerals(generals);
      _items = items;
      _isLoading = false;
    });
  }

  List<General> _sortGenerals(List<General> generals) {
    switch (_sortBy) {
      case 'attack':
        return generals..sort(
          (a, b) =>
              b.getTotalAttack(_items).compareTo(a.getTotalAttack(_items)),
        );
      case 'defense':
        return generals..sort(
          (a, b) =>
              b.getTotalDefense(_items).compareTo(a.getTotalDefense(_items)),
        );
      case 'intelligence':
        return generals..sort(
          (a, b) => b
              .getTotalIntelligence(_items)
              .compareTo(a.getTotalIntelligence(_items)),
        );
      case 'speed':
        return generals..sort(
          (a, b) => b.getTotalSpeed(_items).compareTo(a.getTotalSpeed(_items)),
        );
      case 'rarity':
        return generals..sort((a, b) => b.rarity.compareTo(a.rarity));
      case 'level':
      default:
        return generals..sort((a, b) => b.level.compareTo(a.level));
    }
  }

  void _changeSortOrder(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      _generals = _sortGenerals(_generals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/BG_4.png'),
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
                _buildSortBar(),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryGold,
                            ),
                          ),
                        )
                      : _buildGeneralsList(),
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
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '武将',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '共 ${_generals.length} 位武将',
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text(
              '排序：',
              style: TextStyle(color: AppTheme.textLight, fontSize: 14),
            ),
            const SizedBox(width: 8),
            _buildSortButton('等级', 'level'),
            _buildSortButton('攻击', 'attack'),
            _buildSortButton('防御', 'defense'),
            _buildSortButton('智力', 'intelligence'),
            _buildSortButton('速度', 'speed'),
            _buildSortButton('稀有度', 'rarity'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(String title, String value) {
    final isSelected = _sortBy == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _changeSortOrder(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryGold.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryGold
                  : AppTheme.textLight.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryGold : AppTheme.textLight,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralsList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _generals.length,
      itemBuilder: (context, index) {
        final general = _generals[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutBack,
          child: _buildGeneralCard(general, index),
        );
      },
    );
  }

  Widget _buildGeneralCard(General general, int index) {
    return GestureDetector(
      onTap: () => _showGeneralDetails(general),
      child: Hero(
        tag: 'general_${general.id}',
        child: Container(
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
          child: Stack(
            children: [
              // 背景装饰
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryGold.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // 主要内容
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // 角色图片和稀有度
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 角色图片
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _getRarityColor(general.rarity),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getRarityColor(
                                    general.rarity,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                general.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppTheme.cardBackgroundDark,
                                    child: Center(
                                      child: Text(
                                        general.avatar,
                                        style: const TextStyle(
                                          fontSize: 20,
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
                          // 稀有度星级
                          Positioned(
                            top: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                general.rarity,
                                (index) => Icon(
                                  Icons.star,
                                  color: AppTheme.primaryGold,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 武将信息
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            general.name,
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            general.position,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Lv.${general.level}',
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
                    // 属性预览
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniStatItem(
                            '攻',
                            general.getTotalAttack(_items),
                          ),
                          _buildMiniStatItem(
                            '防',
                            general.getTotalDefense(_items),
                          ),
                          _buildMiniStatItem(
                            '智',
                            general.getTotalIntelligence(_items),
                          ),
                          _buildMiniStatItem(
                            '速',
                            general.getTotalSpeed(_items),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildMiniStatItem(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppTheme.textLight, fontSize: 10),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            color: AppTheme.primaryGold,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showGeneralDetails(General general) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GeneralDetailsScreen(general: general, items: _items),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
