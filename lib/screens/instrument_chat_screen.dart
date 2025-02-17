import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/instrument_model.dart';
import 'dart:math';
import 'dart:async';
import '../models/ai_language_processor.dart';

class InstrumentChatScreen extends StatefulWidget {
  final InstrumentModel instrument;

  const InstrumentChatScreen({
    super.key,
    required this.instrument,
  });

  @override
  State<InstrumentChatScreen> createState() => _InstrumentChatScreenState();
}

class _InstrumentChatScreenState extends State<InstrumentChatScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final Random _random = Random();
  Timer? _messageTimer;
  int _currentTeachingPoint = 0;
  int _currentPracticeGuide = 0;
  int _currentTip = 0;
  bool _isInitialMessagesComplete = false;
  late ThemeData _theme;

  // 初始化动画控制器和动画
  late final AnimationController _noteAnimationController;
  late final List<Animation<double>> _noteAnimations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  void initState() {
    super.initState();
    _noteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat();

    _noteAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _noteAnimationController,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _startInitialMessages();
  }

  void _startInitialMessages() {
    // Add welcome message
    _messages.add({
      'isUser': false,
      'content':
          'Hello! I\'m your ${widget.instrument.name} tutor. Nice to meet you! Let\'s start today\'s learning! 😊',
    });

    setState(() {});
    _scrollToBottom();

    // Start sending random messages with delays
    _messageTimer = Timer(const Duration(seconds: 2), () {
      _sendRandomMessage();
    });
  }

  void _sendRandomMessage() {
    if (!mounted) return;

    // 准备可用的消息类型和内容
    List<Map<String, dynamic>> availableMessages = [];

    // 收集所有可用的教学点
    for (int i = 0; i < widget.instrument.teachingPoints.length; i++) {
      availableMessages.add({
        'type': 'teaching',
        'content': widget.instrument.teachingPoints[i],
        'prefix': '📝 Teaching Point: '
      });
    }

    // 收集所有可用的练习指南
    for (int i = 0; i < widget.instrument.practiceGuides.length; i++) {
      availableMessages.add({
        'type': 'practice',
        'content': widget.instrument.practiceGuides[i],
        'prefix': '🎯 Practice Guide: '
      });
    }

    // 收集所有可用的小贴士
    for (int i = 0; i < widget.instrument.tips.length; i++) {
      availableMessages.add({
        'type': 'tip',
        'content': widget.instrument.tips[i],
        'prefix': '💡 Tips: '
      });
    }

    // 如果没有可用消息，重置计数器并重新开始
    if (availableMessages.isEmpty) {
      _currentTeachingPoint = 0;
      _currentPracticeGuide = 0;
      _currentTip = 0;
      _sendRandomMessage();
      return;
    }

    // 随机选择一条消息
    final randomIndex = _random.nextInt(availableMessages.length);
    final selectedMessage = availableMessages[randomIndex];

    // 更新相应的计数器
    switch (selectedMessage['type']) {
      case 'teaching':
        _currentTeachingPoint = (_currentTeachingPoint + 1) %
            widget.instrument.teachingPoints.length;
        break;
      case 'practice':
        _currentPracticeGuide = (_currentPracticeGuide + 1) %
            widget.instrument.practiceGuides.length;
        break;
      case 'tip':
        _currentTip = (_currentTip + 1) % widget.instrument.tips.length;
        break;
    }

    setState(() {
      _messages.add({
        'isUser': false,
        'content': selectedMessage['prefix'] + selectedMessage['content'],
      });
    });

    _scrollToBottom();

    // 安排下一条消息，延迟3-5秒
    _messageTimer = Timer(
      Duration(milliseconds: 3000 + _random.nextInt(2000)),
      _sendRandomMessage,
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    // 暂停随机消息发送
    _messageTimer?.cancel();

    setState(() {
      _messages.add({
        'isUser': true,
        'content': text,
      });
      _textController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // 使用 AI 处理器生成回复
      final aiProcessor = AILanguageProcessor();
      final response = await aiProcessor.generateResponse(text);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _messages.add({
          'isUser': false,
          'content': response,
        });
      });

      _scrollToBottom();

      // 如果初始消息还未完成，继续发送随机消息
      if (!_isInitialMessagesComplete) {
        _messageTimer = Timer(
          Duration(milliseconds: 3000 + _random.nextInt(2000)),
          _sendRandomMessage,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _messages.add({
          'isUser': false,
          'content':
              'Sorry, I\'m experiencing some issues. Please try again later.',
        });
      });

      _scrollToBottom();
    }
  }

  // 添加删除消息的方法
  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  // 添加举报消息的方法
  void _reportMessage(int index) {
    // 这里可以添加举报逻辑，比如发送到服务器
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message reported successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 修改消息构建部分
  Widget _buildMessage(Map<String, dynamic> message, int index) {
    final isUser = message['isUser'] as bool;

    return GestureDetector(
      onLongPress: !isUser
          ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.report_problem,
                            color: Colors.orange),
                        title: const Text('Report Message'),
                        onTap: () {
                          Navigator.pop(context);
                          _reportMessage(index);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text('Delete Message'),
                        onTap: () {
                          Navigator.pop(context);
                          _deleteMessage(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    widget.instrument.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF6A4C93) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(!isUser ? 0 : 20),
                    topRight: Radius.circular(isUser ? 0 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message['content'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    letterSpacing: 0.3,
                    color: isUser ? Colors.white : const Color(0xFF2C3E50),
                  ),
                ),
              ),
            ),
            if (isUser) ...[
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: Color(0xFF6A4C93),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        body: SafeArea(
          child: Column(
            children: [
              // 顶部乐器信息卡片
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 返回按钮
                    GestureDetector(
                      onTap: () {
                        _messageTimer?.cancel(); // 取消定时器
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 18,
                          color: Color(0xFF6A4C93),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 乐器图片
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.instrument.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 乐器信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.instrument.name} Tutor',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.instrument.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                              height: 1.5,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 聊天内容区域
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index], index);
                  },
                ),
              ),
              // 加载动画
              if (_isLoading) _buildLoadingIndicator(),
              // 底部输入区域
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 120,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _textController,
                          maxLength: 300,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          minLines: 1,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: const Color(0xFF95A5A6).withOpacity(0.8),
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F6FA),
                            counterText: '',
                            isDense: true,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF2C3E50),
                          ),
                          onSubmitted: (text) {
                            if (text.trim().isNotEmpty) {
                              _handleSubmitted(text);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A4C93), Color(0xFF8B63B7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A4C93).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            if (_textController.text.trim().isNotEmpty) {
                              _handleSubmitted(_textController.text);
                            }
                          },
                          child: const Center(
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _messageTimer?.cancel();
    _noteAnimationController.dispose();
    super.dispose();
  }

  // 自定义加载动画组件
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.instrument.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _noteAnimationController,
                  builder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Transform.translate(
                        offset: Offset(0, -8 * _noteAnimations[index].value),
                        child: Opacity(
                          opacity: 0.3 + (0.7 * _noteAnimations[index].value),
                          child: Icon(
                            index == 0
                                ? Icons.music_note
                                : index == 1
                                    ? Icons.music_note_outlined
                                    : Icons.queue_music_outlined,
                            color: Color(0xFF6A4C93),
                            size: 20 + (4 * _noteAnimations[index].value),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
