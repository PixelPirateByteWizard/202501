import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF16161A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                'Last Updated: May 15, 2025',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildTermsSection(
                title: '1. Acceptance of Terms',
                content:
                    'By accessing or using the Dysphor application ("App"), you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access or use the App.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '2. Changes to Terms',
                content:
                    'We reserve the right to modify these terms at any time. We will notify you of any changes by posting the new Terms of Service on this page. Your continued use of the App after such modifications will constitute your acknowledgment of the modified terms and agreement to abide by them.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '3. User Accounts',
                content:
                    'When you create an account with us, you guarantee that the information you provide is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '4. Intellectual Property',
                content:
                    'The App and its original content, features, and functionality are and will remain the exclusive property of Dysphor and its licensors. The App is protected by copyright, trademark, and other laws. Our trademarks may not be used in connection with any product or service without the prior written consent of Dysphor.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '5. User Content',
                content:
                    'You retain all rights to any content you submit, post, or display on or through the App. By posting content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, and display such content in connection with the services provided by the App.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '6. Termination',
                content:
                    'We may terminate or suspend your account and bar access to the App immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever, including but not limited to a breach of the Terms.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '7. Limitation of Liability',
                content:
                    'In no event shall Dysphor, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the App.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '8. Governing Law',
                content:
                    'These Terms shall be governed and construed in accordance with the laws, without regard to its conflict of law provisions.'),
            const SizedBox(height: 20),
            _buildTermsSection(
                title: '9. Contact Us',
                content:
                    'If you have any questions about these Terms, please contact us at legal@dysphor.app.'),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'By using Dysphor, you agree to these terms.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF7F5AF0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
