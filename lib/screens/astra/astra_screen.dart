import 'dart:convert';
import 'package:astrelexis/models/journal_entry.dart';
import 'package:astrelexis/services/ai_service.dart';
import 'package:astrelexis/services/storage_service.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:astrelexis/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class AstraScreen extends StatefulWidget {
  const AstraScreen({super.key});

  @override
  State<AstraScreen> createState() => _AstraScreenState();
}

class _AstraScreenState extends State<AstraScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AiService _aiService = AiService();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
        text:
            'Hello! I\'m Astra. You can ask me anything or tell me about your day.',
        isUser: false));
  }

  Future<void> _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _controller.clear();

    try {
      final journalContext = await _getJournalContext();
      final response =
          await _aiService.getResponse(text, context: journalContext);
      setState(() {
        _messages.insert(0, ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.insert(
            0, ChatMessage(text: 'Sorry, something went wrong.', isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getJournalContext() async {
    final entries = await _storageService.loadJournalEntries();
    if (entries.isEmpty) return '';

    // Get the 3 most recent entries
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentEntries = entries.take(3);

    return recentEntries
        .map((e) => 'Title: ${e.title}\nContent: ${e.content}')
        .join('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                const Text(
                  'Astra',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAstraOrb(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildChatBubble(context,
                          text: message.text, isUser: message.isUser);
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.accentTeal)),
                  ),
                _buildChatInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAstraOrb() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xCCD198FF),
            Color(0x807E57C2),
            Color(0x4D2E1A47),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowColor,
            blurRadius: 15.0,
            spreadRadius: 0.0,
          ),
          const BoxShadow(
            color: Color(0xFF583385),
            blurRadius: 60.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(BuildContext context,
      {required String text, required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GlassCard(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Text(
            text,
            style: const TextStyle(
                color: AppColors.textPrimary, height: 1.4, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Ask Astra anything...',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
                prefixIcon: Icon(
                  FontAwesomeIcons.star,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.paperPlane,
                color: AppColors.accentTeal),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
