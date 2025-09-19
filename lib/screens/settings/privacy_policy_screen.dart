import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                          '隐私政策',
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
                          '1. 隐私保护承诺',
                          '烽尘工作室深知个人信息对您的重要性，并会尽全力保护您的个人信息安全可靠。我们致力于维持您对我们的信任，恪守以下原则，保护您的个人信息：权责一致原则、目的明确原则、选择同意原则、最少够用原则、确保安全原则、主体参与原则、公开透明原则等。',
                        ),
                        _buildSection(
                          '2. 我们收集的信息',
                          '烽尘会谱是一款单机游戏，我们承诺：\n'
                          '• 不收集您的个人身份信息\n'
                          '• 不收集您的联系方式\n'
                          '• 不收集您的位置信息\n'
                          '• 不访问您的通讯录或相册\n'
                          '• 游戏数据仅存储在您的本地设备上',
                        ),
                        _buildSection(
                          '3. 设备信息',
                          '为了确保游戏正常运行和优化体验，我们可能会收集以下设备信息：\n'
                          '• 设备型号和操作系统版本\n'
                          '• 游戏崩溃日志（仅用于修复bug）\n'
                          '• 游戏性能数据（帧率、内存使用等）\n'
                          '• 这些信息均为匿名数据，不会与您的个人身份关联',
                        ),
                        _buildSection(
                          '4. 数据存储',
                          '您的游戏数据存储方式：\n'
                          '• 所有游戏进度、设置、成就等数据均存储在您的本地设备\n'
                          '• 我们不会将您的游戏数据上传到服务器\n'
                          '• 您可以随时删除游戏来清除所有本地数据\n'
                          '• 建议您定期备份重要的游戏数据',
                        ),
                        _buildSection(
                          '5. 数据安全',
                          '我们采取以下措施保护您的数据安全：\n'
                          '• 使用加密技术保护本地存储的游戏数据\n'
                          '• 定期更新安全措施和修复漏洞\n'
                          '• 不与第三方共享您的任何数据\n'
                          '• 严格限制内部人员对数据的访问权限',
                        ),
                        _buildSection(
                          '6. 第三方服务',
                          '本游戏可能使用以下第三方服务：\n'
                          '• 应用商店服务（用于游戏分发和更新）\n'
                          '• 设备系统服务（用于基本功能）\n'
                          '• 我们不会主动向第三方提供您的个人信息\n'
                          '• 请查阅相关第三方的隐私政策了解详情',
                        ),
                        _buildSection(
                          '7. 儿童隐私保护',
                          '我们非常重视儿童的隐私保护：\n'
                          '• 本游戏适合全年龄段用户\n'
                          '• 不包含不适宜儿童的内容\n'
                          '• 不会故意收集13岁以下儿童的个人信息\n'
                          '• 建议家长监督儿童的游戏时间',
                        ),
                        _buildSection(
                          '8. 您的权利',
                          '您对自己的数据享有以下权利：\n'
                          '• 查看权：您可以随时查看游戏内的数据\n'
                          '• 修改权：您可以在游戏内修改相关设置\n'
                          '• 删除权：您可以删除游戏来清除所有数据\n'
                          '• 导出权：您可以备份游戏数据到其他位置',
                        ),
                        _buildSection(
                          '9. 政策更新',
                          '我们可能会不时更新本隐私政策：\n'
                          '• 重大变更会通过游戏内通知告知\n'
                          '• 您可以在设置页面查看最新版本\n'
                          '• 继续使用游戏即表示同意更新后的政策\n'
                          '• 如不同意变更，您可以停止使用游戏',
                        ),
                        _buildSection(
                          '10. 联系我们',
                          '如果您对本隐私政策有任何疑问或建议，请联系我们：\n'
                          '邮箱：privacy@fengchen.game\n'
                          '官网：www.fengchen.game\n'
                          '我们将在收到您的反馈后尽快回复。',
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.primaryGold.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Text(
                            '重要提醒：本游戏承诺保护您的隐私，不会收集或上传您的个人信息。所有游戏数据均安全存储在您的本地设备中。',
                            style: TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
            '隐私政策',
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