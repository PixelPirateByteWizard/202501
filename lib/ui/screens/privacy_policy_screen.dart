import 'package:flutter/material.dart';
import 'base_info_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseInfoScreen(
      title: '隐私政策',
      children: [
        InfoSection(
          title: '引言',
          children: [
            InfoParagraph(
              '我们非常重视用户的隐私和个人信息保护。本隐私政策详细说明了我们如何收集、使用和保护您的个人信息。',
            ),
          ],
        ),
        InfoSection(
          title: '信息收集',
          children: [
            InfoParagraph(
              '我们收集的信息包括：',
            ),
            InfoParagraph(
              '1. 游戏数据：游戏分数、完成时间、移动步数等',
            ),
            InfoParagraph(
              '2. 设备信息：设备型号、操作系统版本等',
            ),
            InfoParagraph(
              '3. 应用使用数据：使用频率、使用时长等',
            ),
          ],
        ),
        InfoSection(
          title: '信息使用',
          children: [
            InfoParagraph(
              '我们收集的信息将用于：',
            ),
            InfoParagraph(
              '1. 提供、维护和改进游戏服务',
            ),
            InfoParagraph(
              '2. 记录游戏成就和统计数据',
            ),
            InfoParagraph(
              '3. 优化游戏体验',
            ),
            InfoParagraph(
              '4. 分析应用性能和用户行为',
            ),
          ],
        ),
        InfoSection(
          title: '信息保护',
          children: [
            InfoParagraph(
              '我们采取适当的技术和组织措施来保护您的个人信息，防止未经授权的访问、使用或泄露。',
            ),
            InfoParagraph(
              '所有数据都存储在本地设备上，不会上传到服务器。',
            ),
          ],
        ),
        InfoSection(
          title: '信息共享',
          children: [
            InfoParagraph(
              '我们不会将您的个人信息出售、出租或与任何第三方共享。',
            ),
            InfoParagraph(
              '除非：',
            ),
            InfoParagraph(
              '1. 获得您的明确同意',
            ),
            InfoParagraph(
              '2. 法律法规要求',
            ),
          ],
        ),
        InfoSection(
          title: '用户权利',
          children: [
            InfoParagraph(
              '您有权：',
            ),
            InfoParagraph(
              '1. 访问您的个人信息',
            ),
            InfoParagraph(
              '2. 更正不准确的信息',
            ),
            InfoParagraph(
              '3. 删除您的个人信息',
            ),
            InfoParagraph(
              '4. 撤回同意',
            ),
          ],
        ),
        InfoSection(
          title: '政策更新',
          children: [
            InfoParagraph(
              '我们可能会不时更新本隐私政策。更新后的政策将在应用内发布，并在发布时生效。',
            ),
            InfoParagraph(
              '建议您定期查看本政策以了解任何变更。继续使用本应用即表示您接受更新后的隐私政策。',
            ),
          ],
        ),
        InfoSection(
          title: '联系我们',
          children: [
            InfoParagraph(
              '如果您对本隐私政策有任何疑问或建议，请通过应用内的"反馈与建议"功能与我们联系。',
            ),
          ],
        ),
      ],
    );
  }
}
