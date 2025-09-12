import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('用户协议'),
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
                          '《烽尘绘谱》用户服务协议',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '生效日期：2024年1月1日',
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
              
              // 协议内容
              _buildSection(
                context,
                title: '1. 协议的接受',
                content: '欢迎使用《烽尘绘谱》游戏（以下简称"本游戏"）。在您下载、安装、使用本游戏之前，请仔细阅读本用户服务协议（以下简称"本协议"）。您使用本游戏即表示您同意接受本协议的全部条款。',
              ),
              
              _buildSection(
                context,
                title: '2. 游戏服务',
                content: '本游戏是一款基于AI技术的三国题材文字RPG游戏。我们致力于为用户提供优质的游戏体验，包括但不限于：\n\n• 动态生成的游戏剧情\n• 武将收集和培养系统\n• 策略性战斗体验\n• 个性化游戏设置',
              ),
              
              _buildSection(
                context,
                title: '3. 用户权利与义务',
                content: '3.1 用户权利：\n• 享受游戏提供的各项功能和服务\n• 对游戏提出合理建议和意见\n• 要求保护个人隐私和游戏数据\n\n3.2 用户义务：\n• 遵守相关法律法规\n• 不得利用游戏进行违法活动\n• 不得恶意破坏游戏环境\n• 尊重其他用户的合法权益',
              ),
              
              _buildSection(
                context,
                title: '4. 知识产权',
                content: '本游戏的所有内容，包括但不限于文字、图像、音频、代码、界面设计等，均受知识产权法保护。未经授权，用户不得复制、修改、传播或用于商业用途。',
              ),
              
              _buildSection(
                context,
                title: '5. 隐私保护',
                content: '我们重视用户隐私保护，严格按照《隐私协议》处理用户信息。我们承诺：\n\n• 不会收集用户敏感个人信息\n• 游戏数据仅用于提供游戏服务\n• 采用适当的安全措施保护用户数据\n• 不会向第三方出售用户信息',
              ),
              
              _buildSection(
                context,
                title: '6. 免责声明',
                content: '6.1 本游戏按"现状"提供，我们不对游戏的完整性、准确性、可靠性作出保证。\n\n6.2 因不可抗力、网络故障、设备问题等原因导致的游戏中断或数据丢失，我们不承担责任。\n\n6.3 用户因使用本游戏而产生的任何直接或间接损失，我们不承担责任。',
              ),
              
              _buildSection(
                context,
                title: '7. 协议修改',
                content: '我们保留随时修改本协议的权利。协议修改后，我们会在游戏内或官方渠道发布通知。用户继续使用游戏即视为接受修改后的协议。',
              ),
              
              _buildSection(
                context,
                title: '8. 争议解决',
                content: '因本协议产生的争议，双方应友好协商解决。协商不成的，可向有管辖权的人民法院提起诉讼。',
              ),
              
              _buildSection(
                context,
                title: '9. 联系方式',
                content: '如您对本协议有任何疑问，请通过以下方式联系我们：\n\n邮箱：legal@sanguohuiquan.com\n客服QQ：123456789',
              ),
              
              const SizedBox(height: 24),
              
              // 同意按钮
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('我已阅读并同意'),
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