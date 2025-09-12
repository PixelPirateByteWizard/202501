import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../models/battle.dart';
import '../models/general.dart';
import '../services/battle_system.dart';
import '../services/general_service.dart';
import '../services/game_data_service.dart';

class BattleScreen extends StatefulWidget {
  final GameState gameState;
  final List<General>? customEnemies;
  final String? battleName;
  final String? battleDescription;

  const BattleScreen({
    super.key,
    required this.gameState,
    this.customEnemies,
    this.battleName,
    this.battleDescription,
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen>
    with TickerProviderStateMixin {
  late Battle _battle;
  List<BattleLog> _battleLogs = [];
  BattleUnit? _selectedUnit;
  bool _isProcessing = false;
  Timer? _logTimer;
  late AnimationController _battleAnimationController;
  late AnimationController _logAnimationController;
  late Animation<double> _battleAnimation;
  late Animation<double> _logAnimation;

  @override
  void initState() {
    super.initState();
    _battleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _battleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _battleAnimationController,
        curve: Curves.easeOutQuart,
      ),
    );
    _logAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _initializeBattle();

    // 启动动画
    Future.delayed(const Duration(milliseconds: 300), () {
      _battleAnimationController.forward();
      _logAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    _battleAnimationController.dispose();
    _logAnimationController.dispose();
    super.dispose();
  }

  void _initializeBattle() {
    // 创建玩家单位
    final playerUnits = widget.gameState.generals
        .take(3)
        .map(
          (general) => BattleUnit(
            general: general,
            currentTroops: general.stats.troops,
            maxTroops: general.stats.troops,
            position: widget.gameState.generals.indexOf(general),
            isPlayer: true,
          ),
        )
        .toList();

    // 创建敌军单位
    final enemyUnits = widget.customEnemies != null
        ? _createCustomEnemyUnits(widget.customEnemies!)
        : _createDefaultEnemyUnits();

    final battleName = widget.battleName ?? '官渡之战';
    final battleDescription =
        widget.battleDescription ?? '袁绍大军压境，曹操以少敌多，此战关乎天下大势！';

    _battle = Battle(
      id: 'battle_${DateTime.now().millisecondsSinceEpoch}',
      name: battleName,
      description: battleDescription,
      playerUnits: playerUnits,
      enemyUnits: enemyUnits,
      playerFormation: widget.gameState.currentFormation,
      enemyFormation: widget.gameState.currentFormation, // 简化处理
      phase: BattlePhase.combat,
    );

    _addBattleLog('【战斗开始】$battleDescription', BattleLogType.info);
    _addBattleLog(
      '【我军】${playerUnits.map((u) => u.general.name).join('、')}严阵以待！',
      BattleLogType.info,
    );
    _addBattleLog(
      '【敌军】${enemyUnits.map((u) => u.general.name).join('、')}来势汹汹！',
      BattleLogType.info,
    );
  }

  List<BattleUnit> _createCustomEnemyUnits(List<General> enemies) {
    return enemies
        .map(
          (general) => BattleUnit(
            general: general,
            currentTroops: general.stats.troops,
            maxTroops: general.stats.troops,
            position: enemies.indexOf(general),
            isPlayer: false,
          ),
        )
        .toList();
  }

  List<BattleUnit> _createDefaultEnemyUnits() {
    // 创建敌军武将
    final enemyGenerals = [
      General(
        id: 'yuanshao',
        name: '袁绍',
        avatar: '袁',
        rarity: 4,
        level: 45,
        experience: 0,
        maxExperience: 1000,
        stats: GeneralStats(
          force: 75,
          intelligence: 60,
          leadership: 95,
          speed: 6,
          troops: 3000,
        ),
        skills: [
          Skill(
            id: 'authority',
            name: '威权',
            description: '凭借威望震慑敌军，降低敌方士气',
            type: SkillType.active,
            cooldown: 3,
          ),
        ],
        biography: '四世三公，门第显赫，拥兵十万，意图一统天下。',
        position: '统帅',
      ),
      General(
        id: 'yanliang',
        name: '颜良',
        avatar: '颜',
        rarity: 3,
        level: 40,
        experience: 0,
        maxExperience: 800,
        stats: GeneralStats(
          force: 95,
          intelligence: 45,
          leadership: 70,
          speed: 8,
          troops: 2200,
        ),
        skills: [
          Skill(
            id: 'fierce_attack',
            name: '猛攻',
            description: '发动猛烈攻击，造成大量伤害',
            type: SkillType.active,
            cooldown: 2,
          ),
        ],
        biography: '河北名将，勇冠三军，有万夫不当之勇。',
        position: '前锋',
      ),
      General(
        id: 'wenchou',
        name: '文丑',
        avatar: '文',
        rarity: 3,
        level: 38,
        experience: 0,
        maxExperience: 800,
        stats: GeneralStats(
          force: 92,
          intelligence: 50,
          leadership: 68,
          speed: 9,
          troops: 2000,
        ),
        skills: [
          Skill(
            id: 'charge',
            name: '冲锋',
            description: '骑兵冲锋，对敌方前排造成伤害',
            type: SkillType.active,
            cooldown: 2,
          ),
        ],
        biography: '河北猛将，与颜良齐名，骁勇善战。',
        position: '前锋',
      ),
    ];

    return enemyGenerals
        .map(
          (general) => BattleUnit(
            general: general,
            currentTroops: general.stats.troops,
            maxTroops: general.stats.troops,
            position: enemyGenerals.indexOf(general),
            isPlayer: false,
          ),
        )
        .toList();
  }

  void _addBattleLog(String message, BattleLogType type) {
    final log = BattleLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );

    setState(() {
      _battleLogs.add(log);
    });

    // 自动滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_battleLogs.length > 10) {
        setState(() {
          _battleLogs = _battleLogs.skip(_battleLogs.length - 10).toList();
        });
      }
    });
  }

  Future<void> _executePlayerAction(BattleAction action) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      switch (action.type) {
        case BattleActionType.attack:
          await _executeAttack(action.attacker!, action.target!);
          break;
        case BattleActionType.skill:
          await _executeSkill(action.attacker!, action.target!, action.skill!);
          break;
        case BattleActionType.defend:
          await _executeDefend(action.attacker!);
          break;
      }

      // 检查战斗结束
      final endResult = BattleSystem.checkBattleEnd(
        _battle.playerUnits,
        _battle.enemyUnits,
      );
      if (endResult != null) {
        _endBattle(endResult.isVictory);
        return;
      }

      // 敌军回合
      await _executeEnemyTurn();

      // 再次检查战斗结束
      final endResult2 = BattleSystem.checkBattleEnd(
        _battle.playerUnits,
        _battle.enemyUnits,
      );
      if (endResult2 != null) {
        _endBattle(endResult2.isVictory);
        return;
      }
    } finally {
      setState(() {
        _isProcessing = false;
        _selectedUnit = null;
      });
    }
  }

  Future<void> _executeAttack(BattleUnit attacker, BattleUnit target) async {
    final result = await BattleSystem.executeAttack(
      attacker: attacker,
      target: target,
      attackerFormation: _battle.playerFormation,
      defenderFormation: _battle.enemyFormation,
    );

    // 更新单位状态
    _updateBattleUnit(result.target);

    // 添加战斗日志
    for (final log in result.battleLogs) {
      _addBattleLog(log.message, log.type);
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  Future<void> _executeSkill(
    BattleUnit attacker,
    BattleUnit target,
    Skill skill,
  ) async {
    final result = await BattleSystem.executeAttack(
      attacker: attacker,
      target: target,
      attackerFormation: _battle.playerFormation,
      defenderFormation: _battle.enemyFormation,
      skill: skill,
    );

    // 更新单位状态
    _updateBattleUnit(result.target);

    // 更新技能冷却
    final updatedGeneral = BattleSystem.updateSkillCooldown(
      attacker.general,
      skill.id,
    );
    final updatedAttacker = attacker.copyWith(general: updatedGeneral);
    _updateBattleUnit(updatedAttacker);

    // 添加战斗日志
    for (final log in result.battleLogs) {
      _addBattleLog(log.message, log.type);
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  Future<void> _executeDefend(BattleUnit unit) async {
    _addBattleLog('【防御】${unit.general.name}采取防御姿态，提升防御力！', BattleLogType.info);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _executeEnemyTurn() async {
    _addBattleLog('【敌军回合】', BattleLogType.turnStart);
    await Future.delayed(const Duration(milliseconds: 500));

    final aliveEnemies = _battle.enemyUnits.where((u) => u.isAlive).toList();
    final alivePlayerUnits = _battle.playerUnits
        .where((u) => u.isAlive)
        .toList();

    for (final enemy in aliveEnemies) {
      if (alivePlayerUnits.isEmpty) break;

      // 随机选择目标
      final target =
          alivePlayerUnits[DateTime.now().millisecondsSinceEpoch %
              alivePlayerUnits.length];

      // 随机选择行动
      final availableSkills = BattleSystem.getAvailableSkills(enemy);
      final useSkill =
          availableSkills.isNotEmpty &&
          DateTime.now().millisecondsSinceEpoch % 3 == 0;

      if (useSkill) {
        await _executeSkill(enemy, target, availableSkills.first);
      } else {
        await _executeAttack(enemy, target);
      }

      await Future.delayed(const Duration(milliseconds: 1000));
    }

    // 减少技能冷却
    for (int i = 0; i < _battle.enemyUnits.length; i++) {
      final unit = _battle.enemyUnits[i];
      final updatedGeneral = BattleSystem.reduceSkillCooldowns(unit.general);
      _battle.enemyUnits[i] = unit.copyWith(general: updatedGeneral);
    }

    for (int i = 0; i < _battle.playerUnits.length; i++) {
      final unit = _battle.playerUnits[i];
      final updatedGeneral = BattleSystem.reduceSkillCooldowns(unit.general);
      _battle.playerUnits[i] = unit.copyWith(general: updatedGeneral);
    }

    setState(() {
      _battle = _battle.copyWith(currentTurn: _battle.currentTurn + 1);
    });
  }

  void _updateBattleUnit(BattleUnit updatedUnit) {
    setState(() {
      if (updatedUnit.isPlayer) {
        final index = _battle.playerUnits.indexWhere(
          (u) => u.general.id == updatedUnit.general.id,
        );
        if (index != -1) {
          _battle.playerUnits[index] = updatedUnit;
        }
      } else {
        final index = _battle.enemyUnits.indexWhere(
          (u) => u.general.id == updatedUnit.general.id,
        );
        if (index != -1) {
          _battle.enemyUnits[index] = updatedUnit;
        }
      }
    });
  }

  void _endBattle(bool isVictory) {
    setState(() {
      _battle = _battle.copyWith(
        phase: isVictory ? BattlePhase.victory : BattlePhase.defeat,
      );
    });

    _addBattleLog(
      isVictory ? '【大获全胜】敌军溃散，我军获得辉煌胜利！' : '【败北而归】我军不敌，暂时撤退...',
      isVictory ? BattleLogType.victory : BattleLogType.defeat,
    );

    // 如果胜利，给武将增加经验
    if (isVictory) {
      _awardExperience();
    }

    // 显示结果对话框
    Future.delayed(const Duration(seconds: 2), () {
      _showBattleResult(isVictory);
    });
  }

  Future<void> _awardExperience() async {
    const expGain = 200; // 每场战斗获得200经验

    final updatedGenerals = _battle.playerUnits.map((unit) {
      if (unit.isAlive) {
        return GeneralService.gainExperience(unit.general, expGain);
      }
      return unit.general;
    }).toList();

    // 更新游戏状态
    final updatedGameState = widget.gameState.copyWith(
      generals: updatedGenerals,
      playerStats: widget.gameState.playerStats.copyWith(
        battlesWon: widget.gameState.playerStats.battlesWon + 1,
        experience: widget.gameState.playerStats.experience + expGain,
      ),
    );

    await GameDataService.saveGameState(updatedGameState);
  }

  void _showBattleResult(bool isVictory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(
          isVictory ? '胜利！' : '失败！',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: isVictory ? AppTheme.accentColor : Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isVictory ? '恭喜！你在这场战斗中取得了胜利！' : '虽败犹荣，重整旗鼓再来！',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (isVictory) ...[
              const SizedBox(height: 16),
              const Text('获得奖励：'),
              const Text('• 经验值 +500'),
              const Text('• 银币 +1000'),
              const Text('• 装备碎片 +10'),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              Navigator.pop(context, isVictory); // 返回上一页，传递胜利结果
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isVictory ? Colors.green : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2d1b69),
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 自定义AppBar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.9),
                      AppTheme.primaryColor.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.lightColor,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _battle.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '第${_battle.currentTurn}回合',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // 平衡布局
                  ],
                ),
              ),

              // 战场态势
              AnimatedBuilder(
                animation: _battleAnimation,
                builder: (context, child) {
                  final clampedValue = _battleAnimation.value.clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: 0.8 + (0.2 * clampedValue),
                    child: Opacity(
                      opacity: clampedValue,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.cardColor.withOpacity(0.9),
                              AppTheme.cardColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildArmyStatus('我军', _battle.playerUnits, true),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sports_martial_arts,
                                color: AppTheme.accentColor,
                                size: 28,
                              ),
                            ),
                            _buildArmyStatus('敌军', _battle.enemyUnits, false),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 战斗日志
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _logAnimation,
                  builder: (context, child) {
                    final clampedValue = _logAnimation.value.clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - clampedValue)),
                      child: Opacity(
                        opacity: clampedValue,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.cardColor.withOpacity(0.9),
                                AppTheme.cardColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.accentColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.live_tv,
                                      color: AppTheme.accentColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '战况直播',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontSize: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.4),
                                        Colors.black.withOpacity(0.2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.accentColor.withOpacity(
                                        0.2,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    itemCount: _battleLogs.length,
                                    itemBuilder: (context, index) {
                                      final log = _battleLogs[index];
                                      return TweenAnimationBuilder<double>(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              -20 * (1 - value),
                                              0,
                                            ),
                                            child: Opacity(
                                              opacity: value,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _getLogColor(
                                                    log.type,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: _getLogColor(
                                                      log.type,
                                                    ).withOpacity(0.3),
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  log.message,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: _getLogColor(
                                                          log.type,
                                                        ),
                                                        height: 1.4,
                                                        fontSize: 13,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 操作面板
              if (_battle.phase == BattlePhase.combat && !_isProcessing)
                _buildActionPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArmyStatus(String name, List<BattleUnit> units, bool isPlayer) {
    final aliveUnits = units.where((u) => u.isAlive).length;
    final totalTroops = units.fold(0, (sum, u) => sum + u.currentTroops);
    final maxTroops = units.fold(0, (sum, u) => sum + u.maxTroops);
    final troopsPercentage = maxTroops > 0 ? totalTroops / maxTroops : 0.0;

    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPlayer ? AppTheme.accentColor : Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '存活：$aliveUnits/${units.length}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '兵力：${(troopsPercentage * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: troopsPercentage,
            backgroundColor: AppTheme.lightColor.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              isPlayer ? AppTheme.accentColor : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.cardColor.withOpacity(0.9),
            AppTheme.cardColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.touch_app,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '选择行动',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 武将选择
          if (_selectedUnit == null) ...[
            Text(
              '选择武将：',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightColor.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _battle.playerUnits
                    .where((u) => u.isAlive)
                    .map(
                      (unit) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildUnitSelector(unit),
                      ),
                    )
                    .toList(),
              ),
            ),
          ] else ...[
            // 行动选择
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedUnit!.general.name} 的行动：',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          '攻击',
                          Icons.gps_fixed,
                          Colors.red,
                          () => _showTargetSelection(BattleActionType.attack),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          '技能',
                          Icons.auto_fix_high,
                          Colors.purple,
                          () => _showSkillSelection(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          '防御',
                          Icons.shield,
                          Colors.blue,
                          () => _executePlayerAction(
                            BattleAction(
                              type: BattleActionType.defend,
                              attacker: _selectedUnit,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => setState(() => _selectedUnit = null),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('重新选择武将'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.accentColor,
                      ),
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

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(height: 1),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitSelector(BattleUnit unit) {
    return GestureDetector(
      onTap: () => setState(() => _selectedUnit = unit),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.cardColor.withOpacity(0.8),
              AppTheme.cardColor.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  unit.general.avatar,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              unit.general.name,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: unit.troopsPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.accentColor, Color(0xFFffd700)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTargetSelection(BattleActionType actionType) {
    final aliveEnemies = _battle.enemyUnits.where((u) => u.isAlive).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('选择目标', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...aliveEnemies.map(
              (enemy) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      enemy.general.avatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(enemy.general.name),
                subtitle: LinearProgressIndicator(
                  value: enemy.troopsPercentage,
                  backgroundColor: AppTheme.lightColor.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _executePlayerAction(
                    BattleAction(
                      type: actionType,
                      attacker: _selectedUnit,
                      target: enemy,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillSelection() {
    final availableSkills = BattleSystem.getAvailableSkills(_selectedUnit!);

    if (availableSkills.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('暂无可用技能')));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('选择技能', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...availableSkills.map(
              (skill) => ListTile(
                title: Text(skill.name),
                subtitle: Text(skill.description),
                onTap: () {
                  Navigator.pop(context);
                  _showTargetSelectionForSkill(skill);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTargetSelectionForSkill(Skill skill) {
    final aliveEnemies = _battle.enemyUnits.where((u) => u.isAlive).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择 ${skill.name} 的目标',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...aliveEnemies.map(
              (enemy) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      enemy.general.avatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(enemy.general.name),
                subtitle: LinearProgressIndicator(
                  value: enemy.troopsPercentage,
                  backgroundColor: AppTheme.lightColor.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _executePlayerAction(
                    BattleAction(
                      type: BattleActionType.skill,
                      attacker: _selectedUnit,
                      target: enemy,
                      skill: skill,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLogColor(BattleLogType type) {
    switch (type) {
      case BattleLogType.attack:
        return AppTheme.lightColor;
      case BattleLogType.skill:
        return AppTheme.accentColor;
      case BattleLogType.damage:
        return Colors.red;
      case BattleLogType.heal:
        return Colors.green;
      case BattleLogType.victory:
        return AppTheme.accentColor;
      case BattleLogType.defeat:
        return Colors.red;
      case BattleLogType.info:
        return AppTheme.lightColor.withOpacity(0.8);
      default:
        return AppTheme.lightColor;
    }
  }
}

class BattleAction {
  final BattleActionType type;
  final BattleUnit? attacker;
  final BattleUnit? target;
  final Skill? skill;

  BattleAction({required this.type, this.attacker, this.target, this.skill});
}

enum BattleActionType { attack, skill, defend }
