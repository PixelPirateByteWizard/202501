import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../models/general.dart';
import '../models/material.dart' as material;
import '../services/general_service.dart';
import '../services/game_data_service.dart';
import '../services/audio_service.dart';
import '../services/material_service.dart';
import '../utils/responsive_utils.dart';

class GeneralsScreen extends StatefulWidget {
  final GameState gameState;

  const GeneralsScreen({super.key, required this.gameState});

  @override
  State<GeneralsScreen> createState() => _GeneralsScreenState();
}

class _GeneralsScreenState extends State<GeneralsScreen> {
  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '前锋', '谋士', '辅助'];

  @override
  Widget build(BuildContext context) {
    final filteredGenerals = _getFilteredGenerals();

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: Text('武将 (${widget.gameState.generals.length}/20)'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 筛选按钮
            Container(
              padding: const EdgeInsets.all(16).responsive(context),
              child: ResponsiveUtils.isExtraSmallScreen(context)
                  ? Column(
                      children: [
                        Row(
                          children: _filters.take(2).map((filter) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildFilterButton(filter),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: _filters.skip(2).map((filter) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildFilterButton(filter),
                            ),
                          )).toList(),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _filters.map((filter) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildFilterButton(filter),
                        ),
                      )).toList(),
                    ),
            ),
            
            // 武将列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16).responsive(context),
                itemCount: filteredGenerals.length,
                itemBuilder: (context, index) {
                  final general = filteredGenerals[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
                    ),
                    child: _buildGeneralCard(general),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<General> _getFilteredGenerals() {
    if (_selectedFilter == '全部') {
      return widget.gameState.generals;
    }
    return widget.gameState.generals
        .where((general) => general.position == _selectedFilter)
        .toList();
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filter 
            ? AppTheme.accentColor 
            : AppTheme.cardColor,
        foregroundColor: _selectedFilter == filter 
            ? AppTheme.primaryColor 
            : AppTheme.lightColor,
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
        minimumSize: Size(0, ResponsiveUtils.getButtonHeight(context, defaultHeight: 36)),
      ),
      child: Text(
        filter,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
        ),
      ),
    );
  }

  Widget _buildGeneralCard(General general) {
    return Card(
      child: InkWell(
        onTap: () => _showGeneralDetails(general),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16).responsive(context),
          child: Row(
            children: [
              // 武将头像
              Container(
                width: ResponsiveUtils.isExtraSmallScreen(context) ? 50 : 60,
                height: ResponsiveUtils.isExtraSmallScreen(context) ? 50 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppTheme.lightColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    general.avatar,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
              
              // 武将信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            general.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            general.rarity,
                            (index) => Icon(
                              Icons.star,
                              color: AppTheme.accentColor,
                              size: ResponsiveUtils.getIconSize(context, 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                    
                    Text(
                      ResponsiveUtils.isExtraSmallScreen(context)
                          ? '武力：${general.stats.force} | 统率：${general.stats.leadership}\n智力：${general.stats.intelligence}'
                          : '武力：${general.stats.force} | 统率：${general.stats.leadership} | 智力：${general.stats.intelligence}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                      ),
                    ),
                    
                    SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                    
                    // 经验条
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: general.experience / general.maxExperience,
                          backgroundColor: AppTheme.lightColor.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                        ),
                        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '等级：${general.level}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                              ),
                            ),
                            Text(
                              '经验：${general.experience}/${general.maxExperience}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
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

  void _showGeneralDetails(General general) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: ResponsiveUtils.getBottomSheetInitialHeight(context),
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24).responsive(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题栏
                Row(
                  children: [
                    Container(
                      width: ResponsiveUtils.isExtraSmallScreen(context) ? 60 : 80,
                      height: ResponsiveUtils.isExtraSmallScreen(context) ? 60 : 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: AppTheme.lightColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          general.avatar,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
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
                            general.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                general.position,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.accentColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: List.generate(
                                  general.rarity,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: AppTheme.accentColor,
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
                
                // 属性面板
                _buildSectionTitle('属性'),
                const SizedBox(height: 12),
                _buildStatRow('武力', general.stats.force, 100),
                _buildStatRow('智力', general.stats.intelligence, 100),
                _buildStatRow('统率', general.stats.leadership, 100),
                _buildStatRow('速度', general.stats.speed, 15),
                _buildStatRow('兵力', general.stats.troops, 3000),
                
                const SizedBox(height: 24),
                
                // 技能
                _buildSectionTitle('技能'),
                const SizedBox(height: 12),
                ...general.skills.map((skill) => _buildSkillCard(skill)),
                
                const SizedBox(height: 24),
                
                // 装备
                _buildSectionTitle('装备'),
                const SizedBox(height: 12),
                _buildEquipmentSlot('武器', general.weapon),
                _buildEquipmentSlot('防具', general.armor),
                _buildEquipmentSlot('饰品', general.accessory),
                
                const SizedBox(height: 24),
                
                // 传记
                _buildSectionTitle('传记'),
                const SizedBox(height: 12),
                Text(
                  general.biography,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 操作按钮
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleUpgradeButtonPress(general),
                        icon: const Icon(Icons.trending_up),
                        label: const Text('升级'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GeneralService.canUpgrade(general, widget.gameState)
                              ? AppTheme.accentColor 
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showGeneralPower(general),
                        icon: const Icon(Icons.flash_on),
                        label: const Text('战力'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildStatRow(String label, int value, int maxValue) {
    final percentage = value / maxValue;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppTheme.lightColor.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(Skill skill) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.primaryColor.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  skill.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: skill.type == SkillType.active 
                        ? AppTheme.accentColor.withOpacity(0.2)
                        : AppTheme.lightColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill.type == SkillType.active ? '主动' : '被动',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              skill.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (skill.type == SkillType.active) ...[
              const SizedBox(height: 4),
              Text(
                '冷却时间：${skill.cooldown}回合',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightColor.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentSlot(String slotName, Equipment? equipment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              _getEquipmentIcon(slotName),
              color: AppTheme.accentColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slotName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    equipment?.name ?? '未装备',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: equipment != null 
                          ? AppTheme.accentColor 
                          : AppTheme.lightColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEquipmentIcon(String slotName) {
    switch (slotName) {
      case '武器':
        return Icons.sports_martial_arts;
      case '防具':
        return Icons.shield;
      case '饰品':
        return Icons.diamond;
      default:
        return Icons.help_outline;
    }
  }

  void _handleUpgradeButtonPress(General general) {
    if (GeneralService.canUpgrade(general, widget.gameState)) {
      // 可以升级，执行正常升级流程
      _levelUpGeneral(general);
    } else {
      // 不可升级，显示原因提示
      _showUpgradeNotAvailableDialog(general);
    }
  }

  Future<void> _levelUpGeneral(General general) async {
    // 显示升级确认对话框
    final confirmed = await _showUpgradeConfirmDialog(general);
    if (!confirmed) return;

    // 执行升级
    final result = GeneralService.upgradeGeneral(general, widget.gameState);
    
    if (!result.success) {
      // 升级失败，显示错误信息
      if (mounted) {
        _showUpgradeFailedDialog(result.message);
      }
      return;
    }

    // 升级成功，更新游戏状态
    final updatedGenerals = widget.gameState.generals.map((g) {
      return g.id == general.id ? result.upgradedGeneral! as General : g;
    }).toList();

    // 消耗材料
    final updatedMaterials = MaterialService.consumeMaterials(
      widget.gameState.materials,
      MaterialService.getUpgradeRequirements(general.level, general.rarity),
    );

    // 扣除银币
    final coinCost = MaterialService.getUpgradeRequirements(general.level, general.rarity)
        .firstWhere((req) => req.materialId == 'coins')
        .quantity;
    
    final updatedGameState = widget.gameState.copyWith(
      generals: updatedGenerals,
      materials: updatedMaterials,
      coins: widget.gameState.coins - coinCost,
    );
    
    await GameDataService.saveGameState(updatedGameState);
    
    if (mounted) {
      AudioService.playSound(SoundEffect.levelUp);
      
      _showUpgradeSuccessDialog(result.message);
      
      // 刷新界面
      setState(() {});
    }
  }

  Future<bool> _showUpgradeConfirmDialog(General general) async {
    final preview = GeneralService.getUpgradePreview(general);
    if (!preview['canUpgrade']) {
      _showUpgradeFailedDialog(preview['reason']);
      return false;
    }

    final requirements = preview['requirements'] as List<material.UpgradeRequirement>;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('升级 ${general.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '等级：${preview['currentLevel']} → ${preview['newLevel']}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text('属性提升：', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              ...preview['statChanges'].entries.map<Widget>((entry) {
                final statName = _getStatDisplayName(entry.key);
                final change = entry.value as int;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '$statName: +$change',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightColor,
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Text('消耗材料：', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              ...requirements.map<Widget>((req) {
                final material = MaterialService.getMaterial(req.materialId);
                final playerQuantity = MaterialService.getMaterialQuantity(
                  widget.gameState.materials,
                  req.materialId,
                );
                final hasEnough = req.materialId == 'coins' 
                    ? widget.gameState.coins >= req.quantity
                    : playerQuantity >= req.quantity;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        material?.icon ?? '?',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${material?.name ?? req.materialId}: ${req.quantity}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: hasEnough ? AppTheme.lightColor : Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        req.materialId == 'coins' 
                            ? '(${widget.gameState.coins})'
                            : '($playerQuantity)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: hasEnough ? AppTheme.accentColor : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightColor,
            ),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryColor,
            ),
            child: const Text('确认升级'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showUpgradeFailedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('升级失败'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showUpgradeSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('升级成功！'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showUpgradeNotAvailableDialog(General general) {
    // 检查具体的不可升级原因
    String title = '无法升级';
    String message = '';
    List<Widget> contentWidgets = [];

    // 检查经验是否足够
    if (general.experience < general.maxExperience) {
      title = '经验不足';
      message = '武将需要更多经验才能升级';
      contentWidgets = [
        Text(message),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '当前经验：${general.experience}/${general.maxExperience}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: general.experience / general.maxExperience,
                backgroundColor: AppTheme.lightColor.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              const SizedBox(height: 8),
              Text(
                '还需要 ${general.maxExperience - general.experience} 经验值',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '💡 提示：通过战斗获得经验值',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.accentColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ];
    } else {
      // 经验足够，检查材料和银币
      final requirements = MaterialService.getUpgradeRequirements(
        general.level,
        general.rarity,
      );

      // 检查银币
      final coinRequirement = requirements.firstWhere(
        (req) => req.materialId == 'coins',
        orElse: () => material.UpgradeRequirement(materialId: 'coins', quantity: 0),
      );

      final missingMaterials = <String>[];
      
      if (widget.gameState.coins < coinRequirement.quantity) {
        missingMaterials.add('银币: 缺少 ${coinRequirement.quantity - widget.gameState.coins} 个');
      }

      // 检查其他材料
      final materialRequirements = requirements.where((req) => req.materialId != 'coins').toList();
      for (final req in materialRequirements) {
        final material = MaterialService.getMaterial(req.materialId);
        final playerQuantity = MaterialService.getMaterialQuantity(
          widget.gameState.materials,
          req.materialId,
        );
        
        if (playerQuantity < req.quantity) {
          missingMaterials.add('${material?.name ?? req.materialId}: 缺少 ${req.quantity - playerQuantity} 个');
        }
      }

      if (missingMaterials.isNotEmpty) {
        title = '材料不足';
        message = '升级需要以下材料：';
        contentWidgets = [
          Text(message),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '缺少材料：',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ...missingMaterials.map((missing) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.close, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        missing,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '💡 提示：通过战斗、商店或任务获得材料',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.accentColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ];
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  String _getStatDisplayName(String statKey) {
    switch (statKey) {
      case 'force': return '武力';
      case 'intelligence': return '智力';
      case 'leadership': return '统率';
      case 'speed': return '速度';
      case 'troops': return '兵力';
      default: return statKey;
    }
  }

  void _showGeneralPower(General general) {
    final power = GeneralService.calculatePower(general);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('${general.name} 的战力'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              power.toString(),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '战力计算包含：\n• 基础属性\n• 装备加成\n• 等级加成',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: AppTheme.primaryColor,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}