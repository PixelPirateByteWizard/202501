import 'package:flutter/material.dart';
import 'dart:async';
import '../models/reality_model.dart';
import '../utils/ai_service.dart';
import '../utils/shared_prefs.dart';

class ChatPage extends StatefulWidget {
  final Reality reality;

  const ChatPage({super.key, required this.reality});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // 存储被屏蔽的消息ID
  final Set<String> _blockedMessageIds = {};
  final TextEditingController _messageController = TextEditingController();
  final AiService _aiService = AiService();
  final ScrollController _scrollController = ScrollController();

  // 聊天消息列表
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // 打字动画控制器
  late AnimationController _typingController;

  // 取消AI请求的标记
  bool _disposed = false;

  // 举报和屏蔽的类型选项
  final List<String> _reportTypes = ['不当内容', '骚扰', '垃圾信息', '虚假信息', '其他'];

  final List<String> _blockTypes = ['不想看到此类内容', '骚扰或冒犯性内容', '垃圾信息', '其他原因'];

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

  @override
  void initState() {
    super.initState();
    // 初始化打字动画控制器
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // 加载历史消息
    _loadChatHistory();

    // 如果没有历史消息，添加初始AI消息
    if (_messages.isEmpty) {
      _addInitialMessage();
    }

    // 保存最近聊天的角色ID
    SharedPrefs.saveLastChatCharacterId(widget.reality.id);
  }

  void _addInitialMessage() {
    // 根据不同角色添加不同的初始消息
    String initialMessage;
    switch (widget.reality.id) {
      case '1':
        initialMessage = '在我的时空里，思想可以实体化，我们用意识直接交流。你好，来自另一个维度的朋友。';
        break;
      case '2':
        initialMessage = '霓虹灯下的旋律是我的语言，数据流是我的血液。很高兴能与你建立连接，想听听我的歌声吗？';
        break;
      case '3':
        initialMessage = '根据我的计算，我们的宇宙有87.3%的差异。我正在研究如何稳定跨维度通信通道，很高兴这次连接成功了。';
        break;
      case '4':
        initialMessage = '星辰的诗篇在我的宇宙中是有形的，可以被触摸和感受。你的宇宙中，诗歌是如何存在的？';
        break;
      case '5':
        initialMessage = '在我的世界里，梦境是我们创造现实的工具。我们可以将梦想构建成真实的建筑和城市。你的世界如何？';
        break;
      default:
        initialMessage = '你好，来自不同时空的朋友。我很高兴能与你交流。请问有什么我可以帮助你的吗？';
    }

    _addBotMessage(initialMessage);
  }

  Future<void> _loadChatHistory() async {
    // 这里可以从SharedPreferences加载历史消息
    // 简化版本，实际应用中可以使用JSON存储更复杂的数据结构
    // 实际实现可以在这里添加
  }

  Future<void> _saveChatHistory() async {
    // 这里可以将消息保存到SharedPreferences
    // 简化版本，实际应用中可以使用JSON存储更复杂的数据结构
    // 实际实现可以在这里添加
  }

  @override
  void dispose() {
    _disposed = true; // 标记为已销毁
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void _addMessage(String text, bool isUser) {
    if (text.trim().isEmpty) return;

    if (!mounted || _disposed) return; // 检查是否已销毁

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        avatarUrl: isUser
            ? '' // 用户头像留空，将使用图标代替
            : widget.reality.avatarUrl,
        timestamp: DateTime.now(),
      ));
    });

    // 保存聊天历史
    _saveChatHistory();

    // 滚动到底部
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // 使用微小延迟确保布局已完成
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients && mounted) {
        // 检查是否已销毁
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addBotMessage(String text) {
    _addMessage(text, false);
  }

  void _addUserMessage(String text) {
    _addMessage(text, true);
  }

  // 检查消息是否包含禁止的主题
  bool _containsForbiddenTopic(String message) {
    final lowerMessage = message.toLowerCase();
    return _forbiddenTopics
        .any((topic) => lowerMessage.contains(topic.toLowerCase()));
  }

  Future<void> _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();

    // 显示AI正在输入
    if (!mounted || _disposed) return; // 检查是否已销毁
    setState(() {
      _isTyping = true;
    });

    // 检查是否包含禁止的主题
    if (_containsForbiddenTopic(text)) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted || _disposed) return; // 再次检查是否已销毁
      _addBotMessage('抱歉，我无法回答与医疗、健康、法律、政治或宗教相关的问题。请尝试问我关于其他话题的问题。');
      if (mounted && !_disposed) {
        // 检查是否已销毁
        setState(() {
          _isTyping = false;
        });
      }
      return;
    }

    // 获取AI回复
    try {
      final response =
          await _aiService.getChatResponse(text, widget.reality.id);

      // 如果组件已被销毁，不继续执行
      if (!mounted || _disposed) return;

      // 检查AI回复是否包含禁止的主题
      if (_containsForbiddenTopic(response)) {
        _addBotMessage('抱歉，我无法讨论与医疗、健康、法律、政治或宗教相关的话题。让我们聊些其他有趣的事情吧。');
      } else {
        // 模拟真实打字效果，根据回复长度计算延迟
        final typingDelay =
            Duration(milliseconds: (response.length * 20).clamp(300, 2000));
        await Future.delayed(typingDelay);

        // 再次检查组件是否已被销毁
        if (!mounted || _disposed) return;

        _addBotMessage(response);
      }
    } catch (e) {
      // 如果组件已被销毁，不继续执行
      if (!mounted || _disposed) return;

      _addBotMessage('抱歉，我暂时无法回应。似乎我们的量子通讯链接不稳定，请稍后再试。');
    } finally {
      // 最后一次检查组件是否已被销毁
      if (mounted && !_disposed) {
        setState(() {
          _isTyping = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.reality.backgroundUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(178),
              BlendMode.darken,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(
                child: _buildChatList(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black.withAlpha(180),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Hero(
            tag: 'avatar-${widget.reality.id}',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.reality.avatarUrl),
                radius: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'name-${widget.reality.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.reality.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '在线',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: const Color.fromARGB(255, 12, 12, 12),
          onSelected: (value) {
            if (value == 'clear') {
              _clearChat();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear',
              child: const Text('清空聊天记录'),
            ),
          ],
        ),
      ],
    );
  }

  // 举报消息
  void _reportMessage(ChatMessage message) {
    // 收起键盘
    FocusScope.of(context).unfocus();

    String selectedType = _reportTypes.first;
    String reportDetails = '';

    showDialog(
      context: context,
      barrierDismissible: false, // 防止点击外部关闭
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Dialog(
              backgroundColor: const Color(0xFF1E1E2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '举报消息',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '请选择举报类型:',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(80),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedType,
                        dropdownColor: const Color(0xFF2A0B47),
                        style: const TextStyle(color: Colors.white),
                        underline: const SizedBox(), // 移除默认的下划线
                        items: _reportTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => selectedType = newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '举报详情 (可选):',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      maxLength: 200,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '请描述举报原因...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.black.withAlpha(80),
                        contentPadding: const EdgeInsets.all(12),
                        counterStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      onChanged: (value) => reportDetails = value,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('取消'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // 显示举报成功提示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('举报已提交，感谢您的反馈'),
                                backgroundColor: Colors.orange[700],
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B2C9E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('提交举报'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 屏蔽消息
  void _blockMessage(ChatMessage message) {
    // 收起键盘
    FocusScope.of(context).unfocus();

    String selectedType = _blockTypes.first;
    String blockDetails = '';

    showDialog(
      context: context,
      barrierDismissible: false, // 防止点击外部关闭
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Dialog(
              backgroundColor: const Color(0xFF1E1E2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '屏蔽消息',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '您将不再收到此用户的消息。请选择屏蔽原因:',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(80),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedType,
                        dropdownColor: const Color(0xFF2A0B47),
                        style: const TextStyle(color: Colors.white),
                        underline: const SizedBox(), // 移除默认的下划线
                        items: _blockTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => selectedType = newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '备注 (可选):',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 2,
                      maxLength: 100,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '添加备注...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.black.withAlpha(80),
                        contentPadding: const EdgeInsets.all(12),
                        counterStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      onChanged: (value) => blockDetails = value,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('取消'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            // 执行屏蔽操作
                            setState(() {
                              _blockedMessageIds.add(message.id);
                            });

                            Navigator.of(context).pop();

                            // 显示屏蔽成功提示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('已屏蔽该消息'),
                                backgroundColor: Colors.red[700],
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('确认屏蔽'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '清空聊天记录',
          style: TextStyle(
            color: Color(0xFF2A0B47),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '确定要清空所有聊天记录吗？此操作不可撤销。',
          style: TextStyle(
            color: Color(0xFF4A1A6B),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (!mounted || _disposed) return; // 检查是否已销毁
              setState(() {
                _messages.clear();
                _blockedMessageIds.clear(); // 同时清空被屏蔽的消息ID
              });
              _saveChatHistory();
              Navigator.of(context).pop();

              // 添加初始消息
              _addInitialMessage();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6B2C9E),
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          '开始与平行时空的自己交流吧',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        // 显示AI正在输入的指示器
        if (_isTyping && index == _messages.length) {
          return _buildTypingIndicator();
        }

        final message = _messages[index];
        return _buildChatBubble(message, index);
      },
    );
  }

  Widget _buildChatBubble(ChatMessage message, int index) {
    // 如果消息被屏蔽，则显示占位符
    if (_blockedMessageIds.contains(message.id)) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '该消息已被屏蔽',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // 计算是否需要显示时间
    bool showTime = true;
    if (index > 0) {
      final prevMessage = _messages[index - 1];
      final timeDiff =
          message.timestamp.difference(prevMessage.timestamp).inMinutes;
      showTime = timeDiff > 5 || prevMessage.isUser != message.isUser;
    }

    return Column(
      children: [
        if (showTime) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: message.isUser
                ? [
                    _buildBubble(message),
                    const SizedBox(width: 8),
                    _buildAvatar(message),
                  ]
                : [
                    _buildAvatar(message),
                    const SizedBox(width: 8),
                    _buildBubble(message),
                  ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      return '今天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDay == today.subtract(const Duration(days: 1))) {
      return '昨天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildAvatar(ChatMessage message) {
    if (message.isUser) {
      // 用户头像使用图标代替
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF6B2C9E).withAlpha(230),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      );
    } else {
      // AI头像使用网络图片
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(message.avatarUrl),
          radius: 18,
        ),
      );
    }
  }

  Widget _buildBubble(ChatMessage message) {
    return GestureDetector(
      onLongPress: () {
        // 只有AI消息才能举报和屏蔽
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
                    leading:
                        const Icon(Icons.report_outlined, color: Colors.orange),
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
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF6B2C9E).withAlpha(230)
              : Colors.black.withAlpha(180),
          borderRadius: BorderRadius.circular(20).copyWith(
            topLeft: message.isUser ? const Radius.circular(20) : Radius.zero,
            topRight: message.isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.reality.avatarUrl),
              radius: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(180),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _DotPulse(controller: _typingController),
                const SizedBox(width: 4),
                _DotPulse(controller: _typingController, delay: 0.2),
                const SizedBox(width: 4),
                _DotPulse(controller: _typingController, delay: 0.4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // 增加底部内边距
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(180),
          border: Border(
            top: BorderSide(
              color: Colors.white.withAlpha(40),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end, // 对齐底部
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withAlpha(40),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: '输入你的消息...',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14, // 增加垂直内边距
                    ),
                    // 添加计数器
                    counterText: '',
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: null, // 允许自动换行
                  minLines: 1, // 最小行数
                  maxLength: 500, // 最大字符数限制
                  textInputAction: TextInputAction.newline, // 回车键行为
                  onSubmitted: (_) => _handleSendMessage(),
                  // 点击输入框外部收起键盘
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                ),
              ),
            ),
            const SizedBox(width: 12), // 增加按钮与输入框的间距
            Container(
              margin: const EdgeInsets.only(bottom: 4), // 调整按钮位置
              decoration: BoxDecoration(
                color: const Color(0xFF6B2C9E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B2C9E).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _handleSendMessage,
                padding: const EdgeInsets.all(12), // 增加按钮内边距
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotPulse extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _DotPulse({required this.controller, this.delay = 0.0});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double opacity = (controller.value + delay) % 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((opacity * 255).toInt()),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String id; // 添加ID用于标识消息
  final String text;
  final bool isUser;
  final String avatarUrl;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.avatarUrl,
    DateTime? timestamp,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString() +
            (text.length > 5 ? text.substring(0, 5) : text),
        timestamp = timestamp ?? DateTime.now();
}
