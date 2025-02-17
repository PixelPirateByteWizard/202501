import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6A4C93), Color(0xFF9B6DFF)],
                  stops: [0.2, 0.9],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A4C93).withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white),
                        padding: EdgeInsets.zero,
                      ),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your privacy is our top priority. Please read carefully.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF0F0F0),
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildPrivacySection(
                    'Information Collection',
                    'We collect and process the following types of information:',
                    [
                      'Personal information you provide (name, email, profile details)',
                      'Device information and usage statistics',
                      'Practice records and performance data',
                      'User-generated content and interactions',
                      'Technical data including IP address and device identifiers',
                    ],
                    Icons.info_outline,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  _buildPrivacySection(
                    'Data Usage',
                    'Your information helps us provide and improve our services:',
                    [
                      'Personalize your learning experience',
                      'Improve our AI teaching algorithms',
                      'Provide community features and social interactions',
                      'Send important updates and notifications',
                      'Analyze app performance and user behavior',
                    ],
                    Icons.psychology,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 16),
                  _buildPrivacySection(
                    'Data Protection',
                    'We implement strong security measures to protect your data:',
                    [
                      'Industry-standard encryption for data transmission',
                      'Regular security audits and updates',
                      'Secure data storage with regular backups',
                      'Access controls and authentication measures',
                      'Compliance with international data protection standards',
                    ],
                    Icons.security,
                    const Color(0xFF9C27B0),
                  ),
                  const SizedBox(height: 16),
                  _buildPrivacySection(
                    'Your Rights',
                    'You have control over your personal data:',
                    [
                      'Access and download your personal data',
                      'Request corrections or updates to your information',
                      'Delete your account and associated data',
                      'Opt-out of non-essential data collection',
                      'Contact our support team for privacy concerns',
                    ],
                    Icons.gavel,
                    const Color(0xFFFF9800),
                  ),
                  const SizedBox(height: 16),
                  _buildPrivacySection(
                    'Third-Party Services',
                    'We work with trusted partners to provide our services:',
                    [
                      'Analytics providers to improve user experience',
                      'Cloud storage for secure data backup',
                      'Payment processors for subscriptions',
                      'Social media integration (optional)',
                      'Third-party authentication services',
                    ],
                    Icons.share,
                    const Color(0xFF607D8B),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(
    String title,
    String subtitle,
    List<String> points,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ...points
                .map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF666666),
                                height: 1.5,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
