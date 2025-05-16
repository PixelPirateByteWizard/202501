class Milestone {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': targetDate.toIso8601String(),
    };
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetDate: DateTime.parse(json['targetDate']),
    );
  }

  int get daysRemaining {
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    return difference.inDays;
  }
}
