import 'package:flutter/material.dart';

class ReportComplaintPage extends StatelessWidget {
  const ReportComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '举报与投诉',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroSection(),
            const SizedBox(height: 24),
            _buildReportTypeSection(context),
            const SizedBox(height: 24),
            _buildReportProcessSection(context),
            const SizedBox(height: 24),
            _buildGuidelinesSection(context),
            const SizedBox(height: 24),
            _buildContactSection(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B2C9E).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.report_problem_outlined,
                  color: Color(0xFF6B2C9E),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '举报与投诉中心',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A0B47),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '我们致力于维护健康、安全的社区环境',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '关于举报与投诉',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A0B47),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Luvimestra致力于为所有用户提供安全、友好的使用环境。如果您在使用过程中遇到任何不良内容或行为，请通过本页面了解如何进行举报和投诉。',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '我们会认真对待每一条举报，并根据社区准则采取相应措施。您的反馈对我们维护健康的社区环境至关重要。',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildReportTypeSection(BuildContext context) {
    final reportTypes = [
      {
        'title': '不良内容',
        'icon': Icons.block,
        'color': Colors.red[700]!,
        'description': '包括但不限于色情、暴力、血腥、恐怖等违反法律法规的内容'
      },
      {
        'title': '侵犯隐私',
        'icon': Icons.visibility_off,
        'color': Colors.orange[700]!,
        'description': '未经授权披露他人个人信息，包括真实姓名、地址、电话等'
      },
      {
        'title': '虚假信息',
        'icon': Icons.info_outline,
        'color': Colors.amber[700]!,
        'description': '传播虚假、误导性信息，可能对他人造成误解或伤害'
      },
      {
        'title': '仇恨言论',
        'icon': Icons.sentiment_very_dissatisfied,
        'color': Colors.purple[700]!,
        'description': '基于种族、民族、宗教、性别等的歧视性言论'
      },
      {
        'title': '骚扰行为',
        'icon': Icons.person_off,
        'color': Colors.blue[700]!,
        'description': '持续骚扰、威胁或恐吓他人的行为'
      },
      {
        'title': '其他问题',
        'icon': Icons.more_horiz,
        'color': Colors.grey[700]!,
        'description': '其他违反社区准则的行为'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '可举报的内容类型',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A0B47),
          ),
        ),
        const SizedBox(height: 16),
        ...reportTypes.map((type) => _buildReportTypeItem(
              title: type['title'] as String,
              icon: type['icon'] as IconData,
              color: type['color'] as Color,
              description: type['description'] as String,
            )),
      ],
    );
  }

  Widget _buildReportTypeItem({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportProcessSection(BuildContext context) {
    final steps = [
      {
        'title': '发现问题',
        'description': '在使用过程中发现不良内容或行为',
        'icon': Icons.visibility,
      },
      {
        'title': '长按操作',
        'description': '长按相关内容（卡片、消息等）',
        'icon': Icons.touch_app,
      },
      {
        'title': '选择举报',
        'description': '在弹出菜单中选择"举报"选项',
        'icon': Icons.report_outlined,
      },
      {
        'title': '填写信息',
        'description': '选择举报原因并提供详细说明',
        'icon': Icons.edit_note,
      },
      {
        'title': '提交举报',
        'description': '点击"提交举报"按钮完成操作',
        'icon': Icons.send,
      },
      {
        'title': '等待处理',
        'description': '我们的团队会尽快审核并处理您的举报',
        'icon': Icons.hourglass_bottom,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '举报流程',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A0B47),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < steps.length; i++)
                _buildProcessStep(
                  step: i + 1,
                  title: steps[i]['title'] as String,
                  description: steps[i]['description'] as String,
                  icon: steps[i]['icon'] as IconData,
                  isLast: i == steps.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProcessStep({
    required int step,
    required String title,
    required String description,
    required IconData icon,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 步骤数字和连接线
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF6B2C9E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B2C9E).withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: const Color(0xFFE0E0E0),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // 步骤内容
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF6B2C9E),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A0B47),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.4,
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
    );
  }

  Widget _buildGuidelinesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '举报准则',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A0B47),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            children: [
              _buildGuidelineItem(
                '请提供准确信息',
                '确保您提供的举报信息真实准确，这有助于我们更快地处理问题。',
                Icons.check_circle_outline,
              ),
              const Divider(height: 24),
              _buildGuidelineItem(
                '保持客观',
                '请以客观的态度描述问题，避免使用情绪化的语言。',
                Icons.balance,
              ),
              const Divider(height: 24),
              _buildGuidelineItem(
                '不滥用举报功能',
                '请不要因个人不喜欢或意见不合而滥用举报功能，这可能会影响我们处理真正违规内容的效率。',
                Icons.warning_amber,
              ),
              const Divider(height: 24),
              _buildGuidelineItem(
                '保护隐私',
                '举报过程中请勿分享他人的个人敏感信息。',
                Icons.lock_outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelineItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF6B2C9E),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A0B47),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '联系我们',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A0B47),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                '如果您有任何关于举报或投诉的问题，或者遇到紧急情况需要立即处理，请通过以下方式联系我们：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                '客服邮箱',
                'support@luvimestra.com',
                Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                '举报专线',
                '400-888-8888',
                Icons.phone_outlined,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                '工作时间',
                '周一至周日 9:00-21:00',
                Icons.access_time,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(String title, String content, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6B2C9E),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2A0B47),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
