import 'package:flutter/material.dart';
import '../services/ai_chat_service.dart';
import '../services/chat_storage_service.dart';
import '../models/chat_message.dart';
import 'dart:async';

class AIAssistantChat extends StatefulWidget {
  const AIAssistantChat({Key? key}) : super(key: key);

  @override
  State<AIAssistantChat> createState() => _AIAssistantChatState();
}

class _AIAssistantChatState extends State<AIAssistantChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isLoading = true;
  String _conversationContext = '';

  // UI Colors
  static const Color primaryColor = Color(0xFF6B4DE3);
  static const Color backgroundColor = Color(0xFF0A0B2E);
  static const Color cardColor = Color(0xFF2A2D5F);
  static const Color accentColor = Color(0xFF8B6BF3);
  static const Color userBubbleColor = Color(0xFF8B6BF3);
  static const Color botBubbleColor = Color(0xFF2A2D5F);

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final chatHistory = await ChatStorageService.loadChatHistory();
    setState(() {
      _messages.addAll(chatHistory);
      _isLoading = false;
    });

    if (_messages.isNotEmpty) {
      _updateConversationContext();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _scrollToBottom();

    // Update conversation context
    _updateConversationContext();

    // Save chat history
    await ChatStorageService.saveChatHistory(_messages);

    // Get AI response
    final response =
        await AIChatService.getAIResponse(text, _conversationContext);

    final botMessage = ChatMessage(
      text: response ??
          "Sorry, I couldn't process your request. Please try again later.",
      isUser: false,
    );

    setState(() {
      _isTyping = false;
      _messages.add(botMessage);
    });

    // Save updated chat history
    await ChatStorageService.saveChatHistory(_messages);

    _scrollToBottom();
  }

  void _updateConversationContext() {
    // Create a context from the last few messages (up to 5)
    final recentMessages = _messages.length > 5
        ? _messages.sublist(_messages.length - 5)
        : _messages;

    _conversationContext = recentMessages.map((msg) {
      return "${msg.isUser ? 'User' : 'Assistant'}: ${msg.text}";
    }).join('\n');
  }

  Future<void> _clearChatHistory() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text(
            'Clear Chat History',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to clear all chat history? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () async {
                await ChatStorageService.clearChatHistory();
                setState(() {
                  _messages.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: accentColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          iconTheme: const IconThemeData(
              color: Colors.white), // Make back button white
          title: const Text(
            'Eco Assistant',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (_messages.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white70),
                onPressed: _clearChatHistory,
                tooltip: 'Clear chat history',
              ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () => _showInfoDialog(context),
              tooltip: 'About this assistant',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildWelcomeScreen()
                        : _buildChatList(),
                  ),
                  if (_isTyping) _buildTypingIndicator(),
                  _buildInputArea(),
                ],
              ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_outlined,
                size: 60,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Environmental Assistant',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Ask me anything about environmental protection, sustainability, and eco-friendly practices.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildSuggestedQuestion('How can I reduce plastic waste?'),
            const SizedBox(height: 12),
            _buildSuggestedQuestion('What are renewable energy sources?'),
            const SizedBox(height: 12),
            _buildSuggestedQuestion('Tips for water conservation at home'),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestion(String question) {
    return InkWell(
      onTap: () => _handleSubmit(question),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              color: accentColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildChatBubble(message);
      },
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(isUser),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? userBubbleColor : botBubbleColor,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(0),
                  bottomRight: !isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(0),
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(isUser),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isUser ? userBubbleColor : accentColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          isUser ? Icons.person : Icons.eco,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _buildAvatar(false),
          const SizedBox(width: 12),
          const Text(
            "Typing...",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Ask something about environment...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _handleSubmit,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B6BF3),
                    Color(0xFF6B4DE3),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
                onPressed: () => _handleSubmit(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'About Eco Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This AI assistant is designed to provide information about environmental protection and sustainability.\n\n'
                  'The assistant can answer questions about:\n'
                  '• Recycling and waste management\n'
                  '• Renewable energy\n'
                  '• Conservation practices\n'
                  '• Sustainable living tips\n'
                  '• Climate change\n\n'
                  'All responses are in English only.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B6BF3),
                          Color(0xFF6B4DE3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
