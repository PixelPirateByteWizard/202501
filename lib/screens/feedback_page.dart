import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _typeController.dispose();
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0B2E),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildIntroCard(),
                      const SizedBox(height: 20),
                      _buildFeedbackForm(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Share Your Thoughts',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Help us improve your experience',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Voice Matters',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We value your feedback and are committed to continuously improving our app. '
              'Whether you have suggestions, found a bug, or want to share your experience, '
              'we\'re here to listen.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Feedback Form',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildContentField(),
              const SizedBox(height: 16),
              _buildContactField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Feedback Type',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D4075)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D4075)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8B6BF3)),
        ),
        filled: true,
        fillColor: const Color(0xFF1A1B3F),
      ),
      dropdownColor: const Color(0xFF1A1B3F),
      style: const TextStyle(color: Colors.white),
      items: const [
        DropdownMenuItem(
            value: 'Feature Request', child: Text('Feature Request')),
        DropdownMenuItem(value: 'Bug Report', child: Text('Bug Report')),
        DropdownMenuItem(
            value: 'UI/UX Feedback', child: Text('UI/UX Feedback')),
        DropdownMenuItem(
            value: 'General Feedback', child: Text('General Feedback')),
        DropdownMenuItem(value: 'Other', child: Text('Other')),
      ],
      onChanged: (value) {
        _typeController.text = value ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a feedback type';
        }
        return null;
      },
    );
  }

  Widget _buildContentField() {
    return TextFormField(
      controller: _contentController,
      maxLines: 5,
      maxLength: 500,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Your Feedback',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        hintText:
            'Please describe your feedback in detail (max 500 characters)...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        counterStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D4075)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D4075)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8B6BF3)),
        ),
        filled: true,
        fillColor: const Color(0xFF1A1B3F),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your feedback';
        }
        if (value.length < 10) {
          return 'Feedback must be at least 10 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildContactField() {
    return TextFormField(
      controller: _contactController,
      maxLength: 50,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Contact Information (Optional)',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        hintText: 'Email or phone number for follow-up (max 50 characters)',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        counterStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D4075)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3D4075)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8B6BF3)),
        ),
        filled: true,
        fillColor: const Color(0xFF1A1B3F),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF8B6BF3),
            Color(0xFF6B4DE3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B6BF3).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Submit Feedback',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement feedback submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Color(0xFF8B6BF3),
        ),
      );
      Navigator.pop(context);
    }
  }
}
