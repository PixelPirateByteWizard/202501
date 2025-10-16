import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/onboarding_service.dart';
import 'onboarding_screen.dart';
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
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoSaveEnabled = true;
  double _gameSpeed = 1.0;
  String _difficulty = 'Normal';
  final OnboardingService _onboardingService = OnboardingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.lavenderWhite,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Settings',
                              style: Theme.of(context).textTheme.displaySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Audio Settings
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Audio & Haptics',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildSwitchTile(
                                      'Sound Effects',
                                      'Enable mechanical sounds and ambient audio',
                                      _soundEnabled,
                                      (value) =>
                                          setState(() => _soundEnabled = value),
                                      Icons.volume_up,
                                    ),

                                    _buildSwitchTile(
                                      'Vibration',
                                      'Haptic feedback for interactions',
                                      _vibrationEnabled,
                                      (value) => setState(
                                        () => _vibrationEnabled = value,
                                      ),
                                      Icons.vibration,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Game Settings
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gameplay',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildSwitchTile(
                                      'Auto-Save',
                                      'Automatically save progress',
                                      _autoSaveEnabled,
                                      (value) => setState(
                                        () => _autoSaveEnabled = value,
                                      ),
                                      Icons.save,
                                    ),

                                

                                    const SizedBox(height: 16),

                                    // Game Speed Slider
                                    Text(
                                      'Game Speed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.vintageGold,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.speed,
                                          color: AppColors.lavenderWhite,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Slider(
                                            value: _gameSpeed,
                                            min: 0.5,
                                            max: 2.0,
                                            divisions: 6,
                                            label:
                                                '${_gameSpeed.toStringAsFixed(1)}x',
                                            activeColor: AppColors.vintageGold,
                                            inactiveColor: AppColors.slateBlue,
                                            onChanged: (value) => setState(
                                              () => _gameSpeed = value,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${_gameSpeed.toStringAsFixed(1)}x',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.vintageGold,
                                              ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Difficulty Dropdown
                                    Text(
                                      'Difficulty',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.vintageGold,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.slateBlue,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.glassBorder,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _difficulty,
                                          isExpanded: true,
                                          dropdownColor: AppColors.slateBlue,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                          items:
                                              [
                                                'Easy',
                                                'Normal',
                                                'Hard',
                                                'Expert',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (value) => setState(
                                            () => _difficulty = value!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Information & Support Section
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Information & Support',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),

                                    _buildNavigationTile(
                                      'About Us',
                                      'Learn about the game and development team',
                                      Icons.info,
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const AboutScreen(),
                                        ),
                                      ),
                                    ),

                                    _buildNavigationTile(
                                      'Help & Support',
                                      'Get help and find answers to common questions',
                                      Icons.help,
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const HelpScreen(),
                                        ),
                                      ),
                                    ),

                                    _buildNavigationTile(
                                      'Feedback & Suggestions',
                                      'Share your thoughts and help us improve',
                                      Icons.feedback,
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const FeedbackScreen(),
                                        ),
                                      ),
                                    ),

                                    _buildNavigationTile(
                                      'Terms of Service',
                                      'Read our terms and conditions',
                                      Icons.gavel,
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const TermsOfServiceScreen(),
                                        ),
                                      ),
                                    ),

                                    _buildNavigationTile(
                                      'Privacy Policy',
                                      'Learn how we protect your privacy',
                                      Icons.privacy_tip,
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyScreen(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Actions Section
                              GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Actions',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 16),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _resetOnboarding,
                                            icon: const Icon(Icons.school),
                                            label: const Text('Show Tutorial'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.vintageGold,
                                              foregroundColor:
                                                  AppColors.deepNavy,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              _showResetConfirmation();
                                            },
                                            icon: const Icon(Icons.refresh),
                                            label: const Text('Reset Progress'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.statusError,
                                              foregroundColor:
                                                  AppColors.lavenderWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.vintageGold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.vintageGold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.vintageGold,
            activeTrackColor: AppColors.vintageGold.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.lavenderWhite,
            inactiveTrackColor: AppColors.slateBlue,
          ),
        ],
      ),
    );
  }

  void _resetOnboarding() async {
    await _onboardingService.resetOnboarding();
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.statusError),
            SizedBox(width: 8),
            Text(
              'Reset Progress',
              style: TextStyle(color: AppColors.statusError),
            ),
          ],
        ),
        content: const Text(
          'This will permanently delete all your game progress, including achievements, story history, and workshop upgrades. This action cannot be undone.',
          style: TextStyle(color: AppColors.lavenderWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Game data reset successfully'),
                  backgroundColor: AppColors.statusOptimal,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusError,
            ),
            child: const Text(
              'Reset All Data',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.vintageGold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.vintageGold, size: 20),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.lavenderWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.lavenderWhite.withValues(alpha: 0.7),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.vintageGold,
        ),
        onTap: onTap,
      ),
    );
  }
}
