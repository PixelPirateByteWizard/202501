import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/background_6.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingsItem(
              context,
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ));
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.description_outlined,
              title: 'User Agreement',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserAgreementScreen(),
                ));
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ));
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.help_outline,
              title: 'Help',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ));
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.feedback_outlined,
              title: 'Feedback and Suggestions',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FeedbackScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.9),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}