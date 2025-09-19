import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/item.dart';
import '../models/general.dart';
import '../services/game_data_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Item> _items = [];
  List<General> _generals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final items = await GameDataService.getInventory();
    final generals = await GameDataService.getGenerals();
    setState(() {
      _items = items;
      _generals = generals;
      _isLoading = false;
    });
  }

  List<Item> _getItemsByType(ItemType type) {
    return _items.where((item) => item.type == type).toList();
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
              _buildTabBar(),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryGold,
                          ),
                        ),
                      )
                    : _buildTabBarView(),
              ),
            ],
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
          const Text(
            '背包',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.darkBlue,
        unselectedLabelColor: AppTheme.textLight,
        indicator: BoxDecoration(
          gradient: AppTheme.goldGradient.gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: '武器'),
          Tab(text: '防具'),
          Tab(text: '饰品'),
          Tab(text: '消耗品'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildItemGrid(ItemType.weapon),
        _buildItemGrid(ItemType.armor),
        _buildItemGrid(ItemType.accessory),
        _buildItemGrid(ItemType.consumable),
      ],
    );
  }

  Widget _buildItemGrid(ItemType type) {
    final items = _getItemsByType(type);

    if (items.isEmpty) {
      return _buildEmptyInventory(type);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildItemCard(items[index]);
      },
    );
  }

  Widget _buildItemCard(Item item) {
    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: AppTheme.goldGradient.copyWith(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppTheme.darkBlue,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (item.quantity > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'x${item.quantity}',
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: const TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (item.stats.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: item.stats.entries
                    .map(
                      (stat) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackgroundDark.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${stat.key}+${stat.value}',
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyInventory(ItemType type) {
    String typeName = _getTypeDisplayName(type);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getTypeIcon(type),
            size: 64,
            color: AppTheme.textLight.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无$typeName',
            style: TextStyle(
              color: AppTheme.textLight.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '通过战斗和任务获得更多物品',
            style: TextStyle(
              color: AppTheme.textLight.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeDisplayName(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return '武器';
      case ItemType.armor:
        return '防具';
      case ItemType.accessory:
        return '饰品';
      case ItemType.consumable:
        return '消耗品';
    }
  }

  IconData _getTypeIcon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.sports_martial_arts;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.accessory:
        return Icons.diamond;
      case ItemType.consumable:
        return Icons.local_drink;
    }
  }

  void _showItemDetails(Item item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: AppTheme.goldGradient.copyWith(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        item.icon,
                        style: const TextStyle(
                          fontSize: 32,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getTypeDisplayName(item.type),
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                          ),
                        ),
                        if (item.quantity > 1)
                          Text(
                            '数量: ${item.quantity}',
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackgroundDark.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.description,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),

              // Stats
              if (item.stats.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '属性加成:',
                    style: TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...item.stats.entries.map(
                  (stat) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackgroundDark.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stat.key,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '+${stat.value}',
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('关闭'),
                    ),
                  ),
                  if (item.type == ItemType.consumable) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _useItem(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('使用'),
                      ),
                    ),
                  ] else if (item.type != ItemType.consumable) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showGeneralSelector(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold,
                          foregroundColor: AppTheme.darkBlue,
                        ),
                        child: const Text('装备'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _useItem(Item item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('使用了 ${item.name}'),
        backgroundColor: AppTheme.primaryGold,
      ),
    );

    // 这里可以添加使用物品的逻辑
    // 比如减少数量、应用效果等
  }

  void _showGeneralSelector(Item item) {
    final slot = _getSlotForItemType(item.type);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择武将装备 ${item.name}',
              style: const TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_generals.isEmpty)
              const Text('没有可用的武将', style: TextStyle(color: AppTheme.textLight))
            else
              ..._generals.map(
                (general) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: AppTheme.goldGradient.copyWith(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        general.avatar,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    general.name,
                    style: const TextStyle(color: AppTheme.primaryGold),
                  ),
                  subtitle: Text(
                    general.position,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                  trailing: general.equipment[slot] != null
                      ? const Icon(
                          Icons.warning,
                          color: Colors.orange,
                          size: 16,
                        )
                      : null,
                  onTap: () async {
                    Navigator.pop(context);
                    final success = await GameDataService.equipItemToGeneral(
                      general.id,
                      item.id,
                      slot,
                    );
                    if (success) {
                      _loadData();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} 已装备给 ${general.name}'),
                            backgroundColor: AppTheme.primaryGold,
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('装备失败'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getSlotForItemType(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return 'weapon';
      case ItemType.armor:
        return 'armor';
      case ItemType.accessory:
        return 'accessory';
      default:
        return 'weapon';
    }
  }
}
