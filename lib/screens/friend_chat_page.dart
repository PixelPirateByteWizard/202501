import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/eco_friend.dart';
import '../services/ai_chat_service.dart';
import 'dart:async';
import 'dart:math';
import '../screens/friend_profile_page.dart';

class FriendChatPage extends StatefulWidget {
  final EcoFriend friend;

  const FriendChatPage({
    super.key,
    required this.friend,
  });

  @override
  State<FriendChatPage> createState() => _FriendChatPageState();
}

class _FriendChatPageState extends State<FriendChatPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isWaitingForResponse = false;
  Timer? _messageTimer;
  final Random _random = Random();
  final List<int> _sentMessageIndices = [];

  @override
  void initState() {
    super.initState();
    _sendWelcomeMessage();
    _scheduleNextMessage();
  }

  void _sendWelcomeMessage() {
    setState(() {
      _messages.add(_ChatMessage(
        content:
            "Hi! I'm ${widget.friend.name}. ${widget.friend.bio} Let's chat about environmental protection! 👋",
        isBot: true,
      ));
    });
  }

  void _scheduleNextMessage() {
    if (_sentMessageIndices.length >= widget.friend.presetMessages.length)
      return;

    _messageTimer = Timer(
      Duration(seconds: 8 + _random.nextInt(12)),
      () {
        if (mounted) {
          _sendRandomPresetMessage();
          _scheduleNextMessage();
        }
      },
    );
  }

  void _sendRandomPresetMessage() {
    final availableIndices = List<int>.generate(
      widget.friend.presetMessages.length,
      (i) => i,
    ).where((i) => !_sentMessageIndices.contains(i)).toList();

    if (availableIndices.isEmpty) return;

    final randomIndex =
        availableIndices[_random.nextInt(availableIndices.length)];
    _sentMessageIndices.add(randomIndex);

    setState(() {
      _messages.add(_ChatMessage(
        content: widget.friend.presetMessages[randomIndex],
        isBot: true,
      ));
    });
    _scrollToBottom();
  }

  void _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isWaitingForResponse) return;

    setState(() {
      _messages.add(_ChatMessage(
        content: text,
        isBot: false,
      ));
      _isWaitingForResponse = true;
    });

    _textController.clear();
    _scrollToBottom();

    String context = '''
    Expert Name: ${widget.friend.name}
    Title: ${widget.friend.title}
    Expertise: ${widget.friend.interests.join(', ')}
    Projects: ${widget.friend.projects.join(', ')}
    ''';

    try {
      final aiResponse = await AIChatService.getAIResponse(text, context);

      if (mounted && aiResponse != null) {
        setState(() {
          _messages.add(_ChatMessage(
            content: aiResponse,
            isBot: true,
          ));
        });
      } else {
        setState(() {
          _messages.add(_ChatMessage(
            content:
                "Sorry, I couldn't process your message at the moment. Please try again.",
            isBot: true,
          ));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            content:
                "Network error. Please check your connection and try again.",
            isBot: true,
          ));
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWaitingForResponse = false;
        });
        _scrollToBottom();
      }
    }
  }

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
  void dispose() {
    _messageTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0B2E), // 深蓝紫色背景
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FriendProfilePage(friend: widget.friend),
                    ),
                  );
                },
                child: Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset(
                        widget.friend.avatar,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friend.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.friend.title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.isBot) ...[
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(
                    widget.friend.avatar,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
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
              ),
              child: Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String content;
  final bool isBot;

  _ChatMessage({
    required this.content,
    required this.isBot,
  });
}
