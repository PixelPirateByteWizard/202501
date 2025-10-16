import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';
  static const String _apiKey = 'sk-9301675593bf4f5ba683ccfabf0b5b31';

  Future<String> generateStoryContent({
    required String context,
    required String playerAction,
    required String currentLocation,
  }) async {
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
              'content': '''You are a story generator for a steampunk adventure game. The game is set in a Victorian-era industrial city filled with mechanical devices, steam power, and mysterious ancient technology.

Based on the player's actions and current location, generate engaging story content that should:
1. Maintain steampunk atmosphere and style
2. Include mysterious elements and clues
3. Provide choices and interaction opportunities for players
4. Keep length between 100-200 words
5. Reply in English'''
            },
            {
              'role': 'user',
              'content': '''Current situation:
Location: $currentLocation
Context: $context
Player Action: $playerAction

Please generate the next story content.'''
            }
          ],
          'stream': false,
          'temperature': 0.8,
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      return 'Steam hisses through the pipes as gears turn slowly. You sense this place holds secrets, but now is not the time to uncover them...';
    }
  }

  Future<List<String>> generateChoices({
    required String currentStory,
    required String location,
  }) async {
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
              'content': '''Generate 3 player choice options for a steampunk adventure game. Each option should:
1. Be concise and clear (15-25 words)
2. Represent different action directions
3. Fit the steampunk style
4. Be in English
5. Separate the three options with "|"'''
            },
            {
              'role': 'user',
              'content': '''Current story: $currentStory
Location: $location

Please generate 3 action choices, separated by "|".'''
            }
          ],
          'stream': false,
          'temperature': 0.9,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        return content.split('|').map((e) => e.trim()).toList();
      } else {
        throw Exception('API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      return [
        'Carefully examine the surrounding mechanical devices',
        'Search for hidden passages or clues',
        'Interact with nearby automatons'
      ];
    }
  }
}