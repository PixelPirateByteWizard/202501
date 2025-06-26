import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Help & Guide',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.secondaryText,
          tabs: const [
            Tab(text: 'How to Play', icon: Icon(Icons.play_circle, size: 20)),
            Tab(text: 'Game Rules', icon: Icon(Icons.rule, size: 20)),
            Tab(text: 'FAQ', icon: Icon(Icons.help, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHowToPlayTab(),
          _buildGameRulesTab(),
          _buildFAQTab(),
        ],
      ),
    );
  }

  Widget _buildHowToPlayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHelpCard(
            title: 'Welcome to Alchemist\'s Palette!',
            icon: Icons.auto_awesome,
            content:
                'Master the ancient art of color alchemy by synthesizing primary colors into secondary colors. Complete challenging orders and unlock achievements as you progress through infinite levels.',
          ),
          _buildStepCard(
            stepNumber: '1',
            title: 'Understanding Colors',
            content:
                'There are two types of colors in the game:\n\n• Primary Colors (Red, Yellow, Blue): Cannot be matched directly but can be synthesized\n• Secondary Colors (Orange, Green, Purple): Can be matched in groups of 3 or more',
            color: Colors.blue,
          ),
          _buildStepCard(
            stepNumber: '2',
            title: 'Color Synthesis',
            content:
                'Tap two adjacent primary colors to synthesize them:\n\n🔴 Red + 🟡 Yellow = 🟠 Orange\n🔴 Red + 🔵 Blue = 🟣 Purple\n🟡 Yellow + 🔵 Blue = 🟢 Green',
            color: Colors.green,
          ),
          _buildStepCard(
            stepNumber: '3',
            title: 'Making Matches',
            content:
                'Match 3 or more secondary colors in a row (horizontal or vertical) to clear them and earn points. Cleared colors contribute to your level objectives.',
            color: Colors.orange,
          ),
          _buildStepCard(
            stepNumber: '4',
            title: 'Complete Objectives',
            content:
                'Each level has specific color collection goals shown in the "Alchemist\'s Order" section. Collect the required amounts of each secondary color to win the level.',
            color: Colors.purple,
          ),
          _buildStepCard(
            stepNumber: '5',
            title: 'Strategy Tips',
            content:
                '• Plan your moves carefully - you have limited moves per level\n• Look for cascade opportunities when colors fall\n• Focus on creating the colors you need most\n• Use the synthesis rules reference at the bottom',
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildGameRulesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRuleCard(
            title: 'Basic Rules',
            icon: Icons.rule,
            rules: [
              'You can only swap adjacent pieces (horizontal or vertical)',
              'Primary colors can only be synthesized, not matched',
              'Secondary colors can only be matched, not synthesized',
              'Matches must be 3 or more pieces in a row',
              'Gravity applies after each move - pieces fall down',
            ],
          ),
          _buildRuleCard(
            title: 'Synthesis Rules',
            icon: Icons.science,
            rules: [
              'Red + Yellow = Orange',
              'Red + Blue = Purple',
              'Yellow + Blue = Green',
              'Both pieces become the synthesized color',
              'Synthesis counts as one move',
            ],
          ),
          _buildRuleCard(
            title: 'Matching Rules',
            icon: Icons.celebration,
            rules: [
              'Match 3+ secondary colors in horizontal or vertical lines',
              'Diagonal matches do not count',
              'All matched pieces are removed from the board',
              'New pieces fall to fill empty spaces',
              'Chain reactions can occur',
            ],
          ),
          _buildRuleCard(
            title: 'Scoring System',
            icon: Icons.star,
            rules: [
              'Each matched piece = 10 points',
              'Bonus points for longer matches',
              'Efficiency bonus for completing with moves left',
              'No points deducted for failed moves',
              'Score contributes to achievements',
            ],
          ),
          _buildRuleCard(
            title: 'Level Objectives',
            icon: Icons.flag,
            rules: [
              'Collect specific amounts of secondary colors',
              'Complete objectives within the move limit',
              'Objectives increase in difficulty as you progress',
              'Some levels may have multiple color requirements',
              'Infinite levels with procedural generation',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFAQItem(
            question: 'How do I restart a level?',
            answer:
                'Currently, you cannot restart a level mid-game. If you run out of moves, you can retry the same level. You can reset all progress in Settings > Reset All Progress.',
          ),
          _buildFAQItem(
            question: 'Can I undo a move?',
            answer:
                'No, moves cannot be undone. This is part of the strategic challenge. Plan your moves carefully before making them.',
          ),
          _buildFAQItem(
            question: 'What happens when I run out of moves?',
            answer:
                'If you don\'t complete the level objectives within the move limit, you can retry the same level. Your best scores are always saved.',
          ),
          _buildFAQItem(
            question: 'How are achievements unlocked?',
            answer:
                'Achievements are unlocked automatically as you play. They track various milestones like syntheses made, matches cleared, levels completed, and efficiency.',
          ),
          _buildFAQItem(
            question: 'Is my progress saved automatically?',
            answer:
                'Yes, all progress including level completions, achievements, and statistics are saved automatically to your device.',
          ),
          _buildFAQItem(
            question: 'Can I play offline?',
            answer:
                'Yes! Alchemist\'s Palette is completely offline. No internet connection is required to play.',
          ),
          _buildFAQItem(
            question: 'How many levels are there?',
            answer:
                'The game features infinite procedural levels. After completing the initial designed levels, new levels are generated automatically with increasing difficulty.',
          ),
          _buildFAQItem(
            question: 'Can I change the difficulty?',
            answer:
                'Difficulty increases naturally as you progress through levels. There are no manual difficulty settings.',
          ),
          _buildFAQItem(
            question: 'What do the statistics track?',
            answer:
                'Statistics track your total games played, levels completed, highest score, total syntheses, matches, moves, and more. View them in the Statistics screen.',
          ),
          _buildFAQItem(
            question: 'How do I turn off sound/haptics?',
            answer:
                'Go to Settings and toggle off "Sound Effects" or "Haptic Feedback" as desired.',
          ),
          _buildFAQItem(
            question: 'My game is running slowly, what can I do?',
            answer:
                'Try closing other apps to free up memory. The game is optimized for smooth performance on most devices.',
          ),
          _buildFAQItem(
            question: 'Can I backup my progress?',
            answer:
                'Progress is stored locally on your device. Make sure to keep your device backed up through your device\'s backup system.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.contact_support,
                  color: AppColors.accent,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Still Need Help?',
                  style: SafeFonts.imFellEnglishSc(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use the Feedback option in Settings to send us your questions or suggestions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.cyanAccent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: SafeFonts.imFellEnglishSc(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required String title,
    required IconData icon,
    required List<String> rules,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: SafeFonts.imFellEnglishSc(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        iconColor: AppColors.accent,
        collapsedIconColor: AppColors.secondaryText,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
