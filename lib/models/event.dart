import 'package:flutter/material.dart';

enum EventCategory {
  work,
  meeting,
  focus,
  personal,
}

extension EventCategoryExtension on EventCategory {
  String get name {
    switch (this) {
      case EventCategory.work:
        return 'Work';
      case EventCategory.meeting:
        return 'Meeting';
      case EventCategory.focus:
        return 'Focus';
      case EventCategory.personal:
        return 'Personal';
    }
  }

  Color get color {
    switch (this) {
      case EventCategory.work:
        return const Color(0xFF3B82F6);
      case EventCategory.meeting:
        return const Color(0xFFA855F7);
      case EventCategory.focus:
        return const Color(0xFF06B6D4);
      case EventCategory.personal:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case EventCategory.work:
        return Icons.work;
      case EventCategory.meeting:
        return Icons.people;
      case EventCategory.focus:
        return Icons.psychology;
      case EventCategory.personal:
        return Icons.favorite;
    }
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final EventCategory category;
  final String? location;
  final bool hasVideoCall;
  final bool isCompleted;
  final bool hasConflict;
  final int priority; // 1-5, 5 being highest
  final List<String> tags;
  final String? recurrenceRule; // RRULE for recurring events
  final DateTime? reminderTime;
  final String? notes;
  final double? energyLevel; // 1-5, for energy-based scheduling
  final List<String> attendees;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.location,
    this.hasVideoCall = false,
    this.isCompleted = false,
    this.hasConflict = false,
    this.priority = 3,
    this.tags = const [],
    this.recurrenceRule,
    this.reminderTime,
    this.notes,
    this.energyLevel,
    this.attendees = const [],
  });

  Duration get duration => endTime.difference(startTime);

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    EventCategory? category,
    String? location,
    bool? hasVideoCall,
    bool? isCompleted,
    bool? hasConflict,
    int? priority,
    List<String>? tags,
    String? recurrenceRule,
    DateTime? reminderTime,
    String? notes,
    double? energyLevel,
    List<String>? attendees,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      location: location ?? this.location,
      hasVideoCall: hasVideoCall ?? this.hasVideoCall,
      isCompleted: isCompleted ?? this.isCompleted,
      hasConflict: hasConflict ?? this.hasConflict,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderTime: reminderTime ?? this.reminderTime,
      notes: notes ?? this.notes,
      energyLevel: energyLevel ?? this.energyLevel,
      attendees: attendees ?? this.attendees,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'category': category.name,
      'location': location,
      'hasVideoCall': hasVideoCall,
      'isCompleted': isCompleted,
      'hasConflict': hasConflict,
      'priority': priority,
      'tags': tags,
      'recurrenceRule': recurrenceRule,
      'reminderTime': reminderTime?.toIso8601String(),
      'notes': notes,
      'energyLevel': energyLevel,
      'attendees': attendees,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      category: EventCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => EventCategory.work,
      ),
      location: json['location'],
      hasVideoCall: json['hasVideoCall'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      hasConflict: json['hasConflict'] ?? false,
      priority: json['priority'] ?? 3,
      tags: List<String>.from(json['tags'] ?? []),
      recurrenceRule: json['recurrenceRule'],
      reminderTime: json['reminderTime'] != null 
          ? DateTime.parse(json['reminderTime']) 
          : null,
      notes: json['notes'],
      energyLevel: json['energyLevel']?.toDouble(),
      attendees: List<String>.from(json['attendees'] ?? []),
    );
  }

  // Helper methods for enhanced functionality
  bool get isHighPriority => priority >= 4;
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    return startTime.isAfter(today) && startTime.isBefore(tomorrow);
  }
  
  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }
  
  bool get isInProgress {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
  
  String get timeUntilStart {
    final now = DateTime.now();
    if (startTime.isBefore(now)) return 'Started';
    
    final difference = startTime.difference(now);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }
}