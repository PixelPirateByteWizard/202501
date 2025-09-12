import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'sk-8e3c046d1446452199b020a5bd08e2e7';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';
  
  // 生成剧情文本
  static Future<String> generateStoryText({
    required String context,
    required String playerChoice,
    required List<String> availableGenerals,
    String style = '演义风格',
    int maxLength = 180,
  }) async {
    try {
      final prompt = _buildStoryPrompt(
        context: context,
        playerChoice: playerChoice,
        availableGenerals: availableGenerals,
        style: style,
        maxLength: maxLength,
      );

      final response = await _makeAPICall(prompt);
      return response ?? _getFallbackStoryText(context, playerChoice);
    } catch (e) {
      print('AI Service Error: $e');
      return _getFallbackStoryText(context, playerChoice);
    }
  }

  // 生成战斗报告
  static Future<List<String>> generateBattleReport({
    required String attackerName,
    required String defenderName,
    required String action,
    required bool isSuccess,
    required bool isCritical,
    String style = '演义风格',
  }) async {
    try {
      final prompt = _buildBattlePrompt(
        attackerName: attackerName,
        defenderName: defenderName,
        action: action,
        isSuccess: isSuccess,
        isCritical: isCritical,
        style: style,
      );

      final response = await _makeAPICall(prompt);
      if (response != null) {
        return response.split('\n').where((line) => line.trim().isNotEmpty).toList();
      }
      
      return _getFallbackBattleReport(attackerName, defenderName, action, isSuccess, isCritical);
    } catch (e) {
      print('AI Service Error: $e');
      return _getFallbackBattleReport(attackerName, defenderName, action, isSuccess, isCritical);
    }
  }

  // 生成武将传记
  static Future<String> generateGeneralBiography({
    required String generalName,
    required List<String> recentAchievements,
    String style = '演义风格',
  }) async {
    try {
      final prompt = _buildBiographyPrompt(
        generalName: generalName,
        recentAchievements: recentAchievements,
        style: style,
      );

      final response = await _makeAPICall(prompt);
      return response ?? _getFallbackBiography(generalName);
    } catch (e) {
      print('AI Service Error: $e');
      return _getFallbackBiography(generalName);
    }
  }

  // 构建剧情提示词
  static String _buildStoryPrompt({
    required String context,
    required String playerChoice,
    required List<String> availableGenerals,
    required String style,
    required int maxLength,
  }) {
    return '''你是一位三国史官，语言风格为$style，请根据以下信息续写剧情：

背景：$context
玩家选择：$playerChoice
可用武将：${availableGenerals.join('、')}

要求：
1. 字数不超过$maxLength字
2. 语言要有文学性和代入感
3. 至少提及一位可用武将
4. 为下一步行动埋下伏笔
5. 符合三国历史背景

请直接输出剧情文本，不要添加其他说明：''';
  }

  // 构建战斗提示词
  static String _buildBattlePrompt({
    required String attackerName,
    required String defenderName,
    required String action,
    required bool isSuccess,
    required bool isCritical,
    required String style,
  }) {
    final result = isSuccess ? '成功' : '失败';
    final critical = isCritical ? '，触发暴击效果' : '';
    
    return '''你是一位三国战场史官，语言风格为$style，请描述以下战斗场面：

攻击者：$attackerName
防御者：$defenderName
行动：$action
结果：$result$critical

要求：
1. 生成3行战报，每行不超过30字
2. 第一行描述攻击动作
3. 第二行描述战斗过程
4. 第三行描述结果和影响
5. 语言要有画面感和节奏感

请直接输出战报，每行用换行符分隔：''';
  }

  // 构建传记提示词
  static String _buildBiographyPrompt({
    required String generalName,
    required List<String> recentAchievements,
    required String style,
  }) {
    return '''你是一位三国史官，语言风格为$style，请为武将$generalName撰写传记片段：

近期战功：${recentAchievements.join('、')}

要求：
1. 字数50字以内
2. 结合历史背景和近期表现
3. 语言要有史书的庄重感
4. 突出武将特色

请直接输出传记文本：''';
  }

  // 调用API
  static Future<String?> _makeAPICall(String prompt) async {
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
            {'role': 'user', 'content': prompt}
          ],
          'stream': false,
          'max_tokens': 200,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }

  // 备用剧情文本
  static String _getFallbackStoryText(String context, String playerChoice) {
    final fallbacks = [
      '战鼓声声，将士们严阵以待。你的决策将决定这场战役的走向。',
      '风云变幻，英雄辈出。在这乱世之中，唯有智勇双全者方能立足。',
      '兵贵神速，机不可失。此时此刻，正是展现谋略的关键时刻。',
      '天下大势，分久必合，合久必分。你的选择将影响历史的进程。',
    ];
    return fallbacks[Random().nextInt(fallbacks.length)];
  }

  // 备用战斗报告
  static List<String> _getFallbackBattleReport(
    String attackerName,
    String defenderName,
    String action,
    bool isSuccess,
    bool isCritical,
  ) {
    if (isSuccess) {
      if (isCritical) {
        return [
          '$attackerName大喝一声，施展$action！',
          '招式精妙绝伦，$defenderName措手不及！',
          '暴击生效，$defenderName损失惨重！',
        ];
      } else {
        return [
          '$attackerName挥兵向前，发动$action！',
          '攻势如潮，$defenderName节节败退！',
          '此招奏效，我军士气大振！',
        ];
      }
    } else {
      return [
        '$attackerName试图施展$action！',
        '$defenderName早有防备，巧妙化解！',
        '攻击落空，战局依然胶着！',
      ];
    }
  }

  // 备用传记
  static String _getFallbackBiography(String generalName) {
    final fallbacks = {
      '关羽': '义薄云天，武勇无双，温酒斩华雄，过五关斩六将，威震华夏。',
      '张辽': '勇冠三军，智勇双全，逍遥津一战成名，令江东闻风丧胆。',
      '郭嘉': '才思敏捷，料事如神，为曹公运筹帷幄，决胜千里之外。',
      '赵云': '一身是胆，忠心耿耿，长坂坡七进七出，护主心切。',
      '黄忠': '老当益壮，百步穿杨，定军山斩夏侯渊，威名远扬。',
    };
    return fallbacks[generalName] ?? '$generalName英勇善战，忠义无双，乃当世之英杰也。';
  }
}