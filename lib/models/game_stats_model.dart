/// Represents game statistics and history
/// 代表游戏统计数据和历史记录
class GameStats {
  int totalGamesPlayed;
  int totalLevelsCompleted;
  int highestScore;
  int totalScore;
  int totalSyntheses;
  int totalMatches;
  int totalMoves;
  List<LevelScore> levelScores;
  DateTime? lastPlayedDate;

  GameStats({
    this.totalGamesPlayed = 0,
    this.totalLevelsCompleted = 0,
    this.highestScore = 0,
    this.totalScore = 0,
    this.totalSyntheses = 0,
    this.totalMatches = 0,
    this.totalMoves = 0,
    this.levelScores = const [],
    this.lastPlayedDate,
  });

  /// Calculate average score
  /// 计算平均得分
  double get averageScore =>
      totalGamesPlayed > 0 ? totalScore / totalGamesPlayed : 0.0;

  /// Calculate efficiency (average moves per level)
  /// 计算效率（每关平均移动次数）
  double get averageMovesPerLevel =>
      totalLevelsCompleted > 0 ? totalMoves / totalLevelsCompleted : 0.0;

  /// Get best score for a specific level
  /// 获取特定关卡的最佳得分
  int getBestScoreForLevel(int level) {
    final levelScore = levelScores
        .where((ls) => ls.levelNumber == level)
        .fold<LevelScore?>(null, (best, current) {
      if (best == null || current.score > best.score) {
        return current;
      }
      return best;
    });
    return levelScore?.score ?? 0;
  }

  /// Add a new level completion
  /// 添加新的关卡完成记录
  void addLevelCompletion(int level, int score, int movesUsed, int movesLeft) {
    totalGamesPlayed++;
    if (level > totalLevelsCompleted) {
      totalLevelsCompleted = level;
    }
    totalScore += score;
    if (score > highestScore) {
      highestScore = score;
    }
    totalMoves += movesUsed;
    lastPlayedDate = DateTime.now();

    // Add level score record
    levelScores.add(LevelScore(
      levelNumber: level,
      score: score,
      movesUsed: movesUsed,
      movesLeft: movesLeft,
      completedAt: DateTime.now(),
    ));

    // Keep only the best 10 scores for each level to avoid excessive storage
    final levelGroups = <int, List<LevelScore>>{};
    for (final ls in levelScores) {
      levelGroups.putIfAbsent(ls.levelNumber, () => []).add(ls);
    }

    levelScores.clear();
    for (final group in levelGroups.values) {
      group.sort((a, b) => b.score.compareTo(a.score));
      levelScores.addAll(group.take(10));
    }
  }

  /// Update synthesis count
  /// 更新合成次数
  void addSynthesis() {
    totalSyntheses++;
  }

  /// Update match count
  /// 更新匹配次数
  void addMatch() {
    totalMatches++;
  }

  /// Convert to Map for storage
  /// 转换为Map用于存储
  Map<String, dynamic> toJson() {
    return {
      'totalGamesPlayed': totalGamesPlayed,
      'totalLevelsCompleted': totalLevelsCompleted,
      'highestScore': highestScore,
      'totalScore': totalScore,
      'totalSyntheses': totalSyntheses,
      'totalMatches': totalMatches,
      'totalMoves': totalMoves,
      'levelScores': levelScores.map((ls) => ls.toJson()).toList(),
      'lastPlayedDate': lastPlayedDate?.millisecondsSinceEpoch,
    };
  }

  /// Create from Map for loading
  /// 从Map创建用于加载
  static GameStats fromJson(Map<String, dynamic> json) {
    return GameStats(
      totalGamesPlayed: json['totalGamesPlayed'] ?? 0,
      totalLevelsCompleted: json['totalLevelsCompleted'] ?? 0,
      highestScore: json['highestScore'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      totalSyntheses: json['totalSyntheses'] ?? 0,
      totalMatches: json['totalMatches'] ?? 0,
      totalMoves: json['totalMoves'] ?? 0,
      levelScores: (json['levelScores'] as List<dynamic>?)
              ?.map((ls) => LevelScore.fromJson(ls))
              .toList() ??
          [],
      lastPlayedDate: json['lastPlayedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPlayedDate'])
          : null,
    );
  }
}

/// Represents a score record for a specific level
/// 代表特定关卡的得分记录
class LevelScore {
  final int levelNumber;
  final int score;
  final int movesUsed;
  final int movesLeft;
  final DateTime completedAt;

  LevelScore({
    required this.levelNumber,
    required this.score,
    required this.movesUsed,
    required this.movesLeft,
    required this.completedAt,
  });

  /// Calculate efficiency percentage
  /// 计算效率百分比
  double get efficiency => movesLeft / (movesUsed + movesLeft);

  /// Convert to Map for storage
  /// 转换为Map用于存储
  Map<String, dynamic> toJson() {
    return {
      'levelNumber': levelNumber,
      'score': score,
      'movesUsed': movesUsed,
      'movesLeft': movesLeft,
      'completedAt': completedAt.millisecondsSinceEpoch,
    };
  }

  /// Create from Map for loading
  /// 从Map创建用于加载
  static LevelScore fromJson(Map<String, dynamic> json) {
    return LevelScore(
      levelNumber: json['levelNumber'],
      score: json['score'],
      movesUsed: json['movesUsed'],
      movesLeft: json['movesLeft'],
      completedAt: DateTime.fromMillisecondsSinceEpoch(json['completedAt']),
    );
  }
}
