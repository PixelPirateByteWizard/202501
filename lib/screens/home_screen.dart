import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../services/game_data_service.dart';
import '../utils/responsive_utils.dart';
import 'journey_screen.dart';
import 'generals_screen.dart';
import 'formation_screen.dart';
import 'inventory_screen.dart';
import 'shop_screen.dart';
import 'achievement_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  GameState? _gameState;
  bool _isLoading = true;
  late AnimationController _cardAnimationController;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutQuart,
      ),
    );

    _loadGameState();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadGameState() async {
    try {
      GameState? gameState = await GameDataService.loadGameState();
      gameState ??= await GameDataService.createNewGame();

      setState(() {
        _gameState = gameState;
        _isLoading = false;
      });

      // 启动动画
      _cardAnimationController.forward();
    } catch (e) {
      debugPrint('Error loading game state: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) {
      // 返回时重新加载游戏状态
      _loadGameState();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.secondaryColor,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        ),
      );
    }

    if (_gameState == null) {
      return Scaffold(
        backgroundColor: AppTheme.secondaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppTheme.accentColor,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                '游戏数据加载失败',
                style: TextStyle(color: AppTheme.lightColor, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadGameState,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AppTheme.accentColor,
              Color(0xFFffd700),
            ],
          ).createShader(bounds),
          child: const Text(
            '烽尘绘谱',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => _navigateToScreen(const SettingsScreen()),
              icon: const Icon(
                Icons.settings,
                color: AppTheme.accentColor,
              ),
              tooltip: '设置',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
              AppTheme.darkColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0).responsive(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 游戏标语
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentColor.withValues(alpha: 0.2),
                          AppTheme.accentColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.accentColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '字里行间，自有千军万马',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accentColor.withValues(alpha: 0.9),
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 当前进度
                AnimatedBuilder(
                  animation: _cardAnimation,
                  builder: (context, child) {
                    final clampedValue = _cardAnimation.value.clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - clampedValue)),
                      child: Opacity(
                        opacity: clampedValue,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.cardColor.withValues(alpha: 0.9),
                                AppTheme.cardColor.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.accentColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentColor.withValues(alpha: 0.1),
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
                                      color: AppTheme.accentColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.auto_stories,
                                      color: AppTheme.accentColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '当前进度',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontSize: 22),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '第${_gameState!.currentChapter}章·第${_gameState!.currentSection}节',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppTheme.accentColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _buildStatChip(
                                          '武将',
                                          '${_gameState!.generals.length}人',
                                          Icons.people,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildStatChip(
                                          '等级',
                                          '${_gameState!.playerStats.level}',
                                          Icons.star,
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
                  },
                ),

                const SizedBox(height: 24),

                // 功能菜单
                Expanded(
                  child: AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return GridView.count(
                        crossAxisCount: ResponsiveUtils.getGridColumns(context, defaultColumns: 2),
                        crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
                        mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
                        childAspectRatio: ResponsiveUtils.getCardAspectRatio(context, defaultRatio: 0.85),
                        children: [
                          _buildAnimatedMenuCard(
                            title: '征程',
                            subtitle: '挑战三国名将',
                            icon: Icons.sports_martial_arts,
                            gradient: const [
                              Color(0xFFe53e3e),
                              Color(0xFFc53030),
                            ],
                            delay: 0,
                            onTap: () => _navigateToScreen(
                              JourneyScreen(gameState: _gameState!),
                            ),
                          ),
                          _buildAnimatedMenuCard(
                            title: '武将',
                            subtitle: '查看和管理武将',
                            icon: Icons.people,
                            gradient: const [
                              Color(0xFF3182ce),
                              Color(0xFF2c5282),
                            ],
                            delay: 100,
                            onTap: () => _navigateToScreen(
                              GeneralsScreen(gameState: _gameState!),
                            ),
                          ),
                          _buildAnimatedMenuCard(
                            title: '阵型',
                            subtitle: '布置战斗阵型',
                            icon: Icons.grid_view,
                            gradient: const [
                              Color(0xFF38a169),
                              Color(0xFF2f855a),
                            ],
                            delay: 200,
                            onTap: () => _navigateToScreen(
                              FormationScreen(gameState: _gameState!),
                            ),
                          ),
                          _buildAnimatedMenuCard(
                            title: '背包',
                            subtitle: '装备和道具管理',
                            icon: Icons.inventory,
                            gradient: const [
                              Color(0xFFd69e2e),
                              Color(0xFFb7791f),
                            ],
                            delay: 300,
                            onTap: () => _navigateToScreen(
                              InventoryScreen(gameState: _gameState!),
                            ),
                          ),
                          _buildAnimatedMenuCard(
                            title: '商店',
                            subtitle: '购买装备和道具',
                            icon: Icons.store,
                            gradient: const [
                              Color(0xFF805ad5),
                              Color(0xFF6b46c1),
                            ],
                            delay: 400,
                            onTap: () => _navigateToScreen(
                              ShopScreen(gameState: _gameState!),
                            ),
                          ),
                          _buildAnimatedMenuCard(
                            title: '成就',
                            subtitle: '查看游戏成就',
                            icon: Icons.emoji_events,
                            gradient: const [
                              AppTheme.accentColor,
                              Color(0xFFb8941f),
                            ],
                            delay: 500,
                            onTap: () => _navigateToScreen(
                              AchievementScreen(gameState: _gameState!),
                            ),
                          ),
                          _buildAnimatedMenuCard(
                            title: '设置',
                            subtitle: '游戏设置和帮助',
                            icon: Icons.settings,
                            gradient: const [
                              Color(0xFF718096),
                              Color(0xFF4a5568),
                            ],
                            delay: 600,
                            onTap: () => _navigateToScreen(
                              const SettingsScreen(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.accentColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.lightColor),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: clampedValue,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - clampedValue)),
            child: Opacity(
              opacity: clampedValue,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0).responsive(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 12)),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon, 
                              size: ResponsiveUtils.getIconSize(context, 32), 
                              color: Colors.white
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 6)),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                                ),
                            textAlign: TextAlign.center,
                            maxLines: ResponsiveUtils.isExtraSmallScreen(context) ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
