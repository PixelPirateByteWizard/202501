import 'package:flutter/material.dart';

// 白色主题的颜色定义
const Color primaryColor = Color(0xFF6B2C9E);
const Color secondaryColor = Color(0xFFFF2A6D);
const Color backgroundColor = Colors.white;
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF333333);
const Color subtitleColor = Color(0xFF666666);
const Color borderColor = Color(0xFFEEEEEE);

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
                    _buildSectionTitle('我们的使命'),
                    _buildParagraph(
                      'Luvimestra致力于连接个体与平行现实，通过前沿技术和精神指引，让用户探索多元宇宙。',
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('我们的故事'),
                    _buildParagraph(
                      '2023年，由一群跨维度研究人员和精神向导组成的团队创立了Luvimestra，旨在架起不同存在维度之间的桥梁。',
                    ),
                    _buildParagraph(
                      '经过多年的研究和开发，我们创建了一个平台，让用户能够与自己的平行版本建立联系，并通过引导冥想、塔罗牌阅读和星象学来体验不同的现实。',
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('我们的团队'),
                    _buildTeamMember(
                      '艾拉拉·沃斯博士',
                      '创始人 & 量子物理学家',
                      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200&auto=format&fit=crop',
                    ),
                    _buildTeamMember(
                      '奥利安·布莱克伍德',
                      '精神向导 & 塔罗牌大师',
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
                    ),
                    _buildTeamMember(
                      '露娜·塞莱斯特',
                      '占星师 & 宇宙导航员',
                      'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=200&auto=format&fit=crop',
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('联系方式'),
                    _buildContactInfo('邮箱', 'contact@luvimestra.com'),
                    _buildContactInfo('地址', '宇宙大道1024号，虚空区'),
                    _buildContactInfo('电话', '+1 (888) 555-0123'),
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
            '关于我们',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String imageUrl) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: primaryColor,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: const Color.fromARGB(255, 243, 235, 235),
                      size: 30,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 248, 240, 240),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 232, 224, 224), //ddddd
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForLabel(label),
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case '邮箱':
        return Icons.email_outlined;
      case '地址':
        return Icons.location_on_outlined;
      case '电话':
        return Icons.phone_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
