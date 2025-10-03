import 'dart:convert';

class GameModel {
  final int score;
  final int bestScore;
  final List<List<int?>> board; // 4x4 game board
  final int nextTile;
  final bool isGameOver;
  final GameStatsModel stats;

  GameModel({
    required this.score,
    required this.bestScore,
    required this.board,
    required this.nextTile,
    required this.isGameOver,
    required this.stats,
  });

  // Create a new game with initial state
  factory GameModel.newGame() {
    // Create an empty 4x4 board
    List<List<int?>> board = List.generate(
      4,
      (_) => List.generate(4, (_) => null),
    );

    // Place initial tiles (typically 2 tiles)
    // For simplicity, we'll place them at fixed positions
    board[1][1] = 1; // Place a '1' tile
    board[2][2] = 2; // Place a '2' tile

    return GameModel(
      score: 0,
      bestScore: 0, // This will be replaced with stored best score
      board: board,
      nextTile: _generateRandomTile(),
      isGameOver: false,
      stats: GameStatsModel(
        maxTileValue: 0,
        totalGamesPlayed: 0,
        gamesWon: 0,
        totalPlayTime: const Duration(),
        bestGameTime: const Duration(hours: 99),
        tileMergeCount: {},
        recentScores: [],
      ),
    );
  }

  // Generate a random tile value (1, 2, or occasionally 3)
  static int _generateRandomTile() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;

    if (random < 60) {
      return 1; // 60% chance for '1'
    } else if (random < 95) {
      return 2; // 35% chance for '2'
    } else {
      return 3; // 5% chance for '3'
    }
  }

  // Create a copy with updated values
  GameModel copyWith({
    int? score,
    int? bestScore,
    List<List<int?>>? board,
    int? nextTile,
    bool? isGameOver,
    GameStatsModel? stats,
  }) {
    return GameModel(
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      board: board ?? List.from(this.board.map((row) => List.from(row))),
      nextTile: nextTile ?? this.nextTile,
      isGameOver: isGameOver ?? this.isGameOver,
      stats: stats ?? this.stats,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'bestScore': bestScore,
      'board': board.map((row) => row.map((tile) => tile).toList()).toList(),
      'nextTile': nextTile,
      'isGameOver': isGameOver,
      'stats': stats.toJson(),
    };
  }

  // Create from JSON
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      score: json['score'] as int,
      bestScore: json['bestScore'] as int,
      board: (json['board'] as List).map((row) {
        return (row as List).map((tile) => tile as int?).toList();
      }).toList(),
      nextTile: json['nextTile'] as int,
      isGameOver: json['isGameOver'] as bool,
      stats: GameStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  // Serialize to string
  String serialize() {
    return jsonEncode(toJson());
  }

  // Deserialize from string
  factory GameModel.deserialize(String data) {
    return GameModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }
}

class GameStatsModel {
  final int maxTileValue;
  final int totalGamesPlayed;
  final int gamesWon;
  final Duration totalPlayTime;
  final Duration bestGameTime;
  final Map<int, int> tileMergeCount;
  final List<int> recentScores; // Stores the last 10 game scores

  GameStatsModel({
    required this.maxTileValue,
    required this.totalGamesPlayed,
    this.gamesWon = 0,
    required this.totalPlayTime,
    this.bestGameTime = const Duration(hours: 99),
    required this.tileMergeCount,
    this.recentScores = const [],
  });

  // Create a copy with updated values
  GameStatsModel copyWith({
    int? maxTileValue,
    int? totalGamesPlayed,
    int? gamesWon,
    Duration? totalPlayTime,
    Duration? bestGameTime,
    Map<int, int>? tileMergeCount,
    List<int>? recentScores,
  }) {
    return GameStatsModel(
      maxTileValue: maxTileValue ?? this.maxTileValue,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      bestGameTime: bestGameTime ?? this.bestGameTime,
      tileMergeCount: tileMergeCount ?? Map.from(this.tileMergeCount),
      recentScores: recentScores ?? List.from(this.recentScores),
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'maxTileValue': maxTileValue,
      'totalGamesPlayed': totalGamesPlayed,
      'gamesWon': gamesWon,
      'totalPlayTimeInSeconds': totalPlayTime.inSeconds,
      'bestGameTimeInSeconds': bestGameTime.inSeconds,
      'tileMergeCount': tileMergeCount.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'recentScores': recentScores,
    };
  }

  // Create from JSON
  factory GameStatsModel.fromJson(Map<String, dynamic> json) {
    final tileMergeCountJson = json['tileMergeCount'] as Map<String, dynamic>;
    final tileMergeCount = tileMergeCountJson.map(
      (key, value) => MapEntry(int.parse(key), value as int),
    );

    return GameStatsModel(
      maxTileValue: json['maxTileValue'] as int,
      totalGamesPlayed: json['totalGamesPlayed'] as int,
      gamesWon: json['gamesWon'] as int? ?? 0,
      totalPlayTime: Duration(seconds: json['totalPlayTimeInSeconds'] as int),
      bestGameTime: json['bestGameTimeInSeconds'] != null
          ? Duration(seconds: json['bestGameTimeInSeconds'] as int)
          : const Duration(hours: 99),
      tileMergeCount: tileMergeCount,
      recentScores: json['recentScores'] != null
          ? List<int>.from(json['recentScores'] as List)
          : [],
    );
  }
}
