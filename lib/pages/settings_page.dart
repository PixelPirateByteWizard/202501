import 'package:flutter/material.dart';
import '../utils/navigation.dart';
import '../utils/cartoon_ui.dart';
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
      child: Row(
        children: [
          CartoonUI.cartoonIconContainer(
            icon: Icons.settings_rounded,
            size: 56,
            iconSize: 28,
            backgroundColor: primaryColor,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '设置',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '个性化你的体验',
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard() {
    return CartoonUI.cartoonCard(
      child: Column(
        children: [
          _buildCardHeader('购买', Icons.shopping_bag_rounded),
          _buildSettingItem(
            icon: Icons.diamond_rounded,
            title: '内购商店',
            subtitle: '解锁更多精彩功能',
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
    return CartoonUI.cartoonCard(
      child: Column(
        children: [
          _buildCardHeader('信息', Icons.info_rounded),
          _buildSettingItem(
            icon: Icons.groups_rounded,
            title: '关于我们',
            subtitle: '了解我们的故事',
            iconColor: const Color(0xFF5C6BC0), // 靛蓝色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const AboutUsPage(),
              );
            },
          ),
          CartoonUI.cartoonDivider(margin: const EdgeInsets.symmetric(horizontal: 16)),
          _buildSettingItem(
            icon: Icons.help_center_rounded,
            title: '帮助中心',
            subtitle: '常见问题解答',
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
    return CartoonUI.cartoonCard(
      child: Column(
        children: [
          _buildCardHeader('支持', Icons.support_agent_rounded),
          _buildSettingItem(
            icon: Icons.feedback_rounded,
            title: '问题反馈',
            subtitle: '告诉我们你的想法',
            iconColor: const Color(0xFF66BB6A), // 柔和绿色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const FeedbackPage(),
              );
            },
          ),
          CartoonUI.cartoonDivider(margin: const EdgeInsets.symmetric(horizontal: 16)),
          _buildSettingItem(
            icon: Icons.report_rounded,
            title: '举报与投诉',
            subtitle: '维护社区环境',
            iconColor: const Color(0xFFEF5350), // 柔和红色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const ReportComplaintPage(),
              );
            },
          ),
          CartoonUI.cartoonDivider(margin: const EdgeInsets.symmetric(horizontal: 16)),
          _buildSettingItem(
            icon: Icons.support_rounded,
            title: '联系客服',
            subtitle: '24小时在线服务',
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
    return CartoonUI.cartoonCard(
      child: Column(
        children: [
          _buildCardHeader('法律', Icons.gavel_rounded),
          _buildSettingItem(
            icon: Icons.security_rounded,
            title: '隐私与安全',
            subtitle: '保护你的数据安全',
            iconColor: const Color(0xFFAB47BC), // 柔和紫色
            onTap: () {
              NavigationUtil.navigateWithAnimation(
                context,
                const PrivacyPage(),
              );
            },
          ),
          CartoonUI.cartoonDivider(margin: const EdgeInsets.symmetric(horizontal: 16)),
          _buildSettingItem(
            icon: Icons.description_rounded,
            title: '服务条款',
            subtitle: '使用协议与规范',
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
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
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
    String? subtitle,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withOpacity(0.15),
                      iconColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: iconColor.withOpacity(0.2),
                    width: 1,
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: subtitleColor,
                  size: 20,
                ),
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
    return CartoonUI.cartoonCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CartoonUI.cartoonIconContainer(
            icon: Icons.favorite_rounded,
            backgroundColor: const Color(0xFFFF2A6D),
            size: 40,
            iconSize: 20,
          ),
          const SizedBox(height: 12),
          Text(
            'Luvimestra',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '感谢你的使用 ❤️',
            style: TextStyle(
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
