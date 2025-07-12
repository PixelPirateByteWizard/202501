import 'package:astrelexis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.primaryBg.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Frequently Asked Questions'),
            const SizedBox(height: 12),
            _buildFaqItem(
              'How do I create a new journal entry?',
              'You can create a new entry by tapping the "+" button on the Journal screen and selecting "New Entry", "New To-Do", or "New Memory".',
            ),
            _buildFaqItem(
              'How does the Astra AI work?',
              'Astra is your personal AI assistant. It uses the content of your recent journal entries to provide contextual insights and answers. Your data is sent securely and anonymously.',
            ),
            _buildFaqItem(
              'Is my data secure?',
              'Absolutely. Your privacy is our top priority. All your journal entries and data are stored exclusively on your device. We do not have access to your personal content.',
            ),
            _buildFaqItem(
              'Can I back up my data?',
              'Data backup and sync features are planned for a future update. For now, all data remains on your device.',
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 12),
            Text(
              'If you have any other questions, encounter a bug, or have a feature request, please don\'t hesitate to reach out. We appreciate your feedback!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: AppColors.accentTeal),
              title: const Text(
                'support@astrelexis.com',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // TODO: Implement mailto link
              },
            ),
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

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      iconColor: AppColors.textSecondary,
      collapsedIconColor: AppColors.textSecondary,
      title: Text(
        question,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      ),
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Text(
            answer,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}