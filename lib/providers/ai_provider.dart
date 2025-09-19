import 'package:flutter/foundation.dart';
import '../models/ai_suggestion.dart';
import '../models/chat_message.dart';
import '../models/event.dart';
import '../models/ai_role.dart';
import '../services/ai_service.dart';

class AIProvider with ChangeNotifier {
  final AIService _aiService = AIService();
  
  List<AISuggestion> _suggestions = [];
  final List<ChatMessage> _chatMessages = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _pendingEventData;
  AIRole? _selectedRole;

  List<AISuggestion> get suggestions => _suggestions.where((s) => !s.isDismissed).toList();
  List<ChatMessage> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AIRole? get selectedRole => _selectedRole;

  void selectRole(AIRole role) {
    _selectedRole = role;
    
    // Add a system message about role change
    final roleMessage = ChatMessage(
      id: 'role_change_${DateTime.now().millisecondsSinceEpoch}',
      content: "你好！我是${role.name}，${role.description}。我的性格特点是${role.personality}，擅长${role.specialties.join('、')}。有什么可以帮助你的吗？",
      type: MessageType.ai,
      timestamp: DateTime.now(),
    );
    
    _chatMessages.add(roleMessage);
    notifyListeners();
  }

  Future<void> loadSuggestions([List<Event>? events]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _suggestions = await _aiService.getSuggestions(events);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptSuggestion(String suggestionId) async {
    try {
      await _aiService.acceptSuggestion(suggestionId);
      final index = _suggestions.indexWhere((s) => s.id == suggestionId);
      if (index != -1) {
        _suggestions[index] = _suggestions[index].copyWith(isAccepted: true);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> dismissSuggestion(String suggestionId) async {
    try {
      await _aiService.dismissSuggestion(suggestionId);
      final index = _suggestions.indexWhere((s) => s.id == suggestionId);
      if (index != -1) {
        _suggestions[index] = _suggestions[index].copyWith(isDismissed: true);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content, {Function(Event)? onEventCreated}) async {
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );
    
    _chatMessages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      String response;
      
      // Check if user is confirming to add an event
      if (_pendingEventData != null && 
          (content.toLowerCase().contains('yes') || 
           content.toLowerCase().contains('add it') ||
           content.toLowerCase().contains('create it'))) {
        
        final event = createEventFromPendingData();
        if (event != null && onEventCreated != null) {
          onEventCreated(event);
          response = "✅ Perfect! I've added '${event.title}' to your calendar for ${_formatDateTime(event.startTime)}.";
        } else {
          response = "I had trouble creating the event. Could you please provide the details again?";
        }
        _pendingEventData = null;
      } else {
        // Check if the message is requesting to create an event
        final eventData = _aiService.parseEventFromText(content);
        
        if (eventData != null && eventData.containsKey('title')) {
          // Generate event creation response
          response = "I can help you create that event! Here's what I understood:\n\n";
          response += "📅 **${eventData['title']}**\n";
          
          if (eventData.containsKey('startTime')) {
            final startTime = eventData['startTime'] as DateTime;
            response += "🕐 ${_formatDateTime(startTime)}\n";
          }
          
          if (eventData.containsKey('duration')) {
            final duration = eventData['duration'] as Duration;
            response += "⏱️ ${_formatDuration(duration)}\n";
          }
          
          if (eventData.containsKey('category')) {
            response += "🏷️ ${eventData['category']}\n";
          }
          
          response += "\n\nJust reply 'yes' if you'd like me to add this to your calendar, or tell me what you'd like to change.";
          
          // Store event data for potential creation
          _pendingEventData = eventData;
        } else {
          // Build conversation history for context
          final conversationHistory = <Map<String, String>>[];
          
          // Include last 10 messages for context (excluding current user message)
          final recentMessages = _chatMessages.take(_chatMessages.length).toList();
          for (final msg in recentMessages.reversed.take(10).toList().reversed) {
            conversationHistory.add({
              'role': msg.type == MessageType.user ? 'user' : 'assistant',
              'content': msg.content,
            });
          }
          
          response = await _aiService.sendMessage(content, conversationHistory: conversationHistory);
        }
      }
      
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        type: MessageType.ai,
        timestamp: DateTime.now(),
      );
      
      _chatMessages.add(aiMessage);
      _error = null;
    } catch (e) {
      _error = e.toString();
      
      // Add error message to chat
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: "I'm having trouble connecting right now. Let me try to help you anyway! What would you like to do with your calendar?",
        type: MessageType.ai,
        timestamp: DateTime.now(),
      );
      _chatMessages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  void clearChat() {
    _chatMessages.clear();
    notifyListeners();
  }

  Event? createEventFromPendingData() {
    if (_pendingEventData == null || !_pendingEventData!.containsKey('title')) {
      return null;
    }

    final now = DateTime.now();
    final startTime = _pendingEventData!['startTime'] as DateTime? ?? 
        DateTime(now.year, now.month, now.day, now.hour + 1);
    final duration = _pendingEventData!['duration'] as Duration? ?? 
        const Duration(hours: 1);
    
    EventCategory category = EventCategory.work;
    final categoryStr = _pendingEventData!['category'] as String?;
    if (categoryStr != null) {
      switch (categoryStr.toLowerCase()) {
        case 'meeting':
          category = EventCategory.meeting;
          break;
        case 'focus':
          category = EventCategory.focus;
          break;
        case 'personal':
          category = EventCategory.personal;
          break;
        default:
          category = EventCategory.work;
      }
    }

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _pendingEventData!['title'] as String,
      description: 'Created by Kaelix',
      startTime: startTime,
      endTime: startTime.add(duration),
      category: category,
    );

    _pendingEventData = null;
    return event;
  }

  void handleQuickAction(String action) {
    if (action == 'Add to Calendar') {
      final event = createEventFromPendingData();
      if (event != null) {
        // This will be handled by the UI layer
        final message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: "✅ Event '${event.title}' has been added to your calendar!",
          type: MessageType.ai,
          timestamp: DateTime.now(),
        );
        _chatMessages.add(message);
        notifyListeners();
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    String dateStr;
    if (eventDate == today) {
      dateStr = 'Today';
    } else if (eventDate == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}';
    }
    
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$dateStr at $displayHour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }
}