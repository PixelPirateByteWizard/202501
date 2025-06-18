Flutter版《神将GO》开发文档

1. 简介 (Introduction)

本文档旨在将现有的 "Blade Clash" Web 游戏的核心玩法和视觉风格，转化为一个原生 Flutter 应用。我们将采用一套简洁、易于理解和扩展的代码架构，专注于实现游戏的核心功能，同时遵循无复杂依赖、无代码生成、纯 Dart/Flutter 的原则。

2. 项目架构 (Project Architecture)

为了保持代码的整洁和模块化，建议采用以下文件结构：

lib/
|
├── main.dart             # App入口，MaterialApp配置
|
├── models/               # 数据模型 (Plain Dart Objects)
|   ├── character.dart      # 角色模型 (玩家和敌人)
|   ├── enemy_type.dart     # 敌人类型定义
|   ├── collectable.dart    # 可收集物(刀片)模型
|   └── particle.dart       # 粒子效果模型
|
├── screens/              # 屏幕/页面
|   └── game_screen.dart    # 游戏主屏幕 (StatefulWidget)
|
├── widgets/              # 可复用的UI组件
|   ├── game_canvas.dart    # 游戏核心渲染区域 (CustomPaint)
|   ├── joystick.dart       # 摇杆控制器
|   ├── leaderboard.dart    # 排行榜UI
|   └── game_over_overlay.dart # 游戏结束遮罩层
|
└── services/             # 后端服务与逻辑
    └── storage_service.dart  # 本地存储 (SharedPreferences)
3. 核心模型 (Core Models - models/)

所有模型都将是简单的 Dart 类，不包含任何外部库的注解。

enemy_type.dart
定义敌人类型及其基础属性，替代 JS 中的 ENEMY_TYPES 对象。

Dart
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

  static const EnemyType scout = EnemyType(...);
  static const EnemyType brute = EnemyType(...);
  static const EnemyType hunter = EnemyType(...);
  
  static List<EnemyType> get allTypes => [scout, brute, hunter];
}
character.dart
通用角色模型，适用于玩家和敌人。

Dart
import 'package.flutter/material.dart';
import './enemy_type.dart';

class Character {
  String id;
  Offset pos; // 核心位置
  int bladeCount;
  bool isActive = true;
  EnemyType? type; // null 表示玩家
  String name;

  // 动态计算的属性
  double get speed => type?.baseSpeed ?? 3.0;
  double get bladesRadius => (30 + bladeCount * 1.2).clamp(0.0, 250.0);
  double get fullRadius => bladesRadius + 20.0; // 用于碰撞检测

  // AI相关状态
  bool isCharging = false;
  DateTime chargeEndTime = DateTime.now();
  DateTime lastClashTime = DateTime.now();
  Offset moveVector = Offset.zero;

  Character({
    required this.id,
    required this.pos,
    required this.bladeCount,
    this.type,
  }) : name = type?.name ?? 'You';

  void takeClashDamage() {
    if (bladeCount > 0) {
      bladeCount--;
    }
    if (bladeCount <= 0) {
      isActive = false;
    }
  }
}
collectable.dart & particle.dart
这两个模型非常简单，主要包含位置信息。

Dart
import 'package.flutter/material.dart';

class Collectable {
  Offset pos;
  final double radius = 15.0;
  Collectable({required this.pos});
}

class Particle {
  Offset pos;
  Offset velocity;
  Color color;
  double lifespan; // e.g., 1.0 (100%), decreases to 0.0
  Particle({required this.pos, required this.velocity, required this.color, this.lifespan = 1.0});
}
4. 状态管理 (State Management)

我们将使用 StatefulWidget (GameScreen) 作为所有游戏状态的中心。

GameScreenState 将持有游戏循环 AnimationController 和所有游戏对象列表。
游戏循环的每一帧 (tick) 都会调用 _updateGame() 方法。
在 _updateGame() 方法的末尾，调用 setState(() {}) 来通知 Flutter 框架重绘UI。
game_screen.dart 核心状态:

Dart
// Inside GameScreenState
late final AnimationController _controller;
Character player;
List<Character> enemies;
List<Collectable> collectables;
List<Particle> particles;
Offset cameraPos;
bool isGameOver;

void initState() {
  super.initState();
  _controller = AnimationController(vsync: this, duration: const Duration(days: 999))
    ..addListener(_updateGame)
    ..forward();
  // ... 初始化游戏 (initGame)
}

void _updateGame() {
  // 1. 更新所有对象的位置
  // 2. 执行AI逻辑
  // 3. 检测碰撞
  // 4. 更新粒子效果
  // 5. 更新摄像头位置
  // 6. 调用 setState
  setState(() {});
}
5. 渲染与UI (Rendering & UI)

GameCanvas (CustomPaint)
这是游戏世界的渲染核心。它将是无状态的，接收所有游戏对象列表并将其绘制在 Canvas 上。

GameCanvas Widget:

Dart
class GameCanvas extends StatelessWidget {
  final Character player;
  final List<Character> enemies;
  // ... 其他对象列表

  const GameCanvas({ ... });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GamePainter(player: player, enemies: enemies, ...),
      size: Size.infinite,
    );
  }
}
 GamePainter (CustomPainter)
paint 方法是所有绘制逻辑的所在地。

绘制星空背景: 在画布上随机绘制一些小圆点作为星星。
绘制可收集物: 遍历 collectables 列表，绘制刀片图标或形状。
绘制角色:
遍历 enemies 和 player。
对于每个角色，先画出中心的圆 (drawCircle).
然后进入旋转状态 (canvas.save, canvas.translate, canvas.rotate)。
根据 bladeCount 计算每个刀片的角度，循环绘制刀片（可以使用 TextPainter 绘制 IconData）。
canvas.restore 恢复画布状态。
在角色上方绘制名字和刀片数量 (TextPainter)。
绘制粒子: 遍历 particles 列表，绘制小圆圈。
摄像头移动
通过在 Stack 中包裹 GameCanvas 的是一个 Transform.translate widget 来实现。offset 的值根据摄像头位置 cameraPos 计算得出。

Dart
// In GameScreen build method
Transform.translate(
  offset: Offset(
    -cameraPos.dx + MediaQuery.of(context).size.width / 2,
    -cameraPos.dy + MediaQuery.of(context).size.height / 2,
  ),
  child: GameCanvas(...),
)
UI叠加 (Stack)
GameScreen 的 build 方法将使用 Stack 来组织UI层级。

Dart
// In GameScreen build method
Stack(
  children: [
    // 游戏世界 (摄像头 + Canvas)
    GameWorld(...),

    // HUD - 排行榜
    Positioned(
      top: 10,
      right: 10,
      child: Leaderboard(characters: [player, ...enemies]),
    ),

    // HUD - 摇杆
    Positioned(
      bottom: 20,
      left: 20,
      child: Joystick(onMove: (Offset vector) { ... }),
    ),
    
    // 游戏结束界面
    if (isGameOver)
      GameOverOverlay(onRestart: _restartGame),
  ],
)
Joystick (widgets/joystick.dart)
使用 GestureDetector 来捕捉用户的拖动操作 (onPanStart, onPanUpdate, onPanEnd)。根据拖动位置和距离，计算出一个单位向量 Offset，并通过回调函数传递给 GameScreen，用于更新玩家的 moveVector。

6. 游戏逻辑 (Game Logic)

游戏逻辑将主要在 GameScreenState 的 _updateGame 方法中实现，其功能与JS版本类似。

AI逻辑: 遍历所有 enemies。
计算与玩家的距离。
判断自己是否比玩家强 (enemy.bladeCount > player.bladeCount)。
追击: 如果更强，移动方向指向玩家。
逃跑: 如果更弱，移动方向背离玩家。
特殊行为 (Scavenger): 如果是 scout 且比玩家弱，但距离较远，则寻找最近的 Collectable 作为目标。
冲锋 (Charger): 如果比玩家强且进入一定范围，则触发 isCharging 状态，获得短时加速。
碰撞检测:
角色 vs 收集物: 简单的圆形碰撞检测，命中后增加角色刀片数并移除收集物。
角色 vs 角色: 检测两个角色 fullRadius 是否重叠。如果重叠，且距离上次碰撞超过冷却时间，则双方都 takeClashDamage()。
磁力拾取: 遍历 collectables，如果与玩家距离小于 MAGNETIC_PICKUP_RADIUS，则给它一个朝向玩家的加速度。
动态生成: 定时器或基于帧计数器，在摄像头视野外随机位置生成新的敌人和收集物。
7. 数据存储 (Data Persistence)

services/storage_service.dart
创建一个简单的单例或静态类来封装 SharedPreferences。

Dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _highScoreKey = 'highScore';

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
在游戏结束时调用 StorageService.saveHighScore(player.bladeCount)。

这套架构为您提供了一个清晰、紧凑且可执行的开发蓝图。它从最简单的模型和状态管理开始，将复杂的渲染逻辑隔离在 CustomPaint 中，并通过 Stack 优雅地处理UI层级，完全符合您提出的所有要求。