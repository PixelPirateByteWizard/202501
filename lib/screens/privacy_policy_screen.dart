import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/background_4.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last Updated: July 25, 2025',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('1. Information We Collect'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We may collect information about your device, including your IP address, operating system, and device identifiers. We also collect gameplay data, such as your level progress, achievements, and in-game actions, to enhance your gaming experience.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('2. How We Use Your Information'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We use the information we collect to provide and improve our game, to personalize your experience, and to provide customer support. Your data helps us balance game difficulty, fix bugs, and develop new features. We may also use your information to send you relevant promotional materials, which you can opt out of at any time.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('3. Information Sharing'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We do not sell or rent your personal information to third parties. We may share your information with third-party service providers who perform services on our behalf, such as analytics and advertising. These providers are obligated to protect your data and use it only for the purposes we specify.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('4. Your Rights'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'You have the right to access, correct, or delete your personal information. You can also object to or restrict the processing of your data. To exercise these rights, please contact us at support@sortstorygame.com.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('5. Data Security'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no internet-based service is 100% secure, and we cannot guarantee the absolute security of your information.',
                ),
                 const SizedBox(height: 24),
                _buildSectionTitle('6. Changes to This Policy'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.purple,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF333333)),
    );
  }
}