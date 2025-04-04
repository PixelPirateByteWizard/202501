import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';
import '../../../services/storage_service.dart';

class EncryptionHistoryScreen extends StatefulWidget {
  const EncryptionHistoryScreen({super.key});

  @override
  State<EncryptionHistoryScreen> createState() =>
      _EncryptionHistoryScreenState();
}

class _EncryptionHistoryScreenState extends State<EncryptionHistoryScreen> {
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
        'type': 'encrypt',
        'input': 'Hello World',
        'output': 'SGVsbG8gV29ybGQ=',
        'password': '********',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .millisecondsSinceEpoch,
      },
      {
        'id': '2',
        'type': 'decrypt',
        'input': 'SGVsbG8gV29ybGQ=',
        'output': 'Hello World',
        'password': '********',
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch,
      },
      {
        'id': '3',
        'type': 'encrypt',
        'input': 'Secure password',
        'output': 'U2VjdXJlIHBhc3N3b3Jk',
        'password': '********',
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
            'Are you sure you want to clear all encryption history?'),
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
              // StorageService.clearHistory(StorageService.encryptionHistoryKey);
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
          'Encryption History',
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
                        Icons.history_rounded,
                        size: 64,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No encryption history yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Encrypted and decrypted content will appear here',
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
                        height: 140,
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
                            item['type'] == 'encrypt'
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.secondary.withOpacity(0.2),
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
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item['type'] == 'encrypt'
                                              ? AppColors.primary
                                                  .withOpacity(0.1)
                                              : AppColors.secondary
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item['type'] == 'encrypt'
                                              ? 'Encrypted'
                                              : 'Decrypted',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: item['type'] == 'encrypt'
                                                ? AppColors.primary
                                                : AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatDate(item['timestamp']),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.copy_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _copyToClipboard(item['output']),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Input
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      'Input:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item['input'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Output
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      'Output:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item['output'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Password
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      'Password:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMedium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item['password'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
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
