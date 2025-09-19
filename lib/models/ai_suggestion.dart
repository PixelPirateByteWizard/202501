enum SuggestionType {
  reschedule,
  addFocus,
  consolidate,
  optimize,
  addBreak,
  energyOptimize,
  priorityReorder,
  timeBlock,
  conflictResolve,
  productivityBoost,
}

extension SuggestionTypeExtension on SuggestionType {
  String get displayName {
    switch (this) {
      case SuggestionType.reschedule:
        return 'Reschedule';
      case SuggestionType.addFocus:
        return 'Add Focus Time';
      case SuggestionType.consolidate:
        return 'Consolidate';
      case SuggestionType.optimize:
        return 'Optimize';
      case SuggestionType.addBreak:
        return 'Add Break';
      case SuggestionType.energyOptimize:
        return 'Energy Optimization';
      case SuggestionType.priorityReorder:
        return 'Priority Reorder';
      case SuggestionType.timeBlock:
        return 'Time Blocking';
      case SuggestionType.conflictResolve:
        return 'Conflict Resolution';
      case SuggestionType.productivityBoost:
        return 'Productivity Boost';
    }
  }
}

class AISuggestion {
  final String id;
  final String title;
  final String description;
  final SuggestionType type;
  final String? eventId;
  final DateTime? suggestedTime;
  final double? improvementPercentage;
  final bool isAccepted;
  final bool isDismissed;
  final int priority; // 1-5, 5 being most important
  final List<String> affectedEventIds;
  final Map<String, dynamic>? actionData;
  final DateTime createdAt;
  final String? reasoning;

  AISuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.eventId,
    this.suggestedTime,
    this.improvementPercentage,
    this.isAccepted = false,
    this.isDismissed = false,
    this.priority = 3,
    this.affectedEventIds = const [],
    this.actionData,
    DateTime? createdAt,
    this.reasoning,
  }) : createdAt = createdAt ?? DateTime.now();

  AISuggestion copyWith({
    String? id,
    String? title,
    String? description,
    SuggestionType? type,
    String? eventId,
    DateTime? suggestedTime,
    double? improvementPercentage,
    bool? isAccepted,
    bool? isDismissed,
    int? priority,
    List<String>? affectedEventIds,
    Map<String, dynamic>? actionData,
    DateTime? createdAt,
    String? reasoning,
  }) {
    return AISuggestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
      suggestedTime: suggestedTime ?? this.suggestedTime,
      improvementPercentage: improvementPercentage ?? this.improvementPercentage,
      isAccepted: isAccepted ?? this.isAccepted,
      isDismissed: isDismissed ?? this.isDismissed,
      priority: priority ?? this.priority,
      affectedEventIds: affectedEventIds ?? this.affectedEventIds,
      actionData: actionData ?? this.actionData,
      createdAt: createdAt ?? this.createdAt,
      reasoning: reasoning ?? this.reasoning,
    );
  }

  // Helper methods
  bool get isHighPriority => priority >= 4;
  bool get isExpired => DateTime.now().difference(createdAt).inHours > 24;
  bool get hasMultipleEvents => affectedEventIds.length > 1;
}