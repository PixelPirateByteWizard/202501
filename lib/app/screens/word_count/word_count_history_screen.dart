import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';
import '../../../services/storage_service.dart';

class WordCountHistoryScreen extends StatefulWidget {
  const WordCountHistoryScreen({super.key});

  @override
  State<WordCountHistoryScreen> createState() => _WordCountHistoryScreenState();
}

class _WordCountHistoryScreenState extends State<WordCountHistoryScreen> {
  List<Map<String, dynamic>> _historyItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    // In a real app, this would load from SharedPreferences via StorageService
    // For this UI demo, we'll use mock data
    await Future.delayed(const Duration(milliseconds: 500));

    final mockHistory = [
      {
        'id': '1',
        'text':
            'This is a sample text for word count analysis. It contains several sentences and a variety of words.',
        'characterCount': 85,
        'wordCount': 18,
        'sentenceCount': 2,
        'paragraphCount': 1,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .millisecondsSinceEpoch,
      },
      {
        'id': '2',
        'text':
            "Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.",
        'characterCount': 121,
        'wordCount': 19,
        'sentenceCount': 1,
        'paragraphCount': 1,
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch,
      },
      {
        'id': '3',
        'text':
            'The quick brown fox jumps over the lazy dog. This sentence contains all the letters in the English alphabet.',
        'characterCount': 93,
        'wordCount': 18,
        'sentenceCount': 2,
        'paragraphCount': 1,
        'timestamp': DateTime.now()
            .subtract(const Duration(days: 1))
            .millisecondsSinceEpoch,
      },
    ];

    setState(() {
      _historyItems = mockHistory;
      _isLoading = false;
    });
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Clear History'),
        content: const Text(
            'Are you sure you want to clear all word count history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMedium,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _historyItems = [];
              });
              // In a real app, this would clear from SharedPreferences via StorageService
              // StorageService.clearHistory(StorageService.wordCountHistoryKey);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Word Count History',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.primary,
            ),
            onPressed: _historyItems.isEmpty ? null : _clearHistory,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _historyItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.text_fields_rounded,
                        size: 64,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No word count history yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Analyzed text will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _historyItems.length,
                  itemBuilder: (context, index) {
                    final item = _historyItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 180,
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
                            AppColors.primary.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(item['timestamp']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.copy_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _copyToClipboard(item['text']),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),

                              // Text preview
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  item['text'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Statistics
                              Expanded(
                                child: Row(
                                  children: [
                                    _StatItem(
                                      icon: Icons.text_fields_rounded,
                                      title: 'Characters',
                                      value: '${item['characterCount']}',
                                    ),
                                    const SizedBox(width: 12),
                                    _StatItem(
                                      icon: Icons.translate_rounded,
                                      title: 'Words',
                                      value: '${item['wordCount']}',
                                    ),
                                    const SizedBox(width: 12),
                                    _StatItem(
                                      icon: Icons.short_text_rounded,
                                      title: 'Sentences',
                                      value: '${item['sentenceCount']}',
                                    ),
                                    const SizedBox(width: 12),
                                    _StatItem(
                                      icon: Icons.notes_rounded,
                                      title: 'Paragraphs',
                                      value: '${item['paragraphCount']}',
                                    ),
                                  ],
                                ),
                              ),

                              // Button to re-analyze
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Re-analyze functionality would go here
                                  },
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  label: Text(
                                    'Re-analyze',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// Statistic item for displaying analysis results
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
