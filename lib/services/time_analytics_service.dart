import '../models/event.dart';

class TimeAnalytics {
  final double totalHours;
  final double focusHours;
  final double meetingHours;
  final double personalHours;
  final double workHours;
  final double efficiency;
  final int conflictCount;
  final double averageEventDuration;
  final Map<String, double> categoryBreakdown;
  final List<String> insights;

  TimeAnalytics({
    required this.totalHours,
    required this.focusHours,
    required this.meetingHours,
    required this.personalHours,
    required this.workHours,
    required this.efficiency,
    required this.conflictCount,
    required this.averageEventDuration,
    required this.categoryBreakdown,
    required this.insights,
  });
}

class TimeAnalyticsService {
  static TimeAnalytics analyzeEvents(
    List<Event> events, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (events.isEmpty) {
      return TimeAnalytics(
        totalHours: 0,
        focusHours: 0,
        meetingHours: 0,
        personalHours: 0,
        workHours: 0,
        efficiency: 0,
        conflictCount: 0,
        averageEventDuration: 0,
        categoryBreakdown: {},
        insights: ['No events to analyze'],
      );
    }

    // Filter events by date range if provided
    List<Event> filteredEvents = events;
    if (startDate != null && endDate != null) {
      filteredEvents = events.where((event) {
        return event.startTime.isAfter(startDate) &&
            event.startTime.isBefore(endDate);
      }).toList();
    }

    double totalHours = 0.0;
    double focusHours = 0.0;
    double meetingHours = 0.0;
    double personalHours = 0.0;
    double workHours = 0.0;
    int conflictCount = 0;

    Map<EventCategory, double> categoryHours = {};

    for (final event in filteredEvents) {
      final duration = event.duration.inMinutes / 60.0;
      totalHours += duration;

      if (event.hasConflict) conflictCount++;

      switch (event.category) {
        case EventCategory.focus:
          focusHours += duration;
          break;
        case EventCategory.meeting:
          meetingHours += duration;
          break;
        case EventCategory.personal:
          personalHours += duration;
          break;
        case EventCategory.work:
          workHours += duration;
          break;
      }

      categoryHours[event.category] =
          (categoryHours[event.category] ?? 0) + duration;
    }

    final double averageEventDuration = filteredEvents.isNotEmpty
        ? totalHours / filteredEvents.length
        : 0.0;

    // Calculate efficiency (focus time / total time, adjusted for conflicts)
    double efficiency = 0.0;
    if (totalHours > 0) {
      final focusRatio = focusHours / totalHours;
      final conflictPenalty = conflictCount * 0.1;
      efficiency = (focusRatio * 100 - conflictPenalty).clamp(0.0, 100.0);
    }

    // Generate insights
    final insights = _generateInsights(
      filteredEvents,
      totalHours,
      focusHours,
      meetingHours,
      conflictCount,
      efficiency,
    );

    // Create category breakdown
    final categoryBreakdown = <String, double>{};
    for (final entry in categoryHours.entries) {
      categoryBreakdown[entry.key.name] = entry.value;
    }

    return TimeAnalytics(
      totalHours: totalHours,
      focusHours: focusHours,
      meetingHours: meetingHours,
      personalHours: personalHours,
      workHours: workHours,
      efficiency: efficiency,
      conflictCount: conflictCount,
      averageEventDuration: averageEventDuration,
      categoryBreakdown: categoryBreakdown,
      insights: insights,
    );
  }

  static List<String> _generateInsights(
    List<Event> events,
    double totalHours,
    double focusHours,
    double meetingHours,
    int conflictCount,
    double efficiency,
  ) {
    final insights = <String>[];

    // Focus time insights
    if (focusHours < totalHours * 0.3 && totalHours > 4) {
      insights.add('Consider adding more focus time blocks for deep work');
    } else if (focusHours > totalHours * 0.6) {
      insights.add(
        'Great focus time allocation! You\'re prioritizing deep work',
      );
    }

    // Meeting insights
    if (meetingHours > totalHours * 0.5) {
      insights.add(
        'High meeting load detected. Consider consolidating or declining some meetings',
      );
    }

    // Conflict insights
    if (conflictCount > 0) {
      insights.add('$conflictCount schedule conflicts need attention');
    }

    // Efficiency insights
    if (efficiency < 50) {
      insights.add(
        'Schedule optimization could improve your productivity by ${(100 - efficiency).toInt()}%',
      );
    } else if (efficiency > 80) {
      insights.add(
        'Excellent schedule efficiency! You\'re making great use of your time',
      );
    }

    // Time distribution insights
    final workingHours = events
        .where((e) => e.startTime.hour >= 9 && e.startTime.hour <= 17)
        .length;

    if (workingHours < events.length * 0.7) {
      insights.add(
        'Many events outside standard working hours. Consider work-life balance',
      );
    }

    // Energy-based insights
    final morningEvents = events.where((e) => e.startTime.hour < 12).length;
    final afternoonEvents = events.where((e) => e.startTime.hour >= 12).length;

    if (morningEvents > afternoonEvents * 1.5) {
      insights.add(
        'You\'re a morning person! Consider scheduling important tasks early',
      );
    } else if (afternoonEvents > morningEvents * 1.5) {
      insights.add(
        'Afternoon-heavy schedule. Make sure to maintain energy levels',
      );
    }

    if (insights.isEmpty) {
      insights.add('Your schedule looks well-balanced!');
    }

    return insights;
  }

  static Map<String, double> getProductivityTrends(
    List<Event> events,
    int days,
  ) {
    final trends = <String, double>{};
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayEvents = events.where((event) {
        return event.startTime.isAfter(dayStart) &&
            event.startTime.isBefore(dayEnd);
      }).toList();

      final analytics = analyzeEvents(dayEvents);
      trends['${date.month}/${date.day}'] = analytics.efficiency;
    }

    return trends;
  }

  static List<DateTime> findOptimalFocusSlots(
    List<Event> events,
    Duration duration,
  ) {
    final slots = <DateTime>[];
    final now = DateTime.now();


    // Analyze historical focus time performance
    final focusEvents = events
        .where((e) => e.category == EventCategory.focus)
        .toList();
    final optimalHours = <int>[];

    // Find most productive hours based on completed focus events
    for (final event in focusEvents) {
      if (event.isCompleted) {
        optimalHours.add(event.startTime.hour);
      }
    }

    // Default to morning hours if no data
    if (optimalHours.isEmpty) {
      optimalHours.addAll([9, 10, 14, 15]);
    }

    // Find available slots during optimal hours
    for (int day = 0; day < 7; day++) {
      final targetDate = now.add(Duration(days: day));

      for (final hour in optimalHours) {
        final slotStart = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          hour,
        );
        final slotEnd = slotStart.add(duration);

        // Check if slot is available
        final hasConflict = events.any((event) {
          return (slotStart.isBefore(event.endTime) &&
              slotEnd.isAfter(event.startTime));
        });

        if (!hasConflict && slotStart.isAfter(now)) {
          slots.add(slotStart);
        }
      }
    }

    return slots..sort((a, b) => a.compareTo(b));
  }
}
