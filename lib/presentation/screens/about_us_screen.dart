import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Text(
                    "About Us",
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App logo and name
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
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
                                  color: UIConstants.PURPLE_COLOR.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "C",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),
                          const Text(
                            "Coria",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Version 1.0.0",
                            style: TextStyle(
                              fontSize: 16,
                              color: UIConstants.TEXT_SECONDARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: UIConstants.SPACING_LARGE),

                    // About the app
                    GlassCard(
                      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Our Story",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),
                          const Text(
                            "Coria was created with a simple mission: to provide a challenging yet relaxing gaming experience that helps players focus and improve their strategic thinking.",
                            style: TextStyle(
                              fontSize: 16,
                              color: UIConstants.TEXT_SECONDARY_COLOR,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),
                          const Text(
                            "Our team of passionate developers and designers worked tirelessly to create a game that is both visually stunning and mentally stimulating. We believe that games should be more than just entertainment - they should be tools for growth and mindfulness.",
                            style: TextStyle(
                              fontSize: 16,
                              color: UIConstants.TEXT_SECONDARY_COLOR,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Team section
                    GlassCard(
                      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Our Team",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),
                          _buildTeamMember(
                            name: "Alex Chen",
                            role: "Lead Developer",
                            color: Colors.blue,
                          ),
                          const SizedBox(height: UIConstants.SPACING_SMALL),
                          _buildTeamMember(
                            name: "Sarah Johnson",
                            role: "UI/UX Designer",
                            color: Colors.purple,
                          ),
                          const SizedBox(height: UIConstants.SPACING_SMALL),
                          _buildTeamMember(
                            name: "Michael Wong",
                            role: "Game Designer",
                            color: Colors.green,
                          ),
                          const SizedBox(height: UIConstants.SPACING_SMALL),
                          _buildTeamMember(
                            name: "Emma Davis",
                            role: "Product Manager",
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Contact section
                    GlassCard(
                      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Contact Us",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),
                          _buildContactItem(
                            icon: Icons.email_outlined,
                            text: "support@coriaapp.com",
                            color: UIConstants.CYAN_COLOR,
                          ),
                          const SizedBox(height: UIConstants.SPACING_SMALL),
                          _buildContactItem(
                            icon: Icons.language,
                            text: "www.coriaapp.com",
                            color: UIConstants.PURPLE_COLOR,
                          ),
                          const SizedBox(height: UIConstants.SPACING_SMALL),
                          _buildContactItem(
                            icon: Icons.location_on_outlined,
                            text: "123 Game Street, San Francisco, CA",
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: UIConstants.SPACING_LARGE),

                    // Copyright
                    const Center(
                      child: Text(
                        "© 2025 Coria. All rights reserved.",
                        style: TextStyle(
                          fontSize: 14,
                          color: UIConstants.TEXT_SECONDARY_COLOR,
                        ),
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            name[0],
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: UIConstants.SPACING_SMALL),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              role,
              style: const TextStyle(
                fontSize: 14,
                color: UIConstants.TEXT_SECONDARY_COLOR,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: UIConstants.SPACING_SMALL),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: UIConstants.TEXT_SECONDARY_COLOR,
          ),
        ),
      ],
    );
  }
}
