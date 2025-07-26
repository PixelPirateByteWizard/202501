import 'bottle.dart';

class GameState {
  final List<Bottle> bottles;
  final int currentLevel;
  final int moveCount;
  final int undoCount;
  final bool isAnimating;
  final bool isRemovingColor;
  final Bottle? selectedBottle;
  final DateTime startTime;
  final int hintsUsed;
  final bool usedUndo;

  GameState({
    required this.bottles,
    required this.currentLevel,
    required this.moveCount,
    required this.undoCount,
    this.isAnimating = false,
    this.isRemovingColor = false,
    this.selectedBottle,
    DateTime? startTime,
    this.hintsUsed = 0,
    this.usedUndo = false,
  }) : startTime = startTime ?? DateTime.fromMillisecondsSinceEpoch(0);

  GameState copyWith({
    List<Bottle>? bottles,
    int? currentLevel,
    int? moveCount,
    int? undoCount,
    bool? isAnimating,
    bool? isRemovingColor,
    Bottle? selectedBottle,
    bool clearSelectedBottle = false,
    DateTime? startTime,
    int? hintsUsed,
    bool? usedUndo,
  }) {
    return GameState(
      bottles: bottles ?? this.bottles.map((b) => b.copy()).toList(),
      currentLevel: currentLevel ?? this.currentLevel,
      moveCount: moveCount ?? this.moveCount,
      undoCount: undoCount ?? this.undoCount,
      isAnimating: isAnimating ?? this.isAnimating,
      isRemovingColor: isRemovingColor ?? this.isRemovingColor,
      selectedBottle: clearSelectedBottle ? null : (selectedBottle ?? this.selectedBottle),
      startTime: startTime ?? this.startTime,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      usedUndo: usedUndo ?? this.usedUndo,
    );
  }

  bool get isWon {
    // 检查是否所有瓶子都已排序完成
    if (bottles.isEmpty) return false;
    
    // 统计所有液体的颜色种类
    final Set<String> allColors = {};
    for (final bottle in bottles) {
      for (final color in bottle.liquids) {
        allColors.add(color.toString());
      }
    }
    
    if (allColors.isEmpty) return false;
    
    // 统计已完成排序的瓶子数量（装满且颜色统一）
    int sortedBottleCount = 0;
    for (final bottle in bottles) {
      if (bottle.isSorted && !bottle.isEmpty) {
        sortedBottleCount++;
      }
    }
    
    // 胜利条件：已排序的瓶子数量等于颜色种类数量
    return sortedBottleCount == allColors.length;
  }

  double get progress {
    if (bottles.isEmpty) return 0.0;
    
    int sortedCount = 0;
    for (final bottle in bottles) {
      if (bottle.isSorted && !bottle.isEmpty) {
        sortedCount++;
      }
    }
    
    // Calculate based on expected sorted bottles (non-empty bottles with single color)
    int expectedSortedBottles = 0;
    Set<String> uniqueColors = {};
    
    for (final bottle in bottles) {
      for (final color in bottle.liquids) {
        uniqueColors.add(color.toString());
      }
    }
    
    expectedSortedBottles = uniqueColors.length;
    
    return expectedSortedBottles > 0 ? sortedCount / expectedSortedBottles : 0.0;
  }

  int get elapsedTimeInSeconds {
    if (startTime.millisecondsSinceEpoch == 0) return 0;
    return DateTime.now().difference(startTime).inSeconds;
  }

  String get formattedTime {
    final seconds = elapsedTimeInSeconds;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}