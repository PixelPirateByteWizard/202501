import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/formation.dart';
import '../models/general.dart';
import '../services/game_data_service.dart';

class FormationScreen extends StatefulWidget {
  const FormationScreen({super.key});

  @override
  State<FormationScreen> createState() => _FormationScreenState();
}

class _FormationScreenState extends State<FormationScreen> {
  Formation? _currentFormation;
  List<General> _availableGenerals = [];
  List<FormationType> _formationTypes = [];
  bool _isLoading = true;
  bool _showFormationSelector = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final formation = await GameDataService.getCurrentFormation();
    final generals = await GameDataService.getGenerals();
    final types = GameDataService.getFormationTypes();
    
    setState(() {
      _currentFormation = formation;
      _availableGenerals = generals;
      _formationTypes = types;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
                  ),
                )
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildCurrentFormationInfo(),
                            const SizedBox(height: 20),
                            _buildFormationGrid(),
                            const SizedBox(height: 20),
                            _buildAvailableGenerals(),
                          ],
                        ),
                      ),
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '阵型布局',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _saveFormation,
            icon: const Icon(
              Icons.save,
              color: AppTheme.primaryGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentFormationInfo() {
    if (_currentFormation == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '当前阵型：${_currentFormation!.name}',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showFormationSelector = true;
                  });
                  _showFormationTypeSelector();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('更换阵型'),
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
        ],
      ),
    );
  }

  Widget _buildFormationGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '阵型布局',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return _buildPositionSlot(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPositionSlot(int index) {
    final generalId = _currentFormation?.positions[index];
    final general = generalId != null 
        ? _availableGenerals.firstWhere(
            (g) => g.id == generalId,
            orElse: () => _availableGenerals.first,
          )
        : null;

    return GestureDetector(
      onTap: () => _onPositionTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: general != null 
              ? AppTheme.primaryGold.withOpacity(0.2)
              : AppTheme.cardBackgroundDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryGold.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: general != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                  const SizedBox(height: 4),
                  Text(
                    general.name,
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: AppTheme.primaryGold,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPositionName(index),
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAvailableGenerals() {
    final undeployedGenerals = _availableGenerals.where((general) {
      return !(_currentFormation?.positions.contains(general.id) ?? false);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '可用武将',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (undeployedGenerals.isEmpty)
            const Center(
              child: Text(
                '所有武将都已部署',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 14,
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: undeployedGenerals.map((general) {
                return GestureDetector(
                  onTap: () => _onGeneralTapped(general),
                  child: Container(
                    width: 60,
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackgroundDark.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGold.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: AppTheme.goldGradient.copyWith(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              general.avatar,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          general.name,
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  String _getPositionName(int index) {
    const positions = [
      '左前', '中前', '右前',
      '左中', '中军', '右中',
      '左后', '中后', '右后',
    ];
    return positions[index];
  }

  void _onPositionTapped(int index) {
    final generalId = _currentFormation?.positions[index];
    if (generalId != null) {
      // 移除武将
      setState(() {
        _currentFormation = _currentFormation!.copyWith(
          positions: List.from(_currentFormation!.positions)..[index] = null,
        );
      });
    }
  }

  void _onGeneralTapped(General general) {
    // 显示位置选择对话框
    _showPositionSelector(general);
  }

  void _showPositionSelector(General general) {
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
              Text(
                '选择${general.name}的位置',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final isOccupied = _currentFormation?.positions[index] != null;
                  return GestureDetector(
                    onTap: isOccupied ? null : () {
                      setState(() {
                        _currentFormation = _currentFormation!.copyWith(
                          positions: List.from(_currentFormation!.positions)..[index] = general.id,
                        );
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isOccupied 
                            ? Colors.grey.withOpacity(0.3)
                            : AppTheme.primaryGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isOccupied 
                              ? Colors.grey
                              : AppTheme.primaryGold,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getPositionName(index),
                          style: TextStyle(
                            color: isOccupied 
                                ? Colors.grey
                                : AppTheme.primaryGold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFormationTypeSelector() {
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
            const Text(
              '选择阵型',
              style: TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ..._formationTypes.map((type) => GestureDetector(
              onTap: () {
                setState(() {
                  _currentFormation = _currentFormation!.copyWith(
                    id: type.id,
                    name: type.name,
                    description: type.description,
                    bonuses: type.bonuses,
                  );
                });
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _currentFormation?.id == type.id
                      ? AppTheme.primaryGold.withOpacity(0.2)
                      : AppTheme.cardBackgroundDark.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _currentFormation?.id == type.id
                        ? AppTheme.primaryGold
                        : AppTheme.primaryGold.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.name,
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      type.description,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFormation() async {
    if (_currentFormation != null) {
      await GameDataService.saveCurrentFormation(_currentFormation!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('阵型已保存'),
            backgroundColor: AppTheme.primaryGold,
          ),
        );
      }
    }
  }
}