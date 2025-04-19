import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'achievements_screen.dart';
import 'package:flutter/rendering.dart';

enum Direction { up, down, left, right }

enum GameState { playing, paused, gameOver, levelComplete }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // 增加游戏区域宽度，保持合适的高度比例
  static const int GRID_WIDTH = 50; // 从40增加到50
  static const int GRID_HEIGHT = 32; // 从30增加到32
  static const double CELL_SIZE = 12.0; // 从15减小到12，以适应更大的网格

  // 游戏状态
  late Timer _timer;
  GameState _gameState = GameState.playing;
  Direction _direction = Direction.right;
  int _score = 0;
  int _lives = 3;
  int _currentLevel = 1;

  // 蛇的位置
  List<Point> _snake = [];
  Point? _food;

  // 添加传送门相关的状态
  List<PortalPair> _portals = [];
  static const portalColors = [
    Color(0xFF1E88E5), // 蓝色传送门
    Color(0xFFD81B60), // 粉色传送门
    Color(0xFF8E24AA), // 紫色传送门
  ];

  // 关卡设置 - 6个难度递增的关卡
  final Map<int, LevelConfig> _levels = {
    1: LevelConfig(
      speed: 250,
      targetScore: 15,
      initialSnakeLength: 6,
      portalPairs: 1, // 一对传送门
      obstacles: [
        // 四角障碍
        Point(5, 5), Point(6, 5), Point(5, 6),
        Point(44, 5), Point(43, 5), Point(44, 6),
        Point(5, 26), Point(6, 26), Point(5, 25),
        Point(44, 26), Point(43, 26), Point(44, 25),
      ],
    ),
    2: LevelConfig(
      speed: 220,
      targetScore: 20,
      initialSnakeLength: 8,
      portalPairs: 1, // 一对传送门
      obstacles: [
        // 中央十字障碍
        Point(24, 15), Point(24, 16), Point(24, 17),
        Point(23, 16), Point(25, 16),
        // 四角障碍
        Point(5, 5), Point(6, 5), Point(5, 6),
        Point(44, 5), Point(43, 5), Point(44, 6),
        Point(5, 26), Point(6, 26), Point(5, 25),
        Point(44, 26), Point(43, 26), Point(44, 25),
        // 额外的中间障碍
        Point(15, 15), Point(35, 15),
        Point(15, 17), Point(35, 17),
      ],
    ),
    3: LevelConfig(
      speed: 190,
      targetScore: 25,
      initialSnakeLength: 10,
      portalPairs: 2, // 两对传送门
      obstacles: [
        // 中央区域障碍
        Point(23, 14), Point(24, 14), Point(25, 14),
        Point(23, 15), Point(25, 15),
        Point(23, 16), Point(24, 16), Point(25, 16),
        // 边缘障碍
        Point(0, 15), Point(0, 16),
        Point(49, 15), Point(49, 16),
        Point(24, 0), Point(25, 0),
        Point(24, 31), Point(25, 31),
        // 额外的障碍
        Point(12, 15), Point(12, 16),
        Point(37, 15), Point(37, 16),
        Point(24, 8), Point(24, 23),
      ],
    ),
    4: LevelConfig(
      speed: 160,
      targetScore: 30,
      initialSnakeLength: 12,
      portalPairs: 2, // 两对传送门
      obstacles: [
        // 迷宫式障碍
        Point(10, 10), Point(10, 11), Point(10, 12),
        Point(25, 10), Point(25, 11), Point(25, 12),
        Point(40, 10), Point(40, 11), Point(40, 12),
        Point(10, 20), Point(11, 20), Point(12, 20),
        Point(25, 20), Point(26, 20), Point(27, 20),
        Point(40, 20), Point(41, 20), Point(42, 20),
        // 额外的障碍
        Point(17, 15), Point(17, 16),
        Point(33, 15), Point(33, 16),
        Point(25, 5), Point(25, 26),
        Point(15, 8), Point(35, 8),
        Point(15, 23), Point(35, 23),
      ],
    ),
    5: LevelConfig(
      speed: 130,
      targetScore: 35,
      initialSnakeLength: 14,
      portalPairs: 3, // 三对传送门
      obstacles: [
        // 复杂迷宫障碍
        Point(12, 5), Point(12, 6), Point(12, 7),
        Point(25, 5), Point(25, 6), Point(25, 7),
        Point(38, 5), Point(38, 6), Point(38, 7),
        Point(12, 15), Point(13, 15), Point(14, 15),
        Point(25, 15), Point(26, 15), Point(27, 15),
        Point(38, 15), Point(39, 15), Point(40, 15),
        Point(12, 25), Point(12, 24), Point(12, 23),
        Point(25, 25), Point(25, 24), Point(25, 23),
        Point(38, 25), Point(38, 24), Point(38, 23),
        // 额外的障碍
        Point(5, 10), Point(45, 10),
        Point(5, 20), Point(45, 20),
        Point(19, 0), Point(31, 0),
        Point(19, 31), Point(31, 31),
        Point(19, 15), Point(31, 15),
      ],
    ),
    6: LevelConfig(
      speed: 100,
      targetScore: 45,
      initialSnakeLength: 16,
      portalPairs: 3, // 三对传送门
      obstacles: [
        // 极限迷宫障碍
        Point(10, 5), Point(10, 6), Point(10, 7),
        Point(20, 5), Point(20, 6), Point(20, 7),
        Point(30, 5), Point(30, 6), Point(30, 7),
        Point(40, 5), Point(40, 6), Point(40, 7),
        Point(10, 15), Point(11, 15), Point(12, 15),
        Point(20, 15), Point(21, 15), Point(22, 15),
        Point(30, 15), Point(31, 15), Point(32, 15),
        Point(40, 15), Point(41, 15), Point(42, 15),
        Point(10, 25), Point(10, 24), Point(10, 23),
        Point(20, 25), Point(20, 24), Point(20, 23),
        Point(30, 25), Point(30, 24), Point(30, 23),
        Point(40, 25), Point(40, 24), Point(40, 23),
        // 额外的障碍增加难度
        Point(15, 10), Point(25, 10), Point(35, 10),
        Point(15, 20), Point(25, 20), Point(35, 20),
        Point(5, 15), Point(45, 15),
        Point(25, 0), Point(25, 31),
        Point(15, 0), Point(35, 0),
        Point(15, 31), Point(35, 31),
        // 随机分布的单点障碍
        Point(8, 12), Point(18, 12), Point(28, 12), Point(38, 12),
        Point(13, 18), Point(23, 18), Point(33, 18), Point(43, 18),
        Point(8, 28), Point(18, 28), Point(28, 28), Point(38, 28),
      ],
    ),
  };

  // 添加动画控制器和底部面板状态
  late AnimationController _panelController;
  late Animation<double> _panelAnimation;
  bool _isPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    // 设置横屏模式
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initGame();

    // 初始化动画控制器
    _panelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut,
    );

    // 默认收起状态，不再调用 _panelController.value = 1.0
  }

  @override
  void dispose() {
    _timer.cancel();
    _panelController.dispose();
    // 移除恢复屏幕方向的代码，保持横屏状态
    super.dispose();
  }

  void _initGame() {
    _snake = [];
    int initialLength = _levels[_currentLevel]!.initialSnakeLength;
    for (int i = 0; i < initialLength; i++) {
      _snake.add(Point(GRID_WIDTH ~/ 4 - i, GRID_HEIGHT ~/ 2));
    }

    _direction = Direction.right;
    _generatePortals();
    _generateFood();
    _startGame();
  }

  void _generatePortals() {
    Random random = Random();
    _portals = [];
    int portalPairsCount = _levels[_currentLevel]!.portalPairs;

    for (int i = 0; i < portalPairsCount; i++) {
      Point portal1;
      Point portal2;
      bool validPosition;

      // 生成第一个传送门
      do {
        validPosition = true;
        portal1 = Point(
          random.nextInt(GRID_WIDTH),
          random.nextInt(GRID_HEIGHT),
        );

        // 检查是否与其他元素重叠
        if (_snake.contains(portal1) ||
            _levels[_currentLevel]!.obstacles.contains(portal1) ||
            _portals.any(
              (pair) => pair.portal1 == portal1 || pair.portal2 == portal1,
            )) {
          validPosition = false;
        }
      } while (!validPosition);

      // 生成第二个传送门
      do {
        validPosition = true;
        portal2 = Point(
          random.nextInt(GRID_WIDTH),
          random.nextInt(GRID_HEIGHT),
        );

        // 检查是否与其他元素重叠
        if (_snake.contains(portal2) ||
            _levels[_currentLevel]!.obstacles.contains(portal2) ||
            _portals.any(
              (pair) => pair.portal1 == portal2 || pair.portal2 == portal2,
            ) ||
            portal1 == portal2) {
          validPosition = false;
        }
      } while (!validPosition);

      _portals.add(PortalPair(portal1, portal2, portalColors[i]));
    }
  }

  void _generateFood() {
    Random random = Random();
    Point newFood;
    do {
      newFood = Point(random.nextInt(GRID_WIDTH), random.nextInt(GRID_HEIGHT));
    } while (_snake.contains(newFood) ||
        _levels[_currentLevel]!.obstacles.contains(newFood));

    _food = newFood;
  }

  void _startGame() {
    _timer = Timer.periodic(
      Duration(milliseconds: _levels[_currentLevel]!.speed),
      (timer) => _updateGame(),
    );
  }

  void _updateGame() {
    if (_gameState != GameState.playing) return;

    setState(() {
      // 移动蛇
      Point newHead = _getNextPosition();

      // 检查碰撞
      if (_checkCollision(newHead)) {
        _handleCollision();
        return;
      }

      _snake.insert(0, newHead);

      // 检查是否吃到食物
      if (newHead == _food) {
        _score++;
        _generateFood();
        // 检查是否完成关卡
        if (_score >= _levels[_currentLevel]!.targetScore) {
          _handleLevelComplete();
        }
      } else {
        _snake.removeLast();
      }
    });
  }

  Point _getNextPosition() {
    Point head = _snake.first;
    Point nextPos;

    switch (_direction) {
      case Direction.up:
        nextPos = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        nextPos = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        nextPos = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        nextPos = Point(head.x + 1, head.y);
        break;
    }

    // 检查是否进入传送门
    for (var portalPair in _portals) {
      if (nextPos == portalPair.portal1) {
        // 从传送门1进入，从传送门2出来
        return portalPair.portal2;
      } else if (nextPos == portalPair.portal2) {
        // 从传送门2进入，从传送门1出来
        return portalPair.portal1;
      }
    }

    return nextPos;
  }

  bool _checkCollision(Point newHead) {
    // 检查是否撞到墙
    if (newHead.x < 0 ||
        newHead.x >= GRID_WIDTH ||
        newHead.y < 0 ||
        newHead.y >= GRID_HEIGHT) {
      return true;
    }

    // 检查是否撞到自己
    if (_snake.contains(newHead)) return true;

    // 检查是否撞到障碍物
    if (_levels[_currentLevel]!.obstacles.contains(newHead)) return true;

    return false;
  }

  void _handleCollision() {
    _lives--;
    if (_lives <= 0) {
      _gameState = GameState.gameOver;
      _timer.cancel();
      _showGameOverDialog();
    } else {
      _resetLevel();
    }
  }

  void _resetLevel() {
    // 根据当前关卡重置蛇的长度
    _snake = [];
    int initialLength = _levels[_currentLevel]!.initialSnakeLength;
    for (int i = 0; i < initialLength; i++) {
      _snake.add(Point(GRID_WIDTH ~/ 4 - i, GRID_HEIGHT ~/ 2));
    }
    _direction = Direction.right;
    _generatePortals();
    _generateFood();
  }

  void _handleLevelComplete() {
    // 解锁当前关卡对应的成就
    AchievementManager.unlockAchievement(_currentLevel);

    if (_currentLevel < 6) {
      _showLevelCompleteDialog();
    } else {
      _showGameCompleteDialog();
    }
    _timer.cancel();
    _gameState = GameState.levelComplete;
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Game Over'),
            content: Text('Score: $_score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Back to Menu'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _score = 0;
                    _lives = 3;
                    _currentLevel = 1;
                    _gameState = GameState.playing;
                    _initGame();
                  });
                },
                child: const Text('Restart'),
              ),
            ],
          ),
    );
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Column(
              children: [
                const Text('Level Complete!'),
                const SizedBox(height: 10),
                Icon(
                  _getAchievementIcon(_currentLevel),
                  size: 50,
                  color: Colors.amber,
                ),
              ],
            ),
            content: Text(
              'Current Score: $_score\nNew Achievement Unlocked: ${_getAchievementTitle(_currentLevel)}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentLevel++;
                    _gameState = GameState.playing;
                    _initGame();
                  });
                },
                child: const Text('Next Level'),
              ),
            ],
          ),
    );
  }

  void _showGameCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Column(
              children: [
                const Text('Congratulations!'),
                const SizedBox(height: 10),
                Icon(Icons.workspace_premium, size: 50, color: Colors.amber),
              ],
            ),
            content: Text(
              'Final Score: $_score\nFinal Achievement Unlocked: Snake Legend\n\nYou have completed all levels!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Back to Menu'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _score = 0;
                    _lives = 3;
                    _currentLevel = 1;
                    _gameState = GameState.playing;
                    _initGame();
                  });
                },
                child: const Text('Restart'),
              ),
            ],
          ),
    );
  }

  IconData _getAchievementIcon(int level) {
    switch (level) {
      case 1:
        return Icons.looks_one;
      case 2:
        return Icons.looks_two;
      case 3:
        return Icons.looks_3;
      case 4:
        return Icons.looks_4;
      case 5:
        return Icons.looks_5;
      case 6:
        return Icons.workspace_premium;
      default:
        return Icons.star;
    }
  }

  String _getAchievementTitle(int level) {
    switch (level) {
      case 1:
        return 'First Steps';
      case 2:
        return 'Rising Star';
      case 3:
        return 'Portal Prodigy';
      case 4:
        return 'Maze Master';
      case 5:
        return 'Speed Demon';
      case 6:
        return 'Snake Legend';
      default:
        return '';
    }
  }

  // 切换面板状态
  void _togglePanel() {
    setState(() {
      _isPanelExpanded = !_isPanelExpanded;
      if (_isPanelExpanded) {
        _panelController.forward();
      } else {
        _panelController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4EABE9),
                const Color(0xFF4EABE9).withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 返回按钮
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // 游戏状态信息
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 关卡信息
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.flag_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_currentLevel',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 分数信息
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 生命值信息
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                color:
                                    _lives >= 2
                                        ? Colors.red
                                        : Colors.red.shade300,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_lives',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 图例说明
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 食物图例
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Food',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 传送门图例
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: portalColors[0],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Portal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 暂停/继续按钮
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _gameState == GameState.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_gameState == GameState.playing) {
                            _gameState = GameState.paused;
                            _timer.cancel();
                          } else if (_gameState == GameState.paused) {
                            _gameState = GameState.playing;
                            _startGame();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFE8F4FB), const Color(0xFFF5FAFD)],
            stops: const [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 游戏区域
              Expanded(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (_direction != Direction.up && details.delta.dy > 0) {
                      _direction = Direction.down;
                    } else if (_direction != Direction.down &&
                        details.delta.dy < 0) {
                      _direction = Direction.up;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (_direction != Direction.left && details.delta.dx > 0) {
                      _direction = Direction.right;
                    } else if (_direction != Direction.right &&
                        details.delta.dx < 0) {
                      _direction = Direction.left;
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: Stack(
                      children: [
                        // 游戏主区域
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4EABE9).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: GRID_WIDTH / GRID_HEIGHT,
                              child: CustomPaint(
                                painter: GamePainter(
                                  snake: _snake,
                                  food: _food,
                                  gridWidth: GRID_WIDTH,
                                  gridHeight: GRID_HEIGHT,
                                  cellSize: CELL_SIZE,
                                  obstacles: _levels[_currentLevel]!.obstacles,
                                  portals: _portals,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 游戏状态覆盖层
                        if (_gameState == GameState.paused)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.pause_circle_filled_rounded,
                                        color: Colors.green.shade600,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Game Paused',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // 展开/收起按钮
              GestureDetector(
                onTap: _togglePanel,
                child: Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedRotation(
                      turns: _isPanelExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              // 底部信息面板 - 使用 SizeTransition 实现动画
              SizeTransition(
                sizeFactor: _panelAnimation,
                axisAlignment: -1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 目标分数进度
                        Row(
                          children: [
                            const Icon(
                              Icons.track_changes_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value:
                                      _score /
                                      _levels[_currentLevel]!.targetScore,
                                  backgroundColor: const Color(0xFFE8F4FB),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF4EABE9),
                                      ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_score}/${_levels[_currentLevel]!.targetScore}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // 控制说明
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildControlHint(
                              Icons.swipe_rounded,
                              'Swipe to Move',
                            ),
                            _buildControlHint(
                              Icons.door_sliding_rounded,
                              'Use Portals',
                            ),
                            _buildControlHint(
                              _gameState == GameState.paused
                                  ? Icons.play_arrow_rounded
                                  : Icons.pause_rounded,
                              _gameState == GameState.paused
                                  ? 'Resume'
                                  : 'Pause',
                              onTap: () {
                                setState(() {
                                  if (_gameState == GameState.playing) {
                                    _gameState = GameState.paused;
                                    _timer.cancel();
                                  } else if (_gameState == GameState.paused) {
                                    _gameState = GameState.playing;
                                    _startGame();
                                  }
                                });
                              },
                            ),
                          ],
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

  Widget _buildControlHint(IconData icon, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 24),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 添加传送门配对类
class PortalPair {
  final Point portal1;
  final Point portal2;
  final Color color;

  PortalPair(this.portal1, this.portal2, this.color);
}

class GamePainter extends CustomPainter {
  final List<Point> snake;
  final Point? food;
  final int gridWidth;
  final int gridHeight;
  final double cellSize;
  final List<Point> obstacles;
  final List<PortalPair> portals;

  GamePainter({
    required this.snake,
    required this.food,
    required this.gridWidth,
    required this.gridHeight,
    required this.cellSize,
    required this.obstacles,
    required this.portals,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / gridWidth;
    final cellHeight = size.height / gridHeight;

    // 绘制背景网格点
    final dotPaint =
        Paint()
          ..color = const Color(0xFFE8F4FB)
          ..style = PaintingStyle.fill;

    for (int x = 0; x < gridWidth; x++) {
      for (int y = 0; y < gridHeight; y++) {
        canvas.drawCircle(
          Offset((x + 0.5) * cellWidth, (y + 0.5) * cellHeight),
          1,
          dotPaint,
        );
      }
    }

    // 绘制障碍物
    final obstaclePaint =
        Paint()
          ..color = const Color(0xFF4EABE9).withOpacity(0.8)
          ..style = PaintingStyle.fill;

    for (var obstacle in obstacles) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            obstacle.x.toDouble() * cellWidth,
            obstacle.y.toDouble() * cellHeight,
            cellWidth,
            cellHeight,
          ),
          const Radius.circular(4),
        ),
        obstaclePaint,
      );
    }

    // 绘制传送门
    for (var portalPair in portals) {
      final portalPaint = Paint()..color = portalPair.color;

      // 添加光晕效果
      final glowPaint =
          Paint()
            ..color = portalPair.color.withOpacity(0.2)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      void drawPortalWithGlow(Point position) {
        final center = Offset(
          (position.x + 0.5) * cellWidth,
          (position.y + 0.5) * cellHeight,
        );

        // 绘制光晕
        canvas.drawCircle(center, min(cellWidth, cellHeight) / 1.5, glowPaint);

        // 绘制外环
        canvas.drawCircle(
          center,
          min(cellWidth, cellHeight) / 1.8,
          portalPaint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        // 绘制内圆
        canvas.drawCircle(
          center,
          min(cellWidth, cellHeight) / 3,
          portalPaint..style = PaintingStyle.fill,
        );
      }

      drawPortalWithGlow(portalPair.portal1);
      drawPortalWithGlow(portalPair.portal2);
    }

    // 绘制食物
    if (food != null) {
      final foodCenter = Offset(
        (food!.x + 0.5) * cellWidth,
        (food!.y + 0.5) * cellHeight,
      );

      // 食物光晕
      final foodGlowPaint =
          Paint()
            ..color = const Color(0xFF4CAF50).withOpacity(0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(
        foodCenter,
        min(cellWidth, cellHeight) / 1.8,
        foodGlowPaint,
      );

      // 食物主体
      final foodPaint = Paint()..color = const Color(0xFF4CAF50);
      canvas.drawCircle(
        foodCenter,
        min(cellWidth, cellHeight) / 2.2,
        foodPaint,
      );
    }

    // 绘制蛇
    if (snake.isNotEmpty) {
      // 蛇身
      final snakeBodyPaint = Paint()..color = const Color(0xFF4EABE9);
      for (var point in snake.skip(1)) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              point.x.toDouble() * cellWidth,
              point.y.toDouble() * cellHeight,
              cellWidth,
              cellHeight,
            ),
            const Radius.circular(4),
          ),
          snakeBodyPaint,
        );
      }

      // 蛇头
      final head = snake.first;
      final snakeHeadPaint = Paint()..color = const Color(0xFF4EABE9);

      // 蛇头光晕
      final headGlowPaint =
          Paint()
            ..color = const Color(0xFF4EABE9).withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            head.x.toDouble() * cellWidth - 2,
            head.y.toDouble() * cellHeight - 2,
            cellWidth + 4,
            cellHeight + 4,
          ),
          const Radius.circular(6),
        ),
        headGlowPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            head.x.toDouble() * cellWidth,
            head.y.toDouble() * cellHeight,
            cellWidth,
            cellHeight,
          ),
          const Radius.circular(4),
        ),
        snakeHeadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LevelConfig {
  final int speed;
  final int targetScore;
  final int initialSnakeLength;
  final List<Point> obstacles;
  final int portalPairs; // 添加传送门对数配置

  LevelConfig({
    required this.speed,
    required this.targetScore,
    required this.initialSnakeLength,
    required this.obstacles,
    required this.portalPairs,
  });
}
