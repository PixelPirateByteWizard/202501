import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'settings/about_screen.dart';
import 'settings/terms_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/help_screen.dart';
import 'settings/feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _aiSuggestions = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              
              // Profile Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.dark800,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solakai User',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Smart Calendar Assistant',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preferences Section
                      _buildSectionHeader('Preferences'),
                      const SizedBox(height: 16),
                      _buildSettingsGroup([
                        _buildSettingItem(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          trailing: Switch(
                            value: _notifications,
                            onChanged: (value) {
                              setState(() {
                                _notifications = value;
                              });
                            },
                            activeColor: AppTheme.primaryEnd,
                          ),
                        ),
                        _buildSettingItem(
                          icon: Icons.psychology,
                          title: 'AI Suggestions',
                          trailing: Switch(
                            value: _aiSuggestions,
                            onChanged: (value) {
                              setState(() {
                                _aiSuggestions = value;
                              });
                            },
                            activeColor: AppTheme.primaryEnd,
                          ),
                        ),
                        _buildSettingItem(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          trailing: Switch(
                            value: _darkMode,
                            onChanged: (value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                            activeColor: AppTheme.primaryEnd,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      
                      // Support & Information Section
                      _buildSectionHeader('Support & Information'),
                      const SizedBox(height: 16),
                      _buildSettingsGroup([
                        _buildNavigationItem(
                          icon: Icons.info_outline,
                          title: 'About Us',
                          onTap: () => _navigateToPage(const AboutScreen()),
                        ),
                        _buildNavigationItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () => _navigateToPage(const HelpScreen()),
                        ),
                        _buildNavigationItem(
                          icon: Icons.feedback_outlined,
                          title: 'Feedback & Suggestions',
                          onTap: () => _navigateToPage(const FeedbackScreen()),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      
                      // Legal Section
                      _buildSectionHeader('Legal'),
                      const SizedBox(height: 16),
                      _buildSettingsGroup([
                        _buildNavigationItem(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          onTap: () => _navigateToPage(const TermsScreen()),
                        ),
                        _buildNavigationItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () => _navigateToPage(const PrivacyScreen()),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      
                      // App Info
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Solakai',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
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
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primaryEnd,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Column(
            children: [
              item,
              if (!isLast)
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(left: 56),
                  color: AppTheme.dark700,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryEnd,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryEnd,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}