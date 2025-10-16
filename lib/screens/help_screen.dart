import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late ScrollController _scrollController;
  int _expandedIndex = -1;

  final List<Map<String, dynamic>> _helpSections = [
    {
      'title': 'Getting Started',
      'icon': Icons.play_circle,
      'color': AppColors.statusOptimal,
      'items': [
        {
          'question': 'How do I start playing?',
          'answer': 'After the tutorial, you\'ll arrive at the Main Menu. From here, you can access the Workshop, Archive, World Map, and Daily Quests. Start by exploring the World Map to begin your adventure.',
        },
        {
          'question': 'What is the main objective?',
          'answer': 'Clockwork Legacy is about exploration and discovery. Uncover the mysteries of the steampunk world, build mechanical devices, and experience unique AI-generated stories based on your choices.',
        },
        {
          'question': 'How do I save my progress?',
          'answer': 'Your progress is automatically saved as you play. All achievements, story progress, and workshop upgrades are preserved between sessions.',
        },
      ],
    },
    {
      'title': 'World Exploration',
      'icon': Icons.explore,
      'color': AppColors.vintageGold,
      'items': [
        {
          'question': 'How do I explore new areas?',
          'answer': 'Tap on locations in the World Map to explore them. Some areas may be locked and require specific items or achievements to access.',
        },
        {
          'question': 'What are the different map regions?',
          'answer': 'There are three main regions: Overworld (Victorian city), Underground (tunnel networks), and Sky City (floating platforms). Each has unique locations and stories.',
        },
        {
          'question': 'How does auto-exploration work?',
          'answer': 'Use the Auto Explore feature to send automatons to discover new content automatically. This is great for finding new stories when you\'re away from the game.',
        },
      ],
    },
    {
      'title': 'AI Stories & Choices',
      'icon': Icons.auto_stories,
      'color': AppColors.accentRose,
      'items': [
        {
          'question': 'How are stories generated?',
          'answer': 'Our AI system creates unique stories based on your location, previous choices, and current game state. Every playthrough offers different narrative experiences.',
        },
        {
          'question': 'Do my choices matter?',
          'answer': 'Yes! Your choices influence future story content and can unlock new locations, items, or story branches. The AI remembers your decisions.',
        },
        {
          'question': 'Can I review past stories?',
          'answer': 'Yes, use the Story History feature in the World Map to review all your previous adventures and the choices you made.',
        },
      ],
    },
    {
      'title': 'Workshop & Crafting',
      'icon': Icons.build_circle,
      'color': AppColors.statusWarning,
      'items': [
        {
          'question': 'How do I build items?',
          'answer': 'Visit the Mechanical Workshop to construct workstations and craft items. You\'ll need resources gathered from exploration and completed quests.',
        },
        {
          'question': 'What are workstations?',
          'answer': 'Workstations are specialized crafting stations that produce different types of items. Upgrade them to unlock new recipes and improve efficiency.',
        },
        {
          'question': 'How do I get resources?',
          'answer': 'Resources are obtained by exploring locations, completing daily quests, and achieving milestones. Different areas provide different types of resources.',
        },
      ],
    },
    {
      'title': 'Achievements & Progress',
      'icon': Icons.emoji_events,
      'color': AppColors.statusOptimal,
      'items': [
        {
          'question': 'How do I unlock achievements?',
          'answer': 'Achievements are unlocked by reaching specific milestones like generating stories, making choices, or exploring locations. Check the Achievements screen for your progress.',
        },
        {
          'question': 'What are daily quests?',
          'answer': 'Daily quests are automatically generated challenges that refresh every day. Complete them for rewards and to maintain steady progress.',
        },
        {
          'question': 'How do I track my progress?',
          'answer': 'Use the Progress Dashboard to view detailed statistics about your gameplay, including time played, stories generated, and achievements unlocked.',
        },
      ],
    },
    {
      'title': 'Troubleshooting',
      'icon': Icons.help_outline,
      'color': AppColors.statusError,
      'items': [
        {
          'question': 'The game is running slowly',
          'answer': 'Try adjusting the animation speed in Map Settings, or restart the app. Ensure you have sufficient device storage and memory available.',
        },
        {
          'question': 'Stories aren\'t generating',
          'answer': 'Story generation requires an internet connection. Check your connection and try again. If the problem persists, the AI service may be temporarily unavailable.',
        },
        {
          'question': 'I lost my progress',
          'answer': 'Game progress is saved locally. If you\'ve reinstalled the app or changed devices, progress may be lost. We recommend using your device\'s backup features.',
        },
        {
          'question': 'The app crashes frequently',
          'answer': 'Try restarting your device and ensuring you have the latest version of the game. If crashes continue, please contact support with your device information.',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.lavenderWhite,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Help & Support',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Introduction
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info,
                                    color: AppColors.vintageGold,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Welcome to Help Center',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Find answers to common questions and learn how to make the most of your Clockwork Legacy experience. Tap on any section below to expand it.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Help Sections
                        ..._helpSections.asMap().entries.map((entry) {
                          final index = entry.key;
                          final section = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildHelpSection(section, index),
                          );
                        }),

                        // Contact Support
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.contact_support,
                                    color: AppColors.statusOptimal,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Still Need Help?',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'If you can\'t find the answer you\'re looking for, don\'t hesitate to reach out to our support team:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              _buildContactMethod(
                                Icons.email,
                                'Email Support',
                                'support@clockworklegacy.com',
                                'Get detailed help via email',
                              ),
                              _buildContactMethod(
                                Icons.forum,
                                'Community Forum',
                                'community.clockworklegacy.com',
                                'Connect with other players',
                              ),
                              _buildContactMethod(
                                Icons.bug_report,
                                'Bug Reports',
                                'bugs@clockworklegacy.com',
                                'Report technical issues',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(Map<String, dynamic> section, int sectionIndex) {
    final isExpanded = _expandedIndex == sectionIndex;
    
    return GlassCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? -1 : sectionIndex;
              });
            },
            child: Row(
              children: [
                Icon(
                  section['icon'],
                  color: section['color'],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section['title'],
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.lavenderWhite,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            ...section['items'].map<Widget>((item) => _buildFAQItem(
                  item['question'],
                  item['answer'],
                  section['color'],
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.help_outline,
                  color: accentColor,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.vintageGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(IconData icon, String title, String contact, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.statusOptimal.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.statusOptimal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.vintageGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  contact,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.statusOptimal,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}