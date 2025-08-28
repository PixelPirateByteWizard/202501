import 'package:flutter/material.dart';

// 白色主题的颜色定义
const Color primaryColor = Color(0xFF6B2C9E);
const Color secondaryColor = Color(0xFFFF2A6D);
const Color backgroundColor = Colors.white;
const Color cardColor = Colors.white;
const Color textColor = Color.fromARGB(255, 165, 164, 164);
const Color subtitleColor = Color(0xFF666666);
const Color borderColor = Color(0xFFEEEEEE);

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrivacyOverview(),
                    const SizedBox(height: 24),
                    _buildSection(
                      title: '数据收集',
                      icon: Icons.data_usage_rounded,
                      iconColor: const Color(0xFF42A5F5), // 柔和蓝色
                      content: '我们收集以下类型的信息：\n\n'
                          '• 个人资料信息：用户名和偏好设置\n'
                          '• 使用数据：您如何与应用程序交互\n'
                          '• 聊天内容：您与AI实体的对话\n'
                          '• 设备信息：设备类型，操作系统版本\n'
                          '• 位置数据：一般位置（国家级别）',
                    ),
                    _buildSection(
                      title: '数据使用',
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFF66BB6A), // 柔和绿色
                      content: '您的数据用于以下目的：\n\n'
                          '• 提供个性化体验\n'
                          '• 改进我们的AI算法\n'
                          '• 增强应用功能和特性\n'
                          '• 解决技术问题\n'
                          '• 分析使用模式以改进服务',
                    ),
                    _buildSection(
                      title: '数据保护',
                      icon: Icons.security_rounded,
                      iconColor: const Color(0xFFAB47BC), // 柔和紫色
                      content: '我们实施以下安全措施：\n\n'
                          '• 所有对话的端到端加密\n'
                          '• 使用行业标准协议的安全数据存储\n'
                          '• 定期安全审计和漏洞测试\n'
                          '• 访问控制和身份验证机制\n'
                          '• 自动威胁检测系统',
                    ),
                    _buildSection(
                      title: '您的隐私权利',
                      icon: Icons.gavel_rounded,
                      iconColor: const Color(0xFFFFA726), // 柔和橙色
                      content: '关于您的数据，您拥有以下权利：\n\n'
                          '• 访问权：请求获取您个人数据的副本\n'
                          '• 更正权：更正不准确的信息\n'
                          '• 删除权：请求删除您的数据\n'
                          '• 限制处理权：限制我们如何使用您的数据\n'
                          '• 数据可携带权：以结构化格式接收您的数据',
                    ),
                    _buildSection(
                      title: '第三方共享',
                      icon: Icons.share_rounded,
                      iconColor: const Color(0xFFFF7043), // 柔和深橙色
                      content: '我们可能与以下第三方共享数据：\n\n'
                          '• 用于数据存储的云服务提供商\n'
                          '• 用于改进我们服务的分析合作伙伴\n'
                          '• 法律要求时的法律机构\n\n'
                          '我们不会将您的个人数据出售给广告商或数据经纪人。',
                    ),
                    _buildSection(
                      title: '数据保留',
                      icon: Icons.access_time_rounded,
                      iconColor: const Color(0xFF26A69A), // 柔和青色
                      content:
                          '我们保留您的数据的时间以提供服务所需或法律要求的时间为限。您可以随时通过应用设置请求删除您的账户和相关数据。',
                    ),
                    const SizedBox(height: 16),
                    _buildLastUpdated(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          ),
          const SizedBox(width: 16),
          Text(
            '隐私与安全',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryColor, const Color(0xFFAB47BC)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '您的隐私很重要',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                '在Luvimestra，我们致力于保护您的隐私并确保您个人信息的安全。本隐私政策解释了我们如何在您使用我们的应用程序时收集、使用和保护您的数据。',
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: 1),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.update,
              size: 16,
              color: subtitleColor,
            ),
            const SizedBox(width: 8),
            Text(
              '最近更新：2023年6月15日',
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
