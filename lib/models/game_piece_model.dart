/// Enum for the type of game piece.
/// 游戏元素的类型枚举
enum PieceType {
  /// A primary color piece (Red, Yellow, Blue) that cannot be matched directly.
  /// 基础元素（红、黄、蓝），不能直接匹配消除
  primary,

  /// A secondary color piece (Orange, Green, Purple) that can be matched.
  /// 高级元素（橙、绿、紫），可以匹配消除
  secondary,

  /// A special piece with unique abilities.
  /// 拥有特殊能力的特殊元素
  special,

  /// An immovable obstacle.
  /// 不可移动的障碍物
  obstacle
}

/// Enum for the color of the game piece.
/// 游戏元素的颜色枚举
enum PieceColor { red, yellow, blue, orange, green, purple, petrified, rainbow }

/// Represents a single piece on the game board.
/// 代表游戏棋盘上的单个元素
class GamePiece {
  /// A unique identifier for this piece, crucial for animations (e.g., using ValueKey).
  /// 元素的唯一标识符，对动画（例如使用ValueKey）至关重要
  final int id;

  /// The type of the piece (e.g., primary, secondary).
  /// 元素的类型（例如，基础或高级）
  PieceType type;

  /// The color of the piece.
  /// 元素的颜色
  PieceColor color;

  /// The health of the piece, used primarily for obstacles.
  /// 元素的生命值，主要用于障碍物
  int health;

  GamePiece({
    required this.id,
    required this.type,
    required this.color,
    this.health = 1,
  });

  /// A copyWith method can be useful for state updates.
  /// copyWith方法对于状态更新很有用
  GamePiece copyWith({
    int? id,
    PieceType? type,
    PieceColor? color,
    int? health,
  }) {
    return GamePiece(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      health: health ?? this.health,
    );
  }
}
