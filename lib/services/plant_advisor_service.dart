import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class PlantAdvisorService {
  static const String _apiKey =
      'sk-EXA446DTpMMWzFbOEJdOzia4AjKaynbVCAZCATT74bTDtUgL';
  static const String _baseUrl = 'https://api.kksj.org/v1/chat/completions';
  static const String _plantConsultationHistoryKey =
      'plant_consultation_history';
  final _uuid = const Uuid();

  final SharedPreferences _prefs;

  PlantAdvisorService(this._prefs);

  Future<List<ChatMessage>> getConsultationHistory() async {
    final String? jsonStr = _prefs.getString(_plantConsultationHistoryKey);
    if (jsonStr == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<void> saveConsultation(ChatMessage consultation) async {
    final consultations = await getConsultationHistory();
    consultations.add(consultation);

    final jsonStr = jsonEncode(consultations.map((m) => m.toJson()).toList());
    await _prefs.setString(_plantConsultationHistoryKey, jsonStr);
  }

  Future<ChatMessage> getPlantAdvice(String question) async {
    try {
      final userMessage = ChatMessage(
        id: _uuid.v4(),
        content: question,
        isUser: true,
        createdAt: DateTime.now(),
      );
      await saveConsultation(userMessage);

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': question,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        final content =
            responseData['choices'][0]['message']['content'] as String;

        final plantAdvice = ChatMessage(
          id: _uuid.v4(),
          content: content.trim(),
          isUser: false,
          createdAt: DateTime.now(),
        );

        await saveConsultation(plantAdvice);
        return plantAdvice;
      } else {
        throw Exception('Failed to get plant advice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting plant advice: $e');
      return ChatMessage(
        id: _uuid.v4(),
        content: '抱歉，我现在无法提供植物护理建议。请稍后再试。',
        isUser: false,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<void> clearConsultationHistory() async {
    await _prefs.remove(_plantConsultationHistoryKey);
  }
}
