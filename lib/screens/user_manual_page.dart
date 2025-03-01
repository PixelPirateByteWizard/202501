import 'package:flutter/material.dart';

class UserManualPage extends StatelessWidget {
  const UserManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _buildCard(
                      context,
                      title: 'Getting Started',
                      content:
                          'Welcome to Gelro! Follow these steps to begin:\n\n'
                          '• First Launch\n'
                          '- Create your account or sign in\n'
                          '- Complete your profile setup\n'
                          '- Grant necessary permissions\n\n'
                          '• App Navigation\n'
                          '- Use the bottom navigation bar to switch between main features\n'
                          '- Swipe gestures supported for easy navigation\n'
                          '- Access quick actions from the home screen',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Waste Recognition',
                      content:
                          'Use our AI-powered waste recognition feature:\n\n'
                          '• Camera Usage\n'
                          '- Tap the camera icon in the sorting page\n'
                          '- Ensure good lighting for best results\n'
                          '- Center the item in the frame\n'
                          '- Hold steady while scanning\n\n'
                          '• Recognition Results\n'
                          '- View waste category and sorting instructions\n'
                          '- Get detailed recycling information\n'
                          '- Save items for future reference',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Knowledge Base',
                      content:
                          'Access our comprehensive environmental resources:\n\n'
                          '• Browse Categories\n'
                          '- Waste types and sorting guides\n'
                          '- Environmental protection tips\n'
                          '- Sustainable living practices\n\n'
                          '• Search Function\n'
                          '- Use keywords to find specific information\n'
                          '- Filter results by category\n'
                          '- Save articles for offline reading',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Community Features',
                      content: 'Connect with fellow environmentalists:\n\n'
                          '• Social Interaction\n'
                          '- Share your eco-friendly activities\n'
                          '- Join environmental discussions\n'
                          '- Follow other users\n\n'
                          '• Challenges & Events\n'
                          '- Participate in eco-challenges\n'
                          '- Track your progress\n'
                          '- Earn achievements',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Profile Management',
                      content: 'Customize your Gelro experience:\n\n'
                          '• Account Settings\n'
                          '- Update personal information\n'
                          '- Manage privacy preferences\n'
                          '- Set notification preferences\n\n'
                          '• Activity Tracking\n'
                          '- View sorting history\n'
                          '- Track environmental impact\n'
                          '- Monitor achievement progress',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Troubleshooting',
                      content: 'Common issues and solutions:\n\n'
                          '• Camera Issues\n'
                          '- Check camera permissions\n'
                          '- Ensure adequate lighting\n'
                          '- Restart the app if necessary\n\n'
                          '• Connection Problems\n'
                          '- Verify internet connectivity\n'
                          '- Check app version is up to date\n'
                          '- Clear app cache if needed\n\n'
                          '• Need Help?\n'
                          '- Visit our FAQ section\n'
                          '- Contact support through the app\n'
                          '- Email us at support@Gelro.eco',
                    ),
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
                          'User Manual',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Learn how to use Gelro effectively',
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
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required String content}) {
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
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
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
}
