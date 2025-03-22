class Goal {
  final String id;
  final String title;
  final String description;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String type;
  final String? category;
  final int priority;
  final DateTime? deadline;
  final bool isNumericGoal;
  final double targetValue;
  final double currentValue;
  final List<GoalRecord> records;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    this.progress = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.type = '',
    this.category,
    this.priority = 2,
    this.deadline,
    this.isNumericGoal = false,
    this.targetValue = 0.0,
    this.currentValue = 0.0,
    List<GoalRecord>? records,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        records = records ?? [];

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    String? category,
    int? priority,
    DateTime? deadline,
    bool? isNumericGoal,
    double? targetValue,
    double? currentValue,
    List<GoalRecord>? records,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      isNumericGoal: isNumericGoal ?? this.isNumericGoal,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      records: records ?? this.records,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'type': type,
      'category': category,
      'priority': priority,
      'deadline': deadline?.toIso8601String(),
      'isNumericGoal': isNumericGoal,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'records': records.map((record) => record.toJson()).toList(),
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      progress: json['progress'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      type: json['type'] ?? '',
      category: json['category'],
      priority: json['priority'] ?? 2,
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isNumericGoal: json['isNumericGoal'] ?? false,
      targetValue: json['targetValue']?.toDouble() ?? 0.0,
      currentValue: json['currentValue']?.toDouble() ?? 0.0,
      records: json['records'] != null
          ? List<GoalRecord>.from(
              json['records'].map((x) => GoalRecord.fromJson(x)))
          : [],
    );
  }
}

class GoalRecord {
  final String id;
  final DateTime date;
  final double value;
  final String note;
  final bool isTotal;

  GoalRecord({
    required this.id,
    required this.date,
    required this.value,
    this.note = '',
    this.isTotal = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'value': value,
      'note': note,
      'isTotal': isTotal,
    };
  }

  factory GoalRecord.fromJson(Map<String, dynamic> json) {
    return GoalRecord(
      id: json['id'],
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
      note: json['note'] ?? '',
      isTotal: json['isTotal'] ?? false,
    );
  }
}
