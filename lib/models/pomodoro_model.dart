class PomodoroSettings {
  int workDuration; // in minutes
  int breakDuration; // in minutes
  int longBreakDuration; // in minutes
  int sessionsBeforeLongBreak;

  PomodoroSettings({
    this.workDuration = 25,
    this.breakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
  });

  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'breakDuration': breakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      workDuration: json['workDuration'] ?? 25,
      breakDuration: json['breakDuration'] ?? 5,
      longBreakDuration: json['longBreakDuration'] ?? 15,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] ?? 4,
    );
  }
}

class PomodoroSession {
  final String id;
  final String title;
  final String duration;
  final DateTime completedAt;

  PomodoroSession({
    required this.id,
    required this.title,
    required this.duration,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }
}
