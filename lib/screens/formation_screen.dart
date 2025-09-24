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

  bool _isLoading = true;
  int _selectedGeneralIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final formation = await GameDataService.getCurrentFormation();
    final generals = await GameDataService.getGenerals();

    setState(() {
      _currentFormation = formation;
      _availableGenerals = generals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/BG_5.png'),
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
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg/BG_7.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryGold,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        _buildTopResourceBar(),
                        Expanded(child: _buildFormationArea()),
                        _buildBottomPanel(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopResourceBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.brown.withValues(alpha: 0.9),
            Colors.brown.shade800.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.primaryGold, width: 2),
      ),
      child: Row(
        children: [
          // 左侧群组按钮
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.purple.shade700,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGold, width: 2),
            ),
            child: const Center(
              child: Text(
                '群',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 玩家名称和金币
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '白夜白',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppTheme.primaryGold,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _formatNumber(254230031),
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 中间装饰
          Container(
            width: 50,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.brown.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          // 右侧资源
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '机敏招佳人',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppTheme.primaryGold,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _formatNumber(295293),
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 右侧群组按钮
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.purple.shade700,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGold, width: 2),
            ),
            child: const Center(
              child: Text(
                '群',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormationArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 阵型网格区域
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: _buildFormationGrid(),
            ),
          ),
          // 底部操作按钮区域
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.arrow_back,
                  '返回',
                  () => Navigator.pop(context),
                ),
                _buildActionButton(Icons.people, '武将', () {}),
                _buildActionButton(Icons.star, '竞技', () {}),
                _buildActionButton(Icons.shopping_bag, '商店', () {}),
                _buildActionButton(Icons.emoji_events, '成就', () {}),
                _buildActionButton(Icons.group, '群组', () {}),
                _buildActionButton(Icons.settings, '设置', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade600, Colors.brown.shade800],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.primaryGold, width: 2),
        ),
        child: Icon(icon, color: AppTheme.primaryGold, size: 20),
      ),
    );
  }

  Widget _buildFormationGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return _buildPositionSlot(index);
      },
    );
  }

  Widget _buildPositionSlot(int index) {
    final generalId = _currentFormation?.positions[index];
    General? general;
    if (generalId != null && _availableGenerals.isNotEmpty) {
      try {
        general = _availableGenerals.firstWhere((g) => g.id == generalId);
      } catch (e) {
        general = null;
      }
    }

    return GestureDetector(
      onTap: () => _onPositionTapped(index),
      child: Stack(
        children: [
          // 位置圆形底座
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: general != null
                  ? Colors.brown.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
              border: Border.all(
                color: general != null ? AppTheme.primaryGold : Colors.grey,
                width: 2,
              ),
            ),
          ),
          // 武将角色图片
          if (general != null)
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 角色图片
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/role/${general.name}.png'),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // 如果图片加载失败，显示默认头像
                          },
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 等级标识
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade700,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        const Text(
                          '600级',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            )
          else
            // 空位置显示
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey.shade400,
                    size: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPositionName(index),
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    final undeployedGenerals = _availableGenerals.where((general) {
      return !(_currentFormation?.positions.contains(general.id) ?? false);
    }).toList();

    return Container(
      height: 120,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.brown.withValues(alpha: 0.9),
            Colors.brown.shade800.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGold, width: 2),
      ),
      child: Row(
        children: [
          // 可用武将列表
          Expanded(
            child: undeployedGenerals.isEmpty
                ? const Center(
                    child: Text(
                      '所有武将都已部署',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: undeployedGenerals.length,
                    itemBuilder: (context, index) {
                      final general = undeployedGenerals[index];
                      final isSelected = _selectedGeneralIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGeneralIndex = isSelected ? -1 : index;
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryGold.withValues(alpha: 0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryGold
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              // 角色图片
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/role/${general.name}.png',
                                      ),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) {
                                        // 图片加载失败时的处理
                                      },
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // 等级标识
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade700,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            '600',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // 选中标识
                                      if (isSelected)
                                        const Positioned(
                                          bottom: 4,
                                          right: 4,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              // 武将名称
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  general.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // 保存按钮
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(left: 8),
            child: ElevatedButton(
              onPressed: _saveFormation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.save, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  String _getPositionName(int index) {
    const positions = ['左前', '中前', '右前', '左中', '中军', '右中', '左后', '中后', '右后'];
    return positions[index];
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
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
    } else if (_selectedGeneralIndex >= 0) {
      // 部署选中的武将
      final undeployedGenerals = _availableGenerals.where((g) {
        return !(_currentFormation?.positions.contains(g.id) ?? false);
      }).toList();

      if (_selectedGeneralIndex < undeployedGenerals.length) {
        final selectedGeneral = undeployedGenerals[_selectedGeneralIndex];
        setState(() {
          _currentFormation = _currentFormation!.copyWith(
            positions: List.from(_currentFormation!.positions)
              ..[index] = selectedGeneral.id,
          );
          _selectedGeneralIndex = -1; // 清除选择
        });
      }
    }
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
