import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Settings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.cosmicBlue,
                ),
              ),

              const SizedBox(height: 24),

              // App Information Card
              _buildSettingsCard(
                context,
                title: 'App Information',
                items: [
                  SettingsItem(
                    title: 'About App',
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.blue,
                    route: '/about',
                  ),
                  SettingsItem(
                    title: 'Features Overview',
                    icon: Icons.featured_play_list_outlined,
                    iconColor: Colors.green,
                    route: '/features',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Legal Information Card
              _buildSettingsCard(
                context,
                title: 'Legal Information',
                items: [
                  SettingsItem(
                    title: 'Terms of Service',
                    icon: Icons.gavel_rounded,
                    iconColor: Colors.amber,
                    route: '/terms',
                  ),
                  SettingsItem(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.purple,
                    route: '/privacy',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Support & Info Card
              _buildSettingsCard(
                context,
                title: 'Support & Info',
                items: [
                  SettingsItem(
                    title: 'Send Feedback',
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: Colors.orange,
                    route: '/feedback',
                  ),
                  SettingsItem(
                    title: 'Version Information',
                    icon: Icons.new_releases_outlined,
                    iconColor: Colors.teal,
                    route: '/version',
                    subtitle: AppConstants.appVersion,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Copyright text
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Verzephronix © 2023\nAll rights reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Title
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.cosmicBlue,
              ),
            ),

            const SizedBox(height: 12),

            // Card Items
            ...items.map((item) {
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.iconColor, size: 24),
                    ),
                    title: Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: item.subtitle != null
                        ? Text(
                            item.subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(
                                0.6,
                              ),
                            ),
                          )
                        : null,
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(item.route);
                    },
                  ),
                  if (items.indexOf(item) < items.length - 1)
                    Divider(
                      color: theme.dividerColor.withOpacity(0.3),
                      height: 1,
                    ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class SettingsItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String route;
  final String? subtitle;

  SettingsItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.route,
    this.subtitle,
  });
}
