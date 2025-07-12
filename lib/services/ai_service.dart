import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  final String _apiKey = 'sk-5a3a8ab1cec14e129e4a3a29becdad00';
  final String _apiUrl = 'https://api.deepseek.com/chat/completions';

  Future<String> getResponse(String userInput, {String? context}) async {
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $_apiKey',
    };

    final messages = [
      {"role": "system", "content": "You are a helpful assistant."},
      if (context != null && context.isNotEmpty)
        {"role": "system", "content": "Here is some context about the user from their journal entries:\n$context"},
      {"role": "user", "content": userInput}
    ];

    final body = jsonEncode({
      "model": "deepseek-chat",
      "messages": messages,
      "stream": false,
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse['choices'][0]['message']['content'];
      } else {
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}