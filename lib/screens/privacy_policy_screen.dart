import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Privacy Policy',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: AppColors.accent,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Privacy Policy',
                            style: SafeFonts.imFellEnglishSc(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last Updated: January 2025',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your privacy is important to us. This Privacy Policy explains how Alchemist\'s Palette collects, uses, and protects your information.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Privacy Sections
                _buildPrivacySection(
                  '1. Information We Collect',
                  'Alchemist\'s Palette is designed with privacy in mind. We collect minimal information to provide you with the best gaming experience:\n\n• Game Progress: Your level completions, scores, and achievements\n• Game Statistics: Play time, moves made, and performance metrics\n• Settings: Your audio and haptic preferences\n• Device Information: Basic device specifications for optimization',
                  Icons.info_outline,
                ),

                _buildPrivacySection(
                  '2. How We Use Your Information',
                  'The information we collect is used exclusively to:\n\n• Save your game progress locally on your device\n• Track your achievements and statistics\n• Remember your game preferences\n• Optimize game performance for your device\n• Provide a personalized gaming experience',
                  Icons.how_to_reg,
                ),

                _buildPrivacySection(
                  '3. Data Storage',
                  'All your game data is stored locally on your device using secure storage mechanisms:\n\n• No data is transmitted to external servers\n• Your information never leaves your device\n• Data is encrypted using device-level security\n• You have full control over your data',
                  Icons.storage,
                ),

                _buildPrivacySection(
                  '4. Third-Party Services',
                  'Alchemist\'s Palette does not integrate with any third-party analytics, advertising, or social media services. We do not share your information with any external parties.',
                  Icons.block,
                ),

                _buildPrivacySection(
                  '5. Children\'s Privacy',
                  'Our game is suitable for all ages and does not knowingly collect personal information from children under 13. Since all data is stored locally, no personal information is transmitted or stored on external servers.',
                  Icons.child_care,
                ),

                _buildPrivacySection(
                  '6. Data Security',
                  'We implement appropriate security measures to protect your information:\n\n• Local encryption of game data\n• Secure coding practices\n• Regular security updates\n• No network transmission of personal data',
                  Icons.shield,
                ),

                _buildPrivacySection(
                  '7. Your Rights',
                  'You have complete control over your data:\n\n• View your data through game statistics\n• Delete your data by resetting game progress\n• Export your achievements (where applicable)\n• Uninstall the game to remove all data',
                  Icons.person,
                ),

                _buildPrivacySection(
                  '8. Data Retention',
                  'Your game data is retained locally on your device until:\n\n• You manually reset your progress\n• You uninstall the game\n• You clear the app data through device settings\n• The app is updated (data is preserved during updates)',
                  Icons.schedule,
                ),

                _buildPrivacySection(
                  '9. Changes to Privacy Policy',
                  'We may update this Privacy Policy from time to time. Any changes will be reflected in the "Last Updated" date. Continued use of the game after updates constitutes acceptance of the revised policy.',
                  Icons.update,
                ),

                _buildPrivacySection(
                  '10. Contact Us',
                  'If you have any questions about this Privacy Policy or our data practices, please contact us through the feedback option in the game settings.',
                  Icons.contact_support,
                ),

                const SizedBox(height: 20),

                // Privacy Commitment
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.1),
                        AppColors.cyanAccent.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: AppColors.accent,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Our Privacy Commitment',
                        style: SafeFonts.imFellEnglishSc(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'We are committed to protecting your privacy. Alchemist\'s Palette is designed as a privacy-first game with no data collection, no ads, and no tracking.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryText,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPrivacyFeature(
                              Icons.no_accounts, 'No Tracking'),
                          _buildPrivacyFeature(Icons.block, 'No Ads'),
                          _buildPrivacyFeature(Icons.cloud_off, 'Local Only'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.accent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyFeature(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.accent,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
