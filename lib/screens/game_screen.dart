import 'dart:async';
import 'package:flutter/material.dart';
import '../components/game_character.dart';
import '../components/enemy_component.dart';
import '../components/bullet.dart';
import '../components/progress_bar.dart';
import '../models/enemy.dart';
import '../models/player.dart';
import '../services/game_service.dart';
import '../utils/constants.dart';
import '../utils/game_utils.dart';
import 'upgrade_screen.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  final Player? initialPlayer;

  const GameScreen({
    Key? key,
    this.initialPlayer,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameService _gameService;
  late StreamSubscription<dynamic> _gameStateSubscription;

  // 用於UI動畫效果
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // 暫停相關
  bool _isPauseMenuVisible = false;

  @override
  void initState() {
    super.initState();
    _gameService = GameService();
    _setupAnimations();

    // 在下一幀初始化遊戲，以確保獲取到螢幕尺寸
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGame();
    });
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  Future<void> _initGame() async {
    // 獲取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;

    // 初始化遊戲
    await _gameService.initGame(screenSize, widget.initialPlayer);

    // 訂閱遊戲狀態更新
    _gameStateSubscription = _gameService.gameStateStream.listen((_) {
      // 強制UI更新以反映遊戲狀態變化
      if (mounted) setState(() {});

      // 檢查是否需要顯示升級畫面
      if (_gameService.gameState != null &&
          _gameService.gameState!.player.canLevelUp &&
          !_gameService.gameState!.isPaused) {
        _showUpgradeScreen();
      }

      // 檢查遊戲是否結束
      if (_gameService.gameState != null &&
          _gameService.gameState!.isGameOver) {
        _showGameOverScreen();
      }
    });

    // 開始遊戲
    _gameService.startGame();
  }

  void _showUpgradeScreen() {
    // 暫停遊戲
    _gameService.pauseGame();

    // 顯示升級畫面
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => UpgradeScreen(
          player: _gameService.gameState!.player,
          onUpgradeSelected: (upgrade) {
            Navigator.pop(context);
            _gameService.selectUpgrade(upgrade);
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _showGameOverScreen() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(
            score: _gameService.gameState!.player.cultivationLevel,
            wave: _gameService.gameState!.player.wave,
            onRestart: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GameScreen()),
              );
            },
            onExit: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    });
  }

  void _togglePauseMenu() {
    if (_isPauseMenuVisible) {
      setState(() {
        _isPauseMenuVisible = false;
      });
      _gameService.resumeGame();
    } else {
      _gameService.pauseGame();
      setState(() {
        _isPauseMenuVisible = true;
      });
    }
  }

  void _exitToMainMenu() {
    _gameService.returnToMainMenu();
    Navigator.pop(context);
  }

  void _restartGame() {
    setState(() {
      _isPauseMenuVisible = false;
    });
    _gameService.restartGame();
  }

  @override
  void dispose() {
    _gameStateSubscription.cancel();
    _gameService.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 遊戲尚未初始化
    if (_gameService.gameState == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/backgrounds_7.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          ),
        ),
      );
    }

    // 遊戲已初始化，顯示遊戲界面
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgrounds_7.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // 顯示所有敵人
            ..._buildEnemies(),

            // 顯示所有子彈
            ..._buildBullets(),

            // 顯示角色（中央）
            _buildCharacter(),

            // 顯示UI元素
            _buildGameUI(),

            // 暫停菜單
            if (_isPauseMenuVisible) _buildPauseMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacter() {
    // 屏幕中心位置
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;

    // 從遊戲狀態獲取角色資產路徑
    final characterAsset = _gameService.gameState?.player.characterAsset ??
        'assets/images/characters/characters_1.png';

    return Positioned(
      left: centerX - GameConstants.characterSize / 2,
      top: centerY - GameConstants.characterSize / 2,
      child: GameCharacter(
        characterAsset: characterAsset,
        size: GameConstants.characterSize,
        player: _gameService.gameState?.player,
        comboCount: _gameService.gameState?.player.comboCount ?? 0,
      ),
    );
  }

  List<Widget> _buildEnemies() {
    final enemies = <Widget>[];

    if (_gameService.gameState == null) return enemies;

    for (final enemy in _gameService.gameState!.enemies) {
      if (enemy.isActive) {
        enemies.add(
          EnemyComponent(enemy: enemy),
        );
      }
    }

    return enemies;
  }

  List<Widget> _buildBullets() {
    final bullets = <Widget>[];

    if (_gameService.gameState == null) return bullets;

    for (final bullet in _gameService.bullets) {
      final type = bullet['type'] as String;
      final position = bullet['position'] as Position;
      final direction = bullet['direction'] as Position;

      // 子彈軌跡（在子彈後面繪製）
      bullets.add(
        BulletTrail(
          type: type,
          position: position,
          direction: direction,
        ),
      );

      // 子彈本身
      bullets.add(
        Bullet(
          type: type,
          position: position,
        ),
      );
    }

    return bullets;
  }

  Widget _buildGameUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTopBar(),
            _buildEnlightenmentProgressBar(),
            const Spacer(),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final player = _gameService.gameState!.player;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    if (isSmallScreen) {
      // 小屏幕布局 - 更緊湊的版面
      return Column(
        children: [
          // 第一行：靈力值和修為值
          Row(
            children: [
              // 靈力值（生命值）
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      'Spirit:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ProgressBar(
                        value: player.health / 100,
                        height: 10,
                        gradient: LinearGradient(
                          colors: [Colors.red.shade700, Colors.red.shade400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 修為值（分數）
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        'Cultivation: ${player.cultivationLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // 第二行：劫數和按鈕
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 劫數
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.amber.withOpacity(0.5), width: 1),
                ),
                child: Text(
                  'Wave ${player.wave}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Row(
                children: [
                  // 升級調試按鈕
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.bug_report,
                      color: Colors.green,
                    ),
                    onPressed: _showUpgradeStatus,
                    tooltip: 'View Upgrade Status',
                  ),

                  // 暫停按鈕
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                    onPressed: _togglePauseMenu,
                    tooltip: 'Pause Game',
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    // 標準布局（原有的）
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 靈力值（生命值）
        Expanded(
          flex: 2,
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 4),
              const Text(
                'Spirit:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProgressBar(
                  value: player.health / 100,
                  height: 12,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade700, Colors.red.shade400],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // 修為值（分數）
        Expanded(
          flex: 1,
          child: Row(
            children: [
              const Icon(
                Icons.stars,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'Cultivation: ${player.cultivationLevel}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // 劫數
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
          ),
          child: Text(
            'Wave ${player.wave} (Endless Mode)',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 升級調試按鈕
        IconButton(
          icon: const Icon(
            Icons.bug_report,
            color: Colors.green,
            size: 20,
          ),
          onPressed: _showUpgradeStatus,
          tooltip: 'View Upgrade Status',
        ),

        // 暫停按鈕
        IconButton(
          icon: const Icon(
            Icons.pause,
            color: Colors.white,
            size: 20,
          ),
          onPressed: _togglePauseMenu,
          tooltip: 'Pause Game',
        ),
      ],
    );
  }

  Widget _buildEnlightenmentProgressBar() {
    final player = _gameService.gameState!.player;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        children: [
          const Text(
            'Enlightenment Progress',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          ProgressBar(
            value: player.enlightenmentProgress,
            height: isSmallScreen ? 12 : 16,
          ),
        ],
      ),
    );
  }

  // 顯示升級狀態
  void _showUpgradeStatus() {
    // 暫停遊戲
    _gameService.pauseGame();

    // 獲取升級狀態信息
    final statusInfo = _gameService.gameState!.verifyUpgrade();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade Status Check'),
        content: SingleChildScrollView(
          child: SelectableText(
            statusInfo,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _gameService.resumeGame();
            },
            child: const Text('Close'),
          ),
        ],
        backgroundColor: Colors.black87,
        titleTextStyle: const TextStyle(color: Colors.green, fontSize: 18),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildBottomBar() {
    final player = _gameService.gameState!.player;
    final canLevelUp = player.canLevelUp;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: canLevelUp ? _pulseAnimation.value : 1.0,
          // child: ElevatedButton(
          //   onPressed: canLevelUp ? _showUpgradeScreen : null,
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor:
          //         canLevelUp ? AppConstants.primaryColor : Colors.grey.shade700,
          //     foregroundColor:
          //         canLevelUp ? Colors.brown.shade900 : Colors.grey.shade300,
          //     padding: EdgeInsets.symmetric(
          //       horizontal: isSmallScreen ? 16 : 24,
          //       vertical: isSmallScreen ? 6 : 8,
          //     ),
          //     elevation: canLevelUp ? 8 : 2,
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     // children: [
          //     //   Icon(
          //     //     canLevelUp ? Icons.auto_awesome : Icons.hourglass_empty,
          //     //     size: isSmallScreen ? 16 : 18,
          //     //   ),
          //     //   const SizedBox(width: 6),
          //     //   Text(
          //     //     canLevelUp ? '頓悟' : '悟道未滿',
          //     //     style: TextStyle(
          //     //       fontSize: isSmallScreen ? 12 : 14,
          //     //       fontWeight: FontWeight.bold,
          //     //     ),
          //     //   ),
          //     // ],
          //   ),
          // ),
        );
      },
    );
  }

  Widget _buildPauseMenu() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final menuWidth = isSmallScreen ? screenWidth * 0.8 : 300.0;

    return Center(
      child: Container(
        width: menuWidth,
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.primaryColor.withOpacity(0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Paused',
              style: AppConstants.headlineMedium.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildPauseMenuItem(
              icon: Icons.play_arrow,
              text: 'Continue Game',
              onTap: _togglePauseMenu,
            ),
            const SizedBox(height: 12),
            _buildPauseMenuItem(
              icon: Icons.replay,
              text: 'Restart Game',
              onTap: _restartGame,
            ),
            const SizedBox(height: 12),
            _buildPauseMenuItem(
              icon: Icons.home,
              text: 'Return to Main Menu',
              onTap: _exitToMainMenu,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 12,
            horizontal: isSmallScreen ? 12 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: AppConstants.primaryColor.withOpacity(0.4),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: isSmallScreen ? 20 : 24,
              color: AppConstants.primaryColor,
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Text(
              text,
              style: AppConstants.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
