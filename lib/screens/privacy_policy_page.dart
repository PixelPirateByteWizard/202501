import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B2E),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCard(
                      context,
                      title: 'Introduction',
                      content:
                          'At Gelro, we take your privacy seriously. This Privacy Policy explains how we collect, '
                          'use, disclose, and safeguard your information when you use our mobile application. '
                          'Please read this privacy policy carefully. If you do not agree with the terms of this privacy policy, '
                          'please do not access the application.',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Information We Collect',
                      content: '• Account Information\n'
                          '- Email address and username\n'
                          '- Profile information you provide\n\n'
                          '• Device Information\n'
                          '- Device type and model\n'
                          '- Operating system version\n'
                          '- Unique device identifiers\n\n'
                          '• Usage Data\n'
                          '- App features you access\n'
                          '- Time spent on different sections\n'
                          '- Interaction patterns\n\n'
                          '• Location Data (Optional)\n'
                          '- Approximate location (network-based)\n'
                          '- Precise location (GPS, with your consent)',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'How We Use Your Information',
                      content: '• Provide and maintain our Service\n'
                          '• Improve and personalize user experience\n'
                          '• Analyze usage patterns and trends\n'
                          '• Communicate with you about updates\n'
                          '• Detect and prevent fraud\n'
                          '• Comply with legal obligations',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Data Security',
                      content:
                          'We implement appropriate technical and organizational security measures to protect your data:\n\n'
                          '• Encryption during transmission\n'
                          '• Secure data storage\n'
                          '• Regular security assessments\n'
                          '• Access controls and authentication\n'
                          '• Regular security updates',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Your Rights',
                      content: 'You have the right to:\n\n'
                          '• Access your personal data\n'
                          '• Correct inaccurate data\n'
                          '• Request data deletion\n'
                          '• Restrict processing\n'
                          '• Data portability\n'
                          '• Withdraw consent',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Updates to This Policy',
                      content:
                          'We may update this Privacy Policy from time to time. We will notify you of any changes by posting '
                          'the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review '
                          'this Privacy Policy periodically for any changes.',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Contact Us',
                      content:
                          'If you have any questions about this Privacy Policy, please contact us:\n\n'
                          '• Email: privacy@Gelro.eco\n'
                          '• Address: 88 Innovation Drive, San Francisco, CA 94105\n'
                          '• Phone: +1 (888) 123-4567',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Last Updated: March 20, 2024',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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

  Widget _buildCard(BuildContext context,
      {required String title, required String content}) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
