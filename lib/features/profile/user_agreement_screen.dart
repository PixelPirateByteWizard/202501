import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: SafeArea(
        child: Column(
          children: [
            // Navigation Bar
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFFE6EDF3),
                      size: 28,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '用户协议',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE6EDF3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 28), // Balance the back button
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '欢迎使用 CoinVerse',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6EDF3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '最后更新时间：2025年1月',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B949E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      '1. 服务条款',
                      '欢迎您使用 CoinVerse 应用程序。通过访问或使用我们的服务，您同意受本用户协议的约束。如果您不同意这些条款，请不要使用我们的服务。',
                    ),
                    _buildSection(
                      '2. 服务描述',
                      'CoinVerse 是一个加密货币信息和分析平台，为用户提供市场数据、新闻资讯和AI分析报告。我们致力于为用户提供准确、及时的加密货币相关信息。',
                    ),
                    _buildSection(
                      '3. 用户责任',
                      '您承诺：\n• 提供真实、准确的个人信息\n• 不滥用我们的服务\n• 遵守所有适用的法律法规\n• 不从事任何可能损害服务的活动',
                    ),
                    _buildSection(
                      '4. 免责声明',
                      '本应用提供的信息仅供参考，不构成投资建议。加密货币投资存在高风险，您应该根据自己的判断做出投资决策。我们不对因使用本服务而产生的任何损失承担责任。',
                    ),
                    _buildSection(
                      '5. 知识产权',
                      '本应用的所有内容，包括但不限于文本、图片、音频、视频、软件等，均受知识产权法保护。未经授权，您不得复制、修改、分发或以其他方式使用这些内容。',
                    ),
                    _buildSection(
                      '6. 服务变更',
                      '我们保留随时修改或终止服务的权利，恕不另行通知。我们也可能会不时更新本用户协议，更新后的协议将在应用内发布。',
                    ),
                    _buildSection(
                      '7. 联系我们',
                      '如果您对本用户协议有任何疑问，请通过应用内的反馈功能联系我们。',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE6EDF3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8B949E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
