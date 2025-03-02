import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class AIServiceLevelThree {
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';
  static const String _apiKey = 'sk-6cf107809b134e62b279d42d9c330105';
  static const String _model = 'deepseek-chat';

  static Future<List<Story>> generateStories(
      String chapterTitle, List<Story> initialStories,
      {required int count}) async {
    try {
      String storyBackground = '';
      String plotOutline = '';

      if (chapterTitle == "无字经书") {
        storyBackground = '''
这是西游记中无字经书的完整故事。需要生成10个后续剧情，按照以下阶段展开：

第1-3个剧情：无字经书初现
- 唐僧发现无字经书的秘密
- 孙悟空保护唐僧
- 其他妖怪试图夺取经书

第4-6个剧情：解读经书
- 唐僧与悟空共同解读经书
- 妖怪们的阴谋逐渐显露
- 唐僧面临选择

第7-10个剧情：最终决战
- 孙悟空与妖怪展开激烈战斗
- 经书的真正力量被揭示
- 最终唐僧成功保护经书
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕无字经书这个主线展开
6. 最终结局必须是唐僧成功保护经书
''';
      } else if (chapterTitle == "凌云渡") {
        storyBackground = '''
这是西游记中凌云渡的完整故事。需要生成8个后续剧情，按照以下阶段展开：

第1-2个剧情：凌云渡的挑战
- 师徒四人遇到凌云渡
- 孙悟空寻找渡过的方法

第3-4个剧情：渡过的考验
- 师徒们面临各种考验
- 孙悟空展现智慧

第5-6个剧情：团结一致
- 师徒们共同克服困难
- 最终成功渡过凌云

第7-8个剧情：新的冒险
- 渡过后遇到新的敌人
- 师徒们继续前行
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕凌云渡这个主线展开
6. 最终结局必须是成功渡过凌云
''';
      } else if (chapterTitle == "真经归唐") {
        storyBackground = '''
这是西游记中真经归唐的完整故事。需要生成10个后续剧情，按照以下阶段展开：

第1-3个剧情：真经的归属
- 唐僧与悟空讨论真经的意义
- 妖怪试图阻止真经归唐

第4-6个剧情：寻找真经
- 师徒们踏上寻找真经的旅程
- 遇到各种挑战和考验

第7-10个剧情：最终归唐
- 师徒们成功找到真经
- 共同抵御妖怪的攻击
- 最终将真经安全带回唐朝
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕真经归唐这个主线展开
6. 最终结局必须是将真经安全带回唐朝
''';
      }

      String prompt = '''
请根据西游记章节"$chapterTitle"，生成完整的连贯剧情。要求：

1. 严格按照原著主要情节发展脉络
2. 每个剧情必须包含三个选项，只有一个正确选项
3. 所有选项都要与当前剧情密切相关
4. 正确选项引导向原著发展方向
5. 错误选项虽合理但会导致偏离正确方向
6. 确保剧情连贯性，前后呼应
7. 正确选项的位置要随机（0-2之间）

已有剧情：
${initialStories.map((story) => '''
情节：${story.content}
选项：${story.options.join(' | ')}
正确选项：${story.options[story.correctOption]}
''').join('\n')}

故事背景：
$storyBackground

剧情要求：
$plotOutline

请生成后续剧情，每个剧情段落格式：
###
故事内容（具体的情节发展）
选项A|选项B|选项C（三个合理但不同的选择）
正确选项索引（0-2之间的随机数字）

注意：
1. 每个选项都要是当前情节的合理延续
2. 正确选项要推动故事向原著方向发展
3. 错误选项要看似合理但会导致偏离正确方向
4. 确保选项与当前剧情密切相关
5. 所有剧情必须围绕主线展开，直到完成降服
''';

      // 发送请求到 AI 接口
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': '你是一个精通西游记的故事创作专家，擅长创作符合原著的连贯剧情。'},
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final String content = data['choices'][0]['message']['content'];

        List<Story> generatedStories = [];
        final segments = content.split('###').where((s) => s.trim().isNotEmpty);

        for (var segment in segments) {
          final lines = segment
              .trim()
              .split('\n')
              .where((l) => l.trim().isNotEmpty)
              .toList();
          if (lines.length >= 3) {
            final storyContent = lines[0].trim();
            final options = lines[1].split('|').map((o) => o.trim()).toList();
            final correctOption = int.tryParse(lines[2]) ?? 0;

            if (options.length == 3) {
              generatedStories.add(Story(
                content: storyContent,
                options: options,
                correctOption: correctOption,
              ));
            }
          }
        }

        // 修改生成故事的补充逻辑
        while (generatedStories.length < count) {
          if (chapterTitle == "无字经书") {
            final phase = generatedStories.length;
            if (phase < 3) {
              // 初次交锋阶段的过渡剧情
              generatedStories.add(Story(
                content: "唐僧发现无字经书的秘密，孙悟空保护唐僧...",
                options: ["继续前行", "警惕其他妖怪", "接受经书的秘密"],
                correctOption: 1,
              ));
            } else if (phase < 6) {
              // 解读经书阶段的过渡剧情
              generatedStories.add(Story(
                content: "唐僧与悟空共同解读经书，妖怪们的阴谋逐渐显露...",
                options: ["继续解读", "试图阻止", "寻求帮助"],
                correctOption: 0,
              ));
            } else {
              // 最终决战阶段的过渡剧情
              generatedStories.add(Story(
                content: "最终，孙悟空与妖怪展开激烈战斗，经书的真正力量被揭示...",
                options: ["帮助悟空", "逃跑", "试图调解"],
                correctOption: 0,
              ));
            }
          } else if (chapterTitle == "凌云渡") {
            final phase = generatedStories.length;
            if (phase < 2) {
              // 凌云渡挑战阶段的过渡剧情
              generatedStories.add(Story(
                content: "师徒四人遇到凌云渡，孙悟空寻找渡过的方法...",
                options: ["寻找渡过方法", "直接冲过去", "退回去"],
                correctOption: 0,
              ));
            } else if (phase < 4) {
              // 渡过考验阶段的过渡剧情
              generatedStories.add(Story(
                content: "师徒们面临各种考验，孙悟空展现智慧...",
                options: ["展现智慧", "寻求帮助", "放弃"],
                correctOption: 0,
              ));
            } else {
              // 团结一致阶段的过渡剧情
              generatedStories.add(Story(
                content: "师徒们共同克服困难，最终成功渡过凌云...",
                options: ["庆祝胜利", "继续前行", "回顾经历"],
                correctOption: 0,
              ));
            }
          } else if (chapterTitle == "真经归唐") {
            final phase = generatedStories.length;
            if (phase < 3) {
              // 真经归属阶段的过渡剧情
              generatedStories.add(Story(
                content: "唐僧与悟空讨论真经的意义，妖怪试图阻止真经归唐...",
                options: ["继续讨论", "寻求帮助", "放弃"],
                correctOption: 0,
              ));
            } else if (phase < 6) {
              // 寻找真经阶段的过渡剧情
              generatedStories.add(Story(
                content: "师徒们踏上寻找真经的旅程，遇到各种挑战和考验...",
                options: ["继续寻找", "放弃", "寻求帮助"],
                correctOption: 0,
              ));
            } else {
              // 最终归唐阶段的过渡剧情
              generatedStories.add(Story(
                content: "师徒们成功找到真经，共同抵御妖怪的攻击...",
                options: ["继续保护", "放弃", "试图逃离"],
                correctOption: 0,
              ));
            }
          }
        }

        return generatedStories;
      } else {
        throw Exception('AI服务响应错误: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('生成故事失败: $e');
    }
  }

  static Future<Story> generateSingleStory(
    String chapterTitle,
    List<Story> initialStories,
    int currentIndex,
    int totalNeeded,
  ) async {
    try {
      // 构建更明确的提示，确保AI生成正确格式的响应
      String prompt = '''
请根据以下要求生成西游记章节"$chapterTitle"的一个剧情片段。

已有剧情：
${initialStories.map((story) => '''
- ${story.content}
  选项：${story.options.join(' | ')}
  正确选项：${story.options[story.correctOption]}
''').join('\n')}

要求：
1. 严格按照以下格式输出：
第一行：故事内容描述（50-100字）
第二行：三个选项，用|分隔
第三行：正确选项的索引（0-2之间的数字）

2. 故事内容要求：
- 必须是连贯的后续发展
- 情节要符合原著风格
- 避免重复前面的情节

3. 选项要求：
- 提供三个完全不同的选项
- 选项必须与当前故事情节直接相关
- 每个选项都要是对当前情况的合理反应
- 选项之间要有明显的区别
- 正确选项要推动故事向原著方向发展
- 禁止重复使用之前出现过的选项
- 每个选项的内容要具体且符合当前场景

示例格式：
悟空与白龙激战正酣，双方法力相当，一时难分胜负。
使用定身法术|寻找弱点突破|呼唤菩萨助阵
1

请生成一个全新的、独特的剧情片段：
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': '''你是一个精通西游记的故事创作专家。
你的任务是生成独特的故事片段，每个故事的选项都必须是全新的、与具体情节相关的。
确保：
1. 选项不能重复使用
2. 选项要与当前情节紧密相关
3. 三个选项要有明显区别
4. 选项要具体且符合场景'''
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.8, // 增加创造性
          'max_tokens': 500,
          'top_p': 0.95,
          'frequency_penalty': 0.8, // 增加以减少重复
          'presence_penalty': 0.8, // 增加以鼓励新内容
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final String content = data['choices'][0]['message']['content'];

        // 清理和解析内容
        final cleanContent = content.replaceAll('###', '').trim();
        final lines = cleanContent
            .split('\n')
            .where((l) => l.trim().isNotEmpty)
            .map((l) => l.trim())
            .toList();

        // 验证响应格式和内容
        if (lines.length >= 3) {
          final storyContent = lines[0];
          final options = lines[1].split('|').map((o) => o.trim()).toList();
          final correctOption = int.tryParse(lines[2]);

          // 验证内容的有效性
          if (storyContent.length >= 20 &&
              options.length == 3 &&
              correctOption != null &&
              correctOption >= 0 &&
              correctOption <= 2) {
            // 检查选项是否重复
            bool hasRepeatedOptions = false;
            for (var story in initialStories) {
              if (story.options.any((option) => options.contains(option))) {
                hasRepeatedOptions = true;
                break;
              }
            }

            if (!hasRepeatedOptions) {
              return Story(
                content: storyContent,
                options: options,
                correctOption: correctOption,
              );
            }
          }
        }

        // 如果生成的内容不符合要求，使用备用故事
        return generateDynamicFallbackStory(
            chapterTitle, currentIndex, initialStories);
      } else {
        throw Exception('AI服务响应错误: ${response.statusCode}');
      }
    } catch (e) {
      print('生成故事错误: $e');
      return generateDynamicFallbackStory(
          chapterTitle, currentIndex, initialStories);
    }
  }

  // 修改方法为公共静态方法
  static Story generateDynamicFallbackStory(
    String chapterTitle,
    int currentIndex,
    List<Story> previousStories,
  ) {
    if (chapterTitle == "无字经书") {
      final fallbackStories = [
        Story(
          content: "唐僧发现无字经书的秘密，孙悟空保护唐僧...",
          options: ["继续前行", "警惕其他妖怪", "接受经书的秘密"],
          correctOption: 1,
        ),
        Story(
          content: "唐僧与悟空共同解读经书，妖怪们的阴谋逐渐显露...",
          options: ["继续解读", "试图阻止", "寻求帮助"],
          correctOption: 0,
        ),
        Story(
          content: "最终，孙悟空与妖怪展开激烈战斗，经书的真正力量被揭示...",
          options: ["帮助悟空", "逃跑", "试图调解"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    } else if (chapterTitle == "凌云渡") {
      final fallbackStories = [
        Story(
          content: "师徒四人遇到凌云渡，孙悟空寻找渡过的方法...",
          options: ["寻找渡过方法", "直接冲过去", "退回去"],
          correctOption: 0,
        ),
        Story(
          content: "师徒们面临各种考验，孙悟空展现智慧...",
          options: ["展现智慧", "寻求帮助", "放弃"],
          correctOption: 0,
        ),
        Story(
          content: "师徒们共同克服困难，最终成功渡过凌云...",
          options: ["庆祝胜利", "继续前行", "回顾经历"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    } else {
      // 真经归唐
      final fallbackStories = [
        Story(
          content: "唐僧与悟空讨论真经的意义，妖怪试图阻止真经归唐...",
          options: ["继续讨论", "寻求帮助", "放弃"],
          correctOption: 0,
        ),
        Story(
          content: "师徒们踏上寻找真经的旅程，遇到各种挑战和考验...",
          options: ["继续寻找", "放弃", "寻求帮助"],
          correctOption: 0,
        ),
        Story(
          content: "师徒们成功找到真经，共同抵御妖怪的攻击...",
          options: ["继续保护", "放弃", "试图逃离"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    }
  }
}
