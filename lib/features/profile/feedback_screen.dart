import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: SafeArea(
        child: Column(
          children: [
            // Navigation Bar
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFFE6EDF3),
                      size: 28,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '反馈和建议',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE6EDF3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 28), // Balance the back button
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '我们珍视您的每一个想法，请在此处写下您的宝贵建议或遇到的问题。',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B949E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3447),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: TextField(
                          controller: _feedbackController,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(
                            color: Color(0xFFE6EDF3),
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: '请输入您的反馈...',
                            hintStyle: TextStyle(
                              color: Color(0xFF8B949E),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _isSubmitting ? null : _submitFeedback,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _isSubmitting 
                              ? const Color(0xFF8B949E) 
                              : const Color(0xFF50E3C2),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  '提交反馈',
                                  style: TextStyle(
                                    color: Color(0xFF1A1E2D),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() async {
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('感谢您的反馈！我们会认真考虑您的建议。'),
          backgroundColor: Color(0xFF4ADE80),
        ),
      );
      Navigator.pop(context);
    }
  }
}