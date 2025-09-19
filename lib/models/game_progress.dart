class GameProgress {
  final int currentChapter;
  final int currentStage;
  final int playerLevel;
  final int experience;
  final int gold;
  final List<String> unlockedGenerals;
  final List<String> completedStages;

  GameProgress({
    required this.currentChapter,
    required this.currentStage,
    required this.playerLevel,
    required this.experience,
    required this.gold,
    required this.unlockedGenerals,
    required this.completedStages,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentChapter': currentChapter,
      'currentStage': currentStage,
      'playerLevel': playerLevel,
      'experience': experience,
      'gold': gold,
      'unlockedGenerals': unlockedGenerals,
      'completedStages': completedStages,
    };
  }

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    return GameProgress(
      currentChapter: json['currentChapter'],
      currentStage: json['currentStage'],
      playerLevel: json['playerLevel'],
      experience: json['experience'],
      gold: json['gold'],
      unlockedGenerals: List<String>.from(json['unlockedGenerals']),
      completedStages: List<String>.from(json['completedStages']),
    );
  }

  GameProgress copyWith({
    int? currentChapter,
    int? currentStage,
    int? playerLevel,
    int? experience,
    int? gold,
    List<String>? unlockedGenerals,
    List<String>? completedStages,
  }) {
    return GameProgress(
      currentChapter: currentChapter ?? this.currentChapter,
      currentStage: currentStage ?? this.currentStage,
      playerLevel: playerLevel ?? this.playerLevel,
      experience: experience ?? this.experience,
      gold: gold ?? this.gold,
      unlockedGenerals: unlockedGenerals ?? this.unlockedGenerals,
      completedStages: completedStages ?? this.completedStages,
    );
  }

  static GameProgress get defaultProgress {
    return GameProgress(
      currentChapter: 1,
      currentStage: 1,
      playerLevel: 1,
      experience: 0,
      gold: 1000,
      unlockedGenerals: ['liu_bei', 'guan_yu', 'zhang_fei'],
      completedStages: [],
    );
  }
}