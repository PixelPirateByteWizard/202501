import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';
import '../utils/haptic_feedback.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                    "Safety & Anti-addiction",
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

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.SPACING_MEDIUM,
              ),
              child: GlassCard(
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: UIConstants.PURPLE_COLOR.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      UIConstants.BORDER_RADIUS_SMALL,
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(text: "Anti-addiction"),
                    Tab(text: "Safety"),
                  ],
                  onTap: (_) {
                    HapticFeedbackService.lightImpact();
                  },
                ),
              ),
            ),

            const SizedBox(height: UIConstants.SPACING_MEDIUM),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Anti-addiction tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Daily time limit
                        GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    color: UIConstants.CYAN_COLOR,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Time Management",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextItem(
                                title: "Daily Time Limit",
                                content:
                                    "We recommend limiting gameplay to 60 minutes per day to maintain a healthy balance between gaming and other activities.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Play Time Reminders",
                                content:
                                    "The app will notify you when you're approaching your daily time limit. Take these reminders as an opportunity to take a break.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Break Reminders",
                                content:
                                    "Take regular breaks during gameplay. We suggest following the 20-20-20 rule: every 20 minutes, look at something 20 feet away for 20 seconds.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Nighttime Gaming",
                                content:
                                    "Avoid playing between 10 PM and 8 AM. Blue light from screens can interfere with your sleep patterns and quality of rest.",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Usage guidelines
                        GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.bar_chart, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text(
                                    "Healthy Gaming Guidelines",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextItem(
                                title: "Weekly Usage",
                                content:
                                    "Try to limit your weekly gameplay to under 7 hours. This helps maintain a balanced lifestyle and prevents gaming from interfering with other important activities.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Physical Activity",
                                content:
                                    "For every hour of gameplay, spend at least 15 minutes doing physical activity. Stand up, stretch, or take a short walk to maintain good physical health.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Eye Health",
                                content:
                                    "Adjust your screen brightness to match your surroundings and maintain a comfortable distance from your screen to reduce eye strain.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Social Balance",
                                content:
                                    "Make sure gaming doesn't replace real-world social interactions. Balance your gaming time with family and friend activities.",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Anti-addiction resources
                        GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    color: UIConstants.PURPLE_COLOR,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Additional Resources",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "If you're concerned about your gaming habits or feel that you might be developing an addiction, please consider reaching out to these resources:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: UIConstants.TEXT_SECONDARY_COLOR,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildResourceText(
                                title: "Game Quitters",
                                description:
                                    "Support community for gaming addiction",
                              ),
                              _buildResourceText(
                                title: "National Center for Responsible Gaming",
                                description:
                                    "Research and resources on gaming addiction",
                              ),
                              _buildResourceText(
                                title: "Digital Wellness Tools",
                                description:
                                    "Apps and tools to monitor and manage screen time",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Safety tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Safety info card
                        GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.security, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    "Privacy & Data Security",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextItem(
                                title: "Data Collection",
                                content:
                                    "We collect minimal data required for gameplay and improvements. All data is stored locally on your device unless you explicitly choose to share it.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Analytics",
                                content:
                                    "Anonymous usage statistics help us improve the game experience. No personally identifiable information is collected.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Third-Party Access",
                                content:
                                    "We do not share your data with third parties for marketing purposes. Your privacy is our priority.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Data Storage",
                                content:
                                    "Game progress, settings, and statistics are stored securely on your device. We use industry-standard encryption to protect any data that may be transmitted.",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Healthy gaming
                        GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.favorite, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    "Healthy Gaming Habits",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextItem(
                                title: "Take Regular Breaks",
                                content:
                                    "Follow the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds to reduce eye strain.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Maintain Good Posture",
                                content:
                                    "Sit upright with your device at eye level to prevent neck and back strain. Consider using a stand or holder for your device to maintain proper ergonomics.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Balance Screen Time",
                                content:
                                    "Ensure gaming doesn't interfere with sleep, physical activity, or social interactions. Set specific times for gaming and stick to your schedule.",
                              ),
                              const SizedBox(height: 12),
                              _buildTextItem(
                                title: "Stay Hydrated",
                                content:
                                    "Remember to drink water regularly while playing. Dehydration can lead to headaches and decreased concentration.",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        // Resources
                        GlassCard(
                          padding: const EdgeInsets.all(
                            UIConstants.SPACING_MEDIUM,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    color: UIConstants.CYAN_COLOR,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "External Resources",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "The following resources provide additional information about digital wellbeing and healthy gaming habits:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: UIConstants.TEXT_SECONDARY_COLOR,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildResourceText(
                                title:
                                    "World Health Organization - Gaming Guidelines",
                                description:
                                    "Official health recommendations for gaming",
                              ),
                              _buildResourceText(
                                title: "Digital Wellbeing Resources",
                                description:
                                    "Tools and tips for maintaining digital balance",
                              ),
                              _buildResourceText(
                                title: "Family Online Safety Institute",
                                description:
                                    "Resources for parents and families",
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: UIConstants.TEXT_SECONDARY_COLOR,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceText({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: UIConstants.CYAN_COLOR),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: UIConstants.TEXT_SECONDARY_COLOR,
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
