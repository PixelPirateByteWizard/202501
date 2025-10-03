import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';
import '../utils/haptic_feedback.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  String _selectedCategory = "General";
  final List<String> _categories = [
    "General",
    "Game Mechanics",
    "User Interface",
    "Performance",
    "Bug Report",
    "Feature Request",
  ];

  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: GestureDetector(
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
                      padding: const EdgeInsets.all(UIConstants.SPACING_SMALL),
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
                      "Feedback",
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

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "We'd love to hear from you!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Your feedback helps us improve the game experience.",
                          style: TextStyle(
                            fontSize: 14,
                            color: UIConstants.TEXT_SECONDARY_COLOR,
                          ),
                        ),
                        const SizedBox(height: UIConstants.SPACING_LARGE),

                        // Name field
                        const Text(
                          "Name",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.SPACING_MEDIUM,
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Enter your name",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            cursorColor: UIConstants.CYAN_COLOR,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            maxLength: 50, // Reasonable limit for names
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) {
                                  return null; // Hide the counter
                                },
                          ),
                        ),
                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Email field
                        const Text(
                          "Email",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.SPACING_MEDIUM,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            cursorColor: UIConstants.CYAN_COLOR,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              // Simple email validation
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            maxLength: 100, // Reasonable limit for emails
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) {
                                  return null; // Hide the counter
                                },
                          ),
                        ),
                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Category dropdown
                        const Text(
                          "Category",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.SPACING_MEDIUM,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            dropdownColor: UIConstants.SURFACE_COLOR,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
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
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Rating
                        const Text(
                          "Rating",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                                HapticFeedbackService.lightImpact();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  index < _rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: index < _rating
                                      ? Colors.amber
                                      : Colors.white60,
                                  size: 36,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Feedback text field
                        const Text(
                          "Your Feedback",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.SPACING_MEDIUM,
                          ),
                          child: TextFormField(
                            controller: _feedbackController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Tell us what you think...",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            cursorColor: UIConstants.CYAN_COLOR,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your feedback";
                              }
                              if (value.length < 10) {
                                return "Feedback must be at least 10 characters";
                              }
                              return null;
                            },
                            maxLength: 500, // Reasonable limit for feedback
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) {
                                  return Text(
                                    "$currentLength/$maxLength",
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                          ),
                        ),
                        const SizedBox(height: UIConstants.SPACING_LARGE),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: UIConstants.PURPLE_COLOR
                                .withOpacity(0.3),
                            onTap: _isSubmitting ? null : _submitFeedback,
                            child: Center(
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
                                      "Submit Feedback",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
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

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Simulate submission
      setState(() {
        _isSubmitting = true;
      });

      // Provide haptic feedback
      HapticFeedbackService.mediumImpact();

      // Simulate network delay
      Future.delayed(const Duration(seconds: 2), () {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: UIConstants.SURFACE_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                UIConstants.BORDER_RADIUS_MEDIUM,
              ),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Thank You!", style: TextStyle(color: Colors.white)),
              ],
            ),
            content: const Text(
              "Your feedback has been submitted successfully. We appreciate your input!",
              style: TextStyle(color: UIConstants.TEXT_SECONDARY_COLOR),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous screen
                },
                child: const Text(
                  "Close",
                  style: TextStyle(color: UIConstants.CYAN_COLOR),
                ),
              ),
            ],
          ),
        );

        setState(() {
          _isSubmitting = false;
        });
      });
    } else {
      // Provide error feedback
      HapticFeedbackService.heavyImpact();
    }
  }
}
