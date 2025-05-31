import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedType = 'Feature Suggestion';
  bool _isSubmitting = false;

  final List<String> _feedbackTypes = [
    'Feature Suggestion',
    'Bug Report',
    'User Experience Feedback',
    'Other'
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Feedback & Suggestions',
          style: TextStyle(
            color: const Color(0xFFFBBF24),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Feedback Type'),
              const SizedBox(height: 12),
              _buildTypeSelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('Feedback Content'),
              const SizedBox(height: 12),
              _buildFeedbackInput(),
              const SizedBox(height: 24),
              _buildSectionTitle('Contact Information'),
              const SizedBox(height: 12),
              _buildContactInput(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.amber.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          isExpanded: true,
          dropdownColor: Colors.black.withOpacity(0.9),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.amber,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedType = newValue;
              });
            }
          },
          items: _feedbackTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeedbackInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.amber.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _feedbackController,
        maxLines: 6,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Please describe your issue or suggestion in detail...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFBBF24)),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildContactInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.amber.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _contactController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Please leave your contact information (optional)',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFBBF24)),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting
            ? null
            : () {
                setState(() {
                  _isSubmitting = true;
                });
                // TODO: Implement feedback submission
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _isSubmitting = false;
                  });
                  Navigator.pop(context);
                });
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Submit Feedback',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
