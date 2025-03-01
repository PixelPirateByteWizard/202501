import 'package:flutter/material.dart';
import '../GelroIAP/RestartMultiTempleReference.dart';
import 'ai_assistant_chat.dart'; // Import the AI assistant chat page

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF2A2D5F),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Settings Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '• App Information: Learn about app details and features\n'
                  '• Support & Feedback: Get help or share your thoughts\n'
                  '• Privacy & Security: Manage your privacy settings\n'
                  '• Tap any item to access more detailed options',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B6BF3),
                          Color(0xFF6B4DE3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0B2E),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 24.0),
                  child: Column(
                    children: [
                      // AI Assistant Card
                      _buildCard(
                        context,
                        title: "AI Assistant",
                        items: [
                          SettingsItem(
                            icon: Icons.chat_outlined,
                            title: 'Eco Assistant Chat',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AIAssistantChat(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Store Card (Updated to English)
                      _buildCard(
                        context,
                        title: "Store & Purchases",
                        items: [
                          SettingsItem(
                            icon: Icons.diamond_outlined,
                            title: 'Gem Store',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CancelCriticalVariableCreator(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildCard(
                        context,
                        title: "App Information",
                        items: [
                          SettingsItem(
                            icon: Icons.info_outline,
                            title: 'About App',
                            onTap: () => Navigator.pushNamed(
                                context, '/app_introduction'),
                          ),
                          SettingsItem(
                            icon: Icons.book,
                            title: 'User Manual',
                            onTap: () =>
                                Navigator.pushNamed(context, '/user_manual'),
                          ),
                          SettingsItem(
                            icon: Icons.apps,
                            title: 'Features',
                            onTap: () =>
                                Navigator.pushNamed(context, '/app_features'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildCard(
                        context,
                        title: "Support & Feedback",
                        items: [
                          SettingsItem(
                            icon: Icons.feedback,
                            title: 'Feedback',
                            onTap: () =>
                                Navigator.pushNamed(context, '/feedback'),
                          ),
                          SettingsItem(
                            icon: Icons.contact_support,
                            title: 'Contact Us',
                            onTap: () =>
                                Navigator.pushNamed(context, '/contact_us'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildCard(
                        context,
                        title: "Privacy & Security",
                        items: [
                          SettingsItem(
                            icon: Icons.security,
                            title: 'Privacy Policy',
                            onTap: () =>
                                Navigator.pushNamed(context, '/privacy_policy'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Customize your app preferences',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8B6BF3),
                            Color(0xFF6B4DE3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B6BF3).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.help_outline_rounded),
                        color: Colors.white,
                        onPressed: () => _showHelpDialog(context),
                        tooltip: 'View Settings Guide',
                      ),
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

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Divider(
              height: 1,
              color: Color(0xFF3D4075),
            ),
            ...items.map((item) => Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8B6BF3),
                              Color(0xFF6B4DE3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B6BF3).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 16,
                      ),
                      onTap: item.onTap,
                    ),
                    if (items.last != item)
                      const Divider(
                        height: 1,
                        color: Color(0xFF3D4075),
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
