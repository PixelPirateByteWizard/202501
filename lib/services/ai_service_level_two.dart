import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class AIServiceLevelTwo {
  static const String _baseUrl = 'https://api.kksj.org/v1/chat/completions';
  static const String _apiKey =
      'sk-ybt88aCSRjgQ7CG3So1enrNvrRv8JnvJ4fwyW1H0135lxS06';
  static const String _model = 'gpt-4o-mini';

  static Future<List<Story>> generateStories(
      String chapterTitle, List<Story> initialStories,
      {required int count}) async {
    try {
      String storyBackground = '';
      String plotOutline = '';

      if (chapterTitle == "三打白骨精") {
        storyBackground = '''
这是西游记中唐僧师徒三打白骨精的完整故事。需要生成10个后续剧情，按照以下阶段展开：

第1-3个剧情：白骨精初现
- 白骨精化身美丽女子接近唐僧
- 孙悟空识破白骨精的伎俩
- 唐僧不信，误会悟空

第4-6个剧情：白骨精的阴谋
- 白骨精再次化身，企图诱惑唐僧
- 孙悟空再次出手
- 唐僧依然不信，反而责怪悟空

第7-10个剧情：最终决战
- 孙悟空与白骨精展开激烈战斗
- 白骨精显露真身
- 最终被悟空打败，唐僧明白真相
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕三打白骨精这个主线展开
6. 最终结局必须是白骨精被打败，唐僧明白真相
''';
      } else if (chapterTitle == "真假美猴王") {
        storyBackground = '''
这是西游记中真假美猴王的完整故事。需要生成8个后续剧情，按照以下阶段展开：

第1-2个剧情：真假美猴王初现
- 真假美猴王相互争斗
- 唐僧无法分辨真伪

第3-4个剧情：斗智斗勇
- 孙悟空设下圈套
- 真假美猴王展开较量

第5-6个剧情：真相大白
- 通过考验揭示真猴王
- 唐僧感慨悟空的智慧

第7-8个剧情：团结一致
- 真假美猴王的最终对决
- 共同抵御外敌
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕真假美猴王这个主线展开
6. 最终结局必须是揭示真相，团结一致
''';
      } else if (chapterTitle == "勇闯火焰山") {
        storyBackground = '''
这是西游记中唐僧师徒勇闯火焰山的完整故事。需要生成10个后续剧情，按照以下阶段展开：

第1-3个剧情：火焰山的挑战
- 师徒四人遇到火焰山
- 孙悟空寻找解决办法
- 唐僧担心前路艰险

第4-6个剧情：借扇之计
- 孙悟空寻找铁扇公主
- 经过一番波折获得芭蕉扇
- 师徒齐心协力应对火焰

第7-10个剧情：成功渡过
- 使用芭蕉扇扑灭火焰
- 师徒团结一致，克服困难
- 最终顺利通过火焰山
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕勇闯火焰山这个主线展开
6. 最终结局必须是成功渡过火焰山
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
          if (chapterTitle == "三打白骨精") {
            final phase = generatedStories.length;
            if (phase < 3) {
              // 初次交锋阶段的过渡剧情
              generatedStories.add(Story(
                content: "白骨精化身美丽女子接近唐僧，试图迷惑他...",
                options: ["继续前行", "警惕孙悟空", "接受她的接近"],
                correctOption: 1,
              ));
            } else if (phase < 6) {
              // 白骨精的阴谋阶段的过渡剧情
              generatedStories.add(Story(
                content: "孙悟空识破了白骨精的伎俩，准备出手...",
                options: ["直接攻击", "寻找证据", "保护唐僧"],
                correctOption: 0,
              ));
            } else {
              // 最终决战阶段的过渡剧情
              generatedStories.add(Story(
                content: "最终，孙悟空与白骨精展开激烈战斗...",
                options: ["帮助悟空", "逃跑", "试图调解"],
                correctOption: 0,
              ));
            }
          } else if (chapterTitle == "真假美猴王") {
            final phase = generatedStories.length;
            if (phase < 2) {
              // 真假美猴王初现阶段的过渡剧情
              generatedStories.add(Story(
                content: "真假美猴王相互争斗，唐僧无法分辨真伪...",
                options: ["询问真相", "保持沉默", "支持悟空"],
                correctOption: 2,
              ));
            } else if (phase < 4) {
              // 斗智斗勇阶段的过渡剧情
              generatedStories.add(Story(
                content: "孙悟空设下圈套，试图揭示真猴王...",
                options: ["继续设圈套", "直接对抗", "请求帮助"],
                correctOption: 0,
              ));
            } else {
              // 团结一致阶段的过渡剧情
              generatedStories.add(Story(
                content: "经过考验，唐僧终于识别出真猴王...",
                options: ["团结一致", "继续争斗", "逃避"],
                correctOption: 0,
              ));
            }
          } else if (chapterTitle == "勇闯火焰山") {
            final phase = generatedStories.length;
            if (phase < 3) {
              // 火焰山的挑战阶段的过渡剧情
              generatedStories.add(Story(
                content: "师徒四人遇到火焰山，面临巨大的挑战...",
                options: ["寻找解决办法", "直接冲过去", "退回去"],
                correctOption: 0,
              ));
            } else if (phase < 6) {
              // 借扇之计阶段的过渡剧情
              generatedStories.add(Story(
                content: "孙悟空寻找铁扇公主，经过一番波折...",
                options: ["继续寻找", "放弃", "请求帮助"],
                correctOption: 0,
              ));
            } else {
              // 成功渡过阶段的过渡剧情
              generatedStories.add(Story(
                content: "使用芭蕉扇扑灭火焰，师徒齐心协力...",
                options: ["庆祝胜利", "继续前行", "回顾经历"],
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
    if (chapterTitle == "三打白骨精") {
      final fallbackStories = [
        Story(
          content: "白骨精化身美丽女子，试图接近唐僧...",
          options: ["继续前行", "警惕孙悟空", "接受她的接近"],
          correctOption: 1,
        ),
        Story(
          content: "孙悟空识破白骨精的伎俩，准备出手...",
          options: ["直接攻击", "寻找证据", "保护唐僧"],
          correctOption: 0,
        ),
        Story(
          content: "最终，孙悟空与白骨精展开激烈战斗...",
          options: ["帮助悟空", "逃跑", "试图调解"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    } else if (chapterTitle == "真假美猴王") {
      final fallbackStories = [
        Story(
          content: "真假美猴王相互争斗，唐僧无法分辨真伪...",
          options: ["询问真相", "保持沉默", "支持悟空"],
          correctOption: 2,
        ),
        Story(
          content: "孙悟空设下圈套，试图揭示真猴王...",
          options: ["继续设圈套", "直接对抗", "请求帮助"],
          correctOption: 0,
        ),
        Story(
          content: "经过考验，唐僧终于识别出真猴王...",
          options: ["团结一致", "继续争斗", "逃避"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    } else {
      // 勇闯火焰山
      final fallbackStories = [
        Story(
          content: "师徒四人遇到火焰山，面临巨大的挑战...",
          options: ["寻找解决办法", "直接冲过去", "退回去"],
          correctOption: 0,
        ),
        Story(
          content: "孙悟空寻找铁扇公主，经过一番波折...",
          options: ["继续寻找", "放弃", "请求帮助"],
          correctOption: 0,
        ),
        Story(
          content: "使用芭蕉扇扑灭火焰，师徒齐心协力...",
          options: ["庆祝胜利", "继续前行", "回顾经历"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    }
  }
}
