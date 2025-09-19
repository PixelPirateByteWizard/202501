import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../models/stage.dart';
import '../models/general.dart';
import '../models/formation.dart';
import '../services/game_data_service.dart';

class BattleScreen extends StatefulWidget {
  final Stage stage;

  const BattleScreen({super.key, required this.stage});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

enum BattlePhase { preparation, battle, ended }

class _BattleScreenState extends State<BattleScreen> {
  List<General> _allGenerals = [];
  List<General> _selectedGenerals = [];
  Formation? _currentFormation;
  List<String> _battleLog = [];
  int _playerHealth = 100;
  int _enemyHealth = 100;
  int _currentRound = 1;
  BattlePhase _battlePhase = BattlePhase.preparation;
  bool _playerWon = false;
  General? _selectedGeneral;
  int _maxGenerals = 6; // 最多可上阵6个武将
  
  // 回合制相关状态
  Set<String> _actedGeneralsThisRound = {}; // 本回合已行动的武将ID
  bool _isPlayerTurn = true; // 是否玩家回合
  bool _isProcessingAction = false; // 是否正在处理行动
  
  // UI状态
  bool _isSelectedGeneralsExpanded = false; // 出战武将卡片是否展开

  @override
  void initState() {
    super.initState();
    _loadBattleData();
  }

  Future<void> _loadBattleData() async {
    final generals = await GameDataService.getGenerals();
    final formation = await GameDataService.getCurrentFormation();
    
    setState(() {
      _allGenerals = generals;
      _currentFormation = formation;
      // 从阵型中获取已选择的武将
      _selectedGenerals = _getGeneralsFromFormation(formation, generals);
    });
  }

  List<General> _getGeneralsFromFormation(Formation formation, List<General> allGenerals) {
    final selectedGenerals = <General>[];
    for (final generalId in formation.positions) {
      if (generalId != null) {
        final general = allGenerals.firstWhere(
          (g) => g.id == generalId,
          orElse: () => allGenerals.first,
        );
        if (!selectedGenerals.contains(general)) {
          selectedGenerals.add(general);
        }
      }
    }
    return selectedGenerals;
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
              if (_battlePhase == BattlePhase.preparation) ...[
                _buildPreparationPhase(),
              ] else ...[
                _buildBattleField(),
                _buildBattleLog(),
                _buildBattleActions(),
              ],
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
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.primaryGold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stage.name,
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.stage.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (_battlePhase != BattlePhase.preparation) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '第$_currentRound回合',
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (_currentFormation != null && _battlePhase == BattlePhase.preparation) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.grid_view, color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '当前阵型: ${_currentFormation!.name}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPreparationPhase() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormationInfo(),
            const SizedBox(height: 20),
            _buildGeneralSelection(),
            const SizedBox(height: 20),
            _buildSelectedGenerals(),
            const SizedBox(height: 20),
            _buildStartBattleButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormationInfo() {
    if (_currentFormation == null) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view, color: AppTheme.primaryGold, size: 20),
              const SizedBox(width: 8),
              const Text(
                '阵型效果',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentFormation!.description,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _currentFormation!.bonuses.entries.map((entry) {
              final isPositive = entry.value > 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_getStatDisplayName(entry.key)} ${isPositive ? '+' : ''}${entry.value}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSelection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: AppTheme.primaryGold, size: 20),
              const SizedBox(width: 8),
              Text(
                '选择武将 (${_selectedGenerals.length}/$_maxGenerals)',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _allGenerals.length,
            itemBuilder: (context, index) {
              final general = _allGenerals[index];
              final isSelected = _selectedGenerals.contains(general);
              final canSelect = !isSelected && _selectedGenerals.length < _maxGenerals;
              
              return GestureDetector(
                onTap: () => _toggleGeneralSelection(general),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? AppTheme.primaryGold.withValues(alpha: 0.2)
                      : AppTheme.cardBackgroundDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                        ? AppTheme.primaryGold 
                        : AppTheme.textSecondary.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppTheme.primaryGold 
                            : AppTheme.textSecondary.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            general.avatar,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppTheme.backgroundDark : AppTheme.textLight,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        general.name,
                        style: TextStyle(
                          color: isSelected ? AppTheme.primaryGold : AppTheme.textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Lv.${general.level}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 2),
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryGold,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedGenerals() {
    if (_selectedGenerals.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: const Center(
          child: Text(
            '请选择至少一名武将参战',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isSelectedGeneralsExpanded = !_isSelectedGeneralsExpanded;
              });
            },
            child: Row(
              children: [
                const Icon(Icons.military_tech, color: AppTheme.primaryGold, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '出战武将',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_selectedGenerals.length})',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '总战力: ${_calculateTotalPower()}',
                  style: const TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isSelectedGeneralsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppTheme.primaryGold,
                ),
              ],
            ),
          ),
          if (_isSelectedGeneralsExpanded) ...[
            const SizedBox(height: 12),
            ...(_selectedGenerals.map((general) => _buildGeneralCard(general))),
          ] else ...[
            const SizedBox(height: 8),
            // 折叠状态下显示简化的武将列表
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedGenerals.length,
                itemBuilder: (context, index) {
                  final general = _selectedGenerals[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryGold,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              general.avatar,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.backgroundDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          general.name,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGeneralCard(General general) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppTheme.primaryGold,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                general.avatar,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.backgroundDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  general.name,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  general.position,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Lv.${general.level}',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '战力: ${_calculateGeneralPower(general)}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _toggleGeneralSelection(general),
            icon: const Icon(
              Icons.remove_circle,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartBattleButton() {
    final canStartBattle = _selectedGenerals.isNotEmpty;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: canStartBattle ? _startBattle : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
          foregroundColor: AppTheme.backgroundDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          canStartBattle ? '开始战斗' : '请选择武将',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBattleField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 战斗状态
          Row(
            children: [
              // Player Army
              Expanded(
                child: _buildArmyStatus(
                  name: '我军',
                  health: _playerHealth,
                  isPlayer: true,
                ),
              ),
              
              // Battle Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
              ),
              
              // Enemy Army
              Expanded(
                child: _buildArmyStatus(
                  name: '敌军',
                  health: _enemyHealth,
                  isPlayer: false,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 当前选中的武将
          if (_selectedGeneral != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryGold),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryGold,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _selectedGeneral!.avatar,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.backgroundDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '当前操作: ${_selectedGeneral!.name}',
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
        ],
      ),
    );
  }

  Widget _buildArmyStatus({
    required String name,
    required int health,
    required bool isPlayer,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              color: isPlayer ? AppTheme.primaryGold : Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '生命值: $health/100',
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          
          // Health Bar
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.cardBackgroundDark.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: health / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPlayer
                        ? [AppTheme.primaryGold, AppTheme.lightGold]
                        : [Colors.red, Colors.redAccent],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleLog() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.history,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  '战斗记录',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackgroundDark.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _battleLog.isEmpty
                    ? const Center(
                        child: Text(
                          '战斗尚未开始...',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _battleLog.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _battleLog[index],
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleActions() {
    if (_battlePhase == BattlePhase.ended) {
      return _buildBattleResult();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.touch_app,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                '战斗操作',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 回合状态显示
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isPlayerTurn 
                ? AppTheme.primaryGold.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isPlayerTurn ? AppTheme.primaryGold : Colors.red,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPlayerTurn ? Icons.person : Icons.computer,
                  color: _isPlayerTurn ? AppTheme.primaryGold : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isProcessingAction 
                    ? '处理中...' 
                    : _isPlayerTurn 
                      ? '玩家回合' 
                      : '敌军回合',
                  style: TextStyle(
                    color: _isPlayerTurn ? AppTheme.primaryGold : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 武将选择
          const Text(
            '选择操作武将:',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedGenerals.length,
              itemBuilder: (context, index) {
                final general = _selectedGenerals[index];
                final isSelected = _selectedGeneral == general;
                final hasActed = _actedGeneralsThisRound.contains(general.id);
                
                return GestureDetector(
                  onTap: () => _selectGeneralForAction(general),
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasActed 
                        ? Colors.grey.withValues(alpha: 0.5)
                        : isSelected 
                          ? AppTheme.primaryGold.withValues(alpha: 0.2)
                          : AppTheme.cardBackgroundDark.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryGold : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: hasActed 
                                  ? Colors.grey 
                                  : isSelected 
                                    ? AppTheme.primaryGold 
                                    : AppTheme.textSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  general.avatar,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: hasActed 
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : isSelected 
                                        ? AppTheme.backgroundDark 
                                        : AppTheme.textLight,
                                  ),
                                ),
                              ),
                            ),
                            if (hasActed)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasActed ? '${general.name}(已行动)' : general.name,
                          style: TextStyle(
                            color: hasActed 
                              ? Colors.grey 
                              : isSelected 
                                ? AppTheme.primaryGold 
                                : AppTheme.textLight,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _canPerformAction() ? _performAttack : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('普通攻击'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canPerformAction() ? _useSkill : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('释放技能'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isPlayerTurn && !_isProcessingAction ? _endTurn : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.backgroundDark,
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(_isProcessingAction ? '处理中...' : '结束回合'),
            ),
          ),
        ],
      ),
    );
  }

  // 辅助方法
  void _toggleGeneralSelection(General general) {
    setState(() {
      if (_selectedGenerals.contains(general)) {
        _selectedGenerals.remove(general);
      } else if (_selectedGenerals.length < _maxGenerals) {
        _selectedGenerals.add(general);
      }
    });
  }

  void _selectGeneralForAction(General general) {
    setState(() {
      _selectedGeneral = general;
    });
  }

  int _calculateGeneralPower(General general) {
    return general.attack + general.defense + general.intelligence + general.speed;
  }

  int _calculateTotalPower() {
    int totalPower = 0;
    for (final general in _selectedGenerals) {
      totalPower += _calculateGeneralPower(general);
    }
    
    // 应用阵型加成
    if (_currentFormation != null) {
      for (final bonus in _currentFormation!.bonuses.entries) {
        if (bonus.key == 'attack') {
          totalPower = (totalPower * (1 + bonus.value / 100)).round();
        }
      }
    }
    
    return totalPower;
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
      case 'damage_taken':
        return '承伤';
      default:
        return statKey;
    }
  }

  void _startBattle() {
    if (_selectedGenerals.isEmpty) return;
    
    setState(() {
      _battlePhase = BattlePhase.battle;
      _selectedGeneral = _selectedGenerals.first;
      _battleLog.clear();
      _actedGeneralsThisRound.clear();
      _isPlayerTurn = true;
      _isProcessingAction = false;
      _currentRound = 1;
      
      _battleLog.add('战斗开始！');
      _battleLog.add('我军出战武将：${_selectedGenerals.map((g) => g.name).join('、')}');
      if (_currentFormation != null) {
        _battleLog.add('使用阵型：${_currentFormation!.name}');
      }
      _battleLog.add('--- 第 $_currentRound 回合开始 ---');
    });
  }

  void _performAttack() {
    if (_selectedGeneral == null || _isProcessingAction || !_isPlayerTurn) {
      _showActionNotAllowedMessage('现在无法进行攻击');
      return;
    }
    
    // 检查该武将本回合是否已经行动
    if (_actedGeneralsThisRound.contains(_selectedGeneral!.id)) {
      _showActionNotAllowedMessage('${_selectedGeneral!.name} 本回合已经行动过了');
      return;
    }
    
    setState(() {
      _isProcessingAction = true;
    });
    
    final damage = Random().nextInt(20) + 10;
    setState(() {
      _enemyHealth = (_enemyHealth - damage).clamp(0, 100);
      _battleLog.add('${_selectedGeneral!.name} 对敌军造成了 $damage 点伤害！');
      _actedGeneralsThisRound.add(_selectedGeneral!.id);
      _isProcessingAction = false;
      
      if (_enemyHealth <= 0) {
        _endBattle(true);
      }
    });
  }

  void _useSkill() {
    if (_selectedGeneral == null || _isProcessingAction || !_isPlayerTurn) {
      _showActionNotAllowedMessage('现在无法释放技能');
      return;
    }
    
    if (_selectedGeneral!.skills.isEmpty) {
      _showActionNotAllowedMessage('${_selectedGeneral!.name} 没有可用技能');
      return;
    }
    
    // 检查该武将本回合是否已经行动
    if (_actedGeneralsThisRound.contains(_selectedGeneral!.id)) {
      _showActionNotAllowedMessage('${_selectedGeneral!.name} 本回合已经行动过了');
      return;
    }
    
    setState(() {
      _isProcessingAction = true;
    });
    
    final skill = _selectedGeneral!.skills.first;
    final damage = Random().nextInt(30) + 15;
    
    setState(() {
      _enemyHealth = (_enemyHealth - damage).clamp(0, 100);
      _battleLog.add('${_selectedGeneral!.name} 使用技能「$skill」造成了 $damage 点伤害！');
      _actedGeneralsThisRound.add(_selectedGeneral!.id);
      _isProcessingAction = false;
      
      if (_enemyHealth <= 0) {
        _endBattle(true);
      }
    });
  }

  void _endTurn() {
    if (_enemyHealth <= 0 || _isProcessingAction) return;
    
    setState(() {
      _isProcessingAction = true;
      _isPlayerTurn = false;
    });
    
    // 敌军回合
    Future.delayed(const Duration(milliseconds: 1000), () {
      final enemyDamage = Random().nextInt(15) + 5;
      setState(() {
        _playerHealth = (_playerHealth - enemyDamage).clamp(0, 100);
        _battleLog.add('敌军反击造成了 $enemyDamage 点伤害！');
        
        if (_playerHealth <= 0) {
          _endBattle(false);
          return;
        }
        
        // 开始新回合
        _currentRound++;
        _actedGeneralsThisRound.clear(); // 清空已行动武将列表
        _isPlayerTurn = true;
        _isProcessingAction = false;
        _battleLog.add('--- 第 $_currentRound 回合开始 ---');
      });
    });
  }

  void _endBattle(bool playerWon) {
    setState(() {
      _battlePhase = BattlePhase.ended;
      _playerWon = playerWon;
      _battleLog.add(playerWon ? '战斗胜利！' : '战斗失败！');
    });
  }

  Widget _buildBattleResult() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Icon(
            _playerWon ? Icons.emoji_events : Icons.close,
            color: _playerWon ? AppTheme.primaryGold : Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _playerWon ? '战斗胜利！' : '战斗失败！',
            style: TextStyle(
              color: _playerWon ? AppTheme.primaryGold : Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_playerWon) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '战斗奖励',
                    style: TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.monetization_on, color: AppTheme.primaryGold),
                          Text(
                            '+${widget.stage.rewards['gold'] ?? 0}',
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.star, color: Colors.blue),
                          Text(
                            '+${widget.stage.rewards['experience'] ?? 0}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textSecondary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('返回'),
                ),
              ),
              const SizedBox(width: 12),
              if (_playerWon) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _claimRewards,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: AppTheme.backgroundDark,
                    ),
                    child: const Text('领取奖励'),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _restartBattle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('重新挑战'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _claimRewards() async {
    // 发放奖励逻辑
    final progress = await GameDataService.getGameProgress();
    final goldReward = widget.stage.rewards['gold'] ?? 0;
    final expReward = widget.stage.rewards['experience'] ?? 0;
    
    final updatedProgress = progress.copyWith(
      gold: progress.gold + goldReward,
      experience: progress.experience + expReward,
    );
    
    await GameDataService.saveGameProgress(updatedProgress);
    
    // 完成关卡并解锁下一关
    await GameDataService.completeStage(widget.stage.id);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('奖励已领取！关卡已完成！'),
          backgroundColor: AppTheme.primaryGold,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true); // 返回true表示关卡已完成
    }
  }

  void _restartBattle() {
    setState(() {
      _battlePhase = BattlePhase.preparation;
      _playerHealth = 100;
      _enemyHealth = 100;
      _currentRound = 1;
      _selectedGeneral = null;
      _battleLog.clear();
      _actedGeneralsThisRound.clear();
      _isPlayerTurn = true;
      _isProcessingAction = false;
    });
  }

  void _showActionNotAllowedMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  bool _canPerformAction() {
    return _selectedGeneral != null && 
           _isPlayerTurn && 
           !_isProcessingAction && 
           !_actedGeneralsThisRound.contains(_selectedGeneral!.id);
  }
}