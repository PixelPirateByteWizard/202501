import '../models/shop_item.dart';
import '../models/item.dart';
import '../models/game_progress.dart';
import 'game_data_service.dart';

class ShopService {
  // 获取推荐商品（基于玩家等级和进度）
  static List<ShopItem> getRecommendedItems(GameProgress progress) {
    final allItems = GameDataService.getShopItems();
    final recommendedItems = <ShopItem>[];
    
    // 根据玩家等级推荐合适的装备
    for (final item in allItems) {
      if (_isItemRecommendedForLevel(item, progress.playerLevel)) {
        recommendedItems.add(item);
      }
    }
    
    // 按稀有度和价格排序
    recommendedItems.sort((a, b) {
      final rarityOrder = {'common': 0, 'rare': 1, 'epic': 2, 'legendary': 3};
      final aRarity = rarityOrder[a.rarity] ?? 0;
      final bRarity = rarityOrder[b.rarity] ?? 0;
      
      if (aRarity != bRarity) {
        return bRarity.compareTo(aRarity); // 稀有度高的在前
      }
      return a.price.compareTo(b.price); // 价格低的在前
    });
    
    return recommendedItems.take(6).toList();
  }
  
  // 判断物品是否适合当前等级
  static bool _isItemRecommendedForLevel(ShopItem item, int playerLevel) {
    // 根据物品价格和稀有度判断适合的等级范围
    if (item.rarity == 'legendary' && playerLevel < 10) return false;
    if (item.rarity == 'epic' && playerLevel < 5) return false;
    if (item.price > 500 && playerLevel < 8) return false;
    if (item.price > 200 && playerLevel < 4) return false;
    
    return true;
  }
  
  // 获取限时特价商品
  static List<ShopItem> getSpecialOffers() {
    final allItems = GameDataService.getShopItems();
    return allItems.where((item) => item.isLimited).toList();
  }
  
  // 计算折扣价格
  static int calculateDiscountPrice(ShopItem item, double discountRate) {
    return (item.price * (1 - discountRate)).round();
  }
  
  // 检查是否可以购买
  static PurchaseResult canPurchase(ShopItem item, int quantity, GameProgress progress, Map<String, int> stock) {
    final totalPrice = item.price * quantity;
    final currentStock = stock[item.id] ?? item.stock;
    
    if (progress.gold < totalPrice) {
      return PurchaseResult(
        canPurchase: false,
        reason: '金币不足！需要 $totalPrice 金币，当前只有 ${progress.gold} 金币',
      );
    }
    
    if (currentStock != -1 && currentStock < quantity) {
      return PurchaseResult(
        canPurchase: false,
        reason: '库存不足！仅剩 $currentStock 件',
      );
    }
    
    return PurchaseResult(canPurchase: true);
  }
  
  // 获取购买统计
  static Future<PurchaseStatistics> getPurchaseStatistics() async {
    final history = await GameDataService.getPurchaseHistory();
    final allItems = GameDataService.getShopItems();
    
    int totalSpent = 0;
    int totalItems = 0;
    final Map<String, int> categoryCount = {};
    final Map<String, int> itemCount = {};
    
    for (final record in history) {
      totalSpent += record.totalPrice;
      totalItems += record.quantity;
      
      // 统计物品类型
      final item = allItems.firstWhere(
        (item) => item.id == record.itemId,
        orElse: () => allItems.first,
      );
      
      final categoryName = _getItemTypeName(item.type);
      categoryCount[categoryName] = (categoryCount[categoryName] ?? 0) + record.quantity;
      itemCount[item.name] = (itemCount[item.name] ?? 0) + record.quantity;
    }
    
    return PurchaseStatistics(
      totalSpent: totalSpent,
      totalItems: totalItems,
      totalTransactions: history.length,
      categoryBreakdown: categoryCount,
      mostPurchasedItems: _getTopItems(itemCount, 5),
    );
  }
  
  static String _getItemTypeName(ItemType type) {
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
  
  static List<MapEntry<String, int>> _getTopItems(Map<String, int> itemCount, int limit) {
    final entries = itemCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }
}

// 购买结果
class PurchaseResult {
  final bool canPurchase;
  final String? reason;
  
  PurchaseResult({
    required this.canPurchase,
    this.reason,
  });
}

// 购买统计
class PurchaseStatistics {
  final int totalSpent;
  final int totalItems;
  final int totalTransactions;
  final Map<String, int> categoryBreakdown;
  final List<MapEntry<String, int>> mostPurchasedItems;
  
  PurchaseStatistics({
    required this.totalSpent,
    required this.totalItems,
    required this.totalTransactions,
    required this.categoryBreakdown,
    required this.mostPurchasedItems,
  });
}