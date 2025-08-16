import 'package:flutter/material.dart';
import '../../shared/widgets/themed_card.dart';
import 'about_screen.dart';
import 'feedback_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Text(
                '我的',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE6EDF3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMenuSection(context),
                  const SizedBox(height: 100), // Bottom padding for tab bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        ThemedCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.group,
                iconColor: const Color(0xFF3B82F6),
                title: '关于我们',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.description,
                iconColor: const Color(0xFF10B981),
                title: '用户协议',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserAgreementScreen()),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.security,
                iconColor: const Color(0xFFF59E0B),
                title: '隐私协议',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ThemedCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                iconColor: const Color(0xFF8B5CF6),
                title: '使用帮助',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                ),
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.edit,
                iconColor: const Color(0xFFF97316),
                title: '反馈和建议',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FeedbackScreen()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 20,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFE6EDF3),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF8B949E),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white.withOpacity(0.1),
    );
  }
}
