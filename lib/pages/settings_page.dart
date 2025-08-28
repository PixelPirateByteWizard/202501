import 'package:flutter/material.dart';
import '../utils/navigation.dart';
import 'settings/about_us_page.dart';
import 'settings/feedback_page.dart';
import 'settings/help_center_page.dart';
import 'settings/customer_service_page.dart';
import 'settings/privacy_page.dart';
import 'settings/terms_page.dart';
import 'settings/report_complaint_page.dart';
import '../luvimestraIAP/ResumeFirstSessionContainer.dart';

// 白色主题的颜色定义
const Color primaryColor = Color(0xFF6B2C9E);
const Color secondaryColor = Color(0xFFFF2A6D);
const Color backgroundColor = Colors.white;
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF333333);
const Color subtitleColor = Color(0xFF666666); //ssssss
const Color borderColor = Color(0xFFEEEEEE);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildPurchaseCard(),
                      const SizedBox(height: 24),
                      _buildInfoCard(),
                      const SizedBox(height: 24),
                      _buildSupportCard(),
                      const SizedBox(height: 24),
                      _buildLegalCard(),
                      const SizedBox(height: 30),
                      _buildVersionInfo(),
                      const SizedBox(height: 24),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Text(
        '设置',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildPurchaseCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      color: cardColor,
      child: Column(
        children: [
          _buildCardHeader('购买', Icons.shopping_bag),
          _buildSettingItem(
            icon: Icons.diamond,
            title: '内购商店',
            iconColor: const Color(0xFFFFD700), // 金色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const UpgradeAsynchronousCaptionType(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      color: cardColor,
      child: Column(
        children: [
          _buildCardHeader('信息', Icons.info),
          _buildSettingItem(
            icon: Icons.groups_rounded,
            title: '关于我们',
            iconColor: const Color(0xFF5C6BC0), // 靛蓝色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const AboutUsPage(),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.help_center_rounded,
            title: '帮助中心',
            iconColor: const Color(0xFFFFA726), // 柔和橙色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const HelpCenterPage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      color: cardColor,
      child: Column(
        children: [
          _buildCardHeader('支持', Icons.support_agent),
          _buildSettingItem(
            icon: Icons.feedback_rounded,
            title: '问题反馈',
            iconColor: const Color(0xFF66BB6A), // 柔和绿色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const FeedbackPage(),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.report_outlined,
            title: '举报与投诉',
            iconColor: const Color(0xFFEF5350), // 柔和红色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const ReportComplaintPage(),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.support_rounded,
            title: '联系客服',
            iconColor: const Color(0xFFFF7043), // 柔和深橙色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const CustomerServicePage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      color: cardColor,
      child: Column(
        children: [
          _buildCardHeader('法律', Icons.gavel),
          _buildSettingItem(
            icon: Icons.security_rounded,
            title: '隐私与安全',
            iconColor: const Color(0xFFAB47BC), // 柔和紫色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const PrivacyPage(),
              );
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.description_rounded,
            title: '服务条款',
            iconColor: const Color(0xFF26A69A), // 柔和青色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const TermsPage(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: subtitleColor,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: borderColor,
        height: 1,
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Text(
        'Luvimestra v1.0.0',
        style: TextStyle(
          fontSize: 12,
          color: subtitleColor,
        ),
      ),
    );
  }
}
