import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';

class WordCountScreen extends StatefulWidget {
  const WordCountScreen({super.key});

  @override
  State<WordCountScreen> createState() => _WordCountScreenState();
}

class _WordCountScreenState extends State<WordCountScreen> {
  final TextEditingController _textController = TextEditingController();

  int _characterCount = 0;
  int _wordCount = 0;
  int _sentenceCount = 0;
  int _paragraphCount = 0;
  Map<String, int> _characterFrequency = {};
  bool _hasAnalyzed = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _analyzeText() {
    final text = _textController.text;

    if (text.isEmpty) {
      setState(() {
        _characterCount = 0;
        _wordCount = 0;
        _sentenceCount = 0;
        _paragraphCount = 0;
        _characterFrequency = {};
        _hasAnalyzed = false;
      });
      return;
    }

    // Count characters (excluding spaces)
    final charactersNoSpaces = text.replaceAll(' ', '');
    final characterCount = charactersNoSpaces.length;

    // Count words
    final wordRegExp = RegExp(r'\b\w+\b');
    final wordMatches = wordRegExp.allMatches(text);
    final wordCount = wordMatches.length;

    // Count sentences
    final sentenceRegExp = RegExp(r'[.!?]+');
    final sentenceMatches = sentenceRegExp.allMatches(text);
    final sentenceCount = sentenceMatches.length;

    // Count paragraphs
    final paragraphRegExp = RegExp(r'\n\s*\n');
    final paragraphMatches = paragraphRegExp.allMatches('\n$text\n');
    final paragraphCount = paragraphMatches.length + 1;

    // Calculate character frequency
    final Map<String, int> characterFrequency = {};
    for (int i = 0; i < text.length; i++) {
      final char = text[i].toLowerCase();
      if (char.trim().isNotEmpty) {
        characterFrequency[char] = (characterFrequency[char] ?? 0) + 1;
      }
    }

    // Sort character frequency by count (descending)
    final sortedFrequency = Map.fromEntries(characterFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));

    // Take only top 10 most frequent characters
    final top10Frequency = Map.fromEntries(sortedFrequency.entries.take(10));

    setState(() {
      _characterCount = characterCount;
      _wordCount = wordCount;
      _sentenceCount = sentenceCount;
      _paragraphCount = paragraphCount;
      _characterFrequency = top10Frequency;
      _hasAnalyzed = true;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  void _clearText() {
    setState(() {
      _textController.clear();
      _characterCount = 0;
      _wordCount = 0;
      _sentenceCount = 0;
      _paragraphCount = 0;
      _characterFrequency = {};
      _hasAnalyzed = false;
    });
  }

  void _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _textController.text = clipboardData.text!;
      });
      _analyzeText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and description
            Text(
              'Word Count Analyzer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze your text for word count and more',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            Row(
              children: [
                _ActionChip(
                  label: 'Paste',
                  icon: Icons.content_paste_rounded,
                  onTap: _pasteFromClipboard,
                ),
                const SizedBox(width: 12),
                _ActionChip(
                  label: 'Clear',
                  icon: Icons.clear_rounded,
                  onTap: _clearText,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Input field with glassmorphism
            GlassmorphicContainer(
              width: double.infinity,
              height: 200,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 0.5,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Type or paste your text here...',
                    hintStyle: TextStyle(color: AppColors.textLight),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      setState(() {
                        _hasAnalyzed = false;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Analyze button
            Center(
              child: ElevatedButton(
                onPressed: _analyzeText,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Analyze Text',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Analysis results
            if (_hasAnalyzed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analysis Results',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Statistics cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Characters',
                          value: _characterCount.toString(),
                          icon: Icons.text_fields_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Words',
                          value: _wordCount.toString(),
                          icon: Icons.translate_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Sentences',
                          value: _sentenceCount.toString(),
                          icon: Icons.short_text_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Paragraphs',
                          value: _paragraphCount.toString(),
                          icon: Icons.notes_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Character frequency
                  if (_characterFrequency.isNotEmpty) ...[
                    Text(
                      'Character Frequency',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    GlassmorphicContainer(
                      width: double.infinity,
                      height: 200,
                      borderRadius: 20,
                      blur: 10,
                      alignment: Alignment.center,
                      border: 0.5,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondary.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: _characterFrequency.entries.map((entry) {
                            final percentage =
                                (entry.value / _characterCount * 100)
                                    .toStringAsFixed(1);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor:
                                                  entry.value / _characterCount,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: AppColors
                                                        .primaryGradient,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${entry.value} occurrences ($percentage%)',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// Action chip for quick actions
class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Statistic card for displaying analysis results
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 20,
      blur: 5,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.white.withOpacity(0.4),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withOpacity(0.05),
          Colors.white.withOpacity(0.05),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
