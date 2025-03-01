import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatService {
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';
  static const String _apiKey = 'sk-94be7e531d6644eca8b7dbb1c12c4234';

  static Future<String?> getAIResponse(String message, String context) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content':
                  '''You are an environmental education expert. Please provide helpful and educational responses about environmental protection.
              Rules:
              1. Always respond in English only
              2. Do not discuss money, politics, medical, or health-related topics
              3. Keep responses focused on environmental education and protection
              4. Be friendly and encouraging
              5. Use simple language and include emojis when appropriate
              6. Keep responses concise (max 2-3 sentences)
              7. If user asks in Chinese, still respond in English
              
              Context of the conversation: $context'''
            },
            {
              'role': 'user',
              'content': message,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      }
      return null;
    } catch (e) {
      print('AI Response Error: $e');
      return null;
    }
  }
}
