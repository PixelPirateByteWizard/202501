import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
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
              // App Logo
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppConstants.spaceIndigo700,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.cosmicBlue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'V',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: AppConstants.cosmicBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App Name and Version
              Center(
                child: Column(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.cosmicBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: TextStyle(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // About Section
              Text(
                'About',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.cosmicBlue,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Verzephronix is a comprehensive sports companion app designed to enhance your sporting experience. Whether you\'re organizing a casual match with friends or managing a local tournament, our app provides essential tools to make your sporting events more organized and enjoyable.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),

              const SizedBox(height: 24),

              // Key Features
              Text(
                'Key Features',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.cosmicBlue,
                ),
              ),

              const SizedBox(height: 16),

              _buildFeatureItem(
                context,
                icon: Icons.group_rounded,
                color: Colors.green,
                title: 'Group Generator',
                description:
                    'Create balanced teams quickly and fairly for any sport.',
              ),

              _buildFeatureItem(
                context,
                icon: Icons.timer_rounded,
                color: Colors.orange,
                title: 'Match Scorer',
                description:
                    'Keep track of scores across different sports with specialized scoring systems.',
              ),

              _buildFeatureItem(
                context,
                icon: Icons.text_fields_rounded,
                color: Colors.purple,
                title: 'LED Scroller',
                description:
                    'Create eye-catching scrolling text displays for your events.',
              ),

              const SizedBox(height: 40),

              // Developer Info
              Text(
                'Developer',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.cosmicBlue,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Verzephronix was developed with passion by sports enthusiasts who understand the needs of players and organizers. Our goal is to create intuitive tools that enhance the sporting experience while keeping the focus on the game.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),

              const SizedBox(height: 40),

              // Copyright
              Center(
                child: Text(
                  'Verzephronix © 2023\nAll rights reserved',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                    fontSize: 14,
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

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                    height: 1.4,
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
