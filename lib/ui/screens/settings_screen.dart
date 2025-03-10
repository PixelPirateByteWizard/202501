import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import 'help_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'feedback_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _showMoveCount = true;
  bool _showTimer = true;
  String _selectedTheme = '默认';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('军机处'),
      ),
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Divider(height: 32),
            _buildSection(
              title: '显示设置',
              children: [
                _buildSwitchTile(
                  icon: Icons.numbers,
                  title: '显示步数',
                  subtitle: '在游戏中显示移动步数',
                  value: _showMoveCount,
                  onChanged: (value) {
                    setState(() {
                      _showMoveCount = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.timer,
                  title: '显示计时器',
                  subtitle: '在游戏中显示计时器',
                  value: _showTimer,
                  onChanged: (value) {
                    setState(() {
                      _showTimer = value;
                    });
                  },
                ),
              ],
            ),
            const Divider(height: 32),
            _buildSection(
              title: '其他',
              children: [
                _buildNavigationTile(
                  icon: Icons.help_outline,
                  title: '使用帮助',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpScreen(),
                    ),
                  ),
                ),
                _buildNavigationTile(
                  icon: Icons.description_outlined,
                  title: '用户协议',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserAgreementScreen(),
                    ),
                  ),
                ),
                _buildNavigationTile(
                  icon: Icons.privacy_tip_outlined,
                  title: '隐私政策',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  ),
                ),
                _buildNavigationTile(
                  icon: Icons.feedback_outlined,
                  title: '反馈与建议',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackScreen(),
                    ),
                  ),
                ),
                _buildNavigationTile(
                  icon: Icons.info_outline,
                  title: '关于应用',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
