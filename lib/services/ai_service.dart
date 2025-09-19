import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_suggestion.dart';
import '../models/event.dart';

class AIService {
  static const String _apiKey = 'sk-157e2d04920344578522e337fc5dc994';
  static const String _baseUrl = 'https://api.deepseek.com';

  // Generate dynamic suggestions based on current events
  static List<AISuggestion> _generateSuggestions(List<Event> events) {
    final suggestions = <AISuggestion>[];
    final now = DateTime.now();
    
    // Check for conflicts
    final conflictingEvents = events.where((e) => e.hasConflict).toList();
    if (conflictingEvents.isNotEmpty) {
      final firstConflict = conflictingEvents.first;
      suggestions.add(AISuggestion(
        id: 'conflict_${firstConflict.id}',
        title: 'Resolve Schedule Conflict',
        description: 'Move "${firstConflict.title}" to avoid overlap',
        type: SuggestionType.reschedule,
        improvementPercentage: 15,
      ));
    }
    
    // Check for lack of focus time
    final todayEvents = events.where((e) {
      final eventDate = DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
      final today = DateTime(now.year, now.month, now.day);
      return eventDate == today;
    }).toList();
    
    final focusEvents = todayEvents.where((e) => e.category == EventCategory.focus).toList();
    if (focusEvents.isEmpty && todayEvents.length > 2) {
      suggestions.add(AISuggestion(
        id: 'focus_${now.millisecondsSinceEpoch}',
        title: 'Add Focus Time',
        description: 'Schedule 2h deep work block for better productivity',
        type: SuggestionType.addFocus,
      ));
    }
    
    // Check for meeting consolidation opportunities
    final meetings = todayEvents.where((e) => e.category == EventCategory.meeting).toList();
    if (meetings.length >= 3) {
      suggestions.add(AISuggestion(
        id: 'consolidate_${now.millisecondsSinceEpoch}',
        title: 'Meeting Consolidation',
        description: 'Group ${meetings.length} meetings for better flow',
        type: SuggestionType.consolidate,
        improvementPercentage: 25,
      ));
    }
    
    // Suggest breaks between long sessions
    for (int i = 0; i < todayEvents.length - 1; i++) {
      final current = todayEvents[i];
      final next = todayEvents[i + 1];
      final gap = next.startTime.difference(current.endTime);
      
      if (gap.inMinutes < 15 && current.duration.inHours >= 1) {
        suggestions.add(AISuggestion(
          id: 'break_${current.id}',
          title: 'Add Break Time',
          description: 'Add 15min break between "${current.title}" and "${next.title}"',
          type: SuggestionType.addBreak,
        ));
        break; // Only suggest one break at a time
      }
    }
    
    return suggestions;
  }

  Future<List<AISuggestion>> getSuggestions([List<Event>? events]) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (events != null && events.isNotEmpty) {
      return _generateSuggestions(events);
    }
    
    // Fallback to static suggestions if no events provided
    return [
      AISuggestion(
        id: 'default_1',
        title: 'Add Focus Time',
        description: 'Schedule 2h deep work session for better productivity',
        type: SuggestionType.addFocus,
      ),
      AISuggestion(
        id: 'default_2',
        title: 'Plan Tomorrow',
        description: 'Review and optimize tomorrow\'s schedule',
        type: SuggestionType.optimize,
      ),
    ];
  }

  Future<void> acceptSuggestion(String suggestionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, this would make an API call to accept the suggestion
  }

  Future<void> dismissSuggestion(String suggestionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, this would make an API call to dismiss the suggestion
  }

  Future<String> sendMessage(String message, {List<Map<String, String>>? conversationHistory}) async {
    try {
      // Build conversation messages
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': '''You are Solakai, a helpful AI scheduling assistant. You help users manage their calendar and schedule events efficiently. 

Key capabilities:
- Schedule meetings and events
- Optimize calendar layouts
- Suggest focus time blocks
- Resolve scheduling conflicts
- Provide time management advice
- Parse natural language for event creation

Guidelines:
- Keep responses concise and actionable
- Use emojis sparingly but effectively
- Offer specific suggestions with times when possible
- Ask clarifying questions when event details are unclear
- Be proactive in suggesting improvements

Current context: You're integrated into a smart calendar app called Solakai.''',
        },
      ];

      // Add conversation history if provided
      if (conversationHistory != null) {
        messages.addAll(conversationHistory);
      }

      // Add current user message
      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': messages,
          'stream': false,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        return content ?? 'I apologize, but I couldn\'t generate a response. Please try again.';
      } else {
        print('DeepSeek API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      print('AI Service Error: $e');
      // Fallback to mock responses for demo
      return _getMockResponse(message);
    }
  }

  String _getMockResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return "Hello! I'm Solakai, your AI scheduling assistant. I'm here to help you manage your calendar efficiently. What would you like to do today?";
    } else if (lowerMessage.contains('tomorrow') || lowerMessage.contains('schedule tomorrow')) {
      return "Here's your schedule for tomorrow:\n\n📅 **Tomorrow's Events:**\n• 9:00 AM - Client call (1 hour)\n• 11:30 AM - Team sync (45 mins)\n• 2:00 PM - Project review (1 hour)\n\n🎯 You also have 2 hours of focus time scheduled in the morning. Would you like me to optimize your schedule?";
    } else if (lowerMessage.contains('today') && (lowerMessage.contains('schedule') || lowerMessage.contains('events'))) {
      return "Here's what you have today:\n\n📅 **Today's Events:**\n• 10:00 AM - Stand-up meeting (30 mins)\n• 2:00 PM - Design review (1 hour)\n• 4:00 PM - Focus time (2 hours)\n\n✨ You're having a productive day! Need help with anything else?";
    } else if (lowerMessage.contains('move') || lowerMessage.contains('reschedule')) {
      return "I can help you reschedule events! Which event would you like to move? I can suggest the best available time slots based on your calendar.";
    } else if (lowerMessage.contains('add') || lowerMessage.contains('create') || lowerMessage.contains('schedule meeting')) {
      return "I'd love to help you schedule something! Please tell me:\n\n📝 **Event details:**\n• What's the event title?\n• When would you like it? (date & time)\n• How long will it take?\n• Is it a meeting, focus time, or personal event?\n\nJust describe it naturally, like 'Schedule team meeting tomorrow at 2pm for 1 hour'";
    } else if (lowerMessage.contains('free') || lowerMessage.contains('available')) {
      return "Here are your free time slots:\n\n🕐 **Today:**\n• 12:30 PM - 2:00 PM (1.5 hours)\n• 3:30 PM - 4:00 PM (30 mins)\n• After 6:00 PM (evening free)\n\n🕐 **Tomorrow:**\n• 8:00 AM - 9:00 AM (1 hour)\n• 12:30 PM - 2:00 PM (1.5 hours)\n• After 3:00 PM (afternoon free)\n\nWould you like to schedule something in any of these slots?";
    } else if (lowerMessage.contains('optimize') || lowerMessage.contains('improve')) {
      return "I can help optimize your schedule! Here are some suggestions:\n\n⚡ **Optimization ideas:**\n• Group similar meetings together\n• Add buffer time between meetings\n• Schedule focus blocks during your peak hours\n• Block time for breaks and lunch\n\nWould you like me to apply any of these optimizations?";
    } else if (lowerMessage.contains('focus') && lowerMessage.contains('time')) {
      return "Focus time is crucial for productivity! I can help you:\n\n🎯 **Focus time options:**\n• Schedule 2-hour deep work blocks\n• Find your optimal focus hours\n• Block distractions during focus time\n• Set up recurring focus sessions\n\nWhen would you like to add focus time to your calendar?";
    } else if (lowerMessage.contains('conflict') || lowerMessage.contains('overlap')) {
      return "I can help resolve scheduling conflicts! Let me check your calendar for overlapping events and suggest the best solutions to reorganize your schedule.";
    } else if (lowerMessage.contains('help') || lowerMessage.contains('what can you do')) {
      return "I'm your AI scheduling assistant! Here's what I can help you with:\n\n🗓️ **Calendar Management:**\n• Schedule meetings and events\n• Find free time slots\n• Reschedule conflicting events\n• Optimize your daily schedule\n\n⚡ **Smart Features:**\n• Natural language event creation\n• Automatic conflict detection\n• Focus time recommendations\n• Schedule optimization tips\n\nJust tell me what you need in plain English!";
    } else {
      return "I understand you want to work with your calendar. Could you be more specific about what you'd like to do? For example:\n\n• 'Schedule a meeting tomorrow at 2pm'\n• 'Show my free time today'\n• 'Move my 3pm call to 4pm'\n• 'Add 2 hours of focus time'\n\nI'm here to help make scheduling effortless!";
    }
  }

  // Parse natural language to extract event details
  Map<String, dynamic>? parseEventFromText(String text) {
    final lowerText = text.toLowerCase();
    
    // Check if this is actually a request to create an event
    final eventKeywords = ['schedule', 'add', 'create', 'book', 'plan', 'set up'];
    final hasEventKeyword = eventKeywords.any((keyword) => lowerText.contains(keyword));
    
    if (!hasEventKeyword) {
      return null; // Not an event creation request
    }
    
    Map<String, dynamic> eventData = {};
    
    // Extract title - more sophisticated approach
    String title = text;
    
    // Remove common prefixes
    final prefixes = ['schedule', 'add', 'create', 'book', 'plan', 'set up'];
    for (final prefix in prefixes) {
      if (lowerText.startsWith(prefix)) {
        title = text.substring(prefix.length).trim();
        break;
      }
    }
    
    // Extract title (everything before time/date indicators)
    final timeIndicators = ['at', 'on', 'tomorrow', 'today', 'next week', 'next month', 'for'];
    for (final indicator in timeIndicators) {
      final index = lowerText.indexOf(indicator);
      if (index != -1) {
        final potentialTitle = title.substring(0, title.toLowerCase().indexOf(indicator)).trim();
        if (potentialTitle.isNotEmpty) {
          title = potentialTitle;
        }
        break;
      }
    }
    
    // Clean up title
    title = title.replaceAll(RegExp(r'^(a |an |the )', caseSensitive: false), '');
    
    if (title.isNotEmpty && title.length > 2) {
      eventData['title'] = title;
    }
    
    // Extract date
    DateTime? eventTime;
    final now = DateTime.now();
    
    if (lowerText.contains('tomorrow')) {
      eventTime = DateTime(now.year, now.month, now.day + 1);
    } else if (lowerText.contains('today')) {
      eventTime = DateTime(now.year, now.month, now.day);
    } else if (lowerText.contains('next week')) {
      eventTime = now.add(const Duration(days: 7));
    } else if (lowerText.contains('monday')) {
      eventTime = _getNextWeekday(now, DateTime.monday);
    } else if (lowerText.contains('tuesday')) {
      eventTime = _getNextWeekday(now, DateTime.tuesday);
    } else if (lowerText.contains('wednesday')) {
      eventTime = _getNextWeekday(now, DateTime.wednesday);
    } else if (lowerText.contains('thursday')) {
      eventTime = _getNextWeekday(now, DateTime.thursday);
    } else if (lowerText.contains('friday')) {
      eventTime = _getNextWeekday(now, DateTime.friday);
    }
    
    // Extract specific time with more patterns
    final timePatterns = [
      RegExp(r'(\d{1,2}):(\d{2})\s*(am|pm)', caseSensitive: false),
      RegExp(r'(\d{1,2})\s*(am|pm)', caseSensitive: false),
      RegExp(r'(\d{1,2}):(\d{2})', caseSensitive: false),
    ];
    
    for (final pattern in timePatterns) {
      final timeMatch = pattern.firstMatch(lowerText);
      if (timeMatch != null) {
        int hour = int.parse(timeMatch.group(1)!);
        int minute = timeMatch.groupCount >= 2 && timeMatch.group(2) != null 
            ? int.parse(timeMatch.group(2)!) 
            : 0;
        
        final amPmGroup = timeMatch.groupCount >= 3 ? timeMatch.group(3) : null;
        final amPm = amPmGroup?.toLowerCase();
        
        if (amPm == 'pm' && hour != 12) hour += 12;
        if (amPm == 'am' && hour == 12) hour = 0;
        
        if (eventTime != null) {
          eventTime = DateTime(eventTime.year, eventTime.month, eventTime.day, hour, minute);
        } else {
          // Default to today if no date specified
          eventTime = DateTime(now.year, now.month, now.day, hour, minute);
          // If the time has passed today, schedule for tomorrow
          if (eventTime.isBefore(now)) {
            eventTime = eventTime.add(const Duration(days: 1));
          }
        }
        eventData['startTime'] = eventTime;
        break;
      }
    }
    
    // Extract duration with more patterns
    final durationPatterns = [
      RegExp(r'for (\d+)\s*(hour|hr|hours)', caseSensitive: false),
      RegExp(r'for (\d+)\s*(minute|min|minutes)', caseSensitive: false),
      RegExp(r'(\d+)\s*(hour|hr|hours)', caseSensitive: false),
      RegExp(r'(\d+)\s*(minute|min|minutes)', caseSensitive: false),
    ];
    
    for (final pattern in durationPatterns) {
      final durationMatch = pattern.firstMatch(lowerText);
      if (durationMatch != null) {
        final value = int.parse(durationMatch.group(1)!);
        final unit = durationMatch.group(2)!.toLowerCase();
        
        Duration duration;
        if (unit.startsWith('hour') || unit == 'hr') {
          duration = Duration(hours: value);
        } else {
          duration = Duration(minutes: value);
        }
        eventData['duration'] = duration;
        break;
      }
    }
    
    // Extract category based on keywords with more sophistication
    if (lowerText.contains('meeting') || lowerText.contains('call') || 
        lowerText.contains('sync') || lowerText.contains('standup') ||
        lowerText.contains('interview') || lowerText.contains('discussion')) {
      eventData['category'] = 'meeting';
    } else if (lowerText.contains('focus') || lowerText.contains('work on') ||
               lowerText.contains('deep work') || lowerText.contains('coding') ||
               lowerText.contains('development') || lowerText.contains('research')) {
      eventData['category'] = 'focus';
    } else if (lowerText.contains('personal') || lowerText.contains('doctor') || 
               lowerText.contains('gym') || lowerText.contains('lunch') ||
               lowerText.contains('break') || lowerText.contains('appointment')) {
      eventData['category'] = 'personal';
    } else {
      eventData['category'] = 'work';
    }
    
    return eventData.isNotEmpty ? eventData : null;
  }

  DateTime _getNextWeekday(DateTime from, int weekday) {
    final daysUntilWeekday = (weekday - from.weekday) % 7;
    final targetDate = from.add(Duration(days: daysUntilWeekday == 0 ? 7 : daysUntilWeekday));
    return DateTime(targetDate.year, targetDate.month, targetDate.day);
  }
}