import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/ai_provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLoading;

  const ChatBubble({
    super.key,
    required this.message,
    this.isLoading = false,
  });

  void _handleQuickAction(BuildContext context, String action) {
    try {
      final aiProvider = context.read<AIProvider>();
      
      if (action == 'Add to Calendar') {
        final event = aiProvider.createEventFromPendingData();
        if (event != null) {
          context.read<EventProvider>().addEvent(event);
          aiProvider.handleQuickAction(action);
          
          // Show success feedback
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Event "${event.title}" added to calendar'),
                backgroundColor: AppTheme.primaryEnd,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } else if (action == 'Modify Details') {
        // Send a message to modify the event
        aiProvider.sendMessage('I want to modify the event details');
      } else if (action == 'Create Event') {
        aiProvider.sendMessage('Help me create a new event');
      } else if (action == 'Show Calendar') {
        // Navigate to agenda screen
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/agenda');
        }
      } else if (action == 'Schedule Meeting') {
        aiProvider.sendMessage('Help me schedule a meeting');
      } else if (action == 'Find Free Time') {
        aiProvider.sendMessage('Show me my available time slots today');
      } else if (action == 'Optimize Calendar') {
        aiProvider.sendMessage('Please optimize my calendar for better productivity');
      }
    } catch (e) {
      // Handle errors gracefully
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser ? AppTheme.primaryGradient : null,
          color: isUser ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) ...[
              const _TypingIndicator(),
            ] else ...[
              Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              
              // Removed quick action buttons to prevent issues
              // Users can continue the conversation by typing
            ],
            
            if (!isLoading) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3 + (_animations[index].value * 0.7)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}