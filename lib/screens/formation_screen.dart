import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../models/general.dart';
import '../models/battle.dart';
import '../services/game_data_service.dart';

class FormationScreen extends StatefulWidget {
  final GameState gameState;

  const FormationScreen({super.key, required this.gameState});

  @override
  State<FormationScreen> createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  late Formation _currentFormation;
  final List<General?> _formationSlots = List.filled(9, null);
  List<Formation> _availableFormations = [];

  @override
  void initState() {
    super.initState();
    _currentFormation = widget.gameState.currentFormation;
    _availableFormations = GameDataService.getAllFormations();
    _initializeFormation();
  }

  void _initializeFormation() {
    // 初始化阵型，将已部署的武将放入对应位置
    for (int i = 0; i < widget.gameState.generals.length && i < 9; i++) {
      _formationSlots[i] = widget.gameState.generals[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('阵型布局'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveFormation,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 当前阵型信息
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '当前阵型：${_currentFormation.name}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          ElevatedButton(
                            onPressed: _showFormationSelector,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: const Text('更换阵型'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentFormation.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 阵型网格
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '阵型布局',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) => _buildFormationSlot(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 可用武将
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '可用武将',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: widget.gameState.generals
                                  .map((general) => Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: _buildGeneralAvatar(general, isInFormation: _formationSlots.contains(general)),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormationSlot(int index) {
    final position = _currentFormation.positions[index];
    final general = _formationSlots[index];
    final hasBonus = position.bonuses.isNotEmpty;

    return DragTarget<General>(
      onAccept: (general) {
        setState(() {
          // 移除武将在其他位置的部署
          for (int i = 0; i < _formationSlots.length; i++) {
            if (_formationSlots[i] == general) {
              _formationSlots[i] = null;
            }
          }
          // 将武将部署到新位置
          _formationSlots[index] = general;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (general != null) {
              _showPositionInfo(position, general);
            } else {
              _showPositionInfo(position, null);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: general != null 
                  ? AppTheme.accentColor.withOpacity(0.3)
                  : AppTheme.primaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasBonus 
                    ? AppTheme.accentColor 
                    : AppTheme.accentColor.withOpacity(0.3),
                width: hasBonus ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (general != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.accentColor, Color(0xFFb8941f)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        general.avatar,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    general.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else ...[
                  Icon(
                    Icons.add,
                    color: AppTheme.lightColor.withOpacity(0.5),
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  position.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: AppTheme.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralAvatar(General general, {required bool isInFormation}) {
    return Draggable<General>(
      data: general,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.accentColor, Color(0xFFb8941f)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              general.avatar,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ),
      child: Opacity(
        opacity: isInFormation ? 0.5 : 1.0,
        child: Container(
          width: 60,
          height: 60,
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPositionInfo(FormationPosition position, General? general) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(
          position.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (general != null) ...[
              Text(
                '当前武将：${general.name}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '位置加成：',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (position.bonuses.isEmpty)
              Text(
                '无特殊加成',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ...position.bonuses.entries.map((entry) => Text(
                '${_getBonusName(entry.key)}：${_formatBonus(entry.value)}',
                style: Theme.of(context).textTheme.bodyMedium,
              )),
            if (general != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _formationSlots[_formationSlots.indexOf(general)] = null;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.7),
                  ),
                  child: const Text('移除武将'),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showFormationSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择阵型',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ..._availableFormations.map((formation) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: formation.id == _currentFormation.id 
                  ? AppTheme.accentColor.withOpacity(0.3)
                  : AppTheme.primaryColor.withOpacity(0.3),
              child: ListTile(
                title: Text(
                  formation.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: formation.id == _currentFormation.id 
                        ? AppTheme.accentColor 
                        : AppTheme.lightColor,
                  ),
                ),
                subtitle: Text(
                  formation.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  setState(() {
                    _currentFormation = formation;
                  });
                  Navigator.pop(context);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _getBonusName(String bonusKey) {
    switch (bonusKey) {
      case 'damage':
        return '伤害';
      case 'defense':
        return '防御';
      case 'takeDamage':
        return '承伤';
      case 'morale':
        return '士气';
      case 'stability':
        return '稳定';
      default:
        return bonusKey;
    }
  }

  String _formatBonus(double value) {
    final percentage = (value * 100).toInt();
    return percentage > 0 ? '+$percentage%' : '$percentage%';
  }

  Future<void> _saveFormation() async {
    // 创建新的游戏状态，包含更新的阵型和武将位置
    final updatedGenerals = <General>[];
    final deployedGenerals = <General>[];
    
    // 收集已部署的武将
    for (int i = 0; i < _formationSlots.length; i++) {
      if (_formationSlots[i] != null) {
        deployedGenerals.add(_formationSlots[i]!);
      }
    }
    
    // 添加已部署的武将（按位置顺序）
    updatedGenerals.addAll(deployedGenerals);
    
    // 添加未部署的武将
    for (final general in widget.gameState.generals) {
      if (!deployedGenerals.contains(general)) {
        updatedGenerals.add(general);
      }
    }
    
    final updatedGameState = widget.gameState.copyWith(
      currentFormation: _currentFormation,
      generals: updatedGenerals,
    );
    
    final success = await GameDataService.saveGameState(updatedGameState);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '阵型已保存' : '保存失败，请重试'),
          backgroundColor: success ? AppTheme.accentColor : Colors.red,
        ),
      );
    }
  }
}