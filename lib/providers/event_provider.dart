import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/time_analytics_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Event> get todayEvents {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _events.where((event) {
      return event.startTime.isAfter(today) && event.startTime.isBefore(tomorrow);
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<Event> get tomorrowEvents {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final dayAfter = tomorrow.add(const Duration(days: 1));
    
    return _events.where((event) {
      return event.startTime.isAfter(tomorrow) && event.startTime.isBefore(dayAfter);
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Event? get currentEvent {
    final now = DateTime.now();
    return _events.where((event) {
      return now.isAfter(event.startTime) && now.isBefore(event.endTime);
    }).firstOrNull;
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _eventService.getEvents();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      // Check for conflicts before adding
      final conflicts = _checkForConflicts(event);
      Event eventToAdd = event;
      
      if (conflicts.isNotEmpty) {
        // Mark event as having conflict
        eventToAdd = event.copyWith(hasConflict: true);
      }
      
      final newEvent = await _eventService.createEvent(eventToAdd);
      _events.add(newEvent);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<Event> _checkForConflicts(Event newEvent) {
    return _events.where((existingEvent) {
      // Check if events overlap
      return (newEvent.startTime.isBefore(existingEvent.endTime) &&
              newEvent.endTime.isAfter(existingEvent.startTime));
    }).toList();
  }

  List<Event> getConflictingEvents() {
    return _events.where((event) => event.hasConflict).toList();
  }

  List<DateTime> getAvailableSlots(Duration duration, {DateTime? startFrom}) {
    final start = startFrom ?? DateTime.now();
    final endOfDay = DateTime(start.year, start.month, start.day, 18); // 6 PM
    final slots = <DateTime>[];
    
    // Find gaps between events
    final dayEvents = _events.where((event) {
      final eventDate = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      final targetDate = DateTime(start.year, start.month, start.day);
      return eventDate == targetDate;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    DateTime currentTime = start;
    
    for (final event in dayEvents) {
      if (event.startTime.difference(currentTime) >= duration) {
        slots.add(currentTime);
      }
      currentTime = event.endTime;
    }
    
    // Check if there's time after the last event
    if (endOfDay.difference(currentTime) >= duration) {
      slots.add(currentTime);
    }
    
    return slots;
  }

  Future<void> updateEvent(Event event) async {
    try {
      final updatedEvent = await _eventService.updateEvent(event);
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      _events.removeWhere((e) => e.id == eventId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeEvent(String eventId) async {
    final event = _events.firstWhere((e) => e.id == eventId);
    await updateEvent(event.copyWith(isCompleted: true));
  }

  List<double> getWeekHeatmap() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    List<double> heatmap = [];
    
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      final dayEvents = _events.where((event) {
        return event.startTime.isAfter(dayStart) && event.startTime.isBefore(dayEnd);
      }).toList();
      
      double totalHours = 0;
      for (final event in dayEvents) {
        totalHours += event.duration.inMinutes / 60.0;
      }
      
      // Normalize to 0-1 scale (assuming max 12 hours per day)
      heatmap.add((totalHours / 12.0).clamp(0.0, 1.0));
    }
    
    return heatmap;
  }

  // Enhanced analytics methods
  TimeAnalytics getTimeAnalytics({DateTime? startDate, DateTime? endDate}) {
    return TimeAnalyticsService.analyzeEvents(_events, startDate: startDate, endDate: endDate);
  }

  TimeAnalytics getTodayAnalytics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    return TimeAnalyticsService.analyzeEvents(_events, startDate: today, endDate: tomorrow);
  }

  TimeAnalytics getWeekAnalytics() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return TimeAnalyticsService.analyzeEvents(_events, startDate: startOfWeek, endDate: endOfWeek);
  }

  Map<String, double> getProductivityTrends(int days) {
    return TimeAnalyticsService.getProductivityTrends(_events, days);
  }

  List<DateTime> findOptimalFocusSlots(Duration duration) {
    return TimeAnalyticsService.findOptimalFocusSlots(_events, duration);
  }

  // Enhanced event filtering
  List<Event> getEventsByCategory(EventCategory category) {
    return _events.where((event) => event.category == category).toList();
  }

  List<Event> getEventsByPriority(int minPriority) {
    return _events.where((event) => event.priority >= minPriority).toList();
  }

  List<Event> getUpcomingEvents({int? limit}) {
    final upcoming = _events.where((event) => event.isUpcoming).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    if (limit != null && upcoming.length > limit) {
      return upcoming.take(limit).toList();
    }
    return upcoming;
  }

  List<Event> getEventsInProgress() {
    return _events.where((event) => event.isInProgress).toList();
  }

  // Smart scheduling methods
  Future<Event?> scheduleSmartEvent({
    required String title,
    required Duration duration,
    EventCategory category = EventCategory.work,
    int priority = 3,
    DateTime? preferredTime,
  }) async {
    try {
      // Find optimal time slot
      final optimalSlots = findOptimalFocusSlots(duration);
      DateTime? scheduledTime;

      if (preferredTime != null) {
        // Check if preferred time is available
        final preferredEnd = preferredTime.add(duration);
        final hasConflict = _events.any((event) {
          return (preferredTime.isBefore(event.endTime) && 
                  preferredEnd.isAfter(event.startTime));
        });
        
        if (!hasConflict) {
          scheduledTime = preferredTime;
        }
      }

      // Fallback to optimal slots
      scheduledTime ??= optimalSlots.isNotEmpty ? optimalSlots.first : null;

      if (scheduledTime == null) {
        // No available slots found
        return null;
      }

      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: 'Smart scheduled event',
        startTime: scheduledTime,
        endTime: scheduledTime.add(duration),
        category: category,
        priority: priority,
      );

      await addEvent(event);
      return event;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Batch operations
  Future<void> batchUpdateEvents(List<Event> events) async {
    try {
      for (final event in events) {
        await _eventService.updateEvent(event);
        final index = _events.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          _events[index] = event;
        }
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> optimizeSchedule() async {
    try {
      // Get conflicting events
      final conflicts = getConflictingEvents();
      
      // Resolve conflicts by rescheduling lower priority events
      for (final event in conflicts) {
        if (event.priority < 4) {
          final availableSlots = getAvailableSlots(event.duration);
          if (availableSlots.isNotEmpty) {
            final optimizedEvent = event.copyWith(
              startTime: availableSlots.first,
              endTime: availableSlots.first.add(event.duration),
              hasConflict: false,
            );
            await updateEvent(optimizedEvent);
          }
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}