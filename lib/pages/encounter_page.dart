import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/tarot_model.dart';
import '../utils/ai_service.dart';

class EncounterPage extends StatefulWidget {
  const EncounterPage({super.key});

  @override
  State<EncounterPage> createState() => _EncounterPageState();
}

class _EncounterPageState extends State<EncounterPage>
    with TickerProviderStateMixin {
  // 存储被屏蔽的消息ID
  final Set<String> _blockedMessageIds = {};
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
                    tag: 'assistant_${_selectedAssistantType}',
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withBlue(
                                  (Theme.of(context).primaryColor.blue + 40)
                                      .clamp(0, 255),
                                ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedAssistantName,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                ],
              )
            : const Text(
                '智能顾问',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
        actions: [
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

  // 构建助手选择界面
  Widget _buildAssistantSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部标题区域
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.psychology,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '智能顾问中心',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '选择专业顾问，获取个性化的解答和建议',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 分类标题
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text(
              '专业顾问',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          // 助手卡片列表
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 360 ? 1 : 2,
                childAspectRatio:
                    MediaQuery.of(context).size.width < 360 ? 1.2 : 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _assistants.length,
              itemBuilder: (context, index) {
                return _buildAssistantCard(_assistants[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 构建助手卡片
  Widget _buildAssistantCard(Assistant assistant) {
    // 将十六进制颜色转换为Color对象
    Color backgroundColor = _hexToColor(assistant.backgroundColor);

    return Hero(
      tag: 'assistant_${assistant.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAssistant(assistant),
          onLongPress: () => _showAssistantOptions(assistant),
          borderRadius: BorderRadius.circular(20),
          splashColor: backgroundColor.withOpacity(0.3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: backgroundColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部图片和图标叠加
                Stack(
                  children: [
                    // 图片
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        assistant.imageUrl,
                        height:
                            MediaQuery.of(context).size.width < 360 ? 140 : 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: MediaQuery.of(context).size.width < 360
                                ? 140
                                : 120,
                            width: double.infinity,
                            color: backgroundColor.withOpacity(0.2),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: MediaQuery.of(context).size.width < 360
                                ? 140
                                : 120,
                            width: double.infinity,
                            color: backgroundColor.withOpacity(0.2),
                            child: Icon(
                              _getIconData(assistant.iconData),
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                    // 渐变遮罩
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                              stops: const [0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 分类标签
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getIconData(assistant.iconData),
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              assistant.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 内容区域
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Text(
                          assistant.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // 描述
                        Text(
                          assistant.description,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // 咨询按钮
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '立即咨询',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建聊天界面
  Widget _buildChatInterface() {
    // 确保在构建界面时输入框和发送按钮可见
    return GestureDetector(
        // 点击非输入框区域收起键盘
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              // 使用渐变背景增加设计感
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F1A2C),
                  Color(0xFF1a0625),
                ],
              ),
            ),
            child: Column(
              children: [
                // 聊天消息列表
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      itemCount: _messages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // 添加日期分隔线
                        if (index == 0 || _shouldShowDateSeparator(index)) {
                          return Column(
                            children: [
                              _buildDateSeparator(_messages[index].timestamp),
                              const SizedBox(height: 16),
                              _buildMessageBubble(_messages[index]),
                            ],
                          );
                        }
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
                  ),
                ),
                // 加载指示器
                if (_isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A0B47).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '思考中...',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                // 输入框区域 - 确保这部分始终可见
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2A0B47),
                        Color(0xFF1a0625),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, -3),
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFFF2A6D).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 输入框
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A0B47).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                                spreadRadius: 1,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF4A1A6B).withOpacity(0.2),
                                const Color(0xFF2A0B47).withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: '输入你的问题...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              isDense: true,
                              // 添加一个小图标作为提示
                              prefixIcon: Container(
                                margin:
                                    const EdgeInsets.only(left: 12, right: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF6B2C9E).withOpacity(0.7),
                                      const Color(0xFFFF2A6D).withOpacity(0.5),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              // 添加一个细微的底部边框
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFFFF2A6D).withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFFFF2A6D).withOpacity(0.5),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            maxLines: 4,
                            minLines: 1,
                            maxLength: 500, // 设置最大字符数为500
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                maxLength}) {
                              // 当输入内容接近上限时显示计数器
                              if (currentLength > 400 && isFocused) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: currentLength > 450
                                        ? Colors.amber[100]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$currentLength/$maxLength',
                                    style: TextStyle(
                                      color: currentLength > 450
                                          ? Colors.orange[800]
                                          : Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return null; // 其他情况隐藏字符计数器
                            },
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            onSubmitted: (_) => _sendMessage(),
                            // 添加输入变化监听，用于更新UI状态
                            onChanged: (text) {
                              // 强制刷新发送按钮状态
                              setState(() {});
                            },
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.3,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 发送按钮
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          // 根据输入框是否有内容来决定按钮的状态
                          final bool hasText =
                              _messageController.text.trim().isNotEmpty;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // 检查输入框是否有内容
                                if (hasText) {
                                  _sendMessage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      hasText
                                          ? const Color(0xFFFF2A6D)
                                          : const Color(0xFF4A1A6B)
                                              .withOpacity(0.5),
                                      hasText
                                          ? const Color(0xFF6B2C9E)
                                          : const Color(0xFF2A0B47)
                                              .withOpacity(0.7),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: hasText
                                          ? const Color(0xFFFF2A6D)
                                              .withOpacity(0.4)
                                          : const Color(0xFF6B2C9E)
                                              .withOpacity(0.3),
                                      blurRadius: hasText ? 12 : 6,
                                      spreadRadius: hasText ? 2 : 0,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: hasText
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // 判断是否需要显示日期分隔线
  bool _shouldShowDateSeparator(int index) {
    if (index == 0) return true;

    final currentDate = _messages[index].timestamp;
    final previousDate = _messages[index - 1].timestamp;

    return !_isSameDay(currentDate, previousDate);
  }

  // 判断两个日期是否是同一天
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 构建日期分隔线
  Widget _buildDateSeparator(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  // 举报消息
  void _reportMessage(ChatMessage message) {
    _showReportMessageDialog(message);
  }

  // 屏蔽消息
  void _blockMessage(ChatMessage message) {
    _showBlockMessageDialog(message);
  }

  // 显示举报消息对话框
  void _showReportMessageDialog(ChatMessage message) {
    final TextEditingController _reportController = TextEditingController();
    String _selectedReportReason = '内容不当';
    final List<String> _reportReasons = [
      '内容不当',
      '侵犯隐私',
      '虚假信息',
      '仇恨言论',
      '其他原因'
    ];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '举报消息',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.report_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在举报一条消息',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    message.text.length > 100
                        ? '${message.text.substring(0, 100)}...'
                        : message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择举报原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _reportReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedReportReason,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedReportReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多200字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reportController,
                  maxLines: 3,
                  maxLength: 200,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请详细描述您遇到的问题...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 举报成功后，该消息将被屏蔽。',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _blockedMessageIds.add(message.id);
                });
                Navigator.pop(context);

                // 显示举报成功提示
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('已举报该消息'),
                    backgroundColor: Colors.orange[700],
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: '知道了',
                      textColor: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '提交举报',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 显示屏蔽消息对话框
  void _showBlockMessageDialog(ChatMessage message) {
    final TextEditingController _blockController = TextEditingController();
    String _selectedBlockReason = '不感兴趣';
    final List<String> _blockReasons = ['不感兴趣', '内容重复', '不喜欢风格', '其他原因'];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '屏蔽消息',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.block,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在屏蔽一条消息',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    message.text.length > 100
                        ? '${message.text.substring(0, 100)}...'
                        : message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择屏蔽原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _blockReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedBlockReason,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedBlockReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多100字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _blockController,
                  maxLines: 2,
                  maxLength: 100,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请说明您屏蔽的具体原因...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 屏蔽后，该消息将不再显示。',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _blockedMessageIds.add(message.id);
                });
                Navigator.pop(context);

                // 显示屏蔽成功提示
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('已屏蔽该消息'),
                    backgroundColor: Colors.red[700],
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: '知道了',
                      textColor: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '确认屏蔽',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 清空聊天记录
  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空聊天记录'),
        content: const Text('确定要清空所有聊天记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // 保留欢迎消息
                _messages = [
                  ChatMessage(
                    text: _getWelcomeMessage(_selectedAssistantType),
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                ];
                _blockedMessageIds.clear();
              });
              Navigator.of(context).pop();

              // 显示清空成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('聊天记录已清空'),
                  backgroundColor: Colors.green[700],
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    // 如果消息被屏蔽，则不显示
    if (_blockedMessageIds.contains(message.id)) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '该消息已被屏蔽',
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontStyle: FontStyle.italic),
        ),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuint,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 助手头像
          Visibility(
            visible: !message.isUser,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(isUser: false),
                const SizedBox(width: 8),
              ],
            ),
          ),
          // 消息内容
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                // 只有非用户消息才能举报和屏蔽
                if (!message.isUser) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A0B47),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.report_outlined,
                                color: Colors.orange),
                            title: const Text('举报此消息',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _reportMessage(message);
                            },
                          ),
                          const Divider(height: 1, color: Colors.white24),
                          ListTile(
                            leading: const Icon(Icons.block, color: Colors.red),
                            title: const Text('屏蔽此消息',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _blockMessage(message);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width < 360
                      ? MediaQuery.of(context).size.width * 0.65
                      : MediaQuery.of(context).size.width * 0.7,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(message.isUser ? 20 : 4),
                    topRight: Radius.circular(message.isUser ? 4 : 20),
                    bottomLeft: Radius.circular(message.isUser ? 20 : 16),
                    bottomRight: Radius.circular(message.isUser ? 16 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: message.isUser
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: message.isUser
                      ? null
                      : Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // 消息内容
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    // 时间戳
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.isUser)
                          Icon(
                            Icons.done_all,
                            size: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        if (message.isUser) const SizedBox(width: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: message.isUser
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 用户头像
          Visibility(
            visible: message.isUser,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                _buildAvatar(isUser: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建头像
  Widget _buildAvatar({required bool isUser}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUser
            ? LinearGradient(
                colors: [
                  Colors.grey[400]!,
                  Colors.grey[500]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withBlue(
                        (Theme.of(context).primaryColor.blue + 40)
                            .clamp(0, 255),
                      ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: isUser
                ? Colors.grey[300]!
                : Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isUser ? Icons.person : Icons.assistant,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  // 格式化时间
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return '今天';
    } else if (messageDate == yesterday) {
      return '昨天';
    } else {
      // 显示完整日期
      return '${date.year}年${date.month}月${date.day}日';
    }
  }

  // 显示顾问选项菜单
  void _showAssistantOptions(Assistant assistant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  '操作选项',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.report_outlined, color: Colors.red),
                ),
                title: const Text(
                  '举报',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                subtitle: const Text(
                  '举报不良内容或违规行为',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportAssistantDialog(assistant);
                },
              ),
              const Divider(height: 1, indent: 70, endIndent: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.block, color: Color(0xFF6B2C9E)),
                ),
                title: const Text(
                  '屏蔽',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                subtitle: const Text(
                  '不再显示此顾问',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockAssistantDialog(assistant);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // 显示举报顾问对话框
  void _showReportAssistantDialog(Assistant assistant) {
    final TextEditingController _reportController = TextEditingController();
    String _selectedReportReason = '内容不当';
    final List<String> _reportReasons = [
      '内容不当',
      '侵犯隐私',
      '虚假信息',
      '仇恨言论',
      '其他原因'
    ];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '举报顾问',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.report_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在举报: ${assistant.name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择举报原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _reportReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedReportReason,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedReportReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多200字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reportController,
                  maxLines: 3,
                  maxLength: 200,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请详细描述您遇到的问题...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 举报成功后，该顾问将从您的列表中永久删除。',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _removeAssistant(assistant, '举报');
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '提交举报',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 显示屏蔽顾问对话框
  void _showBlockAssistantDialog(Assistant assistant) {
    final TextEditingController _blockController = TextEditingController();
    String _selectedBlockReason = '不感兴趣';
    final List<String> _blockReasons = ['不感兴趣', '内容重复', '不喜欢风格', '其他原因'];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '屏蔽顾问',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.block,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在屏蔽: ${assistant.name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择屏蔽原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _blockReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedBlockReason,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedBlockReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多100字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _blockController,
                  maxLines: 2,
                  maxLength: 100,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请说明您屏蔽的具体原因...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 屏蔽后，该顾问将从您的列表中永久删除。',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _removeAssistant(assistant, '屏蔽');
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '确认屏蔽',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 从列表中移除顾问
  void _removeAssistant(Assistant assistant, String action) {
    setState(() {
      _assistants.removeWhere((item) => item.id == assistant.id);
    });

    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已${action}该顾问'),
        backgroundColor: action == '举报' ? Colors.red : Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '知道了',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // 如果当前正在与被移除的顾问聊天，则返回选择界面
    if (_isInChat && _selectedAssistantType == assistant.id) {
      _goBackToSelection();
    }
  }

  // 显示功能介绍对话框
  void _showFeaturesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFF5F0FA),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
                Text(
                  '智能顾问使用指南',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '欢迎使用智能顾问！在这里，您可以与各领域的专业顾问进行对话交流。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 内容管理功能说明
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '内容管理功能',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2A0B47),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 顾问卡片长按功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0FA),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.touch_app,
                              color: Theme.of(context).primaryColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '顾问卡片长按功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '长按顾问卡片可举报或屏蔽不良内容。举报或屏蔽后，该顾问将从您的列表中永久删除。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 聊天消息长按功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: Theme.of(context).primaryColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '聊天消息长按功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '长按顾问的聊天消息可举报或屏蔽不良内容。举报或屏蔽后，该消息将不再显示。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 举报功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.report_outlined,
                              color: Colors.red,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '举报功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '举报不良内容后，我们会对内容进行审核，并采取相应措施。您可以选择举报原因并提供详细说明。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 屏蔽功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.block,
                              color: Theme.of(context).primaryColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '屏蔽功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '屏蔽不感兴趣的内容后，该内容将不再显示。您可以选择屏蔽原因并提供详细说明。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        const Color(0xFF4A1A6B)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '开始探索',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 将十六进制颜色转换为Color对象
  Color _hexToColor(String hexString) {
    final hexColor = hexString.replaceAll('#', '');
    if (hexColor.length == 6) {
      return Color(int.parse('FF$hexColor', radix: 16));
    }
    return Colors.grey[100]!;
  }

  // 根据字符串获取IconData
  IconData _getIconData(String iconName) {
    final Map<String, IconData> iconMap = {
      'rocket_launch': Icons.rocket_launch,
      'auto_stories': Icons.auto_stories,
      'newspaper': Icons.newspaper,
      'lightbulb': Icons.lightbulb,
      'movie': Icons.movie,
      'favorite': Icons.favorite,
      'school': Icons.school,
      'work': Icons.work,
    };

    return iconMap[iconName] ?? Icons.assistant;
  }
}

// 聊天消息模型
class ChatMessage {
  final String id; // 添加ID用于标识消息
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString() +
            (text.length > 5 ? text.substring(0, 5) : text);
}
