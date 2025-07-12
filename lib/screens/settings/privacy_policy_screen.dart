import 'package:astrelexis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.primaryBg.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: July 10, 2024',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Your Privacy is Our Priority'),
            const SizedBox(height: 12),
            _buildParagraph(
                'Astrelexis is designed as a private space. We do not collect, store, or transmit your personal journal entries. All your data is stored locally on your device.'),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Information We Collect'),
            const SizedBox(height: 12),
            _buildParagraph(
                'We collect a minimal amount of information to provide and improve our service:'),
            _buildListItem(
                'Anonymous Analytics: We may collect anonymous usage data to help us understand how the app is used and to identify areas for improvement. This data is not linked to you personally.'),
            _buildListItem(
                'Device Information: We may collect non-personal information about your device, such as the operating system version, to ensure compatibility and optimize performance.'),
            const SizedBox(height: 24),
            _buildSectionTitle('3. Third-Party Services'),
            const SizedBox(height: 12),
            _buildParagraph(
                'We use DeepSeek for our AI features. When you interact with Astra, your input (and recent journal entries for context) is sent to their API. We do not send any personally identifiable information. We encourage you to review DeepSeek\'s privacy policy.'),
            const SizedBox(height: 24),
            _buildSectionTitle('4. Security'),
            const SizedBox(height: 12),
            _buildParagraph(
                'We are committed to protecting your information. While no method of electronic storage is 100% secure, we use commercially acceptable means to protect your data within the app. Remember that securing your device is also crucial.'),
            const SizedBox(height: 24),
            _buildSectionTitle('5. Changes to This Policy'),
            const SizedBox(height: 12),
            _buildParagraph(
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  height: 1.5)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}