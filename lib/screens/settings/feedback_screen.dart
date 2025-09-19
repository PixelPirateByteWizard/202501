import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _selectedCategory = 'General Feedback';
  int _rating = 5;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General Feedback',
    'Bug Report',
    'Feature Request',
    'AI Assistant',
    'Performance Issue',
    'User Interface',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Suggestions'),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'We Value Your Feedback',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help us improve Solakai by sharing your thoughts and suggestions',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Quick Feedback Options
                _buildQuickFeedback(),
                const SizedBox(height: 32),
                
                // Rating Section
                _buildRatingSection(),
                const SizedBox(height: 24),
                
                // Category Selection
                _buildCategorySection(),
                const SizedBox(height: 24),
                
                // Contact Information
                _buildContactSection(),
                const SizedBox(height: 24),
                
                // Subject Field
                _buildTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  hint: 'Brief description of your feedback',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Message Field
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  hint: 'Please provide detailed feedback or suggestions...',
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    if (value.length < 10) {
                      return 'Please provide more detailed feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Submit Button
                _buildSubmitButton(),
                const SizedBox(height: 24),
                
                // Alternative Contact Methods
                _buildAlternativeContact(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Feedback',
          style: TextStyle(
            color: AppTheme.primaryEnd,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tap any option below for quick feedback:',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickFeedbackChip('Love the AI assistant! 🤖'),
            _buildQuickFeedbackChip('Great productivity insights 📊'),
            _buildQuickFeedbackChip('Easy to use interface 👍'),
            _buildQuickFeedbackChip('Helpful scheduling suggestions ⏰'),
            _buildQuickFeedbackChip('Need more customization options ⚙️'),
            _buildQuickFeedbackChip('Would like calendar sync 🔄'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickFeedbackChip(String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleQuickFeedback(text),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.dark800,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryEnd.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How would you rate Solakai?',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
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
                        ? AppTheme.primaryEnd
                        : AppTheme.textSecondary,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _getRatingText(_rating),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.dark800,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: AppTheme.dark700,
              style: const TextStyle(color: AppTheme.textPrimary),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information (Optional)',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'Your name',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'your@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            filled: true,
            fillColor: AppTheme.dark800,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.primaryEnd,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryEnd,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Feedback',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildAlternativeContact() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Other Ways to Reach Us',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactMethod(
            icon: Icons.email,
            title: 'Email',
            value: 'feedback@Solakai.app',
            description: 'Send us detailed feedback',
          ),
          const SizedBox(height: 12),
          _buildContactMethod(
            icon: Icons.bug_report,
            title: 'Bug Reports',
            value: 'bugs@Solakai.app',
            description: 'Report technical issues',
          ),
          const SizedBox(height: 12),
          _buildContactMethod(
            icon: Icons.lightbulb_outline,
            title: 'Feature Requests',
            value: 'features@Solakai.app',
            description: 'Suggest new features',
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String value,
    required String description,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryEnd,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title: $value',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
      ],
    );
  }

  void _handleQuickFeedback(String feedback) {
    setState(() {
      _subjectController.text = 'Quick Feedback';
      _messageController.text = feedback;
      _selectedCategory = 'General Feedback';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quick feedback added! You can modify it below.'),
        backgroundColor: AppTheme.primaryEnd,
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
        return 'Good - Generally satisfied';
      case 4:
        return 'Very Good - Mostly excellent';
      case 5:
        return 'Excellent - Love it!';
      default:
        return '';
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.dark800,
          title: const Text(
            'Thank You!',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: const Text(
            'Your feedback has been submitted successfully. We appreciate your input and will review it carefully.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to settings
              },
              child: const Text(
                'Done',
                style: TextStyle(color: AppTheme.primaryEnd),
              ),
            ),
          ],
        ),
      );
    }
  }
}