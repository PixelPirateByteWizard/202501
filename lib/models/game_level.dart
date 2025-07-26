class GameLevel {
  final int levelNumber;
  final int colorCount;
  final int bottleCount;
  final int targetMoves;
  final String theme;

  const GameLevel({
    required this.levelNumber,
    required this.colorCount,
    required this.bottleCount,
    required this.targetMoves,
    this.theme = '化學實驗室',
  });

  static const List<GameLevel> levels = [
    GameLevel(levelNumber: 0, colorCount: 0, bottleCount: 0, targetMoves: 0), // Placeholder
    GameLevel(levelNumber: 1, colorCount: 2, bottleCount: 3, targetMoves: 2),
    GameLevel(levelNumber: 2, colorCount: 3, bottleCount: 4, targetMoves: 5),
    GameLevel(levelNumber: 3, colorCount: 3, bottleCount: 5, targetMoves: 7),
    GameLevel(levelNumber: 4, colorCount: 4, bottleCount: 5, targetMoves: 9),
    GameLevel(levelNumber: 5, colorCount: 4, bottleCount: 6, targetMoves: 12),
    GameLevel(levelNumber: 6, colorCount: 5, bottleCount: 7, targetMoves: 15),
    GameLevel(levelNumber: 7, colorCount: 5, bottleCount: 8, targetMoves: 18),
    GameLevel(levelNumber: 8, colorCount: 6, bottleCount: 8, targetMoves: 22),
    GameLevel(levelNumber: 9, colorCount: 6, bottleCount: 9, targetMoves: 25),
    GameLevel(levelNumber: 10, colorCount: 7, bottleCount: 10, targetMoves: 30),
    GameLevel(levelNumber: 11, colorCount: 8, bottleCount: 10, targetMoves: 35),
    GameLevel(levelNumber: 12, colorCount: 8, bottleCount: 11, targetMoves: 38),
    GameLevel(levelNumber: 13, colorCount: 8, bottleCount: 12, targetMoves: 42),
    GameLevel(levelNumber: 14, colorCount: 9, bottleCount: 12, targetMoves: 45),
    GameLevel(levelNumber: 15, colorCount: 9, bottleCount: 13, targetMoves: 50),
    GameLevel(levelNumber: 16, colorCount: 10, bottleCount: 13, targetMoves: 55),
    GameLevel(levelNumber: 17, colorCount: 10, bottleCount: 14, targetMoves: 60),
    GameLevel(levelNumber: 18, colorCount: 11, bottleCount: 14, targetMoves: 65),
    GameLevel(levelNumber: 19, colorCount: 11, bottleCount: 15, targetMoves: 70),
    GameLevel(levelNumber: 20, colorCount: 12, bottleCount: 15, targetMoves: 75),
    GameLevel(levelNumber: 21, colorCount: 3, bottleCount: 5, targetMoves: 6),
    GameLevel(levelNumber: 22, colorCount: 4, bottleCount: 6, targetMoves: 8),
    GameLevel(levelNumber: 23, colorCount: 5, bottleCount: 7, targetMoves: 12),
    GameLevel(levelNumber: 24, colorCount: 6, bottleCount: 8, targetMoves: 15),
    GameLevel(levelNumber: 25, colorCount: 7, bottleCount: 9, targetMoves: 20),
    GameLevel(levelNumber: 26, colorCount: 8, bottleCount: 10, targetMoves: 25),
    GameLevel(levelNumber: 27, colorCount: 8, bottleCount: 11, targetMoves: 30),
    GameLevel(levelNumber: 28, colorCount: 9, bottleCount: 12, targetMoves: 35),
    GameLevel(levelNumber: 29, colorCount: 10, bottleCount: 13, targetMoves: 40),
    GameLevel(levelNumber: 30, colorCount: 11, bottleCount: 14, targetMoves: 45),
    GameLevel(levelNumber: 31, colorCount: 12, bottleCount: 14, targetMoves: 50),
    GameLevel(levelNumber: 32, colorCount: 12, bottleCount: 14, targetMoves: 52, theme: "海洋世界"),
    GameLevel(levelNumber: 33, colorCount: 12, bottleCount: 14, targetMoves: 55, theme: "糖果樂園"),
    GameLevel(levelNumber: 34, colorCount: 12, bottleCount: 14, targetMoves: 58, theme: "星空"),
    GameLevel(levelNumber: 35, colorCount: 12, bottleCount: 14, targetMoves: 60, theme: "森林"),
    GameLevel(levelNumber: 36, colorCount: 12, bottleCount: 14, targetMoves: 62, theme: "沙漠"),
    GameLevel(levelNumber: 37, colorCount: 12, bottleCount: 14, targetMoves: 65, theme: "火山"),
    GameLevel(levelNumber: 38, colorCount: 12, bottleCount: 14, targetMoves: 68, theme: "冰川"),
    GameLevel(levelNumber: 39, colorCount: 12, bottleCount: 14, targetMoves: 70, theme: "城市"),
    GameLevel(levelNumber: 40, colorCount: 12, bottleCount: 14, targetMoves: 72, theme: "太空"),
    GameLevel(levelNumber: 41, colorCount: 12, bottleCount: 14, targetMoves: 75, theme: "未來"),
    GameLevel(levelNumber: 42, colorCount: 13, bottleCount: 15, targetMoves: 80),
    GameLevel(levelNumber: 43, colorCount: 13, bottleCount: 15, targetMoves: 82),
    GameLevel(levelNumber: 44, colorCount: 13, bottleCount: 15, targetMoves: 85),
    GameLevel(levelNumber: 45, colorCount: 13, bottleCount: 15, targetMoves: 88),
    GameLevel(levelNumber: 46, colorCount: 14, bottleCount: 16, targetMoves: 92),
    GameLevel(levelNumber: 47, colorCount: 14, bottleCount: 16, targetMoves: 95),
    GameLevel(levelNumber: 48, colorCount: 14, bottleCount: 16, targetMoves: 98),
    GameLevel(levelNumber: 49, colorCount: 14, bottleCount: 16, targetMoves: 100),
    GameLevel(levelNumber: 50, colorCount: 15, bottleCount: 17, targetMoves: 110),
    
    // 进阶挑战关卡 (51-70)
    GameLevel(levelNumber: 51, colorCount: 4, bottleCount: 6, targetMoves: 10, theme: "彩虹挑战"),
    GameLevel(levelNumber: 52, colorCount: 5, bottleCount: 7, targetMoves: 14, theme: "彩虹挑战"),
    GameLevel(levelNumber: 53, colorCount: 6, bottleCount: 8, targetMoves: 18, theme: "彩虹挑战"),
    GameLevel(levelNumber: 54, colorCount: 7, bottleCount: 9, targetMoves: 22, theme: "彩虹挑战"),
    GameLevel(levelNumber: 55, colorCount: 8, bottleCount: 10, targetMoves: 28, theme: "彩虹挑战"),
    GameLevel(levelNumber: 56, colorCount: 9, bottleCount: 11, targetMoves: 32, theme: "彩虹挑战"),
    GameLevel(levelNumber: 57, colorCount: 10, bottleCount: 12, targetMoves: 38, theme: "彩虹挑战"),
    GameLevel(levelNumber: 58, colorCount: 11, bottleCount: 13, targetMoves: 42, theme: "彩虹挑战"),
    GameLevel(levelNumber: 59, colorCount: 12, bottleCount: 14, targetMoves: 48, theme: "彩虹挑战"),
    GameLevel(levelNumber: 60, colorCount: 13, bottleCount: 15, targetMoves: 55, theme: "彩虹挑战"),
    
    // 专家级关卡 (61-80)
    GameLevel(levelNumber: 61, colorCount: 6, bottleCount: 8, targetMoves: 15, theme: "专家挑战"),
    GameLevel(levelNumber: 62, colorCount: 7, bottleCount: 9, targetMoves: 20, theme: "专家挑战"),
    GameLevel(levelNumber: 63, colorCount: 8, bottleCount: 10, targetMoves: 25, theme: "专家挑战"),
    GameLevel(levelNumber: 64, colorCount: 9, bottleCount: 11, targetMoves: 30, theme: "专家挑战"),
    GameLevel(levelNumber: 65, colorCount: 10, bottleCount: 12, targetMoves: 35, theme: "专家挑战"),
    GameLevel(levelNumber: 66, colorCount: 11, bottleCount: 13, targetMoves: 40, theme: "专家挑战"),
    GameLevel(levelNumber: 67, colorCount: 12, bottleCount: 14, targetMoves: 45, theme: "专家挑战"),
    GameLevel(levelNumber: 68, colorCount: 13, bottleCount: 15, targetMoves: 50, theme: "专家挑战"),
    GameLevel(levelNumber: 69, colorCount: 14, bottleCount: 16, targetMoves: 55, theme: "专家挑战"),
    GameLevel(levelNumber: 70, colorCount: 15, bottleCount: 17, targetMoves: 60, theme: "专家挑战"),
    
    // 大师级关卡 (71-90)
    GameLevel(levelNumber: 71, colorCount: 8, bottleCount: 10, targetMoves: 22, theme: "大师试炼"),
    GameLevel(levelNumber: 72, colorCount: 9, bottleCount: 11, targetMoves: 28, theme: "大师试炼"),
    GameLevel(levelNumber: 73, colorCount: 10, bottleCount: 12, targetMoves: 32, theme: "大师试炼"),
    GameLevel(levelNumber: 74, colorCount: 11, bottleCount: 13, targetMoves: 38, theme: "大师试炼"),
    GameLevel(levelNumber: 75, colorCount: 12, bottleCount: 14, targetMoves: 42, theme: "大师试炼"),
    GameLevel(levelNumber: 76, colorCount: 13, bottleCount: 15, targetMoves: 48, theme: "大师试炼"),
    GameLevel(levelNumber: 77, colorCount: 14, bottleCount: 16, targetMoves: 52, theme: "大师试炼"),
    GameLevel(levelNumber: 78, colorCount: 15, bottleCount: 17, targetMoves: 58, theme: "大师试炼"),
    GameLevel(levelNumber: 79, colorCount: 16, bottleCount: 18, targetMoves: 65, theme: "大师试炼"),
    GameLevel(levelNumber: 80, colorCount: 17, bottleCount: 19, targetMoves: 70, theme: "大师试炼"),
    
    // 传奇级关卡 (81-100)
    GameLevel(levelNumber: 81, colorCount: 10, bottleCount: 12, targetMoves: 28, theme: "传奇之路"),
    GameLevel(levelNumber: 82, colorCount: 11, bottleCount: 13, targetMoves: 32, theme: "传奇之路"),
    GameLevel(levelNumber: 83, colorCount: 12, bottleCount: 14, targetMoves: 38, theme: "传奇之路"),
    GameLevel(levelNumber: 84, colorCount: 13, bottleCount: 15, targetMoves: 42, theme: "传奇之路"),
    GameLevel(levelNumber: 85, colorCount: 14, bottleCount: 16, targetMoves: 48, theme: "传奇之路"),
    GameLevel(levelNumber: 86, colorCount: 15, bottleCount: 17, targetMoves: 52, theme: "传奇之路"),
    GameLevel(levelNumber: 87, colorCount: 16, bottleCount: 18, targetMoves: 58, theme: "传奇之路"),
    GameLevel(levelNumber: 88, colorCount: 17, bottleCount: 19, targetMoves: 65, theme: "传奇之路"),
    GameLevel(levelNumber: 89, colorCount: 18, bottleCount: 20, targetMoves: 70, theme: "传奇之路"),
    GameLevel(levelNumber: 90, colorCount: 19, bottleCount: 21, targetMoves: 78, theme: "传奇之路"),
    
    // 终极挑战关卡 (91-100)
    GameLevel(levelNumber: 91, colorCount: 12, bottleCount: 14, targetMoves: 35, theme: "终极挑战"),
    GameLevel(levelNumber: 92, colorCount: 13, bottleCount: 15, targetMoves: 40, theme: "终极挑战"),
    GameLevel(levelNumber: 93, colorCount: 14, bottleCount: 16, targetMoves: 45, theme: "终极挑战"),
    GameLevel(levelNumber: 94, colorCount: 15, bottleCount: 17, targetMoves: 50, theme: "终极挑战"),
    GameLevel(levelNumber: 95, colorCount: 16, bottleCount: 18, targetMoves: 55, theme: "终极挑战"),
    GameLevel(levelNumber: 96, colorCount: 17, bottleCount: 19, targetMoves: 60, theme: "终极挑战"),
    GameLevel(levelNumber: 97, colorCount: 18, bottleCount: 20, targetMoves: 68, theme: "终极挑战"),
    GameLevel(levelNumber: 98, colorCount: 19, bottleCount: 21, targetMoves: 75, theme: "终极挑战"),
    GameLevel(levelNumber: 99, colorCount: 20, bottleCount: 22, targetMoves: 85, theme: "终极挑战"),
    GameLevel(levelNumber: 100, colorCount: 20, bottleCount: 24, targetMoves: 100, theme: "百关大成"),
  ];

  static GameLevel? getLevel(int levelNumber) {
    if (levelNumber < 1 || levelNumber >= levels.length) return null;
    return levels[levelNumber];
  }

  int calculateStars(int moveCount) {
    if (moveCount <= targetMoves) return 3;
    if (moveCount <= targetMoves + 3) return 2;
    return 1;
  }
}