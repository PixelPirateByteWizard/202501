import '../models/event.dart';

class EventService {
  // Mock data for demonstration
  static final List<Event> _mockEvents = [
    Event(
      id: '1',
      title: 'Team Standup',
      description: 'Daily sync with product team',
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      category: EventCategory.meeting,
      hasVideoCall: true,
    ),
    Event(
      id: '2',
      title: 'Design Review',
      description: 'New dashboard designs',
      startTime: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
      endTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      category: EventCategory.work,
      hasConflict: true,
    ),
    Event(
      id: '3',
      title: 'Deep Work',
      description: 'Focus on project proposal',
      startTime: DateTime.now().add(const Duration(hours: 5)),
      endTime: DateTime.now().add(const Duration(hours: 7)),
      category: EventCategory.focus,
    ),
    Event(
      id: '4',
      title: 'Client Meeting',
      description: 'Quarterly review with ABC Corp',
      startTime: DateTime.now().add(const Duration(days: 1, hours: -15)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: -14)),
      category: EventCategory.meeting,
      location: 'Conference Room A',
    ),
  ];

  Future<List<Event>> getEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockEvents);
  }

  Future<Event> createEvent(Event event) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newEvent = event.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _mockEvents.add(newEvent);
    return newEvent;
  }

  Future<Event> updateEvent(Event event) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _mockEvents[index] = event;
    }
    return event;
  }

  Future<void> deleteEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockEvents.removeWhere((e) => e.id == eventId);
  }

  Future<List<Event>> searchEvents(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockEvents.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()) ||
             event.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}