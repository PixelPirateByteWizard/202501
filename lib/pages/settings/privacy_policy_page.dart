import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF8FB3B0),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 100,
            color: const Color(0xFF8FB3B0),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.privacy_tip_outlined,
                          color: Color(0xFF8FB3B0),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FB3B0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Color(0xFF8FB3B0),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Last updated: March 15, 2024',
                            style: TextStyle(
                              color: Color(0xFF8FB3B0),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      'Information We Collect',
                      'We collect information that you provide directly to us, including:\n• Account information (email, name)\n• Task and productivity data\n• Usage statistics and preferences\n• Device information',
                      Icons.info_outline,
                    ),
                    _buildSection(
                      'How We Use Your Information',
                      'We use the collected information to:\n• Provide and maintain our services\n• Improve user experience\n• Send important notifications\n• Analyze usage patterns\n• Protect against fraud and abuse',
                      Icons.security_outlined,
                    ),
                    _buildSection(
                      'Data Storage and Security',
                      'We implement appropriate technical and organizational measures to protect your personal information. Data is encrypted during transmission and storage.',
                      Icons.storage_outlined,
                    ),
                    _buildSection(
                      'Data Sharing',
                      'We do not sell your personal information. We may share data with:\n• Service providers\n• Legal authorities when required\n• Business partners (with your consent)',
                      Icons.share_outlined,
                    ),
                    _buildSection(
                      'Your Rights',
                      'You have the right to:\n• Access your personal data\n• Correct inaccurate data\n• Request data deletion\n• Object to data processing\n• Export your data',
                      Icons.verified_user_outlined,
                    ),
                    _buildSection(
                      'Cookies and Tracking',
                      'We use cookies and similar technologies to enhance your experience and collect usage data. You can control these through your device settings.',
                      Icons.cookie_outlined,
                    ),
                    _buildSection(
                      'Children\'s Privacy',
                      'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13.',
                      Icons.child_care_outlined,
                    ),
                    _buildSection(
                      'Contact Us',
                      'For privacy-related questions or concerns, please contact us at privacy@aetherys.com',
                      Icons.contact_support_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF8FB3B0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
