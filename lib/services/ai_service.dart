import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class AIService {
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

      if (chapterTitle == "鹰愁涧收白龙") {
        storyBackground = '''
这是西游记中唐僧师徒在鹰愁涧收服白龙的完整故事。需要生成10个后续剧情，按照以下阶段展开：

第1-3个剧情：孙悟空与白龙的初次交锋
- 发现白龙吃了白马的真相
- 初步交手
- 了解白龙的来历

第4-6个剧情：激烈战斗阶段
- 孙悟空施展七十二变
- 白龙展现真身
- 双方斗法高潮

第7-8个剧情：观音菩萨点化
- 菩萨现身说法
- 点明因果前世

第9-10个剧情：结局圆满
- 白龙悔悟
- 最终化为白马，随师西行

要求每个剧情都要给出三个选项，正确选项要推动故事向结局发展。
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕降服白龙这个主线展开
6. 最终结局必须是白龙被降服，化作白马随唐僧西行
''';
      } else if (chapterTitle == "高老庄降八戒") {
        storyBackground = '''
这是西游记中收服猪八戒的完整故事。需要生成8个后续剧情，按照以下阶段展开：

第1-2个剧情：调查真相
- 了解猪八戒在高老庄的所作所为
- 发现其天蓬元帅身份

第3-4个剧情：激战阶段
- 孙悟空与猪八戒交手
- 展示双方实力

第5-6个剧情：点化阶段
- 点明前世因果
- 说服猪八戒回头

第7-8个剧情：圆满收服
- 猪八戒醒悟
- 拜别高小姐，随师西行

要求每个剧情都要给出三个选项，正确选项要推动故事向结局发展。
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕降服猪八戒这个主线展开
6. 最终结局必须是猪八戒被降服，皈依佛门随唐僧西行
''';
      } else if (chapterTitle == "流沙河伏悟净") {
        storyBackground = '''
这是西游记中收服沙和尚的完整故事。需要生成13个后续剧情，按照以下阶段展开：

第1-3个剧情：初遇阶段
- 发现流沙河异常
- 调查妖怪来历
- 确认卷帘大将身份

第4-6个剧情：第一轮交锋
- 初步交手
- 了解实力
- 战斗升级

第7-9个剧情：激烈战斗
- 全力交战
- 展示神通
- 战斗高潮

第10-11个剧情：点化阶段
- 点明身世因果
- 说服教化

第12-13个剧情：圆满结局
- 沙和尚醒悟
- 皈依佛门，随师西行

要求每个剧情都要给出三个选项，正确选项要推动故事向结局发展。
''';
        plotOutline = '''
请按照以下要求生成剧情：
1. 每个剧情节点都要给出三个选项，其中只有一个是正确的
2. 错误的选项要合理，但会导致剧情偏离正确方向
3. 正确的选项要推动剧情向原著方向发展
4. 选项要与当前剧情密切相关
5. 所有剧情要围绕降服沙和尚这个主线展开
6. 最终结局必须是沙和尚被降服，皈依佛门随唐僧西行
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
          if (chapterTitle == "鹰愁涧收白龙") {
            final phase = generatedStories.length;
            if (phase < 3) {
              // 初次交锋阶段的过渡剧情
              generatedStories.add(Story(
                content: "白龙与悟空战斗正酣，双方你来我往...",
                options: ["继续强攻", "寻找弱点", "改变策略"],
                correctOption: 1,
              ));
            } else if (phase < 6) {
              // 激烈战斗阶段的过渡剧情
              generatedStories.add(Story(
                content: "战斗愈发激烈，白龙施展出更强大的水系法术...",
                options: ["硬拼法力", "智取取胜", "呼唤援助"],
                correctOption: 1,
              ));
            } else {
              // 结局阶段的过渡剧情
              generatedStories.add(Story(
                content: "在观音菩萨的点化下，白龙渐渐明白了自己的过错...",
                options: ["继续抗争", "诚心悔过", "逃之夭夭"],
                correctOption: 1,
              ));
            }
          } else if (chapterTitle == "高老庄降八戒") {
            final phase = generatedStories.length;
            if (phase < 2) {
              // 调查真相阶段的过渡剧情
              generatedStories.add(Story(
                content: "猪八戒在高老庄的生活被孙悟空发现...",
                options: ["了解真相", "隐瞒事实", "逃避调查"],
                correctOption: 0,
              ));
            } else if (phase < 4) {
              // 激战阶段的过渡剧情
              generatedStories.add(Story(
                content: "孙悟空与猪八戒在高老庄展开激战...",
                options: ["全力战斗", "智取胜利", "呼唤观音"],
                correctOption: 0,
              ));
            } else if (phase < 6) {
              // 点化阶段的过渡剧情
              generatedStories.add(Story(
                content: "在点化阶段，猪八戒开始反思自己的行为...",
                options: ["诚心悔过", "继续逃避", "寻求帮助"],
                correctOption: 0,
              ));
            } else {
              // 圆满收服阶段的过渡剧情
              generatedStories.add(Story(
                content: "猪八戒终于醒悟，决定皈依佛门，随唐僧西行...",
                options: ["接受点化", "继续逃避", "寻求帮助"],
                correctOption: 0,
              ));
            }
          } else if (chapterTitle == "流沙河伏悟净") {
            final phase = generatedStories.length;
            if (phase < 3) {
              // 初遇阶段的过渡剧情
              generatedStories.add(Story(
                content: "沙和尚在流沙河中与唐僧师徒初次相遇...",
                options: ["调查妖怪", "展示善意", "直接战斗"],
                correctOption: 0,
              ));
            } else if (phase < 6) {
              // 第一轮交锋阶段的过渡剧情
              generatedStories.add(Story(
                content: "沙和尚与唐僧师徒在流沙河中展开第一轮战斗...",
                options: ["全力战斗", "智取胜利", "呼唤观音"],
                correctOption: 0,
              ));
            } else if (phase < 9) {
              // 激烈战斗阶段的过渡剧情
              generatedStories.add(Story(
                content: "战斗愈发激烈，沙和尚展现出了更强大的力量...",
                options: ["全力战斗", "智取胜利", "呼唤观音"],
                correctOption: 0,
              ));
            } else if (phase < 11) {
              // 点化阶段的过渡剧情
              generatedStories.add(Story(
                content: "在点化阶段，沙和尚开始反思自己的行为...",
                options: ["诚心悔过", "继续逃避", "寻求帮助"],
                correctOption: 0,
              ));
            } else {
              // 圆满结局阶段的过渡剧情
              generatedStories.add(Story(
                content: "沙和尚终于醒悟，决定皈依佛门，随唐僧西行...",
                options: ["接受点化", "继续逃避", "寻求帮助"],
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
    if (chapterTitle == "鹰愁涧收白龙") {
      final fallbackStories = [
        Story(
          content: "白龙见观音菩萨现身，顿时收敛了水势，但眼中仍带着几分不甘。",
          options: ["请菩萨做主", "主动认错", "保持沉默"],
          correctOption: 1,
        ),
        Story(
          content: "观音菩萨道出白龙前世今生，并指出一条重返天庭的路：'若能保唐僧西行，便是你的机缘。'",
          options: ["立即接受", "询问细节", "思考权衡"],
          correctOption: 2,
        ),
        Story(
          content: "白龙思索片刻，对唐僧道：'若蒙收留，愿化作白马，以报师父大恩。'",
          options: ["欣然应允", "考验真心", "商议对策"],
          correctOption: 0,
        ),
        Story(
          content: "观音菩萨见白龙诚心悔过，便取出一副金羁玉辔，为白龙装扮。",
          options: ["感恩戴德", "请教使用", "默默领受"],
          correctOption: 0,
        ),
        Story(
          content: "白龙化作白马，温顺地来到唐僧身边，眼中再无往日的傲气。",
          options: ["抚摸鼓励", "试骑一番", "检查法器"],
          correctOption: 0,
        ),
        Story(
          content: "悟空见白龙已然归服，笑道：'师父，这白马可比那条恶龙强多了。'",
          options: ["斥责悟空", "赞同附和", "和谐相处"],
          correctOption: 2,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    } else if (chapterTitle == "高老庄降八戒") {
      final fallbackStories = [
        Story(
          content: "猪八戒闻言大惊：'你怎知我是天蓬元帅？'悟空笑道：'我还知道你因何被贬下凡。'",
          options: ["恼羞成怒", "虚心求教", "狡辩搪塞"],
          correctOption: 1,
        ),
        Story(
          content: "悟空将天蓬元帅调戏嫦娥的往事道来，猪八戒听后神色黯然，酒意顿消。",
          options: ["恼怒反驳", "追忆往事", "寻求解脱"],
          correctOption: 2,
        ),
        Story(
          content: "唐僧闻讯赶来，见猪八戒已有悔意，便开导道：'放下执念，随我西行如何？'",
          options: ["立即拜师", "询问因果", "提出条件"],
          correctOption: 0,
        ),
        Story(
          content: "猪八戒跪地叩首：'若师父不嫌弃，弟子愿随师父西天取经。'",
          options: ["收徒点化", "考验诚意", "商议细节"],
          correctOption: 0,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    } else {
      // 流沙河伏悟净
      final fallbackStories = [
        Story(
          content: "沙和尚听闻自己是卷帘大将转世，不禁回想起昔日在天庭的荣光岁月。",
          options: ["否认身份", "追问往事", "流露悔意"],
          correctOption: 2,
        ),
        Story(
          content: "八戒上前劝道：'老沙，我们都是天庭旧部，何不同去西天取经？'",
          options: ["冷言讽刺", "动容倾听", "犹豫不决"],
          correctOption: 1,
        ),
        Story(
          content: "唐僧见沙和尚有了回心转意之意，便道：'既是天庭旧将，何不重归正道？'",
          options: ["叩首拜师", "询问前程", "默默点头"],
          correctOption: 0,
        ),
        Story(
          content: "沙和尚终于放下执念：'弟子愿随师父西行，重归正道。'",
          options: ["立即上路", "整装待发", "告别河神"],
          correctOption: 1,
        ),
        Story(
          content: "悟空笑道：'如此一来，我们师兄弟就都齐了。'",
          options: ["互相认亲", "商议前程", "准备启程"],
          correctOption: 2,
        ),
        Story(
          content: "唐僧欣慰地看着三个徒弟，心想这西天取经的队伍总算是完整了。",
          options: ["训诫徒众", "分派职责", "启程西行"],
          correctOption: 2,
        ),
      ];
      return fallbackStories[currentIndex % fallbackStories.length];
    }
  }
}
