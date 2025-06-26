import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/audio_service.dart';
import 'about_screen.dart';
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioService _audioService = AudioService();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _soundEnabled = _audioService.soundEnabled;
      _hapticEnabled = _audioService.hapticEnabled;
    });
  }

  void _toggleSound(bool value) {
    setState(() {
      _soundEnabled = value;
    });
    _audioService.setSoundEnabled(value);

    if (value) {
      _audioService.playSelectSound();
    }
  }

  void _toggleHaptic(bool value) {
    setState(() {
      _hapticEnabled = value;
    });
    _audioService.setHapticEnabled(value);

    if (value) {
      _audioService.tapFeedback();
    }
  }

  void _navigateToAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }

  void _navigateToTermsOfService() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TermsOfServiceScreen(),
      ),
    );
  }

  void _navigateToPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _navigateToHelp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HelpScreen(),
      ),
    );
  }

  void _navigateToFeedback() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FeedbackScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Settings',
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
                const SizedBox(height: 24),

                // Support & Information Section
                _buildSectionHeader('Support & Information'),
                const SizedBox(height: 16),
                _buildSettingsCard([
                  _buildActionTile(
                    icon: Icons.help_outline,
                    title: 'Help & Guide',
                    subtitle: 'Learn how to play and game rules',
                    onTap: _navigateToHelp,
                  ),
                  const Divider(color: AppColors.secondaryText, height: 1),
                  _buildActionTile(
                    icon: Icons.feedback,
                    title: 'Feedback & Suggestions',
                    subtitle: 'Share your thoughts and report issues',
                    onTap: _navigateToFeedback,
                  ),
                  const Divider(color: AppColors.secondaryText, height: 1),
                  _buildActionTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Game information and credits',
                    onTap: _navigateToAbout,
                  ),
                ]),
                const SizedBox(height: 24),

                // Legal Section
                _buildSectionHeader('Legal'),
                const SizedBox(height: 16),
                _buildSettingsCard([
                  _buildActionTile(
                    icon: Icons.description,
                    title: 'Terms of Service',
                    subtitle: 'Terms and conditions of use',
                    onTap: _navigateToTermsOfService,
                  ),
                  const Divider(color: AppColors.secondaryText, height: 1),
                  _buildActionTile(
                    icon: Icons.security,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: _navigateToPrivacyPolicy,
                  ),
                ]),
                const SizedBox(height: 32),

                // App Version
                Center(
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
                      children: [
                        Text(
                          "Alchemist's Palette",
                          style: SafeFonts.imFellEnglishSc(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '© 2025 All rights reserved',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: SafeFonts.imFellEnglishSc(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.accent,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withOpacity(0.2),
        ),
        child: Icon(icon, color: AppColors.accent, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.secondaryText,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
        activeTrackColor: AppColors.accent.withOpacity(0.3),
        inactiveThumbColor: AppColors.secondaryText,
        inactiveTrackColor: AppColors.secondaryText.withOpacity(0.3),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDestructive
              ? Colors.red.withOpacity(0.2)
              : AppColors.accent.withOpacity(0.2),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.accent,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.red : AppColors.primaryText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.secondaryText,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.secondaryText,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
