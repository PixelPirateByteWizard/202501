import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/general.dart';
import '../models/game_state.dart';
import '../services/game_data_service.dart';

class ShopScreen extends StatefulWidget {
  final GameState gameState;

  const ShopScreen({super.key, required this.gameState});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = '装备';
  final List<String> _categories = ['装备', '武将', '道具'];
  int _playerCoins = 5000; // 玩家金币

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('商店'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: AppTheme.accentColor),
                const SizedBox(width: 4),
                Text(
                  _playerCoins.toString(),
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 分类选择
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _categories.map((category) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == category 
                            ? AppTheme.accentColor 
                            : AppTheme.cardColor,
                        foregroundColor: _selectedCategory == category 
                            ? AppTheme.primaryColor 
                            : AppTheme.lightColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(category),
                    ),
                  ),
                )).toList(),
              ),
            ),
            
            // 商品列表
            Expanded(
              child: _buildShopContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopContent() {
    switch (_selectedCategory) {
      case '装备':
        return _buildEquipmentShop();
      case '武将':
        return _buildGeneralShop();
      case '道具':
        return _buildItemShop();
      default:
        return const SizedBox();
    }
  }

  Widget _buildEquipmentShop() {
    final equipmentList = _getShopEquipment();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: equipmentList.length,
      itemBuilder: (context, index) {
        final equipment = equipmentList[index];
        final price = _calculateEquipmentPrice(equipment);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildEquipmentShopCard(equipment, price),
        );
      },
    );
  }

  Widget _buildEquipmentShopCard(Equipment equipment, int price) {
    final canAfford = _playerCoins >= price;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 装备图标
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                ),
              ),
              child: Icon(
                _getEquipmentIcon(equipment.type),
                color: AppTheme.primaryColor,
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 装备信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getRarityColor(equipment.rarity),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    equipment.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, 
                           color: AppTheme.accentColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        price.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: canAfford ? AppTheme.accentColor : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 购买按钮
            ElevatedButton(
              onPressed: canAfford ? () => _buyEquipment(equipment, price) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford ? AppTheme.accentColor : Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('购买'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralShop() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppTheme.lightColor,
          ),
          SizedBox(height: 16),
          Text(
            '武将招募功能开发中...',
            style: TextStyle(
              color: AppTheme.lightColor,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '敬请期待！',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemShop() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppTheme.lightColor,
          ),
          SizedBox(height: 16),
          Text(
            '道具商店功能开发中...',
            style: TextStyle(
              color: AppTheme.lightColor,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '敬请期待！',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<Equipment> _getShopEquipment() {
    return [
      Equipment(
        id: 'bronze_sword',
        name: '青铜剑',
        description: '普通的青铜制武器，适合初学者使用',
        type: EquipmentType.weapon,
        rarity: 1,
        stats: {'force': 8},
      ),
      Equipment(
        id: 'iron_spear',
        name: '精铁长枪',
        description: '用精铁打造的长枪，攻击力不俗',
        type: EquipmentType.weapon,
        rarity: 2,
        stats: {'force': 15, 'speed': 3},
      ),
      Equipment(
        id: 'steel_armor',
        name: '钢铁战甲',
        description: '厚重的钢铁战甲，提供优秀的防护',
        type: EquipmentType.armor,
        rarity: 3,
        stats: {'defense': 20, 'troops': 300},
      ),
      Equipment(
        id: 'jade_pendant',
        name: '玉佩',
        description: '温润的玉石制成，能够凝神静气',
        type: EquipmentType.accessory,
        rarity: 2,
        stats: {'intelligence': 10, 'leadership': 5},
      ),
      Equipment(
        id: 'dragon_blade',
        name: '龙纹刀',
        description: '刀身刻有龙纹，传说能够增强使用者的威势',
        type: EquipmentType.weapon,
        rarity: 4,
        stats: {'force': 30, 'leadership': 10},
        specialEffect: '攻击时有几率威慑敌人，降低其攻击力',
      ),
      Equipment(
        id: 'phoenix_feather',
        name: '凤羽扇',
        description: '用凤凰羽毛制成的扇子，蕴含神秘力量',
        type: EquipmentType.accessory,
        rarity: 5,
        stats: {'intelligence': 25, 'speed': 8},
        specialEffect: '使用计策时有几率不消耗冷却时间',
      ),
    ];
  }

  int _calculateEquipmentPrice(Equipment equipment) {
    int basePrice = 100;
    int rarityMultiplier = equipment.rarity * equipment.rarity * 50;
    int statsValue = equipment.stats.values.fold(0, (sum, value) => sum + value) * 10;
    
    return basePrice + rarityMultiplier + statsValue;
  }

  void _buyEquipment(Equipment equipment, int price) {
    if (_playerCoins >= price) {
      setState(() {
        _playerCoins -= price;
      });
      
      // 添加到背包
      final updatedInventory = List<Equipment>.from(widget.gameState.inventory);
      updatedInventory.add(equipment);
      
      final updatedGameState = widget.gameState.copyWith(
        inventory: updatedInventory,
        playerStats: widget.gameState.playerStats.copyWith(
          equipmentCollected: widget.gameState.playerStats.equipmentCollected + 1,
        ),
      );
      
      GameDataService.saveGameState(updatedGameState);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('成功购买 ${equipment.name}！'),
          backgroundColor: AppTheme.accentColor,
        ),
      );
    }
  }

  IconData _getEquipmentIcon(EquipmentType type) {
    switch (type) {
      case EquipmentType.weapon:
        return Icons.sports_martial_arts;
      case EquipmentType.armor:
        return Icons.shield;
      case EquipmentType.accessory:
        return Icons.diamond;
    }
  }

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 1: return Colors.grey;
      case 2: return Colors.green;
      case 3: return Colors.blue;
      case 4: return Colors.purple;
      case 5: return AppTheme.accentColor;
      default: return AppTheme.lightColor;
    }
  }
}