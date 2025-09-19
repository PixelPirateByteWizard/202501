import 'dart:math';

class VoiceService {
  static final List<String> _sampleVoiceInputs = [
    "Schedule a meeting with the team tomorrow at 2 PM for 1 hour",
    "Add a focus time block today at 3 PM for 2 hours",
    "Create a personal appointment for doctor visit next Tuesday at 10 AM",
    "Book a client call for Friday at 10 AM for 45 minutes",
    "Set up a design review meeting Thursday at 11 AM",
    "Add lunch break today at 12:30 PM for 30 minutes",
    "Schedule gym session tomorrow at 6 PM for 1 hour",
    "Create a project planning meeting next Monday at 9 AM for 2 hours",
    "Add coffee chat with Sarah tomorrow at 3 PM",
    "Schedule code review session today at 4 PM for 1 hour",
  ];

  static final List<String> _quickQuestions = [
    "What's my schedule for tomorrow?",
    "Do I have any free time today?",
    "When is my next meeting?",
    "Can you reschedule my 3 PM meeting?",
    "What meetings do I have this week?",
    "Add a 30-minute break after my current meeting",
    "Show me my focus time blocks",
    "When am I free for a 1-hour meeting?",
  ];

  // Simulate voice recognition
  static String getRandomVoiceInput() {
    final random = Random();
    final allInputs = [..._sampleVoiceInputs, ..._quickQuestions];
    return allInputs[random.nextInt(allInputs.length)];
  }

  // Simulate listening state
  static Future<String> simulateListening() async {
    // Simulate listening delay
    await Future.delayed(const Duration(seconds: 2));
    return getRandomVoiceInput();
  }

  // Check if input is a question vs command
  static bool isQuestion(String input) {
    final lowerInput = input.toLowerCase();
    return lowerInput.startsWith('what') ||
           lowerInput.startsWith('when') ||
           lowerInput.startsWith('do i') ||
           lowerInput.startsWith('can you') ||
           lowerInput.startsWith('show me') ||
           lowerInput.contains('?');
  }

  // Extract intent from voice input
  static VoiceIntent extractIntent(String input) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('schedule') || 
        lowerInput.contains('add') || 
        lowerInput.contains('create') ||
        lowerInput.contains('book')) {
      return VoiceIntent.createEvent;
    } else if (lowerInput.contains('reschedule') || 
               lowerInput.contains('move') ||
               lowerInput.contains('change')) {
      return VoiceIntent.modifyEvent;
    } else if (lowerInput.contains('cancel') || 
               lowerInput.contains('delete') ||
               lowerInput.contains('remove')) {
      return VoiceIntent.deleteEvent;
    } else if (isQuestion(input)) {
      return VoiceIntent.query;
    } else {
      return VoiceIntent.general;
    }
  }
}

enum VoiceIntent {
  createEvent,
  modifyEvent,
  deleteEvent,
  query,
  general,
}