import 'package:flutter/material.dart';
import '../models/tarot_model.dart';
import '../utils/ai_service.dart';

class EncounterPage extends StatefulWidget {
  const EncounterPage({super.key});

  @override
  State<EncounterPage> createState() => _EncounterPageState();
}

class _EncounterPageState extends State<EncounterPage>
    with TickerProviderStateMixin {
  final AiService _aiService = AiService();

  // 控制器
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();

  // 动画控制器
  late AnimationController _animationController;

  // 状态变量
  bool _isInChat = false;
  String _selectedAssistantType = '';
  String _selectedAssistantName = '';

  // 聊天消息
  List<ChatMessage> _messages = [];

  // 是否正在加载回复
  bool _isLoading = false;

  // 助手列表
  final List<Assistant> _assistants = [
    Assistant(
      id: 'tech',
      name: '未来科技专家',
      description: '探索前沿科技，了解数字创新趋势',
      imageUrl:
          'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=800&auto=format&fit=crop',
      category: '未来科技',
      iconData: 'rocket_launch',
      backgroundColor: '#E3F2FD',
    ),
    Assistant(
      id: 'literature',
      name: '文学艺术大师',
      description: '探索文学艺术的无限可能',
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=800&auto=format&fit=crop',
      category: '未来文学',
      iconData: 'auto_stories',
      backgroundColor: '#F3E5F5',
    ),
    Assistant(
      id: 'news',
      name: '资讯分析师',
      description: '获取最新资讯，多角度解读世界',
      imageUrl:
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?q=80&w=800&auto=format&fit=crop',
      category: '实时资讯',
      iconData: 'newspaper',
      backgroundColor: '#E8F5E9',
    ),
    Assistant(
      id: 'lifestyle',
      name: '生活技巧专家',
      description: '提供实用的日常生活建议和解决方案',
      imageUrl:
          'https://images.unsplash.com/photo-1493612276216-ee3925520721?q=80&w=800&auto=format&fit=crop',
      category: '生活技巧',
      iconData: 'lightbulb',
      backgroundColor: '#FFF3E0',
    ),
    Assistant(
      id: 'entertainment',
      name: '娱乐资讯专家',
      description: '了解流行文化、影视、音乐等领域的最新动态',
      imageUrl:
          'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?q=80&w=800&auto=format&fit=crop',
      category: '娱乐资讯',
      iconData: 'movie',
      backgroundColor: '#FFEBEE',
    ),
    Assistant(
      id: 'emotion',
      name: '情感咨询师',
      description: '倾听和理解你的情感需求，提供支持和建议',
      imageUrl:
          'https://images.unsplash.com/photo-1544027993-37dbfe43562a?q=80&w=800&auto=format&fit=crop',
      category: '情感释放',
      iconData: 'favorite',
      backgroundColor: '#FCE4EC',
    ),
    Assistant(
      id: 'learning',
      name: '学习指导专家',
      description: '提供高效学习方法和解压技巧',
      imageUrl:
          'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?q=80&w=800&auto=format&fit=crop',
      category: '学习解压',
      iconData: 'school',
      backgroundColor: '#E0F7FA',
    ),
    Assistant(
      id: 'career',
      name: '职业发展顾问',
      description: '提供工作和职业规划建议',
      imageUrl:
          'https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=800&auto=format&fit=crop',
      category: '工作指导',
      iconData: 'work',
      backgroundColor: '#E8EAF6',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // 选择助手
  void _selectAssistant(Assistant assistant) {
    setState(() {
      _selectedAssistantType = assistant.id;
      _selectedAssistantName = assistant.name;
      _isInChat = true;
      _messages = [
        ChatMessage(
          text: _getWelcomeMessage(assistant.id),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    });

    // 确保输入框获得焦点并清空
    _messageController.clear();

    // 延迟一下，确保UI已经构建完成后再滚动到底部
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollToBottom();
    });
  }

  // 返回助手选择界面
  void _goBackToSelection() {
    setState(() {
      _isInChat = false;
      _selectedAssistantType = '';
      _messages = [];
    });
  }

  // 获取欢迎消息
  String _getWelcomeMessage(String assistantType) {
    final Map<String, String> welcomeMessages = {
      'tech': '欢迎来到未来科技中心！我是你的未来科技专家，可以为你解答关于前沿科技、数字创新和科技产品的问题。有什么我可以帮助你的吗？',
      'literature': '欢迎进入文学艺术殿堂！我是你的文学艺术大师，可以与你探讨文学作品、写作技巧和艺术鉴赏。今天想聊些什么？',
      'news': '欢迎来到资讯中心！我是你的资讯分析师，可以帮你整合和解读各类信息。你想了解哪方面的资讯？',
      'lifestyle': '欢迎来到生活智慧馆！我是你的生活技巧专家，可以为你提供实用的日常生活建议。有什么生活问题需要解决吗？',
      'entertainment': '欢迎来到娱乐世界！我是你的娱乐资讯专家，可以为你提供关于流行文化、影视、音乐等领域的见解。想聊些什么？',
      'emotion': '欢迎来到心灵港湾！我是你的情感咨询师，很高兴能倾听和理解你的情感需求。有什么想分享或讨论的吗？',
      'learning': '欢迎来到学习空间！我是你的学习指导专家，可以为你提供高效学习方法和解压技巧。有什么学习上的困惑吗？',
      'career': '欢迎来到职业发展中心！我是你的职业发展顾问，可以为你提供工作和职业规划建议。你目前在职业上有什么困惑或目标？',
    };

    return welcomeMessages[assistantType] ?? '你好！我是你的智能助手，有什么我可以帮助你的吗？';
  }

  // 发送消息
  void _sendMessage() async {
    // 检查输入内容是否为空
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // 清空输入框并收起键盘
    _messageController.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    // 滚动到底部
    _scrollToBottom();

    // 获取AI回复
    try {
      final response =
          await _aiService.getChatResponse(userMessage, _selectedAssistantType);

      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });

        // 滚动到底部
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: '抱歉，我遇到了一些问题。请稍后再试。',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });

        // 滚动到底部
        _scrollToBottom();
      }
    }
  }

  // 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 清空聊天记录
  void _clearChatHistory() {
    setState(() {
      _messages = [
        ChatMessage(
          text: _getWelcomeMessage(_selectedAssistantType),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    });
  }

  // 显示功能说明对话框
  void _showFeaturesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('功能说明'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🤖 智能助手',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 选择不同类型的专业助手\n• 获得个性化的回答和建议\n• 支持多轮对话交流'),
                SizedBox(height: 16),
                Text(
                  '💬 聊天功能',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 实时对话交流\n• 智能回复生成\n• 聊天记录管理'),
                SizedBox(height: 16),
                Text(
                  '🎯 专业领域',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 科技、文学、资讯\n• 生活、娱乐、情感\n• 学习、职业发展'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('了解了'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: _isInChat ? 0 : 16,
        title: _isInChat
            ? Row(
                children: [
                  Hero(
                    tag: 'assistant_$_selectedAssistantType',
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withRed(
                                  (Theme.of(context).primaryColor.red + 40)
                                      .clamp(0, 255),
                                ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.assistant,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedAssistantName,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        '在线',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                    ),
                  ),
                ],
              )
            : const Text(
                '遇见',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        actions: [
          // 搜索按钮 - 仅在非聊天界面显示
          if (!_isInChat)
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black87,
              ),
              onPressed: () {
                // 搜索功能
              },
              tooltip: '搜索',
            ),
          // 信息按钮 - 始终显示
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _showFeaturesDialog,
            tooltip: '功能说明',
          ),
          // 清空聊天记录按钮 - 仅在聊天界面显示
          if (_isInChat)
            IconButton(
              icon: Icon(
                Icons.delete_sweep,
                color: _messages.length > 1 ? Colors.black87 : Colors.black26,
              ),
              onPressed: _messages.length > 1 ? _clearChatHistory : null,
              tooltip: '清空聊天记录',
            ),
        ],
        leading: _isInChat
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                onPressed: _goBackToSelection,
              )
            : null,
      ),
      body: _isInChat ? _buildChatInterface() : _buildAssistantSelection(),
    );
  }

  // 构建聊天界面
  Widget _buildChatInterface() {
    return Column(
      children: [
        // 聊天消息列表
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isLoading) {
                return _buildLoadingMessage();
              }
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
        // 输入区域
        _buildInputArea(),
      ],
    );
  }

  // 构建助手选择界面
  Widget _buildAssistantSelection() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFFAF9FF), // 非常淡的紫色背景
            Colors.white,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // 背景装饰
          _buildBackgroundDecorations(),
          // 主要内容
          Column(
            children: [
              // 顶部分类标签
              _buildCategoryTabs(),
              
              // 主要内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 标题区域
                      _buildHeaderSection(),
                      const SizedBox(height: 24),
                      
                      // 推荐卡片网格
                      _buildRecommendedGrid(),
                      const SizedBox(height: 32),
                      
                      // 其他助手列表
                      _buildAssistantList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建背景装饰
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // 浮动的星星
        Positioned(
          top: 100,
          left: 30,
          child: Icon(
            Icons.star,
            color: const Color(0xFFE1BEE7).withValues(alpha: 0.3),
            size: 20,
          ),
        ),
        Positioned(
          top: 200,
          right: 50,
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFFE1BEE7).withValues(alpha: 0.25),
            size: 16,
          ),
        ),
        Positioned(
          top: 350,
          left: 60,
          child: Icon(
            Icons.music_note,
            color: const Color(0xFFE1BEE7).withValues(alpha: 0.2),
            size: 18,
          ),
        ),
        Positioned(
          bottom: 200,
          right: 30,
          child: Icon(
            Icons.star,
            color: const Color(0xFFE1BEE7).withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        Positioned(
          bottom: 300,
          left: 40,
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFFE1BEE7).withValues(alpha: 0.2),
            size: 12,
          ),
        ),
      ],
    );
  }

  // 构建标题区域
  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFf093fb), // 粉色
                Color(0xFFf5576c), // 橙粉色
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFf093fb).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '选择你的专属助手',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '每个助手都有独特的专业领域，为你提供个性化的帮助',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 构建分类标签
  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTab('全部', true),
                  _buildCategoryTab('科技', false),
                  _buildCategoryTab('文学', false),
                  _buildCategoryTab('生活', false),
                  _buildCategoryTab('娱乐', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建分类标签项
  Widget _buildCategoryTab(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          // 处理分类选择
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected 
                ? const LinearGradient(
                    colors: [
                      Color(0xFFf093fb), // 粉色
                      Color(0xFFf5576c), // 橙粉色
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(25), // 更大的圆角
            border: Border.all(
              color: isSelected 
                  ? Colors.transparent 
                  : const Color(0xFFE1BEE7).withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: isSelected 
                ? [
                    BoxShadow(
                      color: const Color(0xFFf093fb).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF6B2C9E),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              shadows: isSelected 
                  ? [
                      const Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  // 构建推荐网格
  Widget _buildRecommendedGrid() {
    final recommendedAssistants = _assistants.take(4).toList();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9, // 稍微调整比例
        crossAxisSpacing: 16, // 增加间距
        mainAxisSpacing: 16,
      ),
      itemCount: recommendedAssistants.length,
      itemBuilder: (context, index) {
        return _buildAssistantCard(recommendedAssistants[index]);
      },
    );
  }

  // 构建助手列表
  Widget _buildAssistantList() {
    final otherAssistants = _assistants.skip(4).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '更多助手',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...otherAssistants.map((assistant) => _buildAssistantListItem(assistant)),
      ],
    );
  }

  // 构建助手卡片
  Widget _buildAssistantCard(Assistant assistant) {
    return GestureDetector(
      onTap: () => _selectAssistant(assistant),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), // 大圆角矩形
          gradient: _getCardGradient(assistant.id), // 渐变背景
          boxShadow: [
            BoxShadow(
              color: _getCardGradient(assistant.id).colors.first.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 顶部区域：图标和装饰
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconData(assistant.iconData),
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // 装饰图标
                  Column(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 16,
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withValues(alpha: 0.25),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
              // 文字区域
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assistant.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    assistant.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建助手列表项
  Widget _buildAssistantListItem(Assistant assistant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _selectAssistant(assistant),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: _getCardGradient(assistant.id),
            borderRadius: BorderRadius.circular(20), // 大圆角
            boxShadow: [
              BoxShadow(
                color: _getCardGradient(assistant.id).colors.first.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // 图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getIconData(assistant.iconData),
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    // 小装饰
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        Icons.star,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // 文字信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      assistant.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      assistant.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 箭头和装饰
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 14,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  // 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            // 助手头像
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.assistant,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          // 消息内容
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            // 用户头像
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 构建加载消息
  Widget _buildLoadingMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 助手头像
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.assistant,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 加载动画
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('正在思考...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建输入区域
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: '输入消息...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 辅助方法：从十六进制字符串获取颜色
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // 获取卡片渐变色
  LinearGradient _getCardGradient(String assistantId) {
    switch (assistantId) {
      case 'tech':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea), // 蓝紫色
            Color(0xFF764ba2), // 深紫色
          ],
        );
      case 'literature':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFf093fb), // 粉色
            Color(0xFFf5576c), // 橙粉色
          ],
        );
      case 'news':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4facfe), // 蓝绿色
            Color(0xFF00f2fe), // 青色
          ],
        );
      case 'lifestyle':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffecd2), // 温暖橙黄
            Color(0xFFfcb69f), // 橙色
          ],
        );
      case 'entertainment':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFa8edea), // 淡紫色
            Color(0xFFfed6e3), // 粉色
          ],
        );
      case 'emotion':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffecd2), // 温暖色调
            Color(0xFFfcb69f), // 橙粉色
          ],
        );
      case 'learning':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFa8edea), // 蓝绿色
            Color(0xFFfed6e3), // 淡紫色
          ],
        );
      case 'career':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea), // 蓝紫色
            Color(0xFF764ba2), // 深紫色
          ],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFf093fb), // 粉色
            Color(0xFFf5576c), // 橙粉色
          ],
        );
    }
  }



  // 辅助方法：从字符串获取图标数据
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'newspaper':
        return Icons.newspaper;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'movie':
        return Icons.movie;
      case 'favorite':
        return Icons.favorite;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      default:
        return Icons.assistant;
    }
  }
}