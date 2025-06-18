### main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BladeClashApp());
}

class BladeClashApp extends StatelessWidget {
  const BladeClashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '神将GO (Blade Clash)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const GameWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameWrapper extends StatefulWidget {
  const GameWrapper({super.key});

  @override
  State<GameWrapper> createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  @override
  void initState() {
    super.initState();
    _setOrientation();
  }

  void _setOrientation() {
    // 设置沉浸式全屏模式
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    // 将方向设置为横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return const GameScreen();
  }
}
```

### models/enemy_type.dart

```dart
import 'package:flutter/material.dart';

class EnemyType {
  final String name;
  final double baseSpeed;
  final Color color;
  final IconData icon;
  final String behavior; // 'scavenger', 'charger', 'standard'
  final int baseBlades;

  const EnemyType({
    required this.name,
    required this.baseSpeed,
    required this.color,
    required this.icon,
    required this.behavior,
    required this.baseBlades,
  });

  static const EnemyType scout = EnemyType(
    name: 'Scout',
    baseSpeed: 2.2,
    color: Color(0xFF22d3ee), // cyan-400
    icon: Icons.directions_run,
    behavior: 'scavenger',
    baseBlades: 3,
  );

  static const EnemyType brute = EnemyType(
    name: 'Brute',
    baseSpeed: 0.9,
    color: Color(0xFFa855f7), // purple-500
    icon: Icons.shield,
    behavior: 'standard',
    baseBlades: 20,
  );

  static const EnemyType hunter = EnemyType(
    name: 'Hunter',
    baseSpeed: 1.6,
    color: Color(0xFFf97316), // orange-500
    icon: Icons.flash_on,
    behavior: 'charger',
    baseBlades: 8,
  );

  static List<EnemyType> get allTypes => [scout, brute, hunter];
}
```

### models/collectable.dart

```dart
import 'package:flutter/material.dart';

class Collectable {
  Offset pos;
  final double radius = 15.0;

  Collectable({required this.pos});
}
```

### models/character.dart

```dart
import 'package:flutter/material.dart';
import 'enemy_type.dart';

class Character {
  String id;
  Offset pos;
  int bladeCount;
  bool isActive = true;
  EnemyType? type; // null indicates player
  String name;

  // AI-related state
  bool isCharging = false;
  DateTime chargeEndTime = DateTime.now();
  DateTime lastClashTime = DateTime.now();
  Offset moveVector = Offset.zero;

  Character({
    required this.id,
    required this.pos,
    required this.bladeCount,
    this.type,
    String? customName,
  }) : name = customName ?? (type?.name ?? 'You');

  // Dynamic calculated properties
  double get speed => type?.baseSpeed ?? 3.0;

  double get bladesRadius => (30 + bladeCount * 1.2).clamp(30.0, 250.0);

  double get fullRadius => bladesRadius + 20.0; // Used for collision detection

  Color get color => type?.color ?? Colors.yellow;

  IconData get icon => type?.icon ?? Icons.person;

  String get behavior => type?.behavior ?? 'player';

  // Blade visual styling based on count
  BladeStyle get bladeStyle {
    if (bladeCount >= 100) {
      return const BladeStyle(
        color: Color(0xFFef4444), // red-500
        size: 32.0,
        labelColor: Color(0xFFdc2626), // red-600
      );
    }
    if (bladeCount >= 10) {
      return const BladeStyle(
        color: Color(0xFF4ade80), // green-400
        size: 24.0,
        labelColor: Color(0xFF16a34a), // green-600
      );
    }
    return const BladeStyle(
      color: Colors.white,
      size: 16.0,
      labelColor: Color(0xFF6b7280), // gray-500
    );
  }

  void takeClashDamage() {
    if (bladeCount > 0) {
      bladeCount--;
    }
    if (bladeCount <= 0) {
      isActive = false;
    }
    lastClashTime = DateTime.now();
  }

  void addBlade() {
    bladeCount++;
  }

  bool canClash() {
    final now = DateTime.now();
    return now.difference(lastClashTime).inMilliseconds > 200; // 200ms cooldown
  }

  void startCharging() {
    isCharging = true;
    chargeEndTime = DateTime.now().add(const Duration(milliseconds: 500));
  }

  void updateCharging() {
    if (isCharging && DateTime.now().isAfter(chargeEndTime)) {
      isCharging = false;
    }
  }

  double get currentSpeed {
    if (isCharging) {
      return speed * 3.0; // Charge speed multiplier
    }
    return speed;
  }
}

class BladeStyle {
  final Color color;
  final double size;
  final Color labelColor;

  const BladeStyle({
    required this.color,
    required this.size,
    required this.labelColor,
  });
}
```

### models/particle.dart

```dart
import 'package:flutter/material.dart';

class Particle {
  Offset pos;
  Offset velocity;
  Color color;
  double lifespan; // 1.0 (100%) decreases to 0.0
  final double size;

  Particle({
    required this.pos,
    required this.velocity,
    required this.color,
    this.lifespan = 1.0,
    this.size = 3.0,
  });

  void update() {
    // Safety checks for position and velocity
    if (!pos.dx.isFinite || !pos.dy.isFinite) {
      pos = Offset.zero;
    }
    if (!velocity.dx.isFinite || !velocity.dy.isFinite) {
      velocity = Offset.zero;
    }

    pos += velocity;
    velocity += const Offset(0, 0.1); // Simple gravity
    lifespan -= 0.03; // Fade over time

    // Final safety check after update
    if (!pos.dx.isFinite || !pos.dy.isFinite) {
      pos = Offset.zero;
    }
    if (!velocity.dx.isFinite || !velocity.dy.isFinite) {
      velocity = Offset.zero;
    }
  }

  bool get isDead => lifespan <= 0;
}
```

### screens/game_screen.dart

```dart
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
  DateTime lastEnemySpawn = DateTime.now();

  // Configuration
  static const double playerSpeed = 3.0;
  static const int maxCollectables = 120;
  static const int maxEnemies = 25;
  static const double magneticPickupRadius = 150.0;
  static const double magneticForce = 4.0;
  static const double cameraLerpFactor = 0.08;
  static const double chargeDistance = 300.0;

  // Player movement
  Offset moveVector = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 365), // Infinite duration
    )..addListener(_updateGame);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGameDataAndInitialize();
    });
  }

  Future<void> _loadGameDataAndInitialize() async {
    highScore = await StorageService.getHighScore();
    _initGame();
    _controller.forward();
  }

  void _initGame() {
    _enemySpawnTimer?.cancel();
    _collectableSpawnTimer?.cancel();

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
    }

    _startTimers();
  }

  void _startTimers() {
    _enemySpawnTimer?.cancel();
    _collectableSpawnTimer?.cancel();

    _enemySpawnTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _spawnEnemy(),
    );

    _collectableSpawnTimer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => _spawnCollectable(),
    );
  }

  Character _createEnemy(EnemyType type, Offset pos) {
    final bladeCount = type.baseBlades + math.Random().nextInt(5);
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

    // Safety check for moveVector
    if (!moveVector.dx.isFinite || !moveVector.dy.isFinite) {
      moveVector = Offset.zero;
    }

    // Safety check for player position before updating
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    player!.pos += Offset(
      moveVector.dx * playerSpeed,
      moveVector.dy * playerSpeed,
    );

    // Safety check for player position after updating
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    _updateAI();

    final allCharacters = [player!, ...enemies];
    for (final character in allCharacters) {
      if (character.isActive) {
        character.updateCharging();
        if (character.id != 'player') {
          // Safety check for character moveVector
          if (!character.moveVector.dx.isFinite ||
              !character.moveVector.dy.isFinite) {
            character.moveVector = Offset.zero;
          }

          // Safety check for character position before updating
          if (!character.pos.dx.isFinite || !character.pos.dy.isFinite) {
            character.pos = Offset.zero;
          }

          character.pos += character.moveVector;

          // Safety check for character position after updating
          if (!character.pos.dx.isFinite || !character.pos.dy.isFinite) {
            character.pos = Offset.zero;
          }
        }
      }
    }

    _updateMagneticPickup();
    _checkCollisions();
    _updateParticles();
    _updateCamera();
    _cleanupObjects();

    // This setState call is crucial to update the UI with new game state each frame.
    if (mounted) {
      setState(() {});
    }
  }

  // ### BUG FIX: Rewritten _updateAI method for robustness ###
  // 这个重写的方法是解决黑屏问题的关键。它能防止因距离为零而导致的除零错误，
  // 这种错误会产生无效的坐标值（NaN），从而使渲染引擎崩溃。
  void _updateAI() {
    if (player == null) return;

    // Safety check for player position
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    for (final enemy in enemies) {
      if (!enemy.isActive) continue;

      // Safety check for enemy position
      if (!enemy.pos.dx.isFinite || !enemy.pos.dy.isFinite) {
        enemy.pos = Offset.zero;
      }

      final dx = player!.pos.dx - enemy.pos.dx;
      final dy = player!.pos.dy - enemy.pos.dy;

      // Safety check for dx and dy
      if (!dx.isFinite || !dy.isFinite) {
        enemy.moveVector = Offset.zero;
        continue;
      }

      final distToPlayer = math.sqrt(dx * dx + dy * dy);

      // 关键修复：增加一个安全检查，防止后续计算中使用一个几乎为零的距离值。
      // 这是导致崩溃的主要原因。
      if (distToPlayer < 0.01 || !distToPlayer.isFinite) {
        enemy.moveVector = Offset.zero;
        continue;
      }

      final isStronger = enemy.bladeCount > player!.bladeCount;

      // Activate charging behavior if conditions are met.
      if (isStronger && !enemy.isCharging && distToPlayer < chargeDistance) {
        enemy.startCharging();
      }

      // Determine behavior based on strength and enemy type.
      if (isStronger || enemy.isCharging) {
        // BEHAVIOR: ATTACK / CHARGE towards the player.
        final currentSpeed = enemy.currentSpeed;
        if (currentSpeed.isFinite && currentSpeed > 0) {
          enemy.moveVector = Offset(
            (dx / distToPlayer) * currentSpeed,
            (dy / distToPlayer) * currentSpeed,
          );
        } else {
          enemy.moveVector = Offset.zero;
        }
      } else {
        // BEHAVIOR: WEAKER (FLEE or SCAVENGE).
        if (enemy.behavior == 'scavenger' && distToPlayer > 250) {
          // SUB-BEHAVIOR: SCAVENGE for collectables when far from the player.
          Collectable? closest;
          double minDistance = double.infinity;

          // Find the closest collectable.
          for (final collectable in collectables) {
            // Safety check for collectable position
            if (!collectable.pos.dx.isFinite || !collectable.pos.dy.isFinite) {
              continue;
            }

            final cdx = collectable.pos.dx - enemy.pos.dx;
            final cdy = collectable.pos.dy - enemy.pos.dy;

            // Safety check for cdx and cdy
            if (!cdx.isFinite || !cdy.isFinite) {
              continue;
            }

            final distance = math.sqrt(cdx * cdx + cdy * cdy);

            if (distance.isFinite && distance < minDistance) {
              minDistance = distance;
              closest = collectable;
            }
          }

          if (closest != null) {
            // 关键修复：检查与可收集物品的距离，防止除零。
            if (minDistance > 0.01 && minDistance.isFinite) {
              final cdx = closest.pos.dx - enemy.pos.dx;
              final cdy = closest.pos.dy - enemy.pos.dy;

              // Final safety check
              if (cdx.isFinite && cdy.isFinite && enemy.speed.isFinite) {
                enemy.moveVector = Offset(
                  (cdx / minDistance) * enemy.speed,
                  (cdy / minDistance) * enemy.speed,
                );
              } else {
                enemy.moveVector = Offset.zero;
              }
            } else {
              // If already on top of the collectable, stop moving.
              enemy.moveVector = Offset.zero;
            }
          } else {
            // If no collectables are found, stop moving (idle).
            enemy.moveVector = Offset.zero;
          }
        } else {
          // SUB-BEHAVIOR: FLEE from the player if not scavenging.
          if (enemy.speed.isFinite && enemy.speed > 0) {
            enemy.moveVector = Offset(
              -(dx / distToPlayer) * enemy.speed,
              -(dy / distToPlayer) * enemy.speed,
            );
          } else {
            enemy.moveVector = Offset.zero;
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

    // Safety check for player position
    if (!player!.pos.dx.isFinite || !player!.pos.dy.isFinite) {
      player!.pos = Offset.zero;
    }

    // Safety check for current camera position
    if (!cameraPos.dx.isFinite || !cameraPos.dy.isFinite) {
      cameraPos = Offset.zero;
    }

    final newCameraPos = Offset.lerp(cameraPos, player!.pos, cameraLerpFactor);

    // Safety check for new camera position
    if (newCameraPos != null &&
        newCameraPos.dx.isFinite &&
        newCameraPos.dy.isFinite) {
      cameraPos = newCameraPos;
    } else {
      cameraPos = player!.pos; // Fallback to player position
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      // Show a loading indicator or a blank screen while initializing
      return const Scaffold(
        backgroundColor: Color(0xFF000010),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final joystickPosition = Positioned(
      bottom: 40,
      left: (screenWidth - 160) / 2,
      child: Joystick(
        onMove: (Offset vector) {
          if (mounted) {
            setState(() {
              moveVector = vector;
            });
          }
        },
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF000010),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GameCanvas(
            repaint: _controller,
            player: player,
            enemies: enemies,
            collectables: collectables,
            particles: particles,
            cameraPos: cameraPos,
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Leaderboard(
              characters: [
                if (player != null && player!.isActive) player!,
                ...enemies.where((e) => e.isActive),
              ],
            ),
          ),
          joystickPosition,
          if (isGameOver)
            GameOverOverlay(
              onRestart: _restartGame,
              finalScore: player?.bladeCount ?? 0,
              highScore: highScore,
            ),
        ],
      ),
    );
  }
}
```

### services/storage_service.dart

```dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _highScoreKey = 'highScore';

  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighScore = await getHighScore();
    if (score > currentHighScore) {
      await prefs.setInt(_highScoreKey, score);
    }
  }

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }
}
```

### widgets/leaderboard.dart

```dart
import 'package:flutter/material.dart';
import '../models/character.dart';

class Leaderboard extends StatelessWidget {
  final List<Character> characters;

  const Leaderboard({
    super.key,
    required this.characters,
  });

  @override
  Widget build(BuildContext context) {
    final sortedList = List<Character>.from(characters);
    sortedList.sort((a, b) => b.bladeCount.compareTo(a.bladeCount));
    final topCharacters = sortedList.take(5);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.yellow,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '排行榜',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 12),
          if (topCharacters.isEmpty)
            const Center(
              child: Text('...', style: TextStyle(color: Colors.grey)),
            )
          else
            ...topCharacters.map((character) {
              final isPlayer = character.type == null;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: isPlayer
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        character.icon,
                        color: character.color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          character.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isPlayer ? Colors.yellow : Colors.white,
                            fontSize: 14,
                            fontWeight:
                                isPlayer ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${character.bladeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
```

### widgets/joystick.dart

```dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Joystick extends StatefulWidget {
  final Function(Offset) onMove;
  final double size;

  const Joystick({
    super.key,
    required this.onMove,
    this.size = 160.0,
  });

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset _thumbPosition = Offset.zero;

  void _handlePanUpdate(Offset localPosition) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final position = localPosition - center;
    final distance = position.distance;
    final maxDistance = widget.size / 2;

    // Safety check for valid position values
    if (!position.dx.isFinite || !position.dy.isFinite || !distance.isFinite) {
      return;
    }

    Offset newThumbPosition;
    if (distance <= maxDistance) {
      newThumbPosition = position;
    } else {
      newThumbPosition = Offset.fromDirection(position.direction, maxDistance);
    }

    final maxMoveDistance = widget.size / 4;
    // Safety check to prevent division by zero
    if (maxMoveDistance <= 0) {
      widget.onMove(Offset.zero);
      return;
    }

    final moveVectorDistance = newThumbPosition.distance;
    final normalizedVector = moveVectorDistance > 0
        ? Offset(
            (newThumbPosition.dx / maxMoveDistance).clamp(-1.0, 1.0),
            (newThumbPosition.dy / maxMoveDistance).clamp(-1.0, 1.0),
          )
        : Offset.zero;

    // Final safety check for the normalized vector
    if (!normalizedVector.dx.isFinite || !normalizedVector.dy.isFinite) {
      widget.onMove(Offset.zero);
      return;
    }

    widget.onMove(normalizedVector);
    setState(() {
      _thumbPosition = newThumbPosition;
    });
  }

  void _handlePanEnd() {
    setState(() {
      _thumbPosition = Offset.zero;
    });
    widget.onMove(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onPanStart: (details) => _handlePanUpdate(details.localPosition),
        onPanUpdate: (details) => _handlePanUpdate(details.localPosition),
        onPanEnd: (details) => _handlePanEnd(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: Transform.translate(
              offset: _thumbPosition,
              child: Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### widgets/game_over_overlay.dart

```dart
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;
  final int finalScore;
  final int highScore;

  const GameOverOverlay({
    super.key,
    required this.onRestart,
    required this.finalScore,
    required this.highScore,
  });

  @override
  Widget build(BuildContext context) {
    final isNewHighScore = finalScore >= highScore && finalScore > 0;

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isNewHighScore ? Colors.yellow : Colors.red,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isNewHighScore ? Colors.yellow : Colors.red)
                      .withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '游戏结束',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.white, blurRadius: 2)]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (isNewHighScore) ...[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '新纪录！',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              _buildScoreRow('最终得分', finalScore, Colors.white),
              const SizedBox(height: 8),
              _buildScoreRow('最高纪录', highScore, Colors.yellow),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRestart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('重新开始'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int score, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 18,
          ),
        ),
        Text(
          '$score',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
```

### widgets/game_canvas.dart

```dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/character.dart';
import '../models/collectable.dart';
import '../models/particle.dart';

class GameCanvas extends StatelessWidget {
  final Listenable repaint;
  final Character? player;
  final List<Character> enemies;
  final List<Collectable> collectables;
  final List<Particle> particles;
  final Offset cameraPos;

  const GameCanvas({
    super.key,
    required this.repaint,
    required this.player,
    required this.enemies,
    required this.collectables,
    required this.particles,
    required this.cameraPos,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // This ensures the canvas is redrawn every time the AnimationController ticks.
      painter: GamePainter(
        player: player,
        enemies: enemies,
        collectables: collectables,
        particles: particles,
        cameraPos: cameraPos,
        repaint: repaint,
      ),
      isComplex: true,
      willChange: true,
    );
  }
}

class GamePainter extends CustomPainter {
  final Character? player;
  final List<Character> enemies;
  final List<Collectable> collectables;
  final List<Particle> particles;
  final Offset cameraPos;
  final Listenable repaint;

  // Reusable Paint objects for performance
  final Paint _starPaint = Paint()..color = Colors.white.withOpacity(0.6);
  final Paint _chargePaint = Paint()..style = PaintingStyle.fill;
  final Paint _corePaint = Paint()..style = PaintingStyle.fill;
  final Paint _coreStrokePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _bladePaint = Paint()..style = PaintingStyle.fill;
  final Paint _particlePaint = Paint()..style = PaintingStyle.fill;
  final Paint _labelBgPaint = Paint()..style = PaintingStyle.fill;
  final TextPainter _labelTextPainter = TextPainter(
      textAlign: TextAlign.center, textDirection: TextDirection.ltr);

  // Cache for blade Paths and icon TextPainters
  final Map<double, Path> _bladePathCache = {};
  final Map<IconData, TextPainter> _iconPainterCache = {};
  final double _time;

  GamePainter({
    required this.player,
    required this.enemies,
    required this.collectables,
    required this.particles,
    required this.cameraPos,
    required this.repaint,
  })  : _time = DateTime.now().millisecondsSinceEpoch / 1000.0,
        super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _drawStars(canvas, size);
    _drawCollectables(canvas, size);

    final allCharacters = [
      if (player != null && player!.isActive) player!,
      ...enemies.where((e) => e.isActive),
    ];
    allCharacters.sort((a, b) => a.pos.dy.compareTo(b.pos.dy));

    for (final character in allCharacters) {
      _drawCharacter(canvas, character, size);
    }

    _drawParticles(canvas, size);
  }

  void _drawStars(Canvas canvas, Size size) {
    // Safety check for cameraPos
    if (!cameraPos.dx.isFinite || !cameraPos.dy.isFinite) {
      return; // Skip drawing stars if camera position is invalid
    }

    final random = math.Random(0);
    final starCount = (size.width * size.height / 5000).clamp(50, 200).toInt();

    for (int i = 0; i < starCount; i++) {
      final starX = random.nextDouble() * 4000 - 2000;
      final starY = random.nextDouble() * 4000 - 2000;
      final parallaxFactor = (random.nextDouble() * 0.5) + 0.1;

      final screenPos = Offset(
        size.width / 2 + (starX - cameraPos.dx * parallaxFactor),
        size.height / 2 + (starY - cameraPos.dy * parallaxFactor),
      );

      // Safety check for screen position
      if (!screenPos.dx.isFinite || !screenPos.dy.isFinite) {
        continue;
      }

      final wrappedX = (screenPos.dx % size.width + size.width) % size.width;
      final wrappedY = (screenPos.dy % size.height + size.height) % size.height;

      // Safety check for wrapped coordinates
      if (!wrappedX.isFinite || !wrappedY.isFinite) {
        continue;
      }

      final starSize = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(wrappedX, wrappedY), starSize, _starPaint);
    }
  }

  void _drawCollectables(Canvas canvas, Size size) {
    for (final collectable in collectables) {
      // Safety check for collectable position
      if (!collectable.pos.dx.isFinite || !collectable.pos.dy.isFinite) {
        continue;
      }

      final screenPos = _worldToScreen(collectable.pos, size);

      // Safety check for screen position
      if (!screenPos.dx.isFinite || !screenPos.dy.isFinite) {
        continue;
      }

      if (_isOnScreen(screenPos, size, 100)) {
        _drawBlade(
            canvas, screenPos, collectable.radius, Colors.white, _time * 2);
      }
    }
  }

  void _drawCharacter(Canvas canvas, Character character, Size size) {
    // Safety check for character position
    if (!character.pos.dx.isFinite || !character.pos.dy.isFinite) {
      return;
    }

    final screenPos = _worldToScreen(character.pos, size);

    // Safety check for screen position
    if (!screenPos.dx.isFinite || !screenPos.dy.isFinite) {
      return;
    }

    if (!_isOnScreen(screenPos, size, character.fullRadius * 2)) return;

    if (character.isCharging) {
      _chargePaint.color = Colors.red.withOpacity(0.3);
      canvas.drawCircle(screenPos, character.bladesRadius * 1.5, _chargePaint);
    }

    _drawBlades(canvas, character, screenPos);

    _corePaint.color = character.color;
    canvas.drawCircle(screenPos, 20, _corePaint);
    canvas.drawCircle(screenPos, 20, _coreStrokePaint);

    _drawIcon(canvas, screenPos, character.icon, Colors.white, 16);
    _drawCharacterLabel(canvas, character, screenPos);
  }

  void _drawBlades(Canvas canvas, Character character, Offset center) {
    if (character.bladeCount <= 0) return;

    final bladeStyle = character.bladeStyle;
    const layers = 3;
    final bladesPerLayer = (character.bladeCount / layers).ceil();
    final maxBladesInRing = 40;

    for (int layer = 0; layer < layers; layer++) {
      if (character.bladeCount < layer * (bladesPerLayer / 2)) continue;

      final layerBladeCount = math.min(bladesPerLayer, maxBladesInRing);
      if (layerBladeCount == 0) continue;

      final layerRadius = character.bladesRadius - (layer * 18.0);
      if (layerRadius < 25) continue;

      final rotationSpeed = 1.0 - (layer * 0.4);
      final direction = layer.isEven ? 1 : -1;
      final rotation = (_time * rotationSpeed * direction);

      final angleStep = (2 * math.pi) / layerBladeCount;

      for (int i = 0; i < layerBladeCount; i++) {
        final angle = (angleStep * i) + rotation + (layer * 0.5);

        final bladePos = Offset(
          center.dx + math.cos(angle) * layerRadius,
          center.dy + math.sin(angle) * layerRadius,
        );

        _drawBlade(
            canvas, bladePos, bladeStyle.size / 2, bladeStyle.color, angle);
      }
    }
  }

  void _drawBlade(
      Canvas canvas, Offset center, double size, Color color, double rotation) {
    // Safety check for inputs
    if (!center.dx.isFinite ||
        !center.dy.isFinite ||
        !size.isFinite ||
        !rotation.isFinite) {
      return; // Skip drawing if any value is invalid
    }

    _bladePaint.color = color;

    final path = _bladePathCache.putIfAbsent(size, () {
      final p = Path();
      p.moveTo(-size, -size * 0.3);
      p.quadraticBezierTo(size * 0.5, -size * 0.8, size, 0);
      p.quadraticBezierTo(size * 0.5, size * 0.8, -size, size * 0.3);
      p.quadraticBezierTo(-size * 0.3, 0, -size, -size * 0.3);
      return p;
    });

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation + math.pi / 2);
    canvas.drawPath(path, _bladePaint);
    canvas.restore();
  }

  void _drawIcon(
      Canvas canvas, Offset center, IconData icon, Color color, double size) {
    final textPainter = _iconPainterCache.putIfAbsent(icon, () {
      final painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      );
      painter.layout();
      return painter;
    });

    if ((textPainter.text as TextSpan?)?.style?.color != color) {
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      );
      textPainter.layout();
    }

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawCharacterLabel(
      Canvas canvas, Character character, Offset screenPos) {
    final labelY = screenPos.dy - character.bladesRadius - 35;

    _labelTextPainter.text = TextSpan(
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 2.0, color: Colors.black)]),
      children: [
        TextSpan(
          text: character.name,
          style: TextStyle(
              color: character.type == null ? Colors.yellow : Colors.white),
        ),
        TextSpan(
          text: '  ${character.bladeCount}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );

    _labelTextPainter.layout();

    final bgWidth = _labelTextPainter.width + 16;
    final bgHeight = 22.0;
    _labelBgPaint.color = character.bladeStyle.labelColor.withOpacity(0.8);
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(screenPos.dx, labelY),
          width: bgWidth,
          height: bgHeight),
      const Radius.circular(11),
    );

    canvas.drawRRect(bgRect, _labelBgPaint);
    _labelTextPainter.paint(
      canvas,
      Offset(
        screenPos.dx - _labelTextPainter.width / 2,
        labelY - _labelTextPainter.height / 2,
      ),
    );
  }

  void _drawParticles(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Safety check for particle position
      if (!particle.pos.dx.isFinite || !particle.pos.dy.isFinite) {
        continue;
      }

      final screenPos = _worldToScreen(particle.pos, size);

      // Safety check for screen position
      if (!screenPos.dx.isFinite || !screenPos.dy.isFinite) {
        continue;
      }

      if (_isOnScreen(screenPos, size, 20)) {
        _particlePaint.color =
            particle.color.withOpacity((particle.lifespan).clamp(0.0, 1.0));
        canvas.drawCircle(screenPos, particle.size, _particlePaint);
      }
    }
  }

  Offset _worldToScreen(Offset worldPos, Size screenSize) {
    // Safety check for input values
    if (!worldPos.dx.isFinite ||
        !worldPos.dy.isFinite ||
        !cameraPos.dx.isFinite ||
        !cameraPos.dy.isFinite ||
        !screenSize.width.isFinite ||
        !screenSize.height.isFinite) {
      return Offset(screenSize.width / 2, screenSize.height / 2);
    }

    return Offset(
      worldPos.dx - cameraPos.dx + screenSize.width / 2,
      worldPos.dy - cameraPos.dy + screenSize.height / 2,
    );
  }

  bool _isOnScreen(Offset screenPos, Size screenSize, double margin) {
    return screenPos.dx > -margin &&
        screenPos.dx < screenSize.width + margin &&
        screenPos.dy > -margin &&
        screenPos.dy < screenSize.height + margin;
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    // The painter should repaint if any of the game state lists change
    // or if the camera position changes.
    // More importantly, it should repaint based on the animation controller ticks.
    // Since the repaint property is passed to the super constructor (CustomPainter),
    // CustomPainter will handle the repainting when 'repaint' notifies.
    // We only need to return true if the data that the painter uses changes.
    return oldDelegate.player != player ||
        oldDelegate.enemies != enemies ||
        oldDelegate.collectables != collectables ||
        oldDelegate.particles != particles ||
        oldDelegate.cameraPos != cameraPos;
  }
}
```

