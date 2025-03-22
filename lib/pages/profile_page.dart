import 'package:flutter/material.dart';
import 'settings/about_app_page.dart';
import 'settings/help_page.dart';
import 'settings/terms_page.dart';
import 'settings/privacy_policy_page.dart';
import 'settings/feedback_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF8FB3B0),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF8FB3B0),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 32,
                    color: Color(0xFF8FB3B0),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Aetherys',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Customize your app experience',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSectionTitle('App Settings'),
                _buildSettingsTile(
                  context,
                  'About App',
                  Icons.info_outline,
                  'Learn more about Aetherys',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutAppPage()),
                  ),
                ),
                _buildSettingsTile(
                  context,
                  'Help',
                  Icons.help_outline,
                  'FAQ and support',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpPage()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Legal'),
                _buildSettingsTile(
                  context,
                  'Terms of Service',
                  Icons.description_outlined,
                  'Read our terms',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsPage()),
                  ),
                ),
                _buildSettingsTile(
                  context,
                  'Privacy Policy',
                  Icons.privacy_tip_outlined,
                  'View privacy information',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Support'),
                _buildSettingsTile(
                  context,
                  'Feedback & Suggestions',
                  Icons.feedback_outlined,
                  'Help us improve',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF8FB3B0).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8FB3B0),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
