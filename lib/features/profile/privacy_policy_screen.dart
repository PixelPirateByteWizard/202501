import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                      '隐私协议',
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
                      'CoinVerse 隐私政策',
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
                      '1. 信息收集',
                      '我们可能收集以下类型的信息：\n• 您主动提供的信息（如反馈内容）\n• 自动收集的信息（如设备信息、使用统计）\n• 第三方服务提供的信息（如市场数据）',
                    ),
                    _buildSection(
                      '2. 信息使用',
                      '我们使用收集的信息来：\n• 提供和改进我们的服务\n• 个性化用户体验\n• 发送重要通知\n• 分析服务使用情况\n• 确保服务安全',
                    ),
                    _buildSection(
                      '3. 信息共享',
                      '我们不会出售、交易或转让您的个人信息给第三方，除非：\n• 获得您的明确同意\n• 法律要求\n• 保护我们的权利和安全\n• 与可信的第三方服务提供商合作',
                    ),
                    _buildSection(
                      '4. 数据安全',
                      '我们采用适当的技术和组织措施来保护您的个人信息，包括：\n• 数据加密\n• 访问控制\n• 定期安全审查\n• 员工培训',
                    ),
                    _buildSection(
                      '5. 数据保留',
                      '我们只在必要的时间内保留您的个人信息。具体保留期限取决于信息类型和使用目的。当信息不再需要时，我们会安全地删除或匿名化处理。',
                    ),
                    _buildSection(
                      '6. 您的权利',
                      '您有权：\n• 访问您的个人信息\n• 更正不准确的信息\n• 删除您的个人信息\n• 限制信息处理\n• 数据可携带性',
                    ),
                    _buildSection(
                      '7. Cookie 和追踪技术',
                      '我们可能使用 Cookie 和类似技术来改善用户体验、分析使用情况和提供个性化内容。您可以通过设备设置管理这些技术的使用。',
                    ),
                    _buildSection(
                      '8. 第三方链接',
                      '我们的服务可能包含第三方网站或服务的链接。我们不对这些第三方的隐私做法负责。建议您查看他们的隐私政策。',
                    ),
                    _buildSection(
                      '9. 政策更新',
                      '我们可能会不时更新本隐私政策。重大变更将通过应用内通知或其他适当方式告知您。',
                    ),
                    _buildSection(
                      '10. 联系我们',
                      '如果您对本隐私政策有任何疑问或关切，请通过应用内的反馈功能联系我们。',
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
