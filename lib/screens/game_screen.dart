import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../models/character.dart';
import '../models/enemy_type.dart';
import '../models/collectable.dart';
import '../models/particle.dart';
import '../widgets/game_canvas.dart';
import '../widgets/joystick.dart';
import '../widgets/leaderboard.dart';
import '../widgets/game_over_overlay.dart';
import '../services/storage_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game state
  late AnimationController _controller;
  Character? player;
  List<Character> enemies = [];
  List<Collectable> collectables = [];
  List<Particle> particles = [];
  Offset cameraPos = Offset.zero;
  bool isGameOver = false;
  int highScore = 0;

  // Game timing
  Timer? _enemySpawnTimer;
  Timer? _collectableSpawnTimer;
  Timer? _timersUpdateTimer; // 用于定期更新定时器
  DateTime lastEnemySpawn = DateTime.now();
  DateTime gameStartTime = DateTime.now(); // 游戏开始时间
  int _lastDifficultyLevel = 0; // 上次的难度等级

  // Configuration
  static const double playerSpeed = 4.0;
  static const int maxCollectables = 120;
  static const int maxEnemies = 20;
  static const double magneticPickupRadius = 180.0;
  static const double magneticForce = 5.0;
  static const double cameraLerpFactor = 0.08;
  static const double chargeDistance = 300.0;

  // Player movement
  Offset moveVector = Offset.zero;

  // Player dash functionality
  void _triggerPlayerDash() {
    if (player != null && player!.canDash()) {
      player!.startDash();
      _createDashParticles(player!.pos, Colors.cyan);
      if (mounted) {
        setState(() {}); // Update UI to reflect dash state
      }
    }
  }

  void _createDashParticles(Offset pos, Color color) {
    List<Particle> newParticles = [];
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final speed = math.Random().nextDouble() * 6 + 4;

      newParticles.add(Particle(
        pos: pos,
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        color: color,
        size: math.Random().nextDouble() * 3 + 2,
        lifespan: 0.8,
      ));
    }
    if (mounted) {
      setState(() {
        particles.addAll(newParticles);
      });
    }
  }

  // 获取当前游戏难度级别（基于游戏时长，每分钟+1级）
  int get currentDifficultyLevel {
    if (isGameOver) return 0;
    final elapsed = DateTime.now().difference(gameStartTime);
    return (elapsed.inMinutes).clamp(0, 10); // 最高10级难度
  }

  // 获取当前难度倍数
  double get difficultyMultiplier {
    return 1.0 + (currentDifficultyLevel * 0.25); // 每分钟增加25%难度
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 365), // Infinite duration
    )..addListener(_updateGame);

    // 同步初始化游戏，避免异步导致的黑屏问题
    _initGame();
    _loadHighScore();
    _controller.forward();
  }

  Future<void> _loadHighScore() async {
    try {
      final score = await StorageService.getHighScore();
      if (mounted) {
        setState(() {
          highScore = score;
        });
      }
    } catch (e) {
      // 如果加载失败，使用默认值
      if (mounted) {
        setState(() {
          highScore = 0;
        });
      }
    }
  }

  void _initGame() {
    _enemySpawnTimer?.cancel();
    _collectableSpawnTimer?.cancel();

    // 重置游戏开始时间
    gameStartTime = DateTime.now();

    final newPlayer = Character(
      id: 'player',
      pos: Offset.zero,
      bladeCount: 10,
      customName: 'You',
    );
    final newEnemies = [
      _createEnemy(EnemyType.brute, const Offset(400, 300)),
      _createEnemy(EnemyType.hunter, const Offset(-300, -200)),
      _createEnemy(EnemyType.scout, const Offset(-300, 400)),
    ];
    final newCollectables = <Collectable>[];
    final pRef = newPlayer;
    for (int i = 0; i < 80; i++) {
      final angle = math.Random().nextDouble() * 2 * math.pi;
      final distance = math.Random().nextDouble() * 1000;
      final spawnPos = Offset(
        pRef.pos.dx + math.cos(angle) * distance,
        pRef.pos.dy + math.sin(angle) * distance,
      );
      newCollectables.add(Collectable(pos: spawnPos));
    }

    if (mounted) {
      setState(() {
        isGameOver = false;
        player = newPlayer;
        enemies = newEnemies;
        collectables = newCollectables;
        particles.clear();
        cameraPos = Offset.zero;
        moveVector = Offset.zero;
      });
      print(
          '🎮 Game initialized - Player: ${player?.bladeCount}, Enemies: ${enemies.length}, Collectables: ${collectables.length}');
    }

    _startTimers();
  }

  void _startTimers() {
    _enemySpawnTimer?.cancel();
    _collectableSpawnTimer?.cancel();
    _timersUpdateTimer?.cancel();

    // 动态调整生成间隔 - 随着时间推移，生成间隔会减少
    final baseEnemyInterval = 4.0; // 基础4秒间隔
    final minEnemyInterval = 1.5; // 最小1.5秒间隔
    final currentEnemyInterval = (baseEnemyInterval / difficultyMultiplier)
        .clamp(minEnemyInterval, baseEnemyInterval);

    final baseCollectableInterval = 1200; // 基础1200ms间隔
    final minCollectableInterval = 600; // 最小600ms间隔
    final currentCollectableInterval =
        (baseCollectableInterval / difficultyMultiplier)
            .clamp(minCollectableInterval.toDouble(),
                baseCollectableInterval.toDouble())
            .round();

    _enemySpawnTimer = Timer.periodic(
      Duration(milliseconds: (currentEnemyInterval * 1000).round()),
      (_) => _spawnEnemy(),
    );

    _collectableSpawnTimer = Timer.periodic(
      Duration(milliseconds: currentCollectableInterval),
      (_) => _spawnCollectable(),
    );

    // 每30秒检查一次是否需要更新定时器
    _timersUpdateTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _updateTimersIfNeeded(),
    );

    _lastDifficultyLevel = currentDifficultyLevel;
  }

  void _updateTimersIfNeeded() {
    if (currentDifficultyLevel != _lastDifficultyLevel) {
      print(
          '🎯 Difficulty updated: Level ${currentDifficultyLevel + 1} (${(difficultyMultiplier * 100).round()}%)');
      _startTimers(); // 重新启动定时器
    }
  }

  Character _createEnemy(EnemyType type, Offset pos) {
    // 基于时间的难度递增系统 - 后期敌人数据要大幅增长
    final timeDifficultyMultiplier = difficultyMultiplier;

    // 基于玩家当前等级的难度（减弱影响）
    final playerLevel = (player?.bladeCount ?? 10) ~/ 20;
    final playerDifficultyMultiplier = 1.0 + (playerLevel * 0.1);

    // 后期敌人数据大幅增长 - 游戏时间越长，敌人越强
    final gameMinutes = DateTime.now().difference(gameStartTime).inMinutes;
    final lateGameMultiplier = 1.0 + (gameMinutes * 0.4); // 每分钟增长40%

    // 综合难度倍数
    final finalMultiplier = timeDifficultyMultiplier *
        playerDifficultyMultiplier *
        lateGameMultiplier;

    // 后期敌人的基础数据更大
    final baseBlades = (type.baseBlades * finalMultiplier).round();
    final randomRange = (8 * timeDifficultyMultiplier * lateGameMultiplier)
        .round()
        .clamp(5, 30);
    final bladeCount = baseBlades + math.Random().nextInt(randomRange);

    return Character(
      id: '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      pos: pos,
      bladeCount: bladeCount,
      type: type,
    );
  }

  void _spawnEnemy() {
    if (enemies.where((e) => e.isActive).length >= maxEnemies ||
        player == null) {
      return;
    }

    // Safety check for player position before spawning
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    final angle = math.Random().nextDouble() * 2 * math.pi;
    final distance = 800.0 + math.Random().nextDouble() * 200;
    final spawnPos = Offset(
      player!.pos.dx + math.cos(angle) * distance,
      player!.pos.dy + math.sin(angle) * distance,
    );

    // Safety check for spawn position
    if (!spawnPos.dx.isFinite || !spawnPos.dy.isFinite) {
      return; // Skip spawning if position is invalid
    }

    final enemyTypes = EnemyType.allTypes;
    final randomType = enemyTypes[math.Random().nextInt(enemyTypes.length)];

    if (mounted) {
      setState(() {
        enemies.add(_createEnemy(randomType, spawnPos));
      });
    }
  }

  void _spawnCollectable() {
    if (collectables.length >= maxCollectables || player == null) {
      return;
    }

    // Safety check for player position before spawning
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    final angle = math.Random().nextDouble() * 2 * math.pi;
    final distance = math.Random().nextDouble() * 1000;
    final spawnPos = Offset(
      player!.pos.dx + math.cos(angle) * distance,
      player!.pos.dy + math.sin(angle) * distance,
    );

    // Safety check for spawn position
    if (!spawnPos.dx.isFinite || !spawnPos.dy.isFinite) {
      return; // Skip spawning if position is invalid
    }
    if (mounted) {
      setState(() {
        collectables.add(Collectable(pos: spawnPos));
      });
    }
  }

  void _updateGame() {
    if (isGameOver || player == null || !mounted) return;

    // Basic safety check and player movement
    if (!moveVector.dx.isFinite || !moveVector.dy.isFinite) {
      moveVector = Offset.zero;
    }

    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    // Calculate player speed based on dash state
    final currentPlayerSpeed =
        player!.isDashing ? playerSpeed * 5.0 : playerSpeed;

    player!.pos += Offset(
      moveVector.dx * currentPlayerSpeed,
      moveVector.dy * currentPlayerSpeed,
    );

    _updateAI();

    // Update all characters
    final allCharacters = [player!, ...enemies];
    for (final character in allCharacters) {
      if (character.isActive) {
        character.updateCharging();
        if (character.id != 'player') {
          if (!character.moveVector.dx.isFinite ||
              !character.moveVector.dy.isFinite) {
            character.moveVector = Offset.zero;
          }
          if (!character.pos.dx.isFinite || !character.pos.dy.isFinite) {
            character.pos = Offset.zero;
          }
          character.pos += character.moveVector;
        }
      }
    }

    _updateMagneticPickup();
    _checkCollisions();
    _updateParticles();
    _updateCamera();
    _cleanupObjects();

    // Update UI
    if (mounted) {
      setState(() {});
    }
  }

  void _updateAI() {
    if (player == null) return;

    // Basic safety check for player position
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    final activeEnemies = enemies.where((e) => e.isActive).toList();

    for (final enemy in activeEnemies) {
      // Basic safety check for enemy position
      if (!enemy.pos.dx.isFinite || !enemy.pos.dy.isFinite) {
        enemy.pos = Offset.zero;
      }

      final dx = player!.pos.dx - enemy.pos.dx;
      final dy = player!.pos.dy - enemy.pos.dy;
      final distToPlayer = math.sqrt(dx * dx + dy * dy);

      // 关键修复：防止除零错误
      if (distToPlayer < 0.1) {
        enemy.moveVector = Offset.zero;
        continue;
      }

      final isStronger = enemy.bladeCount > player!.bladeCount;

      // 计算附近盟友数量以实现群体行为
      final nearbyAllies = activeEnemies.where((other) {
        if (other.id == enemy.id) return false;
        final allyDist = (other.pos - enemy.pos).distance;
        return allyDist < 200.0;
      }).length;

      // 群体攻击bonus
      final groupConfidence = nearbyAllies * 0.15;
      final effectiveStrength = enemy.bladeCount * (1.0 + groupConfidence);

      // Activate charging behavior if conditions are met.
      // 强敌更积极地冲刺 - 数据大于玩家时立即冲刺
      final isSignificantlyStronger =
          enemy.bladeCount > (player!.bladeCount * 1.2);
      final chargeDistanceForStrongEnemy =
          isSignificantlyStronger ? 500.0 : chargeDistance;

      if ((effectiveStrength > player!.bladeCount ||
              isStronger ||
              isSignificantlyStronger) &&
          !enemy.isCharging &&
          distToPlayer < chargeDistanceForStrongEnemy) {
        enemy.startCharging();
      }

      // Determine behavior based on strength and enemy type.
      if (effectiveStrength > player!.bladeCount || enemy.isCharging) {
        // BEHAVIOR: ATTACK / CHARGE towards the player.
        final currentSpeed = enemy.currentSpeed;

        // 强敌更加直接和快速地追击玩家
        if (isSignificantlyStronger) {
          // 强敌直接追击，不添加随机性
          enemy.moveVector = Offset(
            (dx / distToPlayer) * currentSpeed,
            (dy / distToPlayer) * currentSpeed,
          );
        } else {
          // 普通强敌添加一些随机性避免所有敌人都走相同路径
          final randomOffset = Offset(
            (math.Random().nextDouble() - 0.5) * 0.3,
            (math.Random().nextDouble() - 0.5) * 0.3,
          );

          final baseDirection = Offset(dx / distToPlayer, dy / distToPlayer);
          final finalDirection = baseDirection + randomOffset;
          final finalDistance = finalDirection.distance;

          if (finalDistance > 0.1) {
            enemy.moveVector = Offset(
              (finalDirection.dx / finalDistance) * currentSpeed,
              (finalDirection.dy / finalDistance) * currentSpeed,
            );
          } else {
            enemy.moveVector = Offset(
              (dx / distToPlayer) * currentSpeed,
              (dy / distToPlayer) * currentSpeed,
            );
          }
        }
      } else {
        // BEHAVIOR: WEAKER (FLEE or SCAVENGE).
        if (enemy.behavior == 'scavenger' && distToPlayer > 300) {
          // SUB-BEHAVIOR: SCAVENGE for collectables when far from the player.
          Collectable? closest;
          double minDistance = double.infinity;

          // Find the closest collectable.
          for (final collectable in collectables) {
            final cdx = collectable.pos.dx - enemy.pos.dx;
            final cdy = collectable.pos.dy - enemy.pos.dy;
            final distance = math.sqrt(cdx * cdx + cdy * cdy);

            if (distance < minDistance) {
              minDistance = distance;
              closest = collectable;
            }
          }

          if (closest != null && minDistance > 0.1) {
            final cdx = closest.pos.dx - enemy.pos.dx;
            final cdy = closest.pos.dy - enemy.pos.dy;
            enemy.moveVector = Offset(
              (cdx / minDistance) * enemy.speed,
              (cdy / minDistance) * enemy.speed,
            );
          } else {
            enemy.moveVector = Offset.zero;
          }
        } else {
          // SUB-BEHAVIOR: FLEE from the player if not scavenging.
          // 聪明的逃跑：不只是直线逃跑，而是向安全区域逃跑
          final fleeSpeed = enemy.speed * 1.5; // 逃跑时移动更快

          // 寻找逃跑方向：远离玩家并且避开其他敌人
          var fleeDirection = Offset(-dx / distToPlayer, -dy / distToPlayer);

          // 避免与其他敌人碰撞
          for (final other in activeEnemies) {
            if (other.id == enemy.id) continue;
            final otherDist = (other.pos - enemy.pos).distance;
            if (otherDist < 100.0 && otherDist > 0.1) {
              final avoidX = (enemy.pos.dx - other.pos.dx) / otherDist;
              final avoidY = (enemy.pos.dy - other.pos.dy) / otherDist;
              fleeDirection += Offset(avoidX * 0.5, avoidY * 0.5);
            }
          }

          final fleeDistance = fleeDirection.distance;
          if (fleeDistance > 0.1) {
            enemy.moveVector = Offset(
              (fleeDirection.dx / fleeDistance) * fleeSpeed,
              (fleeDirection.dy / fleeDistance) * fleeSpeed,
            );
          } else {
            enemy.moveVector = Offset(
              -(dx / distToPlayer) * fleeSpeed,
              -(dy / distToPlayer) * fleeSpeed,
            );
          }
        }
      }

      // Final safety check for the calculated moveVector
      if (!enemy.moveVector.dx.isFinite || !enemy.moveVector.dy.isFinite) {
        enemy.moveVector = Offset.zero;
      }
    }
  }

  void _updateMagneticPickup() {
    if (player == null) return;
    final List<Character> allPickers = [player!, ...enemies];

    for (final picker in allPickers) {
      if (!picker.isActive) continue;

      double pickupRadius = (picker.id == 'player')
          ? magneticPickupRadius
          : magneticPickupRadius / 2;

      for (final collectable in collectables) {
        final dx = picker.pos.dx - collectable.pos.dx;
        final dy = picker.pos.dy - collectable.pos.dy;
        final distance = math.sqrt(dx * dx + dy * dy);

        if (distance < pickupRadius && distance > 0.01) {
          final force = 1 - (distance / pickupRadius);
          final moveX = (dx / distance) * magneticForce * force;
          final moveY = (dy / distance) * magneticForce * force;

          collectable.pos += Offset(moveX, moveY);
        }
      }
    }
  }

  void _checkCollisions() {
    if (player == null) return;

    final allCharacters = [player!, ...enemies.where((e) => e.isActive)];
    List<Collectable> collectedThisFrame = [];

    for (final character in allCharacters) {
      for (final collectable in collectables) {
        final distance = (character.pos - collectable.pos).distance;
        if (distance < 20 + collectable.radius) {
          // Core radius
          character.addBlade();
          collectedThisFrame.add(collectable);
        }
      }
    }
    if (collectedThisFrame.isNotEmpty && mounted) {
      setState(() {
        collectables.removeWhere((c) => collectedThisFrame.contains(c));
      });
    }

    for (int i = 0; i < allCharacters.length; i++) {
      for (int j = i + 1; j < allCharacters.length; j++) {
        final charA = allCharacters[i];
        final charB = allCharacters[j];

        final distance = (charA.pos - charB.pos).distance;

        if (distance < charA.bladesRadius + charB.bladesRadius) {
          if (charA.canClash()) {
            charA.takeClashDamage();
            _createClashParticles(charA.pos, charA.color);
          }

          if (charB.canClash()) {
            charB.takeClashDamage();
            _createClashParticles(charB.pos, charB.color);
          }
        }
      }
    }

    if (player != null && !player!.isActive) {
      _endGame();
    }
  }

  void _createClashParticles(Offset pos, Color color) {
    List<Particle> newParticles = [];
    for (int i = 0; i < 5; i++) {
      final angle = math.Random().nextDouble() * 2 * math.pi;
      final speed = math.Random().nextDouble() * 8 + 2;

      newParticles.add(Particle(
        pos: pos,
        velocity: Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        ),
        color: color,
        size: math.Random().nextDouble() * 4 + 2,
      ));
    }
    if (mounted) {
      setState(() {
        particles.addAll(newParticles);
      });
    }
  }

  void _updateParticles() {
    if (particles.isEmpty) return;
    particles.forEach((p) => p.update());
    particles.removeWhere((p) => p.isDead);
  }

  void _updateCamera() {
    if (player == null) return;

    // Basic safety checks
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }
    if (!cameraPos.dx.isFinite || !cameraPos.dy.isFinite) {
      cameraPos = Offset.zero;
    }

    final newCameraPos = Offset.lerp(cameraPos, player!.pos, cameraLerpFactor);
    cameraPos = newCameraPos ?? player!.pos;
  }

  void _cleanupObjects() {
    enemies.removeWhere((enemy) => !enemy.isActive);
  }

  void _endGame() async {
    if (isGameOver) return;

    _controller.stop();
    _enemySpawnTimer?.cancel();
    _collectableSpawnTimer?.cancel();

    int finalScore = player?.bladeCount ?? 0;
    if (player != null) {
      await StorageService.saveHighScore(finalScore);
      final newHighScore = await StorageService.getHighScore();
      if (mounted) {
        setState(() {
          highScore = newHighScore;
        });
      }
    }

    if (mounted) {
      setState(() {
        isGameOver = true;
      });
    }
  }

  void _restartGame() {
    _controller.stop();
    _initGame();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateGame);
    _controller.dispose();
    _enemySpawnTimer?.cancel();
    _collectableSpawnTimer?.cancel();
    _timersUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 确保始终显示游戏界面，即使在初始化过程中
    final currentPlayer = player;

    final joystickPosition = Positioned(
      bottom: 80,
      left: 30,
      child: Joystick(
        size: 140.0, // 稍微缩小摇杆适配竖屏
        onMove: (Offset vector) {
          if (mounted) {
            setState(() {
              moveVector = vector;
            });
          }
        },
      ),
    );

    // 冲刺按钮
    final dashButton = Positioned(
      bottom: 80,
      right: 30,
      child: GestureDetector(
        onTap: _triggerPlayerDash,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: (currentPlayer?.canDash() ?? false)
                ? Colors.blue.withOpacity(0.8)
                : Colors.grey.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: (currentPlayer?.isDashing ?? false)
                  ? Colors.white
                  : Colors.grey.withOpacity(0.7),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 冷却进度环
              if (currentPlayer != null && !currentPlayer.canDash())
                CircularProgressIndicator(
                  value: currentPlayer.dashCooldownProgress,
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
              // 冲刺图标
              Icon(
                Icons.double_arrow,
                color: (currentPlayer?.canDash() ?? false)
                    ? Colors.white
                    : Colors.grey[600],
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GameCanvas(
            repaint: _controller,
            player: currentPlayer,
            enemies: enemies,
            collectables: collectables,
            particles: particles,
            cameraPos: cameraPos,
          ),
          Positioned(
            top: 60,
            left: 20,
            child: Leaderboard(
              characters: [
                if (currentPlayer != null && currentPlayer.isActive)
                  currentPlayer,
                ...enemies.where((e) => e.isActive),
              ],
            ),
          ),
          // 难度等级显示
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '难度 ${currentDifficultyLevel + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(difficultyMultiplier * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          joystickPosition,
          dashButton,
          if (isGameOver)
            GameOverOverlay(
              onRestart: _restartGame,
              finalScore: currentPlayer?.bladeCount ?? 0,
              highScore: highScore,
            ),
        ],
      ),
    );
  }
}
