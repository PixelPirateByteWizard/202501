import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class ChatStorageService {
  static const String _chatHistoryKey = 'eco_assistant_chat_history';

  // Save chat history to shared preferences
  static Future<bool> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> messageMapList =
          messages.map((message) => message.toMap()).toList();

      final String encodedData = jsonEncode(messageMapList);
      return await prefs.setString(_chatHistoryKey, encodedData);
    } catch (e) {
      print('Error saving chat history: $e');
      return false;
    }
  }

  // Load chat history from shared preferences
  static Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString(_chatHistoryKey);

      if (encodedData == null) {
        return [];
      }

      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData
          .map((item) => ChatMessage.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }

  // Clear chat history
  static Future<bool> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_chatHistoryKey);
    } catch (e) {
      print('Error clearing chat history: $e');
      return false;
    }
  }
}
