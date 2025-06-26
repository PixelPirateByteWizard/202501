import 'game_piece_model.dart';

/// Represents the definition for a single game level.
/// 代表单个游戏关卡的定义
class Level {
  final int levelNumber;
  final int moves;
  final Map<PieceColor, int> objectives;
  // You can extend this to include predefined obstacle layouts.
  // 你可以扩展这个类来包含预定义的障碍物布局
  // final List<ObstaclePlacement> obstacles;

  Level({
    required this.levelNumber,
    required this.moves,
    required this.objectives,
  });

  /// A static list of predefined levels in the game.
  /// 游戏中预定义关卡的静态列表
  static final List<Level> _predefinedLevels = [
    Level(
      levelNumber: 1,
      moves: 30,
      objectives: {
        PieceColor.green: 25,
        PieceColor.purple: 15,
      },
    ),
    Level(
      levelNumber: 2,
      moves: 25,
      objectives: {
        PieceColor.orange: 20,
        PieceColor.green: 20,
      },
    ),
    Level(
      levelNumber: 3,
      moves: 22,
      objectives: {
        PieceColor.purple: 30,
        PieceColor.orange: 25,
      },
    ),
    Level(
      levelNumber: 4,
      moves: 20,
      objectives: {
        PieceColor.green: 35,
        PieceColor.purple: 30,
        PieceColor.orange: 25,
      },
    ),
    Level(
      levelNumber: 5,
      moves: 18,
      objectives: {
        PieceColor.orange: 40,
        PieceColor.green: 35,
      },
    ),
  ];

  /// Get a level by number, generating it if beyond predefined levels
  /// 根据编号获取关卡，如果超出预定义关卡则生成新关卡
  static Level getLevel(int levelNumber) {
    if (levelNumber <= _predefinedLevels.length) {
      return _predefinedLevels[levelNumber - 1];
    }

    // Generate infinite levels beyond predefined ones
    return _generateLevel(levelNumber);
  }

  /// Generate a procedural level for infinite gameplay
  /// 为无限游戏生成程序化关卡
  static Level _generateLevel(int levelNumber) {
    // Base difficulty scaling
    final difficultyMultiplier =
        1 + (levelNumber - _predefinedLevels.length) * 0.1;

    // Calculate moves (decreases slightly with level but has a minimum)
    final baseMoves = 25;
    final moves = (baseMoves - (levelNumber - _predefinedLevels.length) * 0.5)
        .clamp(12, baseMoves)
        .round();

    // Generate objectives
    final objectives = <PieceColor, int>{};
    final secondaryColors = [
      PieceColor.orange,
      PieceColor.green,
      PieceColor.purple
    ];

    // Number of different colors to collect (1-3)
    final colorCount =
        ((levelNumber - _predefinedLevels.length) / 5).clamp(1, 3).ceil();

    // Shuffle and take required colors
    secondaryColors.shuffle();
    for (int i = 0; i < colorCount; i++) {
      final baseAmount = 20 + (levelNumber - _predefinedLevels.length) * 2;
      final amount =
          (baseAmount * difficultyMultiplier * (1 + i * 0.2)).round();
      objectives[secondaryColors[i]] = amount;
    }

    return Level(
      levelNumber: levelNumber,
      moves: moves,
      objectives: objectives,
    );
  }

  /// Get all levels up to a certain number (for backwards compatibility)
  /// 获取到特定编号的所有关卡（用于向后兼容）
  static List<Level> get levels => _predefinedLevels;
}
