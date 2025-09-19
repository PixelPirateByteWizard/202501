import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';
import '../providers/event_provider.dart';
import '../models/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../theme/app_theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add initial greeting message if chat is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final aiProvider = context.read<AIProvider>();
      if (aiProvider.chatMessages.isEmpty) {
        _addWelcomeMessage();
      }
    });
  }

  void _addWelcomeMessage() {
    final aiProvider = context.read<AIProvider>();
    final welcomeMessage = ChatMessage(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      content: "Hi! I'm Kaelix, your AI scheduling assistant. I can help you:\n\n• Schedule meetings and events\n• Optimize your calendar\n• Find free time slots\n• Resolve scheduling conflicts\n• Suggest focus time blocks\n\nJust type what you need help with, like 'schedule a meeting tomorrow at 2pm' or 'show me my free time today'.",
      type: MessageType.ai,
      timestamp: DateTime.now(),
    );
    
    aiProvider.chatMessages.add(welcomeMessage);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _sendQuickMessage(message);
      _messageController.clear();
    }
  }

  void _sendQuickMessage(String message) {
    context.read<AIProvider>().sendMessage(message, onEventCreated: (event) {
      context.read<EventProvider>().addEvent(event);
    });
    _scrollToBottom();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [

                  
                  // Kaelix avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Kaelix info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kaelix',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Consumer<AIProvider>(
                          builder: (context, aiProvider, child) {
                            return Text(
                              aiProvider.isLoading ? 'Typing...' : 'Online - Ready to help',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: aiProvider.isLoading 
                                  ? AppTheme.primaryEnd 
                                  : Colors.green.shade300,
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
            
            // Chat Messages
            Expanded(
              child: Consumer<AIProvider>(
                builder: (context, aiProvider, child) {
                  final messages = aiProvider.chatMessages;
                  
                  if (messages.isEmpty && !aiProvider.isLoading) {
                    return const Center(
                      child: Text('Start a conversation with Kaelix'),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: messages.length + (aiProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && aiProvider.isLoading) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ChatBubble(
                            message: ChatMessage(
                              id: 'loading',
                              content: '...',
                              type: MessageType.ai,
                              timestamp: DateTime.now(),
                            ),
                            isLoading: true,
                          ),
                        );
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ChatBubble(message: messages[index]),
                      );
                    },
                  );
                },
              ),
            ),
            
            // Quick Suggestions - Only show when chat is empty
            Consumer<AIProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.chatMessages.isEmpty && !aiProvider.isLoading) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Try asking me about:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _QuickActionChip(
                              label: 'Schedule a meeting',
                              onTap: () => _sendQuickMessage('Help me schedule a meeting'),
                            ),
                            _QuickActionChip(
                              label: 'Find free time',
                              onTap: () => _sendQuickMessage('When do I have free time today?'),
                            ),
                            _QuickActionChip(
                              label: 'Add focus time',
                              onTap: () => _sendQuickMessage('I need to add some focus time to my calendar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.dark800,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ask Kaelix anything...',
                          hintStyle: TextStyle(color: AppTheme.textSecondary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(color: AppTheme.textPrimary),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Consumer<AIProvider>(
                    builder: (context, aiProvider, child) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: aiProvider.isLoading 
                            ? LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade700])
                            : AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: IconButton(
                          onPressed: aiProvider.isLoading ? null : _sendMessage,
                          icon: Icon(
                            aiProvider.isLoading ? Icons.hourglass_empty : Icons.send,
                            color: Colors.white,
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
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}