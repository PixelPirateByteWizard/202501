import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppConstants.spaceIndigo600,
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.purple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.cosmicBlue,
                          ),
                        ),
                        Text(
                          'Last updated: January 2023',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'At Verzephronix, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),

              const SizedBox(height: 24),

              // Information We Collect
              _buildSection(
                context,
                title: '1. Information We Collect',
                content:
                    'We collect information that you provide directly to us when you use our application. This may include:',
                bulletPoints: [
                  'Personal information (such as name, email address) when you create an account',
                  'User preferences and settings within the application',
                  'Content you create, upload, or store in the application',
                  'Feedback and support requests you submit to us',
                ],
              ),

              // How We Use Your Information
              _buildSection(
                context,
                title: '2. How We Use Your Information',
                content:
                    'We use the information we collect for various purposes, including to:',
                bulletPoints: [
                  'Provide, maintain, and improve our services',
                  'Personalize your experience and deliver content relevant to your interests',
                  'Respond to your comments, questions, and requests',
                  'Send you technical notices, updates, security alerts, and support messages',
                  'Monitor and analyze trends, usage, and activities in connection with our services',
                ],
              ),

              // Data Storage and Security
              _buildSection(
                context,
                title: '3. Data Storage and Security',
                content:
                    'Verzephronix primarily stores your information locally on your device. We implement appropriate technical and organizational measures to protect the security of your personal information. However, please be aware that no security system is impenetrable and we cannot guarantee the absolute security of your data.',
              ),

              // Sharing Your Information
              _buildSection(
                context,
                title: '4. Sharing Your Information',
                content:
                    'We do not share your personal information with third parties except in the following circumstances:',
                bulletPoints: [
                  'With your consent',
                  'To comply with legal obligations',
                  'To protect and defend our rights and property',
                  'With service providers who perform services on our behalf',
                ],
              ),

              // Your Choices
              _buildSection(
                context,
                title: '5. Your Choices',
                content:
                    'You have several choices regarding the use of your information:',
                bulletPoints: [
                  'Account Information: You can update, correct, or delete your account information at any time by logging into your account settings',
                  'Cookies: You can set your browser to refuse all or some browser cookies, or to alert you when cookies are being sent',
                  'Promotional Communications: You can opt out of receiving promotional messages from us by following the instructions in those messages',
                ],
              ),

              // Children's Privacy
              _buildSection(
                context,
                title: '6. Children\'s Privacy',
                content:
                    'Our services are not intended for children under 13 years of age, and we do not knowingly collect personal information from children under 13. If we learn that we have collected personal information from a child under 13, we will promptly delete that information.',
              ),

              // Changes to This Privacy Policy
              _buildSection(
                context,
                title: '7. Changes to This Privacy Policy',
                content:
                    'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date at the top of this Privacy Policy.',
              ),

              // Contact Us
              _buildSection(
                context,
                title: '8. Contact Us',
                content:
                    'If you have any questions about this Privacy Policy, please contact us at privacy@verzephronix.com',
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  'By using Verzephronix, you agree to this Privacy Policy.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),
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
    List<String>? bulletPoints,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.spaceIndigo600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          if (bulletPoints != null) ...[
            const SizedBox(height: 12),
            ...bulletPoints.map((point) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
