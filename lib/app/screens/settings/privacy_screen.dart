import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Information Collection',
                'We collect information that you provide directly to us, including:\n'
                    '• QR code content you generate\n'
                    '• QR codes you scan\n'
                    '• Device information for app functionality',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'How We Use Information',
                'We use the information we collect to:\n'
                    '• Provide and maintain the app\n'
                    '• Improve user experience\n'
                    '• Send updates and notifications\n'
                    '• Respond to your requests',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Data Storage',
                'All QR code data is stored locally on your device. We do not upload or store your QR codes on our servers. Your data remains private and under your control.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Camera Access',
                'We request camera access only for scanning QR codes. The camera feed is not recorded or stored, and is only used for real-time QR code detection.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Third-Party Services',
                'We do not share your personal information with third parties. Any external links in scanned QR codes are accessed at your own discretion.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Data Security',
                'We implement appropriate security measures to protect your information. However, no method of transmission over the internet or electronic storage is 100% secure.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Children\'s Privacy',
                'Our app does not address anyone under the age of 13. We do not knowingly collect personal information from children under 13.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Changes to Policy',
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at:\n'
                    'Email: privacy@yourcompany.com',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: content.split('\n').length > 2 ? 200 : 160,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withOpacity(0.1),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
