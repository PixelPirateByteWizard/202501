import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF8FB3B0),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 100,
            color: const Color(0xFF8FB3B0),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.gavel_outlined,
                          color: Color(0xFF8FB3B0),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8FB3B0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Color(0xFF8FB3B0),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Last updated: March 15, 2024',
                            style: TextStyle(
                              color: Color(0xFF8FB3B0),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      'Acceptance of Terms',
                      'By accessing and using the Aetherys application, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                      Icons.check_circle_outline,
                    ),
                    _buildSection(
                      'User Accounts',
                      'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. Notify us immediately of any unauthorized use.',
                      Icons.account_circle_outlined,
                    ),
                    _buildSection(
                      'User Data',
                      'We collect and process your data in accordance with our Privacy Policy. You retain all rights to your data and grant us a license to use it solely for providing and improving our services.',
                      Icons.data_usage_outlined,
                    ),
                    _buildSection(
                      'Acceptable Use',
                      'You agree not to misuse our services or help anyone else do so. You agree not to:\n• Violate any laws or regulations\n• Infringe on others\' rights\n• Distribute malware or viruses\n• Attempt to breach our security measures',
                      Icons.security_outlined,
                    ),
                    _buildSection(
                      'Modifications',
                      'We reserve the right to modify these terms at any time. Continued use of our services after changes constitutes acceptance of the modified terms.',
                      Icons.edit_outlined,
                    ),
                    _buildSection(
                      'Termination',
                      'We may suspend or terminate your access to our services at our discretion, with or without notice, for violations of these terms.',
                      Icons.block_outlined,
                    ),
                    _buildSection(
                      'Contact Us',
                      'If you have any questions about these Terms, please contact us at legal@aetherys.com',
                      Icons.contact_support_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF8FB3B0),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
