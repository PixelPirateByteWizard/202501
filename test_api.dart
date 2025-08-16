// 这是一个简单的API测试文件，用于验证DeepSeek API集成
// 在实际项目中，您可以运行这个测试来验证API是否正常工作

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const apiUrl = 'https://api.deepseek.com/chat/completions';
  const apiKey = 'sk-8e3c046d1446452199b020a5bd08e2e7';
  
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': 'Hello!'},
        ],
        'stream': false,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print('API测试成功！');
      print('响应: ${data['choices'][0]['message']['content']}');
    } else {
      print('API测试失败: ${response.statusCode}');
      print('错误信息: ${response.body}');
    }
  } catch (e) {
    print('API测试异常: $e');
  }
}