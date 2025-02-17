import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
                        'Terms of Service',
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
                    'Please read these terms carefully before using Joyee',
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
                  _buildTermsSection(
                    'Account Terms',
                    'Your Joyee account comes with the following responsibilities:',
                    [
                      'You must be at least 13 years old to use this service',
                      'Provide accurate and complete registration information',
                      'Maintain the security of your account credentials',
                      'Notify us immediately of any unauthorized access',
                      'One person or legal entity may maintain only one account',
                    ],
                    Icons.person_outline,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  _buildTermsSection(
                    'User Content',
                    'When posting content on Joyee, you agree that:',
                    [
                      'You own or have necessary rights to share the content',
                      'Content must not violate any applicable laws or regulations',
                      'We may remove content that violates our guidelines',
                      'You grant us license to use your content for service improvement',
                      'You are responsible for all content posted through your account',
                    ],
                    Icons.content_copy,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 16),
                  _buildTermsSection(
                    'Service Rules',
                    'To maintain a positive community environment:',
                    [
                      'Do not engage in harassment or bullying of other users',
                      'Respect intellectual property rights and copyright laws',
                      'Do not attempt to manipulate or abuse our systems',
                      'Follow community guidelines in all interactions',
                      'Report any violations or inappropriate content',
                    ],
                    Icons.gavel,
                    const Color(0xFF9C27B0),
                  ),
                  const SizedBox(height: 16),
                  _buildTermsSection(
                    'Premium Features',
                    'Regarding premium subscriptions and payments:',
                    [
                      'Subscription fees are billed in advance on a recurring basis',
                      'Cancellations will take effect at the end of the current period',
                      'Some features may require additional payment',
                      'Refunds are handled according to platform policies',
                      'Prices may change with reasonable notice',
                    ],
                    Icons.workspace_premium,
                    const Color(0xFFFF9800),
                  ),
                  const SizedBox(height: 16),
                  _buildTermsSection(
                    'Termination',
                    'We may terminate or suspend access to our service:',
                    [
                      'For repeated violations of these terms',
                      'For creating risk or possible legal exposure',
                      'Due to extended periods of inactivity',
                      'At our sole discretion with reasonable notice',
                      'Upon your request to delete your account',
                    ],
                    Icons.block,
                    const Color(0xFFE91E63),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(
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
