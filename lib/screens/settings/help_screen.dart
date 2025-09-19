import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I create a new event?',
      answer: 'You can create events in several ways:\n\n1. Use the AI chat: Simply tell Kaelix "Schedule a meeting tomorrow at 2pm"\n2. Use the + button in the Agenda view\n3. Ask the AI assistant in natural language\n\nKaelix will understand your request and help you create the event with all the necessary details.',
    ),
    FAQItem(
      question: 'How does the AI scheduling work?',
      answer: 'Kaelix uses advanced AI to understand your scheduling needs:\n\n• Natural language processing to understand your requests\n• Smart conflict detection and resolution\n• Automatic time zone handling\n• Intelligent suggestions based on your patterns\n• Optimization recommendations for better productivity',
    ),
    FAQItem(
      question: 'Can I sync with other calendar apps?',
      answer: 'Currently, Kaelix works as a standalone calendar application. We are working on integrations with popular calendar services like Google Calendar, Outlook, and Apple Calendar. These features will be available in future updates.',
    ),
    FAQItem(
      question: 'How do I optimize my schedule?',
      answer: 'Use the Forge feature to optimize your schedule:\n\n1. Go to the Forge tab\n2. Select "Optimize" to see AI suggestions\n3. Review and accept recommendations\n4. Use the AI Assistant for personalized advice\n\nKaelix analyzes your patterns and suggests improvements for better productivity.',
    ),
    FAQItem(
      question: 'What are focus time blocks?',
      answer: 'Focus time blocks are dedicated periods for deep work without interruptions. Kaelix can:\n\n• Automatically suggest optimal focus times\n• Block distractions during focus periods\n• Analyze your most productive hours\n• Help you maintain work-life balance',
    ),
    FAQItem(
      question: 'How do I use voice commands?',
      answer: 'Voice control is coming soon! You\'ll be able to:\n\n• Create events by speaking\n• Ask questions about your schedule\n• Get AI recommendations through voice\n• Control the app hands-free\n\nStay tuned for this exciting feature in upcoming updates.',
    ),
    FAQItem(
      question: 'Is my data secure?',
      answer: 'Yes, your data security is our top priority:\n\n• All data is encrypted in transit and at rest\n• We follow industry-standard security practices\n• Your calendar data stays private and secure\n• We never share your personal information\n\nRead our Privacy Policy for complete details.',
    ),
    FAQItem(
      question: 'How do I delete my account?',
      answer: 'To delete your account:\n\n1. Go to Settings\n2. Contact our support team at support@kaelix.app\n3. Request account deletion\n4. We\'ll process your request within 48 hours\n\nNote: This action is irreversible and will permanently delete all your data.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Help & Support',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find answers to common questions and get support',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              
              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 32),
              
              // Getting Started Section
              _buildGettingStarted(),
              const SizedBox(height: 32),
              
              // FAQ Section
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: AppTheme.primaryEnd,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // FAQ Items
              ..._faqItems.map((item) => _buildFAQItem(item)),
              
              const SizedBox(height: 32),
              
              // Contact Support
              _buildContactSupport(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: AppTheme.primaryEnd,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.chat_bubble_outline,
                title: 'AI Chat Help',
                description: 'Learn how to use the AI assistant',
                onTap: () => _showAIChatHelp(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.video_library,
                title: 'Video Tutorials',
                description: 'Watch step-by-step guides',
                onTap: () => _showVideoTutorials(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.dark800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppTheme.primaryEnd,
                size: 24,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGettingStarted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Getting Started',
          style: TextStyle(
            color: AppTheme.primaryEnd,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildStepItem(
          step: '1',
          title: 'Explore the Interface',
          description: 'Familiarize yourself with the four main tabs: Agenda, Forge, Kaelix (AI), and Settings.',
        ),
        _buildStepItem(
          step: '2',
          title: 'Create Your First Event',
          description: 'Try saying "Schedule a meeting tomorrow at 2pm" to the AI assistant.',
        ),
        _buildStepItem(
          step: '3',
          title: 'Use the Forge',
          description: 'Check the Forge tab for productivity insights and schedule optimization.',
        ),
        _buildStepItem(
          step: '4',
          title: 'Customize Settings',
          description: 'Adjust notifications, AI preferences, and other settings to your liking.',
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String step,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconColor: AppTheme.primaryEnd,
        collapsedIconColor: AppTheme.textSecondary,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item.answer,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Still Need Help?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our support team is here to help you get the most out of Kaelix.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContactMethod(
                  icon: Icons.email,
                  title: 'Email Support',
                  value: 'support@kaelix.app',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContactMethod(
                  icon: Icons.schedule,
                  title: 'Response Time',
                  value: 'Within 24 hours',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _showAIChatHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dark800,
        title: const Text(
          'AI Chat Help',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Try these example commands:\n\n• "Schedule a meeting tomorrow at 2pm"\n• "Show my free time today"\n• "Add 2 hours of focus time"\n• "Optimize my schedule"\n• "When is my next meeting?"',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppTheme.primaryEnd),
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoTutorials() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dark800,
        title: const Text(
          'Video Tutorials',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Video tutorials are coming soon! We\'re creating comprehensive guides to help you master Kaelix.\n\nIn the meantime, explore the app and don\'t hesitate to contact support if you need help.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Okay',
              style: TextStyle(color: AppTheme.primaryEnd),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}