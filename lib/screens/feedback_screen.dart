import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late TextEditingController _feedbackController;
  late TextEditingController _emailController;
  
  String _selectedCategory = 'General Feedback';
  int _rating = 5;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General Feedback',
    'Bug Report',
    'Feature Request',
    'Story Content',
    'User Interface',
    'Performance',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _feedbackController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your feedback before submitting'),
          backgroundColor: AppColors.statusError,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate submission delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback! We\'ll review it soon.'),
          backgroundColor: AppColors.statusOptimal,
        ),
      );

      // Clear form
      _feedbackController.clear();
      _emailController.clear();
      setState(() {
        _rating = 5;
        _selectedCategory = 'General Feedback';
      });
    }
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
                        'Feedback & Suggestions',
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
                                    Icons.feedback,
                                    color: AppColors.accentRose,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'We Value Your Input',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your feedback helps us improve Clockwork Legacy. Whether you\'ve found a bug, have a feature idea, or just want to share your thoughts, we\'d love to hear from you!',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Rating Section
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.vintageGold,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rate Your Experience',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'How would you rate Clockwork Legacy overall?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _rating = index + 1;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(
                                        Icons.star,
                                        size: 32,
                                        color: index < _rating
                                            ? AppColors.vintageGold
                                            : AppColors.lavenderWhite.withValues(alpha: 0.3),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  _getRatingText(_rating),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.vintageGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Category Selection
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category,
                                    color: AppColors.statusOptimal,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Feedback Category',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.deepNavy.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.statusOptimal.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCategory,
                                    isExpanded: true,
                                    dropdownColor: AppColors.slateBlue,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    items: _categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedCategory = newValue;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Feedback Text
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.edit,
                                    color: AppColors.accentRose,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Your Feedback',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _feedbackController,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: _getHintText(_selectedCategory),
                                  hintStyle: TextStyle(
                                    color: AppColors.lavenderWhite.withValues(alpha: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.accentRose.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.accentRose.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.accentRose,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.deepNavy.withValues(alpha: 0.5),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Email (Optional)
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: AppColors.statusWarning,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Email (Optional)',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'your.email@example.com',
                                  hintStyle: TextStyle(
                                    color: AppColors.lavenderWhite.withValues(alpha: 0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.statusWarning.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.statusWarning.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: AppColors.statusWarning,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.deepNavy.withValues(alpha: 0.5),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Provide your email if you\'d like us to follow up on your feedback.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.vintageGold,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColors.deepNavy,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Submitting...',
                                        style: TextStyle(
                                          color: AppColors.deepNavy,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'Submit Feedback',
                                    style: TextStyle(
                                      color: AppColors.deepNavy,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Alternative Contact Methods
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.alternate_email,
                                    color: AppColors.statusOptimal,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Other Ways to Reach Us',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildContactOption(
                                Icons.email,
                                'Direct Email',
                                'feedback@clockworklegacy.com',
                                'Send detailed feedback directly',
                              ),
                              _buildContactOption(
                                Icons.forum,
                                'Community Forum',
                                'community.clockworklegacy.com',
                                'Discuss with other players',
                              ),
                              _buildContactOption(
                                Icons.bug_report,
                                'Bug Tracker',
                                'bugs.clockworklegacy.com',
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

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor - Needs significant improvement';
      case 2:
        return 'Fair - Some issues to address';
      case 3:
        return 'Good - Generally satisfactory';
      case 4:
        return 'Very Good - Mostly excellent';
      case 5:
        return 'Excellent - Outstanding experience';
      default:
        return 'Please select a rating';
    }
  }

  String _getHintText(String category) {
    switch (category) {
      case 'Bug Report':
        return 'Please describe the bug you encountered, including steps to reproduce it and what you expected to happen...';
      case 'Feature Request':
        return 'Describe the new feature you\'d like to see and how it would improve your gaming experience...';
      case 'Story Content':
        return 'Share your thoughts about the AI-generated stories, narrative quality, or story-related features...';
      case 'User Interface':
        return 'Tell us about your experience with the game\'s interface, navigation, or visual design...';
      case 'Performance':
        return 'Report any performance issues like slow loading, crashes, or lag you\'ve experienced...';
      default:
        return 'Share your thoughts, suggestions, or any feedback about Clockwork Legacy...';
    }
  }

  Widget _buildContactOption(IconData icon, String title, String contact, String description) {
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