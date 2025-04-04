import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';
import 'about_screen.dart';
import 'help_screen.dart';
import 'terms_screen.dart';
import 'privacy_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 24),
              _buildSettingsItem(
                context,
                'About App',
                Icons.info_outline_rounded,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                context,
                'Help',
                Icons.help_outline_rounded,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                context,
                'Terms of Service',
                Icons.description_outlined,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                context,
                'Privacy Policy',
                Icons.privacy_tip_outlined,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingsItem(
                context,
                'Feedback',
                Icons.feedback_outlined,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FeedbackScreen()),
                ),
              ),
              const SizedBox(height: 24),
              _buildAppVersion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withOpacity(0.1),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersion() {
    return Center(
      child: Text(
        'Version 1.0.0',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
        ),
      ),
    );
  }
}
