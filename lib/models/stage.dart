enum StageStatus { locked, unlocked, completed }

class Stage {
  final String id;
  final String name;
  final String description;
  final int difficulty;
  final List<String> enemies;
  final StageStatus status;
  final int chapter;
  final Map<String, int> rewards;

  Stage({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.enemies,
    required this.status,
    required this.chapter,
    required this.rewards,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'enemies': enemies,
      'status': status.index,
      'chapter': chapter,
      'rewards': rewards,
    };
  }

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      enemies: List<String>.from(json['enemies']),
      status: StageStatus.values[json['status']],
      chapter: json['chapter'],
      rewards: Map<String, int>.from(json['rewards']),
    );
  }

  Stage copyWith({
    String? id,
    String? name,
    String? description,
    int? difficulty,
    List<String>? enemies,
    StageStatus? status,
    int? chapter,
    Map<String, int>? rewards,
  }) {
    return Stage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      enemies: enemies ?? this.enemies,
      status: status ?? this.status,
      chapter: chapter ?? this.chapter,
      rewards: rewards ?? this.rewards,
    );
  }
}