import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: "How do I play Coria?",
      answer:
          "Coria is a tile-merging puzzle game. Swipe in any direction to move all tiles. When two tiles with the same number touch, they merge into one. Special rule: 1 and 2 merge to create 3. Try to create the highest tile possible!",
    ),
    FAQItem(
      question: "How does the scoring system work?",
      answer:
          "You earn points every time tiles merge. The score you get equals the value of the resulting tile. For example, merging two 6 tiles gives you 12 points. Try to create higher value tiles for more points!",
    ),
    FAQItem(
      question: "What happens when the board is full?",
      answer:
          "When the board is full and no more moves are possible, the game ends. Your final score and statistics will be recorded. You can then start a new game or review your performance in the statistics screen.",
    ),
    FAQItem(
      question: "What are the different game modes?",
      answer:
          "Coria offers several game modes: Classic Mode (standard gameplay), Zen Mode (relaxed, endless play), and Time Challenge (score as high as possible within a time limit).",
    ),
    FAQItem(
      question: "How do I enable or disable sound?",
      answer:
          "You can toggle sound effects in the Settings menu. Navigate to Settings from the main menu and use the Sound toggle switch.",
    ),
    FAQItem(
      question: "What is haptic feedback?",
      answer:
          "Haptic feedback provides tactile responses when you interact with the game, like subtle vibrations when tiles move or merge. You can enable or disable this feature in the Settings menu.",
    ),
    FAQItem(
      question: "How do I reset my high score?",
      answer:
          "To reset your high score, go to the Settings menu and tap on 'Reset High Score'. You'll be asked to confirm this action, as it cannot be undone.",
    ),
    FAQItem(
      question: "The game is running slowly. What can I do?",
      answer:
          "Try closing other apps running in the background. If the issue persists, restart your device. If you continue experiencing performance issues, please contact our support team.",
    ),
  ];

  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  List<FAQItem> get _filteredFAQs {
    if (_searchQuery.isEmpty) {
      return _faqItems;
    }

    return _faqItems
        .where(
          (item) =>
              item.question.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              item.answer.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: UIConstants.BACKGROUND_COLOR,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // Dismiss keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                Padding(
                  padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(
                          UIConstants.SPACING_SMALL,
                        ),
                        borderRadius: BorderRadius.circular(
                          UIConstants.BORDER_RADIUS_XLARGE,
                        ),
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ),
                      const Text(
                        "Help Center",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance for the back button
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.SPACING_MEDIUM,
                  ),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.SPACING_MEDIUM,
                      vertical: 4,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Search for help...",
                        hintStyle: TextStyle(color: Colors.white60),
                        prefixIcon: Icon(Icons.search, color: Colors.white60),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      cursorColor: UIConstants.CYAN_COLOR,
                    ),
                  ),
                ),

                const SizedBox(height: UIConstants.SPACING_MEDIUM),

                // FAQ list
                Expanded(
                  child: _filteredFAQs.isEmpty
                      ? const Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(color: Colors.white60),
                          ),
                        )
                      : GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(
                              UIConstants.SPACING_MEDIUM,
                            ),
                            // Dismiss keyboard on scroll
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: _filteredFAQs.length,
                            itemBuilder: (context, index) {
                              return _buildFAQItem(_filteredFAQs[index]);
                            },
                          ),
                        ),
                ),

                // Contact support button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.SPACING_MEDIUM),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          onExpansionChanged: (_) {
            // Dismiss keyboard when expanding/collapsing FAQ items
            FocusScope.of(context).unfocus();
          },
          title: Text(
            item.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconColor: UIConstants.CYAN_COLOR,
          collapsedIconColor: Colors.white60,
          tilePadding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
          childrenPadding: const EdgeInsets.only(
            left: UIConstants.SPACING_MEDIUM,
            right: UIConstants.SPACING_MEDIUM,
            bottom: UIConstants.SPACING_MEDIUM,
          ),
          children: [
            Text(
              item.answer,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: UIConstants.TEXT_SECONDARY_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
