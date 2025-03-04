import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class AIService {
  static const String _baseUrl = 'https://api.kksj.org/v1/chat/completions';
  static const String _apiKey =
      'sk-ybt88aCSRjgQ7CG3So1enrNvrRv8JnvJ4fwyW1H0135lxS06';
  static const String _model = 'gpt-4o-mini';

  static Future<Story> generateSingleStory(
    String chapterTitle,
    List<Story> previousStories,
    int currentIndex,
    int totalNeeded,
  ) async {
    try {
      // 构建上下文信息
      String context = '''
当前章节：$chapterTitle
已发生的剧情：
${_buildStoryContext(previousStories)}
当前进度：$currentIndex / $totalNeeded
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: utf8.encode(jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': '''
你是一个西游记剧情设计专家。根据已有剧情，生成新的故事情节和三个选项。
要求：
1. 故事要符合西游记的风格和主题
2. 每个选项都要合理，但只有一个是最佳选择
3. 故事要有连贯性和趣味性
4. 选项要有策略性，考验玩家的判断
输出格式：
{
  "content": "故事内容",
  "options": ["选项1", "选项2", "选项3"],
  "correctOption": 正确选项的索引(0-2)
}
'''
            },
            {'role': 'user', 'content': context}
          ],
          'temperature': 0.8,
        })),
      );

      if (response.statusCode == 200) {
        // 使用 utf8.decode 解析响应内容
        final responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        final contentStr = data['choices'][0]['message']['content'];

        // 确保 content 也使用 utf8 解析
        final content = jsonDecode(contentStr);

        return Story(
          content: content['content'],
          options: List<String>.from(content['options']),
          correctOption: content['correctOption'],
        );
      } else {
        throw Exception(
            'Failed to generate story: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('Error generating story: $e');
      // 当API调用失败时，使用动态生成的故事
      return generateDynamicFallbackStory(
          chapterTitle, currentIndex, previousStories);
    }
  }

  static String _buildStoryContext(List<Story> stories) {
    return stories.map((story) => '''
情节：${story.content}
选项：${story.options.join(' | ')}
正确选择：${story.options[story.correctOption]}
''').join('\n');
  }

  static Story generateDynamicFallbackStory(
    String chapterTitle,
    int index,
    List<Story> previousStories,
  ) {
    // 根据前文生成相关的故事
    final lastStory = previousStories.isNotEmpty ? previousStories.last : null;

    return Story(
      content: "继续着西行的旅程，${lastStory?.content ?? '师徒几人'}遇到了新的挑战...",
      options: ["静观其变", "请教悟空", "寻找援助"],
      correctOption: 1,
    );
  }
}
