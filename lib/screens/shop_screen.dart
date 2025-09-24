import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/shop_item.dart';
import '../models/item.dart';
import '../models/game_progress.dart';
import '../services/game_data_service.dart';
import '../services/shop_service.dart';
import 'purchase_history_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  List<ShopItem> _shopItems = [];
  Map<String, int> _shopStock = {};
  GameProgress? _gameProgress;
  ItemType _selectedCategory = ItemType.weapon;
  bool _isLoading = true;
  bool _showRecommended = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadShopData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadShopData() async {
    setState(() => _isLoading = true);
    
    final shopItems = GameDataService.getShopItems();
    final stock = await GameDataService.getShopStock();
    final progress = await GameDataService.getGameProgress();
    
    setState(() {
      _shopItems = shopItems;
      _shopStock = stock;
      _gameProgress = progress;
      _isLoading = false;
    });
  }

  Future<void> _purchaseItem(ShopItem item, int quantity) async {
    if (_gameProgress == null) return;
    
    final totalPrice = item.price * quantity;
    final currentStock = _shopStock[item.id] ?? item.stock;
    
    // 检查金币是否足够
    if (_gameProgress!.gold < totalPrice) {
      _showMessage('金币不足！需要 $totalPrice 金币', isError: true);
      return;
    }
    
    // 检查库存是否足够
    if (currentStock != -1 && currentStock < quantity) {
      _showMessage('库存不足！仅剩 $currentStock 件', isError: true);
      return;
    }
    
    // 确认购买
    final confirmed = await _showPurchaseDialog(item, quantity, totalPrice);
    if (!confirmed) return;
    
    // 执行购买
    final success = await GameDataService.purchaseItem(item.id, quantity);
    
    if (success) {
      _showMessage('购买成功！');
      await _loadShopData(); // 刷新数据
    } else {
      _showMessage('购买失败！', isError: true);
    }
  }

  Future<bool> _showPurchaseDialog(ShopItem item, int quantity, int totalPrice) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackgroundDark,
        title: const Text(
          '确认购买',
          style: TextStyle(color: AppTheme.primaryGold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '物品：${item.name}',
              style: const TextStyle(color: AppTheme.textLight),
            ),
            Text(
              '数量：$quantity',
              style: const TextStyle(color: AppTheme.textLight),
            ),
            Text(
              '总价：$totalPrice 金币',
              style: const TextStyle(color: AppTheme.primaryGold, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.backgroundDark,
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<ShopItem> _getFilteredItems() {
    if (_showRecommended && _gameProgress != null) {
      return ShopService.getRecommendedItems(_gameProgress!);
    }
    return _shopItems.where((item) => item.type == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/BG_7.png'),
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
                if (_gameProgress != null) _buildGoldDisplay(),
                _buildCategoryTabs(),
                Expanded(
                  child: _isLoading ? _buildLoadingWidget() : _buildShopContent(),
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
            '商店',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PurchaseHistoryScreen()),
            ),
            icon: const Icon(Icons.history, color: AppTheme.primaryGold),
          ),
          IconButton(
            onPressed: _refreshShop,
            icon: const Icon(Icons.refresh, color: AppTheme.primaryGold),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: AppTheme.primaryGold, size: 20),
          const SizedBox(width: 8),
          Text(
            '${_gameProgress!.gold}',
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              _showRecommended = true;
            } else {
              _showRecommended = false;
              _selectedCategory = ItemType.values[index - 1];
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
        tabs: const [
          Tab(text: '推荐'),
          Tab(text: '武器'),
          Tab(text: '防具'),
          Tab(text: '饰品'),
          Tab(text: '消耗品'),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryGold),
    );
  }

  Widget _buildShopContent() {
    final filteredItems = _getFilteredItems();
    
    if (filteredItems.isEmpty) {
      return const Center(
        child: Text(
          '暂无商品',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final currentStock = _shopStock[item.id] ?? item.stock;
        return _buildShopItemCard(item, currentStock);
      },
    );
  }

  Widget _buildShopItemCard(ShopItem item, int currentStock) {
    final isOutOfStock = currentStock == 0;
    final canAfford = _gameProgress != null && _gameProgress!.gold >= item.price;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.getRarityColor().withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 物品图标
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: item.getRarityColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // 物品信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.getRarityColor(),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.getRarityName(),
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
                        item.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatsDisplay(item.stats),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 价格和购买按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: AppTheme.primaryGold, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${item.price}',
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (item.stock != -1) ...[
                      const SizedBox(height: 4),
                      Text(
                        '库存：${currentStock == -1 ? '无限' : currentStock}',
                        style: TextStyle(
                          color: isOutOfStock ? Colors.red : AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                
                Row(
                  children: [
                    if (item.type == ItemType.consumable) ...[
                      // 消耗品可以选择数量
                      _buildQuantitySelector(item),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton(
                      onPressed: (isOutOfStock || !canAfford) 
                        ? null 
                        : () => _purchaseItem(item, _getSelectedQuantity(item)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAfford ? AppTheme.primaryGold : AppTheme.textSecondary,
                        foregroundColor: AppTheme.backgroundDark,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        isOutOfStock 
                          ? '缺货' 
                          : !canAfford 
                            ? '金币不足' 
                            : '购买',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsDisplay(Map<String, int> stats) {
    if (stats.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: stats.entries.map((entry) {
        final statName = _getStatDisplayName(entry.key);
        final statValue = entry.value;
        final isPositive = statValue > 0;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isPositive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$statName ${isPositive ? '+' : ''}$statValue',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getStatDisplayName(String statKey) {
    switch (statKey) {
      case 'attack':
        return '攻击';
      case 'defense':
        return '防御';
      case 'intelligence':
        return '智力';
      case 'speed':
        return '速度';
      case 'health':
        return '生命';
      case 'experience':
        return '经验';
      default:
        return statKey;
    }
  }

  // 数量选择器（用于消耗品）
  final Map<String, int> _selectedQuantities = {};
  
  Widget _buildQuantitySelector(ShopItem item) {
    final quantity = _selectedQuantities[item.id] ?? 1;
    final maxQuantity = _getMaxPurchaseQuantity(item);
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: quantity > 1 ? () {
              setState(() {
                _selectedQuantities[item.id] = quantity - 1;
              });
            } : null,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.remove,
                size: 16,
                color: quantity > 1 ? AppTheme.primaryGold : AppTheme.textSecondary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
            ),
          ),
          InkWell(
            onTap: quantity < maxQuantity ? () {
              setState(() {
                _selectedQuantities[item.id] = quantity + 1;
              });
            } : null,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.add,
                size: 16,
                color: quantity < maxQuantity ? AppTheme.primaryGold : AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedQuantity(ShopItem item) {
    return _selectedQuantities[item.id] ?? 1;
  }

  int _getMaxPurchaseQuantity(ShopItem item) {
    if (_gameProgress == null) return 1;
    
    final currentStock = _shopStock[item.id] ?? item.stock;
    final maxByGold = _gameProgress!.gold ~/ item.price;
    
    if (currentStock == -1) {
      return maxByGold.clamp(1, 99);
    } else {
      return maxByGold.clamp(1, currentStock);
    }
  }

  Future<void> _refreshShop() async {
    await GameDataService.refreshShop();
    await _loadShopData();
    _showMessage('商店已刷新！');
  }
}