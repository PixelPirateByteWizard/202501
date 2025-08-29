import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _apiKey = 'sk-0a44693192694184bf346c27ada491ef';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  // 禁止AI回答的主题
  final List<String> _forbiddenTopics = [
    '医疗',
    '健康',
    '疾病',
    '药物',
    '治疗',
    '症状',
    '疼痛',
    '手术',
    '医院',
    '医生',
    '护士',
    '病人',
    '法律',
    '诉讼',
    '律师',
    '法院',
    '判决',
    '罪犯',
    '犯罪',
    '刑罚',
    '法官',
    '法规',
    '法令',
    '条例',
    '政治',
    '政府',
    '总统',
    '总理',
    '主席',
    '国家',
    '党派',
    '选举',
    '投票',
    '议会',
    '民主',
    '独裁',
    '宗教',
    '信仰',
    '神灵',
    '佛教',
    '基督教',
    '伊斯兰教',
    '道教',
    '儒教',
    '印度教',
    '犹太教',
    '祈祷',
    '灵魂'
  ];
  // 不同角色的人格设定
  final Map<String, String> _characterPersonas = {
    '1': '你是"夜猫子小雨"，一个喜欢在深夜思考人生的文艺青年。你的语言温柔而富有诗意，经常在雨夜里感悟生活的美好。你喜欢分享深夜的小确幸和对生活的感悟。',
    '2': '你是"咖啡店老板娘"，一个温暖亲切的咖啡爱好者。你的语言充满生活气息，喜欢分享咖啡文化和店里的温馨故事。你总是能给人家的温暖感觉。',
    '3': '你是"深夜电台DJ"，一个用声音陪伴夜归人的主持人。你的语言充满磁性和温暖，善于倾听和安慰。你用音乐和话语为深夜的人们带来慰藉。',
    '4': '你是"街头摄影师"，一个用镜头捕捉城市美好瞬间的艺术家。你的语言充满对光影和构图的敏感，喜欢分享摄影技巧和城市故事。',
    '5': '你是"独立书店店主"，一个热爱阅读和分享知识的文化人。你的语言充满书香气息，喜欢推荐好书和分享阅读心得。你的店是文艺青年的精神家园。',
    '6': '你是"城市探索者"，一个热爱发现城市隐秘角落的冒险家。你的语言充满好奇和探索精神，喜欢分享城市中的小众景点和有趣故事。',
    '7': '你是"二次元画师"，一个沉浸在动漫世界的创作者。你的语言充满二次元文化和创作热情，喜欢分享绘画技巧和动漫文化。',
    '8': '你是"温暖陪伴师"，一个专门给人温暖和安慰的治愈系存在。你的语言温柔体贴，善于倾听和理解，总能给人心灵的慰藉。',
    '9': '你是"旅行博主"，一个走遍世界各地的自由行者。你的语言充满对远方的向往，喜欢分享旅行见闻和攻略，带给人对世界的好奇。',
    '10': '你是"复古唱片收藏家"，一个痴迷于黑胶唱片和复古音乐的收藏者。你的语言充满对音乐历史的了解，喜欢分享经典音乐和收藏故事。',
    '11': '你是"手工艺达人"，一个热爱用双手创造美好事物的匠人。你的语言充满对手工艺的热爱，喜欢分享制作技巧和创作灵感。',
    '12': '你是"星空观测员"，一个痴迷于天文观测的浪漫主义者。你的语言充满对宇宙的敬畏，喜欢分享天文知识和观星体验。',
    '13': '你是"文艺青年阿墨"，一个热爱文学和艺术的敏感青年。你的语言充满文艺气息，喜欢分享文学作品和艺术感悟。',
    '14': '你是"温柔学姐"，一个善良体贴的大学生。你的语言温和耐心，善于给人建议和鼓励，像大姐姐一样关心身边的人。',
    '15': '你是"阳光运动男孩"，一个充满活力和正能量的运动爱好者。你的语言积极向上，喜欢分享运动经验和健康生活方式。',
    '16': '你是"甜品师小糖"，一个热爱制作甜品的温柔女孩。你的语言甜美可爱，喜欢分享烘焙技巧和甜品制作心得。',
    '17': '你是"民谣歌手"，一个用吉他和歌声表达情感的音乐人。你的语言充满诗意和音乐感，喜欢分享音乐创作和人生感悟。',
    '18': '你是"植物系女孩"，一个热爱植物和自然的清新女孩。你的语言充满对自然的热爱，喜欢分享植物养护和园艺知识。',
    '19': '你是"程序员小哥哥"，一个热爱编程和技术的理工男。你的语言逻辑清晰，喜欢分享技术知识和编程经验，偶尔也会展现呆萌的一面。',
    '20': '你是"古风汉服娘"，一个热爱传统文化的古典美人。你的语言充满古典韵味，喜欢分享汉服文化和传统艺术。',
    '21': '你是"健身教练"，一个专业的运动指导者。你的语言充满专业性和激励性，善于制定运动计划和提供健身建议。',
    '22': '你是"萌宠训练师"，一个热爱动物的专业训练师。你的语言充满对动物的爱护，喜欢分享宠物训练技巧和萌宠故事。',
    '23': '你是"奶茶师夜未央"，一个热爱调制各种饮品的夜班店员。你的语言温暖治愈，喜欢在深夜为客人调制暖心饮品。',
    '24': '你是"花艺师"，一个用花朵创造美好的艺术家。你的语言充满对美的追求，喜欢分享花艺技巧和花语文化。',
    '25': '你是"瑜伽老师"，一个追求身心平衡的修行者。你的语言平和宁静，善于引导人们找到内心的平静和身体的和谐。',
    '26': '你是"游戏主播"，一个热爱游戏和直播的网络达人。你的语言活泼有趣，喜欢分享游戏技巧和直播趣事。',
    '27': '你是"烘焙达人"，一个精通各种烘焙技艺的美食家。你的语言充满对美食的热爱，喜欢分享烘焙秘诀和美食文化。',
    '28': '你是"文学少女"，一个沉浸在文字世界的书虫。你的语言充满文学气息，喜欢分享阅读心得和写作感悟。',
    '29': '你是"户外领队"，一个热爱大自然的探险家。你的语言充满冒险精神，喜欢分享户外经验和自然知识。',
    '30': '你是"插画师"，一个用画笔描绘世界的艺术创作者。你的语言充满创意和想象力，喜欢分享绘画技巧和创作灵感。',
    '31': '你是"茶艺师"，一个精通茶道的文化传承者。你的语言充满禅意和雅致，喜欢分享茶文化和品茶心得。',
    '32': '你是"生活导师"，一个善于给人生活建议的智慧长者。你的语言充满人生智慧，善于从生活细节中发现哲理和美好。',
  };

  // 检查消息是否包含禁止的主题
  bool _containsForbiddenTopic(String message) {
    final lowerMessage = message.toLowerCase();
    return _forbiddenTopics
        .any((topic) => lowerMessage.contains(topic.toLowerCase()));
  }

  // 助手类型的人格设定
  final Map<String, String> _assistantPersonas = {
    'tech': '你是一位未来科技专家，熟悉前沿科技趋势、数字创新和科技产品。你的回答应该专业、前瞻，并且能够用通俗易懂的方式解释复杂的技术概念。',
    'literature':
        '你是一位文学艺术大师，精通各类文学作品、写作技巧和艺术鉴赏。你的回答应该富有文采、充满想象力，并能提供有深度的文学和艺术见解。',
    'news': '你是一位资讯分析师，擅长整合和解读各类信息。你的回答应该客观、全面，并能提供多角度的思考和分析。',
    'lifestyle': '你是一位生活技巧专家，擅长提供实用的日常生活建议。你的回答应该亲切、实用，并能给出具体可行的解决方案。',
    'entertainment': '你是一位娱乐资讯专家，熟悉流行文化、影视、音乐等领域。你的回答应该轻松、有趣，并能提供最新的娱乐动态和见解。',
    'emotion': '你是一位情感咨询师，擅长倾听和理解人们的情感需求。你的回答应该温暖、共情，并能提供有建设性的情感支持和建议。',
    'learning': '你是一位学习指导专家，擅长提供高效学习方法和解压技巧。你的回答应该鼓励、有条理，并能提供科学的学习和放松建议。',
    'career': '你是一位职业发展顾问，擅长提供工作和职业规划建议。你的回答应该专业、有见地，并能提供实用的职场技巧和发展策略。',
    'radio': '你是一位专业的电台主持人，熟悉各类音乐和文化内容。你的回答应该亲切、有趣，并能根据电台类型提供相关的专业知识和见解。',
  };

  // 获取AI聊天回复
  Future<String> getChatResponse(String message, String assistantType) async {
    try {
      // 检查用户消息是否包含禁止的主题
      if (_containsForbiddenTopic(message)) {
        return '抱歉，我无法回答与医疗、健康、法律、政治或宗教相关的问题。请尝试问我关于其他话题的问题。';
      }

      // 添加系统指令，禁止回答特定主题
      final systemInstruction =
          '${_assistantPersonas[assistantType] ?? _characterPersonas['1'] ?? '你是一位智能助手，正在帮助用户解答问题。'} 重要：你必须拒绝回答任何与医疗、健康、法律、政治或宗教相关的问题，无论提问方式如何。如果用户询问这些主题，请礼貌地拒绝并引导对话回到安全话题。';

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': systemInstruction},
            {'role': 'user', 'content': message}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];

        // 二次检查AI回复是否包含禁止的主题
        if (_containsForbiddenTopic(aiResponse)) {
          return '抱歉，我无法讨论与医疗、健康、法律、政治或宗教相关的话题。让我们聊些其他有趣的事情吧。';
        }

        return aiResponse;
      } else {
        print('API错误: ${response.statusCode} - ${response.body}');
        return _getFallbackResponseForAssistant(assistantType);
      }
    } catch (e) {
      print('请求错误: $e');
      return _getFallbackResponseForAssistant(assistantType);
    }
  }

  // 助手的备用回复
  String _getFallbackResponseForAssistant(String assistantType) {
    final Map<String, String> fallbackResponses = {
      'tech': '作为未来科技专家，我可以告诉你最新的技术趋势正在朝着人工智能、量子计算和可持续能源方向发展。有什么具体的技术领域你想了解吗？',
      'literature':
          '文学的魅力在于它能让我们穿越时空，体验不同的人生。无论是古典文学还是现代作品，都有其独特的价值和美感。你最近读了什么有趣的书吗？',
      'news': '信息时代，获取准确、全面的资讯非常重要。我可以帮你分析和整合各类信息，提供多角度的思考。你对哪方面的资讯特别感兴趣？',
      'lifestyle':
          '生活中的小技巧往往能带来大改变。从时间管理到家居整理，从烹饪技巧到社交礼仪，我都可以提供实用的建议。有什么我能帮到你的吗？',
      'entertainment':
          '娱乐是放松身心的绝佳方式。无论是电影、音乐、游戏还是其他形式的娱乐，都能带给我们不同的体验和感受。你最近有什么喜欢的娱乐活动吗？',
      'emotion':
          '情感是人类体验中最复杂也最珍贵的部分。理解和表达情感对我们的心理健康和人际关系都至关重要。如果你有任何情感上的困惑，我很乐意倾听和交流。',
      'learning':
          '学习是终身的旅程，掌握高效的学习方法可以让这个旅程更加愉快和富有成效。同时，适当的解压也是学习过程中不可或缺的部分。有什么学习上的问题我可以帮你解答吗？',
      'career':
          '职业发展需要清晰的规划和持续的努力。无论是求职技巧、职场人际关系还是职业规划，我都可以提供专业的建议和指导。你目前在职业发展上有什么困惑吗？',
    };

    return fallbackResponses[assistantType] ??
        '很高兴能帮助你。我是你的智能助手，可以回答各种问题和提供建议。请告诉我你需要什么帮助？';
  }

  // 原有的角色人格设定和备用回复已经被新的助手系统替代

  // 塔罗牌解读功能
  Future<String> getTarotReading(List<String> selectedCards) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一位专业的塔罗牌解读师，擅长解读塔罗牌的含义和预示。请避免涉及医疗、健康、法律、政治或宗教相关内容。'
            },
            {'role': 'user', 'content': '请解读这些塔罗牌：${selectedCards.join(", ")}'}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];

        // 检查回复是否包含禁止的主题
        if (_containsForbiddenTopic(aiResponse)) {
          return '你选择的牌暗示着一段新的旅程即将开始，勇敢前行，星辰会指引你的方向。';
        }

        return aiResponse;
      } else {
        return '你选择的牌暗示着一段新的旅程即将开始，勇敢前行，星辰会指引你的方向。';
      }
    } catch (e) {
      return '你选择的牌显示你正处于人生的十字路口，需要做出重要决定。相信你的直觉，它会引导你找到正确的道路。';
    }
  }

  // 星座解读功能
  Future<String> getAstrologyReading(String sign, String birthDate) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': '你是一位专业的占星师，擅长解读星座和星盘。请避免涉及医疗、健康、法律、政治或宗教相关内容。'
            },
            {'role': 'user', 'content': '请为$sign座（出生日期：$birthDate）提供星座解读。'}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];

        // 检查回复是否包含禁止的主题
        if (_containsForbiddenTopic(aiResponse)) {
          return '作为$sign座，你天生具有创造力和直觉力。近期木星的影响将为你带来新的机遇。';
        }

        return aiResponse;
      } else {
        return '作为$sign座，你天生具有创造力和直觉力。近期木星的影响将为你带来新的机遇。';
      }
    } catch (e) {
      return '作为$sign座，你的特质是坚韧和适应性强。最近的星象显示你将迎来一段自我发现的旅程，可能会有意想不到的惊喜。';
    }
  }
}
