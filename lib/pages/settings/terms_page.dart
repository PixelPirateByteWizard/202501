import 'package:flutter/material.dart';

// 白色主题的颜色定义
const Color primaryColor = Color(0xFF6B2C9E);
const Color secondaryColor = Color(0xFFFF2A6D);
const Color backgroundColor = Colors.white;
const Color cardColor = Colors.white;
const Color textColor = Color.fromARGB(255, 183, 181, 181);
const Color subtitleColor = Color(0xFF666666);
const Color borderColor = Color(0xFFEEEEEE);

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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
                    _buildIntroduction(),
                    const SizedBox(height: 24),
                    _buildTermsSection(
                      title: '1. 条款接受',
                      content:
                          '通过访问或使用Luvimestra，您同意受这些服务条款的约束。如果您不同意这些条款，请不要使用本应用程序。',
                    ),
                    _buildTermsSection(
                      title: '2. 用户账户',
                      content:
                          '您负责维护您的账户信息的机密性，并对在您账户下发生的所有活动负责。您同意立即通知我们任何未经授权使用您的账户或任何其他安全漏洞的情况。',
                    ),
                    _buildTermsSection(
                      title: '3. 用户内容',
                      content:
                          '您保留对您在Luvimestra上提交、发布或显示的任何内容的所有权利。通过提交内容，您授予我们全球范围内的非独占性、免版税许可，允许我们使用、复制、修改、改编、发布、翻译和分发此类内容，以任何媒体格式呈现。',
                    ),
                    _buildTermsSection(
                      title: '4. 禁止行为',
                      content: '您同意不参与以下任何禁止活动：\n\n'
                          '• 违反任何适用法律或法规\n'
                          '• 冒充任何人或实体\n'
                          '• 干扰或中断服务\n'
                          '• 尝试未经授权访问服务\n'
                          '• 将服务用于任何非法或有害目的',
                    ),
                    _buildTermsSection(
                      title: '5. 知识产权',
                      content:
                          'Luvimestra及其原创内容、功能和特性均由Luvimestra所有，并受国际版权、商标、专利、商业秘密和其他知识产权法律保护。',
                    ),
                    _buildTermsSection(
                      title: '6. 终止',
                      content:
                          '我们可能会立即终止或暂停您的账户和对服务的访问，无需事先通知或承担责任，理由包括但不限于违反这些服务条款。',
                    ),
                    _buildTermsSection(
                      title: '7. 责任限制',
                      content:
                          '在任何情况下，Luvimestra及其董事、员工、合作伙伴、代理商、供应商或附属机构均不对任何间接、偶然、特殊、后果性或惩罚性损害负责，包括但不限于利润损失、数据损失、使用损失、商誉损失或其他无形损失。',
                    ),
                    _buildTermsSection(
                      title: '8. 免责声明',
                      content:
                          '您使用Luvimestra的风险完全由您自己承担。该服务按"原样"和"可用性"提供。我们明确声明不提供任何形式的保证，无论是明示的还是暗示的。',
                    ),
                    _buildTermsSection(
                      title: '9. 适用法律',
                      content:
                          '这些条款应受Luvimestra运营所在司法管辖区的法律管辖并据其解释，不考虑其法律冲突规定。',
                    ),
                    _buildTermsSection(
                      title: '10. 条款变更',
                      content:
                          '我们保留随时修改或替换这些条款的权利。定期查看这些条款的变更是您的责任。在发布任何变更后继续使用该服务即表示您接受这些变更。',
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
            '服务条款',
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

  Widget _buildIntroduction() {
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
              const Color(0xFF26A69A).withOpacity(0.05), // 柔和青色
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
                        color: const Color(0xFF26A69A).withOpacity(0.2),
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
                          colors: [
                            const Color(0xFF26A69A),
                            const Color(0xFF26A69A).withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.description_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '服务条款',
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
                '欢迎使用Luvimestra。在使用我们的应用程序之前，请仔细阅读这些服务条款。这些条款规定了您对Luvimestra的使用，并提供了关于您与我们之间法律协议的信息。',
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

  Widget _buildTermsSection({
    required String title,
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
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF26A69A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    title.split('.')[0],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF26A69A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title.split('. ')[1],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
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
