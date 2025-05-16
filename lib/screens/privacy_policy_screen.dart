import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
                'Privacy Policy',
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
            _buildPolicySection(
                title: 'Introduction',
                content:
                    'Dysphor ("we", "our", or "us") respects the privacy of our users. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application Dysphor ("Application"). Please read this Privacy Policy carefully. By using the Application, you consent to the practices described in this policy.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Information We Collect',
                content:
                    'We may collect information about you in various ways, including:\n\n1. Personal Data: While using our Application, we may ask you to provide certain personally identifiable information that can be used to contact or identify you. This may include email address and usage data.\n\n2. Usage Data: We may collect information about how you use the Application, including session durations, feature usage, and performance data.\n\n3. Device Information: We collect information about your device including the model, operating system, unique device identifiers, and mobile network information.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'How We Use Your Information',
                content:
                    'We may use the information we collect for various purposes, including to:\n\n• Provide, maintain, and improve our Application\n• Personalize your experience\n• Analyze usage patterns and trends\n• Send you technical notices and updates\n• Respond to your comments, questions, and customer service requests\n• Enforce our terms, conditions, and policies'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Disclosure of Your Information',
                content:
                    'We may share information we have collected about you in certain situations. Your information may be disclosed as follows:\n\n1. By Law or to Protect Rights: If we believe the release of information is appropriate to comply with the law or protect our or others\' rights, property, or safety.\n\n2. Third-Party Service Providers: We may share your information with third-party vendors who provide services on our behalf.\n\n3. Business Transfers: If we are involved in a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred as part of that transaction.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Security of Your Information',
                content:
                    'We use administrative, technical, and physical security measures to protect your personal information. While we have taken reasonable steps to secure the information you provide to us, please be aware that no security measures are perfect or impenetrable, and we cannot guarantee the security of your information.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Your Choices About Your Information',
                content:
                    'You can stop all collection of information by the Application by uninstalling it from your device. You may also opt-out of certain data collection features within the Application settings, if available.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Children\'s Privacy',
                content:
                    'The Application is not intended for children under the age of 13. We do not knowingly collect information from children under 13. If you are a parent or guardian and believe we have collected information from a child under 13, please contact us.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Changes to This Privacy Policy',
                content:
                    'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically for any changes.'),
            const SizedBox(height: 20),
            _buildPolicySection(
                title: 'Contact Us',
                content:
                    'If you have questions or concerns about this Privacy Policy, please contact us at privacy@dysphor.app.'),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'By using Dysphor, you agree to this privacy policy.',
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

  Widget _buildPolicySection({required String title, required String content}) {
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
