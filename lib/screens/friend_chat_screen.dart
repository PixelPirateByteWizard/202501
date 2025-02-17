import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/friend_model.dart';
import 'dart:math';
import 'dart:async';
import '../models/ai_language_processor.dart';
import 'friend_profile_screen.dart';

class FriendChatScreen extends StatefulWidget {
  final Friend friend;

  const FriendChatScreen({
    super.key,
    required this.friend,
  });

  @override
  State<FriendChatScreen> createState() => _FriendChatScreenState();
}

class _FriendChatScreenState extends State<FriendChatScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final Random _random = Random();
  Timer? _messageTimer;
  bool _isInitialMessagesComplete = false;
  late ThemeData _theme;
  late final AnimationController _noteAnimationController;
  late final List<Animation<double>> _noteAnimations;
  final AILanguageProcessor _aiProcessor = AILanguageProcessor();
  final Set<String> _sentMessageContents = {};

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
      'content': 'Hi! Nice to meet you! Let\'s talk about music! 😊',
      'timestamp': DateTime.now(),
    });

    setState(() {});
    _scrollToBottom();

    // Schedule the first random message
    _scheduleNextRandomMessage();
  }

  void _scheduleNextRandomMessage() {
    if (_isLoading) return; // 如果正在加载AI回复，不发送新消息

    // 获取未发送的消息
    final unsentMessages = widget.friend.instrumentMessages
        .where((msg) => !_sentMessageContents.contains(msg.content))
        .toList();

    if (unsentMessages.isEmpty) {
      _isInitialMessagesComplete = true;
      return;
    }

    // 随机选择一条未发送的消息
    final randomMessage =
        unsentMessages[_random.nextInt(unsentMessages.length)];

    _messageTimer = Timer(
      Duration(milliseconds: 2000 + _random.nextInt(3000)), // 2-5秒随机延迟
      () {
        if (!mounted) return;

        setState(() {
          _messages.add({
            'isUser': false,
            'content': randomMessage.content,
            'timestamp': DateTime.now(),
          });
          _sentMessageContents.add(randomMessage.content); // 记录已发送的消息
        });

        _scrollToBottom();

        // 继续安排下一条消息
        _scheduleNextRandomMessage();
      },
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

    _messageTimer?.cancel(); // 取消当前计划的消息

    setState(() {
      _messages.add({
        'isUser': true,
        'content': text,
        'timestamp': DateTime.now(),
      });
      _textController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Get AI response
      final response = await _aiProcessor.generateResponse(text);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _messages.add({
          'isUser': false,
          'content': response,
          'timestamp': DateTime.now(),
        });
      });

      _scrollToBottom();

      // AI回复后，如果还有未发送的消息，继续发送
      if (!_isInitialMessagesComplete) {
        _scheduleNextRandomMessage();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _messages.add({
          'isUser': false,
          'content': 'Sorry, I encountered an error. Please try again later.',
          'timestamp': DateTime.now(),
        });
      });

      _scrollToBottom();

      // 即使AI回复出错，也继续发送好友消息
      if (!_isInitialMessagesComplete) {
        _scheduleNextRandomMessage();
      }
    }
  }

  // Add new method to handle message options
  void _showMessageOptions(Map<String, dynamic> message) {
    if (message['isUser']) return; // Only show options for friend messages

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.report_problem_outlined,
                    color: Colors.orange),
                title: const Text('Report Message'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete Message'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _reportMessage(Map<String, dynamic> message) {
    // Show report confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Message'),
        content: const Text('Are you sure you want to report this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add message content to blocked messages
              _sentMessageContents.add(message['content']);
              // Remove the message from chat
              setState(() {
                _messages.remove(message);
              });
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message reported and removed')),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteMessage(Map<String, dynamic> message) {
    // Add message content to blocked messages so it won't appear again
    _sentMessageContents.add(message['content']);
    // Remove the message from chat
    setState(() {
      _messages.remove(message);
    });
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
    );
  }

  // Update the message bubble in ListView.builder
  Widget _buildMessageBubble(Map<String, dynamic> message, bool isUser) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
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
                    widget.friend.avatarAsset,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.9),
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
              // Friend info card
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
                    // Back button
                    GestureDetector(
                      onTap: () {
                        _messageTimer?.cancel();
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
                    // Friend avatar
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FriendProfileScreen(friend: widget.friend),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'profile_${widget.friend.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              widget.friend.avatarAsset,
                              fit: BoxFit.cover,
                              alignment: const Alignment(0, -0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Friend info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.friend.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (widget.friend.isOnline)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.friend.musicExperience} years experience • ${widget.friend.mainInstrument.join(", ")}',
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
              // Chat content area
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['isUser'] as bool;
                    return _buildMessageBubble(message, isUser);
                  },
                ),
              ),
              // Loading animation
              if (_isLoading) _buildLoadingIndicator(),
              // Input area
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
    _aiProcessor.terminate();
    _sentMessageContents.clear();
    super.dispose();
  }

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
                widget.friend.avatarAsset,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.9),
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
                            color: widget.friend.themeColor,
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
