import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Features Overview'),
        backgroundColor: AppConstants.spaceIndigo600,
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Our Features',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.cosmicBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Verzephronix offers a comprehensive suite of tools designed to enhance your sporting experience.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 32),

              // Group Generator Feature
              _buildFeatureCard(
                context,
                title: 'Group Generator',
                icon: Icons.group_rounded,
                color: Colors.green,
                description:
                    'Create balanced teams quickly and fairly for any sport or activity.',
                details: [
                  'Randomize players into equal teams',
                  'Consider skill levels for balanced groups',
                  'Save team configurations for future use',
                  'Customize team sizes and number of teams',
                  'Visual representation of team assignments',
                ],
              ),

              const SizedBox(height: 24),

              // Match Scorer Feature
              _buildFeatureCard(
                context,
                title: 'Match Scorer',
                icon: Icons.timer_rounded,
                color: Colors.orange,
                description:
                    'Keep track of scores across different sports with specialized scoring systems.',
                details: [
                  'Support for multiple sports (Tennis, Badminton, Table Tennis, etc.)',
                  'Specialized scoring rules for each sport',
                  'Track sets, games, and points',
                  'Visual match history and statistics',
                  'Real-time score updates',
                ],
              ),

              const SizedBox(height: 24),

              // LED Scroller Feature
              _buildFeatureCard(
                context,
                title: 'LED Scroller',
                icon: Icons.text_fields_rounded,
                color: Colors.purple,
                description:
                    'Create eye-catching scrolling text displays for your events and matches.',
                details: [
                  'Customizable scrolling text messages',
                  'Adjustable scroll speed and direction',
                  'Multiple color themes and backgrounds',
                  'Full-screen display mode for maximum visibility',
                  'Save and reuse message templates',
                ],
              ),

              const SizedBox(height: 24),

              // Settings Feature
              _buildFeatureCard(
                context,
                title: 'Settings & Customization',
                icon: Icons.settings_rounded,
                color: Colors.blue,
                description:
                    'Personalize your app experience to suit your preferences.',
                details: [
                  'Customize app appearance and behavior',
                  'Access app information and documentation',
                  'Manage app permissions and preferences',
                  'View legal information and policies',
                  'Submit feedback and suggestions',
                ],
              ),

              const SizedBox(height: 32),

              Center(
                child: Text(
                  'More features coming soon!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppConstants.cosmicBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> details,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Feature Details
            ...details.map((detail) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded, color: color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(detail, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
