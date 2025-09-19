import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
                'Terms of Service',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Last updated: December 2024',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Introduction
              _buildSection(
                title: '1. Introduction',
                content:
                    'Welcome to Solakai! These Terms of Service ("Terms") govern your use of the Solakai mobile application and related services (collectively, the "Service") operated by Solakai Inc. ("we," "us," or "our").\n\nBy accessing or using our Service, you agree to be bound by these Terms. If you disagree with any part of these terms, then you may not access the Service.',
              ),

              _buildSection(
                title: '2. Acceptance of Terms',
                content:
                    'By creating an account or using Solakai, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy. These Terms apply to all visitors, users, and others who access or use the Service.',
              ),

              _buildSection(
                title: '3. Description of Service',
                content:
                    'Solakai is an AI-powered calendar and scheduling assistant that helps users manage their time more effectively. Our Service includes:\n\n• Intelligent calendar management\n• AI-powered scheduling suggestions\n• Productivity analytics and insights\n• Natural language event creation\n• Schedule optimization recommendations',
              ),

              _buildSection(
                title: '4. User Accounts',
                content:
                    'To use certain features of our Service, you must create an account. You are responsible for:\n\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use\n• Ensuring that your account information is accurate and up-to-date',
              ),

              _buildSection(
                title: '5. Acceptable Use',
                content:
                    'You agree to use the Service only for lawful purposes and in accordance with these Terms. You agree not to:\n\n• Use the Service in any way that violates applicable laws or regulations\n• Transmit any harmful, offensive, or inappropriate content\n• Attempt to gain unauthorized access to our systems\n• Interfere with or disrupt the Service or servers\n• Use the Service for any commercial purpose without our consent',
              ),

              _buildSection(
                title: '6. Privacy and Data Protection',
                content:
                    'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our Service. By using Solakai, you consent to the collection and use of information in accordance with our Privacy Policy.',
              ),

              _buildSection(
                title: '7. Intellectual Property Rights',
                content:
                    'The Service and its original content, features, and functionality are and will remain the exclusive property of Solakai Inc. and its licensors. The Service is protected by copyright, trademark, and other laws. Our trademarks may not be used without our prior written consent.',
              ),

              _buildSection(
                title: '8. AI and Machine Learning',
                content:
                    'Solakai uses artificial intelligence and machine learning technologies to provide personalized recommendations and insights. While we strive for accuracy, AI-generated suggestions are not guaranteed to be perfect and should be reviewed before implementation.',
              ),

              _buildSection(
                title: '9. Limitation of Liability',
                content:
                    'In no event shall Solakai Inc., its directors, employees, or agents be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your use of the Service.',
              ),

              _buildSection(
                title: '10. Service Availability',
                content:
                    'We strive to maintain high availability of our Service, but we do not guarantee uninterrupted access. The Service may be temporarily unavailable due to maintenance, updates, or technical issues. We reserve the right to modify or discontinue the Service at any time.',
              ),

              _buildSection(
                title: '11. Termination',
                content:
                    'We may terminate or suspend your account and access to the Service immediately, without prior notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties, or for any other reason.',
              ),

              _buildSection(
                title: '12. Changes to Terms',
                content:
                    'We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.',
              ),

              _buildSection(
                title: '13. Governing Law',
                content:
                    'These Terms shall be interpreted and governed by the laws of the jurisdiction in which Solakai Inc. is incorporated, without regard to its conflict of law provisions. Any disputes arising from these Terms will be resolved in the appropriate courts of that jurisdiction.',
              ),

              _buildSection(
                title: '14. Contact Information',
                content:
                    'If you have any questions about these Terms of Service, please contact us at:\n\nEmail: legal@Solakai.app\nAddress: Solakai Inc., Legal Department\nWebsite: www.Solakai.app/legal',
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
                    Text(
                      'Thank you for using Solakai!',
                      style: TextStyle(
                        color: AppTheme.primaryEnd,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'By continuing to use our service, you acknowledge that you have read and agree to these terms.',
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

  Widget _buildSection({required String title, required String content}) {
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
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
