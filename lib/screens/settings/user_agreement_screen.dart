import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '用户协议',
                          style: TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '最后更新：2024年12月',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          '1. 接受条款',
                          '欢迎使用烽尘会谱游戏！通过下载、安装或使用本游戏，您同意受本用户协议的约束。如果您不同意本协议的任何条款，请不要使用本游戏。',
                        ),
                        _buildSection(
                          '2. 游戏服务',
                          '烽尘会谱是一款单机策略卡牌游戏，提供以下服务：\n'
                          '• 完整的三国历史战役体验\n'
                          '• 武将收集和培养系统\n'
                          '• 多样化的阵型和策略玩法\n'
                          '• 成就和奖励系统\n'
                          '• 本地数据存储和管理',
                        ),
                        _buildSection(
                          '3. 用户行为规范',
                          '在使用本游戏时，您同意：\n'
                          '• 遵守当地法律法规\n'
                          '• 不使用任何外挂、作弊软件或修改游戏文件\n'
                          '• 不进行任何可能损害游戏体验的行为\n'
                          '• 不传播恶意软件或病毒\n'
                          '• 尊重知识产权，不进行盗版或破解',
                        ),
                        _buildSection(
                          '4. 知识产权',
                          '本游戏及其所有内容（包括但不限于文字、图像、音频、视频、代码等）均受知识产权法保护。除非法律明确允许，否则您不得：\n'
                          '• 复制、修改、分发游戏内容\n'
                          '• 进行反向工程或反编译\n'
                          '• 用于商业目的\n'
                          '• 移除版权声明或其他标识',
                        ),
                        _buildSection(
                          '5. 免责声明',
                          '本游戏按"现状"提供，我们不保证：\n'
                          '• 游戏完全无错误或不间断运行\n'
                          '• 满足您的特定需求\n'
                          '• 与所有设备完全兼容\n'
                          '• 数据不会丢失（建议定期备份）',
                        ),
                        _buildSection(
                          '6. 责任限制',
                          '在法律允许的最大范围内，我们不对以下情况承担责任：\n'
                          '• 因使用或无法使用游戏而造成的任何损失\n'
                          '• 数据丢失或设备损坏\n'
                          '• 第三方行为造成的损失\n'
                          '• 不可抗力因素导致的问题',
                        ),
                        _buildSection(
                          '7. 协议修改',
                          '我们保留随时修改本协议的权利。重大修改将通过游戏内通知或其他适当方式告知用户。继续使用游戏即表示您接受修改后的协议。',
                        ),
                        _buildSection(
                          '8. 终止',
                          '您可以随时停止使用本游戏并删除相关文件。我们也保留在您违反本协议时终止服务的权利。',
                        ),
                        _buildSection(
                          '9. 联系我们',
                          '如果您对本协议有任何疑问，请通过以下方式联系我们：\n'
                          '邮箱：legal@fengchen.game\n'
                          '官网：www.fengchen.game',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '感谢您选择烽尘会谱，祝您游戏愉快！',
                          style: TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '用户协议',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}