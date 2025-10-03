import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';
import '../utils/haptic_feedback.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<ContactMethod> _contactMethods = [
    ContactMethod(
      icon: Icons.email_outlined,
      title: "Email Support",
      subtitle: "support@coriaapp.com",
      description:
          "For general inquiries and non-urgent issues. We typically respond within 24 hours.",
      color: Colors.blue,
      action: "Email Us",
    ),
    ContactMethod(
      icon: Icons.chat_outlined,
      title: "Live Chat",
      subtitle: "Available Mon-Fri, 9AM-5PM",
      description:
          "For quick questions and real-time assistance. Our support team is ready to help during business hours.",
      color: Colors.green,
      action: "Start Chat",
    ),
    ContactMethod(
      icon: Icons.forum_outlined,
      title: "Community Forum",
      subtitle: "community.coriaapp.com",
      description:
          "Connect with other Coria players, share tips, and find solutions to common issues.",
      color: Colors.orange,
      action: "Visit Forum",
    ),
    ContactMethod(
      icon: Icons.help_outline,
      title: "Help Center",
      subtitle: "Find answers to common questions",
      description:
          "Browse our comprehensive knowledge base for tutorials, guides, and FAQs.",
      color: Colors.purple,
      action: "Browse Articles",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleContactAction(ContactMethod method) {
    HapticFeedbackService.lightImpact();

    // In a real app, these would launch the appropriate action
    // For now, just show a snackbar with the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${method.action}: ${method.subtitle}"),
        backgroundColor: method.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
      ),
    );
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
        body: SafeArea(
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
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        "Customer Support",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance for the back button
                  ],
                ),
              ),

              // Support intro card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.SPACING_MEDIUM,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: GlassCard(
                      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      UIConstants.PURPLE_COLOR,
                                      UIConstants.CYAN_COLOR,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: UIConstants.PURPLE_COLOR
                                          .withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.support_agent,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: UIConstants.SPACING_MEDIUM),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "We're Here to Help",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Choose a contact method below",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: UIConstants.TEXT_SECONDARY_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),
                          const Text(
                            "Our support team is dedicated to providing you with the best gaming experience. Feel free to reach out through any of the channels below.",
                            style: TextStyle(
                              fontSize: 14,
                              color: UIConstants.TEXT_SECONDARY_COLOR,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: UIConstants.SPACING_MEDIUM),

              // Contact methods list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.SPACING_MEDIUM,
                  ),
                  itemCount: _contactMethods.length,
                  itemBuilder: (context, index) {
                    final delay = 0.1 + (index * 0.1);
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          delay,
                          delay + 0.4,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  delay,
                                  delay + 0.5,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: UIConstants.SPACING_MEDIUM,
                          ),
                          child: _buildContactMethodCard(
                            _contactMethods[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Support hours
              Padding(
                padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                  ),
                  child: const Text(
                    "Support hours: Monday to Friday, 9:00 AM - 5:00 PM (GMT)",
                    style: TextStyle(
                      fontSize: 12,
                      color: UIConstants.TEXT_SECONDARY_COLOR,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactMethodCard(ContactMethod method) {
    return GlassCard(
      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: method.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(method.icon, color: method.color, size: 24),
              ),
              const SizedBox(width: UIConstants.SPACING_MEDIUM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      method.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: UIConstants.TEXT_SECONDARY_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.SPACING_SMALL),
          Text(
            method.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: UIConstants.SPACING_MEDIUM),
          GlassCard(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: UIConstants.SPACING_MEDIUM,
            ),
            backgroundColor: method.color.withOpacity(0.2),
            onTap: () => _handleContactAction(method),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  method.action,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: method.color.withAlpha(240),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: method.color.withAlpha(240),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactMethod {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final String action;

  ContactMethod({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.action,
  });
}
