import 'package:astrelexis/screens/settings/about_us_screen.dart';
import 'package:astrelexis/screens/settings/feedback_screen.dart';
import 'package:astrelexis/screens/settings/help_support_screen.dart';
import 'package:astrelexis/screens/settings/privacy_policy_screen.dart';
import 'package:astrelexis/screens/settings/user_agreement_screen.dart';
import 'package:astrelexis/utils/app_colors.dart';
import 'package:astrelexis/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      'About Us',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AboutUsScreen())),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      'User Agreement',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UserAgreementScreen())),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      'Privacy Policy',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen())),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      'Help & Support',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HelpSupportScreen())),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      context,
                      'Feedback & Suggestions',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FeedbackScreen())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.glassBorder,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
