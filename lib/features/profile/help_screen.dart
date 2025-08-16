import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                      '使用帮助',
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
                      'CoinVerse 使用指南',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6EDF3),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildHelpItem(
                      '如何查看市场数据？',
                      '在"市场"页面，您可以查看各种加密货币的实时价格、涨跌幅和市值信息。点击任意币种可查看详细信息。',
                      Icons.show_chart,
                      const Color(0xFF4A90E2),
                    ),
                    _buildHelpItem(
                      '如何获取最新资讯？',
                      '在"资讯"页面，我们为您精选了最新的加密货币新闻和市场动态。您可以点击文章标题查看完整内容。',
                      Icons.article,
                      const Color(0xFF10B981),
                    ),
                    _buildHelpItem(
                      '如何使用AI助手？',
                      '在"AI助手"页面，您可以向我们的AI询问关于加密货币的任何问题，获得专业的分析和建议。',
                      Icons.psychology,
                      const Color(0xFF8B5CF6),
                    ),
                    _buildHelpItem(
                      '个人信息安全吗？',
                      '我们非常重视用户隐私和数据安全。所有数据都经过加密处理，我们不会向第三方泄露您的个人信息。',
                      Icons.security,
                      const Color(0xFFF59E0B),
                    ),
                    _buildHelpItem(
                      '如何提供反馈？',
                      '您可以在"我的"页面中找到"反馈和建议"选项，我们非常重视您的意见和建议。',
                      Icons.feedback,
                      const Color(0xFFF97316),
                    ),
                    _buildHelpItem(
                      '应用更新频率？',
                      '我们会定期更新应用以提供更好的用户体验和最新功能。建议您开启自动更新以获得最佳体验。',
                      Icons.update,
                      const Color(0xFF06B6D4),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D3447),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.help_outline,
                                color: Color(0xFF4A90E2),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '还有问题？',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE6EDF3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '如果您在使用过程中遇到任何问题，或者有其他疑问，请通过"反馈和建议"功能联系我们。我们的团队会尽快为您解答。',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8B949E),
                              height: 1.5,
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
    );
  }

  Widget _buildHelpItem(
      String question, String answer, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3447),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE6EDF3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
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
