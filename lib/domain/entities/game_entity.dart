class GameEntity {
  final int score;
  final int bestScore;
  final List<List<TileEntity?>> board;
  final TileEntity nextTile;
  final bool isGameOver;

  GameEntity({
    required this.score,
    required this.bestScore,
    required this.board,
    required this.nextTile,
    required this.isGameOver,
  });

  // Create a copy with updated values
  GameEntity copyWith({
    int? score,
    int? bestScore,
    List<List<TileEntity?>>? board,
    TileEntity? nextTile,
    bool? isGameOver,
  }) {
    return GameEntity(
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      board: board ?? List.from(this.board.map((row) => List.from(row))),
      nextTile: nextTile ?? this.nextTile,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

class TileEntity {
  final int value;
  final bool isNew;
  final bool isMerged;
  final int? previousX;
  final int? previousY;

  TileEntity({
    required this.value,
    this.isNew = false,
    this.isMerged = false,
    this.previousX,
    this.previousY,
  });

  // Create a copy with updated values
  TileEntity copyWith({
    int? value,
    bool? isNew,
    bool? isMerged,
    int? previousX,
    int? previousY,
  }) {
    return TileEntity(
      value: value ?? this.value,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
      previousX: previousX ?? this.previousX,
      previousY: previousY ?? this.previousY,
    );
  }

  // Create a new tile with movement history
  TileEntity withMovement({required int previousX, required int previousY}) {
    return copyWith(previousX: previousX, previousY: previousY, isNew: false);
  }

  // Create a merged tile
  TileEntity withMerge({required int newValue}) {
    return copyWith(value: newValue, isMerged: true, isNew: false);
  }

  // Reset animation state
  TileEntity resetState() {
    return copyWith(
      isNew: false,
      isMerged: false,
      previousX: null,
      previousY: null,
    );
  }
}

class GameStatsEntity {
  final int maxTileValue;
  final int totalGamesPlayed;
  final Duration totalPlayTime;
  final Map<int, int> tileMergeCount;

  GameStatsEntity({
    required this.maxTileValue,
    required this.totalGamesPlayed,
    required this.totalPlayTime,
    required this.tileMergeCount,
  });

  // Create a copy with updated values
  GameStatsEntity copyWith({
    int? maxTileValue,
    int? totalGamesPlayed,
    Duration? totalPlayTime,
    Map<int, int>? tileMergeCount,
  }) {
    return GameStatsEntity(
      maxTileValue: maxTileValue ?? this.maxTileValue,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      tileMergeCount: tileMergeCount ?? Map.from(this.tileMergeCount),
    );
  }

  // Update stats after a merge
  GameStatsEntity updateAfterMerge(int tileValue) {
    final newMergeCount = Map<int, int>.from(tileMergeCount);
    newMergeCount[tileValue] = (newMergeCount[tileValue] ?? 0) + 1;

    return copyWith(
      maxTileValue: tileValue > maxTileValue ? tileValue : maxTileValue,
      tileMergeCount: newMergeCount,
    );
  }

  // Update stats after a game
  GameStatsEntity updateAfterGame(Duration gameTime) {
    return copyWith(
      totalGamesPlayed: totalGamesPlayed + 1,
      totalPlayTime: Duration(
        seconds: totalPlayTime.inSeconds + gameTime.inSeconds,
      ),
    );
  }
}
