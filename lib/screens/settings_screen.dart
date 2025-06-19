import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_settings_service.dart';
import '../widgets/app_background.dart';
import 'about_us_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'usage_help_screen.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 Provider 来获取和监听设置服务的变化
    final settings = Provider.of<GameSettingsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        backgroundIndex: 2,
        overlayOpacity: 0.7,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            // 图像设置区域
            _buildSectionHeader(context, '图像设置', Icons.image_outlined),
            _buildCard(
              child: Column(
                children: [
                  _buildSwitchTile(
                    context: context,
                    title: '粒子效果',
                    icon: Icons.flare_outlined,
                    value: settings.particlesEnabled,
                    onChanged: settings.updateParticlesEnabled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 数据管理区域
            _buildSectionHeader(context, '数据管理', Icons.storage_outlined),
            _buildCard(
              child: _buildSettingsTile(
                context,
                '重置游戏数据',
                Icons.delete_forever_outlined,
                () => _showResetDataDialog(context),
                iconColor: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 24),

            // 关于区域
            _buildSectionHeader(context, '关于', Icons.help_center_outlined),
            _buildCard(
              child: Column(
                children: [
                  _buildSettingsTile(
                    context,
                    '使用帮助',
                    Icons.help_outline,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UsageHelpScreen())),
                  ),
                  const Divider(
                      height: 1,
                      color: Colors.white12,
                      indent: 56,
                      endIndent: 16),
                  _buildSettingsTile(
                    context,
                    '反馈与建议',
                    Icons.feedback_outlined,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedbackScreen())),
                  ),
                  const Divider(
                      height: 1,
                      color: Colors.white12,
                      indent: 56,
                      endIndent: 16),
                  _buildSettingsTile(
                    context,
                    '关于我们',
                    Icons.info_outline,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUsScreen())),
                  ),
                  const Divider(
                      height: 1,
                      color: Colors.white12,
                      indent: 56,
                      endIndent: 16),
                  _buildSettingsTile(
                    context,
                    '用户协议',
                    Icons.gavel_outlined,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserAgreementScreen())),
                  ),
                  const Divider(
                      height: 1,
                      color: Colors.white12,
                      indent: 56,
                      endIndent: 16),
                  _buildSettingsTile(
                    context,
                    '隐私政策',
                    Icons.privacy_tip_outlined,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建区域标题
  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 构建设置项卡片容器
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 0,
      color: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withOpacity(0.3)),
      ),
      child: child,
    );
  }

  // 构建开关设置项
  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, size: 28, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
      inactiveTrackColor: Colors.grey.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // 构建导航设置项
  Widget _buildSettingsTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap,
      {Color iconColor = Colors.blueAccent}) {
    return ListTile(
      leading: Icon(icon, size: 28, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }

  // 显示重置数据确认对话框
  void _showResetDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1a2e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.redAccent, width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('确认重置?', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            '此操作将清除所有游戏统计数据、成就和设置，且无法恢复。确定要继续吗？',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('确认重置'),
              onPressed: () async {
                final settings =
                    Provider.of<GameSettingsService>(context, listen: false);
                await settings.resetAllGameData();

                Navigator.of(dialogContext).pop();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('所有数据已成功重置。'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
