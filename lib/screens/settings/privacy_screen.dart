import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Last updated: December 2024',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              
              // Introduction
              _buildSection(
                title: '1. Introduction',
                content: 'At Kaelix, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and related services.\n\nWe are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy or our practices with regard to your personal information, please contact us.',
              ),
              
              _buildSection(
                title: '2. Information We Collect',
                content: 'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.',
                subsections: [
                  _buildSubsection(
                    'Personal Information',
                    '• Name and email address\n• Profile information\n• Account preferences and settings',
                  ),
                  _buildSubsection(
                    'Calendar Data',
                    '• Event titles, descriptions, and times\n• Meeting participants and locations\n• Calendar preferences and configurations',
                  ),
                  _buildSubsection(
                    'Usage Information',
                    '• App usage patterns and interactions\n• Feature usage statistics\n• Performance and error logs',
                  ),
                  _buildSubsection(
                    'Device Information',
                    '• Device type and operating system\n• App version and settings\n• Unique device identifiers',
                  ),
                ],
              ),
              
              _buildSection(
                title: '3. How We Use Your Information',
                content: 'We use the information we collect to provide, maintain, and improve our services:',
                subsections: [
                  _buildSubsection(
                    'Service Provision',
                    '• Provide and maintain the Kaelix service\n• Process and manage your calendar events\n• Generate AI-powered scheduling suggestions',
                  ),
                  _buildSubsection(
                    'Personalization',
                    '• Customize your experience\n• Provide personalized recommendations\n• Analyze your productivity patterns',
                  ),
                  _buildSubsection(
                    'Communication',
                    '• Send you service-related notifications\n• Respond to your inquiries and support requests\n• Provide updates about new features',
                  ),
                  _buildSubsection(
                    'Improvement',
                    '• Analyze usage patterns to improve our service\n• Develop new features and functionality\n• Ensure security and prevent fraud',
                  ),
                ],
              ),
              
              _buildSection(
                title: '4. Information Sharing and Disclosure',
                content: 'We do not sell, trade, or otherwise transfer your personal information to third parties except in the following circumstances:',
                subsections: [
                  _buildSubsection(
                    'Service Providers',
                    'We may share information with trusted third-party service providers who assist us in operating our service, conducting our business, or serving our users.',
                  ),
                  _buildSubsection(
                    'Legal Requirements',
                    'We may disclose your information if required to do so by law or in response to valid requests by public authorities.',
                  ),
                  _buildSubsection(
                    'Business Transfers',
                    'In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of that transaction.',
                  ),
                ],
              ),
              
              _buildSection(
                title: '5. Data Security',
                content: 'We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. These measures include:\n\n• Encryption of data in transit and at rest\n• Regular security assessments and updates\n• Access controls and authentication measures\n• Secure data storage and backup procedures',
              ),
              
              _buildSection(
                title: '6. Data Retention',
                content: 'We retain your personal information only for as long as necessary to provide you with our services and as described in this Privacy Policy. We will retain and use your information to the extent necessary to comply with our legal obligations, resolve disputes, and enforce our agreements.',
              ),
              
              _buildSection(
                title: '7. Your Privacy Rights',
                content: 'Depending on your location, you may have certain rights regarding your personal information:',
                subsections: [
                  _buildSubsection(
                    'Access and Portability',
                    'You have the right to access and receive a copy of your personal information.',
                  ),
                  _buildSubsection(
                    'Correction',
                    'You have the right to correct or update your personal information.',
                  ),
                  _buildSubsection(
                    'Deletion',
                    'You have the right to request deletion of your personal information.',
                  ),
                  _buildSubsection(
                    'Opt-out',
                    'You have the right to opt-out of certain communications and data processing activities.',
                  ),
                ],
              ),
              
              _buildSection(
                title: '8. AI and Machine Learning',
                content: 'Kaelix uses artificial intelligence and machine learning to provide personalized recommendations. This processing is based on your calendar data and usage patterns. You can opt-out of AI-powered features in your account settings.',
              ),
              
              _buildSection(
                title: '9. International Data Transfers',
                content: 'Your information may be transferred to and processed in countries other than your own. We ensure that such transfers are conducted in accordance with applicable data protection laws and with appropriate safeguards in place.',
              ),
              
              _buildSection(
                title: '10. Children\'s Privacy',
                content: 'Our service is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
              ),
              
              _buildSection(
                title: '11. Changes to This Privacy Policy',
                content: 'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date. You are advised to review this Privacy Policy periodically for any changes.',
              ),
              
              _buildSection(
                title: '12. Contact Us',
                content: 'If you have any questions about this Privacy Policy or our privacy practices, please contact us at:\n\nEmail: privacy@kaelix.app\nAddress: Kaelix Inc., Privacy Officer\nWebsite: www.kaelix.app/privacy',
              ),
              
              const SizedBox(height: 40),
              
              // Footer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.dark800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppTheme.primaryEnd,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Your Privacy Matters',
                      style: TextStyle(
                        color: AppTheme.primaryEnd,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We are committed to protecting your personal information and maintaining your trust.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<Widget>? subsections,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryEnd,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (content.isNotEmpty)
            Text(
              content,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          if (subsections != null) ...[
            const SizedBox(height: 12),
            ...subsections,
          ],
        ],
      ),
    );
  }

  Widget _buildSubsection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}