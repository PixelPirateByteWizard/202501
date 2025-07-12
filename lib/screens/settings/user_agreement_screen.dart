import 'package:astrelexis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Agreement'),
        backgroundColor: AppColors.primaryBg.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
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
            _buildSectionTitle('1. Acceptance of Terms'),
            const SizedBox(height: 12),
            _buildParagraph(
                'By accessing or using Astrelexis ("the Service"), you agree to be bound by these Terms of Service ("Terms"). If you disagree with any part of the terms, then you may not access the Service. Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms.'),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Use of Service'),
            const SizedBox(height: 12),
            _buildParagraph(
                'You must be at least 13 years old to use the Service. You are responsible for safeguarding your device and for any activities or actions under your account. You agree not to use the Service for any illegal or unauthorized purpose.'),
            const SizedBox(height: 24),
            _buildSectionTitle('3. Your Content'),
            const SizedBox(height: 12),
            _buildParagraph(
                'You retain full ownership of all content, including text and images, that you create or store using the Service ("Content"). We do not claim any ownership rights to your Content. All Content is stored locally on your device, and we do not have access to it.'),
            const SizedBox(height: 24),
            _buildSectionTitle('4. Termination'),
            const SizedBox(height: 12),
            _buildParagraph(
                'We may terminate or suspend your access to the Service at any time, without prior notice or liability, for any reason, including without limitation if you breach the Terms. Upon termination, your right to use the Service will immediately cease.'),
            const SizedBox(height: 24),
            _buildSectionTitle('5. Changes to Terms'),
            const SizedBox(height: 12),
            _buildParagraph(
                'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any changes by posting the new Terms within the app. Your continued use of the Service after any such changes constitutes your acceptance of the new Terms.'),
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
}