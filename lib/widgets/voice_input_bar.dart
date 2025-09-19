import 'package:flutter/material.dart';
import '../screens/ai_chat_screen.dart';
import '../theme/app_theme.dart';

class VoiceInputBar extends StatelessWidget {
  const VoiceInputBar({super.key});

  void _openAIChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AIChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAIChat(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryEnd.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            
            const Expanded(
              child: Text(
                'Tap to chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppTheme.primaryEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

