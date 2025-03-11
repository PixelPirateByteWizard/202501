import 'package:flutter/material.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'User Manual',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 16),
            const _ManualSection(
              icon: Icons.rocket_launch,
              iconColor: Colors.blue,
              title: 'Getting Started',
              content: 'Follow these steps to begin your style journey:',
              items: [
                'Complete the personalized style assessment',
                'Upload photos of your wardrobe items',
                'Set your style preferences and goals',
                'Enable notifications for daily outfit suggestions',
                'Explore the AI-powered outfit recommendations',
              ],
            ),
            const _ManualSection(
              icon: Icons.style,
              iconColor: Colors.purple,
              title: 'Style Assessment',
              content: 'Maximize your style profile accuracy:',
              items: [
                'Answer all questions honestly for better recommendations',
                'Upload full-body photos in good lighting',
                'Specify your preferred fashion styles and brands',
                'Update your measurements for precise fitting advice',
                'Include your lifestyle and daily activities',
              ],
            ),
            const _ManualSection(
              icon: Icons.camera_alt,
              iconColor: Colors.green,
              title: 'Wardrobe Management',
              content: 'Tips for organizing your digital wardrobe:',
              items: [
                'Take photos in natural lighting for accurate colors',
                'Categorize items by type (tops, bottoms, accessories)',
                'Add detailed descriptions for better matching',
                'Tag seasonal appropriateness for each item',
                'Regular updates keep your wardrobe current',
              ],
            ),
            const _ManualSection(
              icon: Icons.auto_awesome,
              iconColor: Colors.orange,
              title: 'AI Recommendations',
              content: 'Get the most from our AI styling system:',
              items: [
                'Set occasion preferences for targeted suggestions',
                'Rate outfits to improve future recommendations',
                'Save favorite combinations for quick access',
                'Consider weather conditions for daily outfits',
                'Explore mix-and-match possibilities',
              ],
            ),
            const _ManualSection(
              icon: Icons.settings_suggest,
              iconColor: Colors.teal,
              title: 'Advanced Features',
              content: 'Unlock the full potential of the app:',
              items: [
                'Create custom outfit collections for different occasions',
                'Share outfits with the community for feedback',
                'Track wearing frequency of items',
                'Set reminders for seasonal wardrobe updates',
                'Export your wardrobe data for backup',
              ],
            ),
            const _ManualSection(
              icon: Icons.tips_and_updates,
              iconColor: Colors.red,
              title: 'Pro Tips',
              content: 'Expert advice for the best experience:',
              items: [
                'Regular app updates ensure optimal performance',
                'Use tags for efficient wardrobe organization',
                'Participate in community style challenges',
                'Leverage the virtual try-on feature',
                'Schedule weekly wardrobe planning sessions',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Guide',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                      const Text(
                        'Your complete guide to app features',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to your personal style assistant! This guide will help you make the most of our app\'s features and create your perfect wardrobe experience.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final List<String> items;

  const _ManualSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
