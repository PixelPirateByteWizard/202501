enum ExpeditionStatus { ready, inProgress, completed, failed }

class Expedition {
  final String id;
  final String name;
  final String description;
  final ExpeditionStatus status;
  final Duration duration;
  final DateTime? startTime;
  final double successRate;
  final Map<String, int> rewards;
  final Map<String, int> requirements;

  const Expedition({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.duration,
    this.startTime,
    required this.successRate,
    required this.rewards,
    required this.requirements,
  });

  bool get isCompleted =>
      status == ExpeditionStatus.inProgress &&
      startTime != null &&
      DateTime.now().difference(startTime!).compareTo(duration) >= 0;

  Expedition copyWith({
    String? id,
    String? name,
    String? description,
    ExpeditionStatus? status,
    Duration? duration,
    DateTime? startTime,
    double? successRate,
    Map<String, int>? rewards,
    Map<String, int>? requirements,
  }) {
    return Expedition(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      successRate: successRate ?? this.successRate,
      rewards: rewards ?? this.rewards,
      requirements: requirements ?? this.requirements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.index,
      'duration': duration.inMilliseconds,
      'startTime': startTime?.millisecondsSinceEpoch,
      'successRate': successRate,
      'rewards': rewards,
      'requirements': requirements,
    };
  }

  factory Expedition.fromJson(Map<String, dynamic> json) {
    return Expedition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: ExpeditionStatus.values[json['status']],
      duration: Duration(milliseconds: json['duration']),
      startTime: json['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startTime'])
          : null,
      successRate: json['successRate'].toDouble(),
      rewards: Map<String, int>.from(json['rewards']),
      requirements: Map<String, int>.from(json['requirements']),
    );
  }
}
