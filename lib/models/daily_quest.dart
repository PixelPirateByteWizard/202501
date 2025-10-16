enum QuestType {
  generateStories,
  makeChoices,
  visitLocations,
  unlockAchievements,
  playTime,
}

enum QuestStatus {
  active,
  completed,
  claimed,
}

class DailyQuest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final int targetValue;
  final int currentProgress;
  final QuestStatus status;
  final Map<String, dynamic> rewards;
  final DateTime createdAt;
  final DateTime? completedAt;

  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentProgress = 0,
    this.status = QuestStatus.active,
    this.rewards = const {},
    required this.createdAt,
    this.completedAt,
  });

  DailyQuest copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    int? targetValue,
    int? currentProgress,
    QuestStatus? status,
    Map<String, dynamic>? rewards,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return DailyQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      status: status ?? this.status,
      rewards: rewards ?? this.rewards,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }

  bool get isCompleted => currentProgress >= targetValue;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'status': status.index,
      'rewards': rewards,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    return DailyQuest(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: QuestType.values[json['type']],
      targetValue: json['targetValue'],
      currentProgress: json['currentProgress'] ?? 0,
      status: QuestStatus.values[json['status'] ?? 0],
      rewards: Map<String, dynamic>.from(json['rewards'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }
}