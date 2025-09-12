import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../models/general.dart';
import '../models/material.dart' as material;
import '../services/general_service.dart';
import '../services/game_data_service.dart';
import '../services/material_service.dart';

class InventoryScreen extends StatefulWidget {
  final GameState gameState;

  const InventoryScreen({super.key, required this.gameState});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedCategory = '装备';
  final List<String> _categories = ['装备', '道具', '材料'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: Text('背包 (${widget.gameState.inventory.length}/60)'),
        backgroundColor: AppTheme.primaryColor,
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
            
            // 物品列表
            Expanded(
              child: _buildItemList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    if (_selectedCategory == '装备') {
      return _buildEquipmentList();
    } else if (_selectedCategory == '道具') {
      return _buildItemsList();
    } else {
      return _buildMaterialsList();
    }
  }

  Widget _buildEquipmentList() {
    final equipment = widget.gameState.inventory;
    
    if (equipment.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppTheme.lightColor,
            ),
            SizedBox(height: 16),
            Text(
              '暂无装备',
              style: TextStyle(
                color: AppTheme.lightColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: equipment.length,
      itemBuilder: (context, index) {
        final item = equipment[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildEquipmentCard(item),
        );
      },
    );
  }

  Widget _buildEquipmentCard(Equipment equipment) {
    return Card(
      child: InkWell(
        onTap: () => _showEquipmentDetails(equipment),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 装备图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  _getEquipmentIcon(equipment.type),
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 装备信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          equipment.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getRarityColor(equipment.rarity),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            equipment.rarity,
                            (index) => Icon(
                              Icons.star,
                              color: _getRarityColor(equipment.rarity),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      _getStatsText(equipment.stats),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    
                    if (equipment.specialEffect != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        equipment.specialEffect!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentColor.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    // 道具列表（暂时为空，可以后续添加）
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 64,
            color: AppTheme.lightColor,
          ),
          SizedBox(height: 16),
          Text(
            '暂无道具',
            style: TextStyle(
              color: AppTheme.lightColor,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    final materials = widget.gameState.materials;
    
    if (materials.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 64,
              color: AppTheme.lightColor,
            ),
            SizedBox(height: 16),
            Text(
              '暂无材料',
              style: TextStyle(
                color: AppTheme.lightColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 银币显示
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentColor.withValues(alpha: 0.2),
                AppTheme.accentColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.accentColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Text(
                '🪙',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '银币',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${widget.gameState.coins}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // 材料列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final materialStack = materials[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMaterialCard(materialStack),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialCard(material.MaterialStack materialStack) {
    final material = materialStack.material;
    
    return Card(
      child: InkWell(
        onTap: () => _showMaterialDetails(materialStack),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 材料图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getMaterialRarityColor(material.rarity).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getMaterialRarityColor(material.rarity),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    material.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 材料信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            material.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getMaterialRarityColor(material.rarity).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getMaterialRarityName(material.rarity),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getMaterialRarityColor(material.rarity),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      material.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getMaterialTypeName(material.type),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightColor.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          '数量：${materialStack.quantity}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Color _getMaterialRarityColor(int rarity) {
    switch (rarity) {
      case 1: return Colors.grey;
      case 2: return Colors.green;
      case 3: return Colors.blue;
      case 4: return Colors.purple;
      case 5: return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _getMaterialRarityName(int rarity) {
    switch (rarity) {
      case 1: return '普通';
      case 2: return '精良';
      case 3: return '稀有';
      case 4: return '史诗';
      case 5: return '传说';
      default: return '未知';
    }
  }

  String _getMaterialTypeName(material.MaterialType type) {
    switch (type) {
      case material.MaterialType.upgrade: return '升级材料';
      case material.MaterialType.currency: return '货币';
      case material.MaterialType.special: return '特殊材料';
    }
  }

  void _showMaterialDetails(material.MaterialStack materialStack) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 材料标题
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getMaterialRarityColor(materialStack.material.rarity).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getMaterialRarityColor(materialStack.material.rarity),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          materialStack.material.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            materialStack.material.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getMaterialRarityColor(materialStack.material.rarity).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getMaterialRarityName(materialStack.material.rarity),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getMaterialRarityColor(materialStack.material.rarity),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getMaterialTypeName(materialStack.material.type),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.lightColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 描述
                Text(
                  '描述',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  materialStack.material.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 数量信息
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '拥有数量',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        '${materialStack.quantity}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEquipmentDetails(Equipment equipment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 装备标题
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        _getEquipmentIcon(equipment.type),
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            equipment.name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: _getRarityColor(equipment.rarity),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                _getEquipmentTypeName(equipment.type),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: List.generate(
                                  equipment.rarity,
                                  (index) => Icon(
                                    Icons.star,
                                    color: _getRarityColor(equipment.rarity),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 装备描述
                Text(
                  '描述',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  equipment.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 属性加成
                Text(
                  '属性加成',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                ...equipment.stats.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getStatName(entry.key),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '+${entry.value}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
                
                if (equipment.specialEffect != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    '特殊效果',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      equipment.specialEffect!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // 操作按钮
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _equipItem(equipment),
                        child: const Text('装备'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _sellItem(equipment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.7),
                        ),
                        child: const Text('出售'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  String _getEquipmentTypeName(EquipmentType type) {
    switch (type) {
      case EquipmentType.weapon:
        return '武器';
      case EquipmentType.armor:
        return '防具';
      case EquipmentType.accessory:
        return '饰品';
    }
  }

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      case 5:
        return AppTheme.accentColor;
      default:
        return AppTheme.lightColor;
    }
  }

  String _getStatsText(Map<String, int> stats) {
    return stats.entries
        .map((entry) => '${_getStatName(entry.key)}+${entry.value}')
        .join(', ');
  }

  String _getStatName(String statKey) {
    switch (statKey) {
      case 'force':
        return '武力';
      case 'intelligence':
        return '智力';
      case 'leadership':
        return '统率';
      case 'speed':
        return '速度';
      case 'troops':
        return '兵力';
      case 'defense':
        return '防御';
      case 'critRate':
        return '暴击率';
      case 'critDamage':
        return '暴击伤害';
      default:
        return statKey;
    }
  }

  void _equipItem(Equipment equipment) {
    // 显示武将选择对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('选择武将'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.gameState.generals.length,
            itemBuilder: (context, index) {
              final general = widget.gameState.generals[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      general.avatar,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(general.name),
                subtitle: Text(general.position),
                onTap: () => _confirmEquipItem(general, equipment),
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryColor,
            ),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmEquipItem(General general, Equipment equipment) async {
    Navigator.pop(context); // 关闭武将选择对话框
    
    // 装备物品
    General updatedGeneral;
    switch (equipment.type) {
      case EquipmentType.weapon:
        updatedGeneral = GeneralService.equipWeapon(general, equipment);
        break;
      case EquipmentType.armor:
        updatedGeneral = GeneralService.equipArmor(general, equipment);
        break;
      case EquipmentType.accessory:
        updatedGeneral = GeneralService.equipAccessory(general, equipment);
        break;
    }
    
    // 更新游戏状态
    final updatedGenerals = widget.gameState.generals.map((g) {
      return g.id == general.id ? updatedGeneral : g;
    }).toList();
    
    // 从背包中移除装备
    final updatedInventory = List<Equipment>.from(widget.gameState.inventory);
    updatedInventory.removeWhere((e) => e.id == equipment.id);
    
    final updatedGameState = widget.gameState.copyWith(
      generals: updatedGenerals,
      inventory: updatedInventory,
    );
    
    await GameDataService.saveGameState(updatedGameState);
    
    Navigator.pop(context); // 关闭装备详情对话框
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${equipment.name} 已装备给 ${general.name}'),
          backgroundColor: AppTheme.accentColor,
        ),
      );
      
      // 刷新界面
      setState(() {});
    }
  }

  void _sellItem(Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('确认出售'),
        content: Text('确定要出售 ${equipment.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightColor,
            ),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${equipment.name} 已出售'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}