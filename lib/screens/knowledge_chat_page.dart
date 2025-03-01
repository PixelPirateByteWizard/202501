import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/knowledge_item.dart';
import 'dart:async';
import '../models/eco_friend.dart';
import 'dart:math';
import '../data/sample_eco_friends.dart';
import '../services/ai_chat_service.dart';
import '../screens/friend_profile_page.dart';
import '../screens/friend_chat_page.dart';

class KnowledgeChatPage extends StatefulWidget {
  final KnowledgeItem knowledgeItem;

  const KnowledgeChatPage({
    super.key,
    required this.knowledgeItem,
  });

  @override
  State<KnowledgeChatPage> createState() => _KnowledgeChatPageState();
}

class _KnowledgeChatPageState extends State<KnowledgeChatPage> {
  final List<_ChatMessage> _messages = [];
  Timer? _messageTimer;
  final Random _random = Random();
  final List<int> _sentMessageIndices = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;

  final List<EcoFriend> _activeFriends = [];
  Timer? _friendJoinTimer;
  final Map<String, List<int>> _sentFriendMessageIndices = {};

  final List<int> _sentDetailContentIndices = [];

  bool _isWaitingForAIResponse = false;

  // 添加一个标志来追踪页面是否已被销毁
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _initializeChat();
  }

  // 将初始化逻辑抽取到单独的方法
  void _initializeChat() {
    _scrollController.addListener(_scrollListener);
    _sendWelcomeMessage();
    // 使用mounted检查确保widget仍然存在
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!_isDisposed) {
          _scheduleNextDetailContent();
          _scheduleAddFriends();
        }
      });
    }
  }

  // 修改所有涉及setState的方法，添加disposed检查
  void setState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      super.setState(fn);
    }
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      _shouldAutoScroll = (maxScroll - currentScroll) <= 50;
    }
  }

  void _scrollToBottom() {
    if (!_shouldAutoScroll) return;

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

  void _sendWelcomeMessage() {
    String welcomeMessage = _generateWelcomeMessage();
    setState(() {
      _messages.add(_ChatMessage(
        content: welcomeMessage,
        isBot: true,
      ));
    });
    _scrollToBottom();
  }

  String _generateWelcomeMessage() {
    return '''Welcome to "${widget.knowledgeItem.title}" Knowledge Base! 👋

I'm your eco-friendly assistant. Let's explore ${widget.knowledgeItem.description} together!

Here are the key points we'll learn today:
${widget.knowledgeItem.keyPoints.map((point) => "• $point").join("\n")}

Ready to start our eco-friendly journey? 🌱''';
  }

  void _scheduleAddFriends() {
    final friendCount = 6 + _random.nextInt(4);
    final shuffledFriends = List<EcoFriend>.from(sampleEcoFriends)
      ..shuffle(_random);
    final selectedFriends = shuffledFriends.take(friendCount).toList();

    // 延长初始等待时间
    Future.delayed(const Duration(seconds: 4), () {
      _addFriendsSequentially(selectedFriends);
    });
  }

  void _addFriendsSequentially(List<EcoFriend> friends) {
    int index = 0;

    _friendJoinTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // 增加间隔到5秒
      if (index < friends.length) {
        final friend = friends[index];
        _addFriend(friend);
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  void _addFriend(EcoFriend friend) {
    setState(() {
      _activeFriends.add(friend);
      _sentFriendMessageIndices[friend.id] = [];
      _messages.add(_ChatMessage(
        content: "${friend.name} joined the discussion...",
        isBot: true,
        isSystemMessage: true,
      ));
    });
    _scrollToBottom();

    _scheduleFriendMessages(friend);
  }

  void _scheduleFriendMessages(EcoFriend friend) {
    if (_isDisposed) return;

    void sendMessage() {
      if (_isDisposed) return;

      final sentIndices = _sentFriendMessageIndices[friend.id]!;
      if (sentIndices.length >= friend.presetMessages.length) return;

      final availableIndices = List<int>.generate(
        friend.presetMessages.length,
        (i) => i,
      ).where((i) => !sentIndices.contains(i)).toList();

      if (availableIndices.isEmpty) return;

      final randomIndex =
          availableIndices[_random.nextInt(availableIndices.length)];
      sentIndices.add(randomIndex);

      setState(() {
        _messages.add(_ChatMessage(
          content: friend.presetMessages[randomIndex],
          isBot: true,
          friend: friend,
        ));
      });

      _scrollToBottom();

      if (!_isDisposed && sentIndices.length < friend.presetMessages.length) {
        Future.delayed(
          Duration(seconds: 5 + _random.nextInt(8)), // 增加消息间隔时间
          () {
            if (!_isDisposed) {
              sendMessage();
            }
          },
        );
      }
    }

    if (!_isDisposed) {
      Future.delayed(
        Duration(seconds: 3 + _random.nextInt(5)), // 增加初始延迟
        () {
          if (!_isDisposed) {
            sendMessage();
          }
        },
      );
    }
  }

  void _sendNextDetailContent() {
    if (_sentDetailContentIndices.length >=
        widget.knowledgeItem.detailContent.length) return;

    final availableIndices = List<int>.generate(
      widget.knowledgeItem.detailContent.length,
      (i) => i,
    ).where((i) => !_sentDetailContentIndices.contains(i)).toList();

    if (availableIndices.isEmpty) return;

    final randomIndex =
        availableIndices[_random.nextInt(availableIndices.length)];
    _sentDetailContentIndices.add(randomIndex);

    setState(() {
      _messages.add(_ChatMessage(
        content: widget.knowledgeItem.detailContent[randomIndex],
        isBot: true,
      ));
    });

    _scrollToBottom();
  }

  void _scheduleNextDetailContent() {
    if (_isDisposed) return;

    if (_sentDetailContentIndices.length <
        widget.knowledgeItem.detailContent.length) {
      Future.delayed(
        Duration(seconds: 4 + _random.nextInt(6)), // 增加内容显示间隔
        () {
          if (!_isDisposed) {
            _sendNextDetailContent();
            _scheduleNextDetailContent();
          }
        },
      );
    }
  }

  void _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isWaitingForAIResponse) return;

    setState(() {
      _messages.add(_ChatMessage(
        content: text,
        isBot: false,
      ));
      _isWaitingForAIResponse = true;
    });

    _textController.clear();
    _shouldAutoScroll = true;
    _scrollToBottom();

    String context = '''
    Topic: ${widget.knowledgeItem.title}
    Description: ${widget.knowledgeItem.description}
    Key Points: ${widget.knowledgeItem.keyPoints.join(', ')}
    ''';

    try {
      final aiResponse = await AIChatService.getAIResponse(text, context);

      if (aiResponse != null) {
        setState(() {
          _messages.add(_ChatMessage(
            content: aiResponse,
            isBot: true,
            isAIResponse: true,
          ));
        });
      } else {
        setState(() {
          _messages.add(_ChatMessage(
            content:
                "Sorry, I couldn't process your message at the moment. Please try again.",
            isBot: true,
            isAIResponse: true,
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          content: "Network error. Please check your connection and try again.",
          isBot: true,
          isAIResponse: true,
        ));
      });
    } finally {
      setState(() {
        _isWaitingForAIResponse = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    // 取消所有定时器
    _messageTimer?.cancel();
    _friendJoinTimer?.cancel();

    // 清理控制器
    _scrollController.removeListener(_scrollListener);
    _textController.dispose();
    _scrollController.dispose();

    // 清理数据集合
    _messages.clear();
    _activeFriends.clear();
    _sentFriendMessageIndices.clear();
    _sentDetailContentIndices.clear();
    _sentMessageIndices.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0B2E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2A2D5F),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B6BF3),
                      Color(0xFF6B4DE3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B6BF3).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.knowledgeItem.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.knowledgeItem.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _messages.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessage(message);
                      },
                    ),
                    if (!_shouldAutoScroll)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF8B6BF3),
                                Color(0xFF6B4DE3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B6BF3).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.white),
                            onPressed: () {
                              _shouldAutoScroll = true;
                              _scrollToBottom();
                            },
                            tooltip: 'Scroll to bottom',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D5F),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.of(context).padding.bottom + 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF8B6BF3).withOpacity(0.1),
                                const Color(0xFF6B4DE3).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFF8B6BF3).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _textController,
                            style: const TextStyle(color: Colors.white),
                            maxLength: 300,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _handleSendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B6BF3),
                              Color(0xFF6B4DE3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B6BF3).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _handleSendMessage,
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                          tooltip: 'Send message',
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
    );
  }

  Widget _buildMessage(_ChatMessage message) {
    if (message.isSystemMessage) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B6BF3).withOpacity(0.1),
                const Color(0xFF6B4DE3).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.isBot) ...[
            GestureDetector(
              onTap: () {
                if (message.friend != null) {
                  _showFriendInfoDialog(message.friend!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B6BF3),
                      Color(0xFF6B4DE3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B6BF3).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: message.friend?.avatar != null
                        ? Image.asset(
                            message.friend!.avatar,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )
                        : const Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: message.isBot
                      ? [
                          const Color(0xFF2A2D5F),
                          const Color(0xFF1A1B3F),
                        ]
                      : [
                          const Color(0xFF8B6BF3).withOpacity(0.2),
                          const Color(0xFF6B4DE3).withOpacity(0.2),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: message.isAIResponse
                    ? Border.all(
                        color: const Color(0xFF8B6BF3),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.friend != null || message.isAIResponse)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.friend?.name ?? 'AI Response',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B6BF3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFriendInfoDialog(EcoFriend friend) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2A2D5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B6BF3),
                    Color(0xFF6B4DE3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        friend.avatar,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter, // 对齐到顶部
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          friend.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FriendProfilePage(friend: friend),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FriendChatPage(friend: friend),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF8B6BF3).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String content;
  final bool isBot;
  final bool isSystemMessage;
  final EcoFriend? friend;
  final bool isAIResponse;

  _ChatMessage({
    required this.content,
    required this.isBot,
    this.isSystemMessage = false,
    this.friend,
    this.isAIResponse = false,
  });
}
