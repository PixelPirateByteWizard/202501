import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('隐私协议'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 协议标题
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '《烽尘绘谱》隐私保护政策',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '最后更新：2024年1月1日',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 隐私政策内容
              _buildSection(
                context,
                title: '1. 引言',
                content: '《烽尘绘谱》（以下简称"我们"）非常重视用户的隐私保护。本隐私政策说明了我们如何收集、使用、存储和保护您的个人信息。请仔细阅读本政策，以了解我们的隐私保护措施。',
              ),
              
              _buildSection(
                context,
                title: '2. 信息收集',
                content: '2.1 我们收集的信息类型：\n\n• 游戏进度数据（武将、装备、剧情进度等）\n• 游戏设置偏好（音量、文本速度等）\n• 设备信息（设备型号、操作系统版本）\n• 应用使用统计（游戏时长、功能使用频率）\n\n2.2 我们不会收集：\n• 您的真实姓名、身份证号等身份信息\n• 您的联系方式（除非您主动提供反馈）\n• 您的位置信息\n• 您设备上的其他应用信息',
              ),
              
              _buildSection(
                context,
                title: '3. 信息使用',
                content: '我们收集的信息仅用于以下目的：\n\n• 提供游戏服务和功能\n• 保存您的游戏进度\n• 个性化游戏体验\n• 改进游戏质量和性能\n• 提供技术支持\n• 分析游戏使用情况以优化产品',
              ),
              
              _buildSection(
                context,
                title: '4. 信息存储',
                content: '4.1 存储位置：\n• 游戏数据主要存储在您的本地设备上\n• 部分匿名统计数据可能存储在安全的云服务器上\n\n4.2 存储期限：\n• 本地游戏数据将保留直到您卸载应用\n• 云端统计数据保留期不超过2年\n• 您可以随时删除本地游戏数据',
              ),
              
              _buildSection(
                context,
                title: '5. 信息共享',
                content: '我们承诺不会向第三方出售、出租或以其他方式转让您的个人信息，除非：\n\n• 获得您的明确同意\n• 法律法规要求\n• 保护我们的合法权益\n• 紧急情况下保护用户安全\n\n我们可能会与以下第三方共享匿名统计数据：\n• 应用分析服务提供商\n• 云存储服务提供商',
              ),
              
              _buildSection(
                context,
                title: '6. 信息安全',
                content: '我们采取以下措施保护您的信息安全：\n\n• 数据加密存储\n• 访问权限控制\n• 定期安全审计\n• 安全传输协议\n• 及时的安全更新\n\n尽管我们采取了合理的安全措施，但请注意任何网络传输都存在一定风险。',
              ),
              
              _buildSection(
                context,
                title: '7. 用户权利',
                content: '您对自己的个人信息享有以下权利：\n\n• 访问权：了解我们收集了哪些信息\n• 更正权：要求更正不准确的信息\n• 删除权：要求删除您的个人信息\n• 限制处理权：限制我们处理您的信息\n• 数据可携权：获取您的数据副本\n\n如需行使这些权利，请联系我们。',
              ),
              
              _buildSection(
                context,
                title: '8. 儿童隐私',
                content: '我们的游戏适合所有年龄段的用户。对于13岁以下的儿童用户，我们：\n\n• 不会故意收集儿童的个人信息\n• 建议在家长监护下使用\n• 如发现收集了儿童信息，将立即删除\n• 鼓励家长监督孩子的网络活动',
              ),
              
              _buildSection(
                context,
                title: '9. 政策更新',
                content: '我们可能会不时更新本隐私政策。重大变更时，我们会：\n\n• 在游戏内发布通知\n• 通过官方渠道公告\n• 给予合理的过渡期\n\n继续使用游戏即表示您接受更新后的政策。',
              ),
              
              _buildSection(
                context,
                title: '10. 联系我们',
                content: '如您对本隐私政策有任何疑问或建议，请联系我们：\n\n邮箱：privacy@sanguohuiquan.com\n客服QQ：123456789\n\n我们将在收到您的询问后尽快回复。',
              ),
              
              const SizedBox(height: 24),
              
              // 确认按钮
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('我已了解'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                height: 1.6,
                color: AppTheme.lightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}