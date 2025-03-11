import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 16),
            const _PrivacySection(
              icon: Icons.person_outline,
              iconColor: Colors.blue,
              title: 'Information We Collect',
              content:
                  'To provide you with the best possible experience, we collect:',
              items: [
                'Basic profile information (name, email, preferences)',
                'Device information (model, OS version, unique identifiers)',
                'Usage data (app interactions, feature preferences)',
                'Location data (when permitted and necessary)',
                'Communication data (feedback, support requests)',
              ],
            ),
            const _PrivacySection(
              icon: Icons.security,
              iconColor: Colors.green,
              title: 'How We Use Your Information',
              content: 'Your information helps us to:',
              items: [
                'Personalize your app experience and recommendations',
                'Improve our services and develop new features',
                'Send important updates and notifications',
                'Provide customer support and resolve issues',
                'Analyze app performance and user behavior',
              ],
            ),
            const _PrivacySection(
              icon: Icons.shield,
              iconColor: Colors.orange,
              title: 'Data Protection',
              content: 'We implement robust security measures:',
              items: [
                'End-to-end encryption for sensitive data',
                'Regular security audits and penetration testing',
                'Strict access controls and authentication',
                'Secure data centers and backup systems',
                'Compliance with international security standards',
              ],
            ),
            const _PrivacySection(
              icon: Icons.gavel,
              iconColor: Colors.purple,
              title: 'Your Rights',
              content: 'You have the right to:',
              items: [
                'Access and export your personal data',
                'Request correction or deletion of your information',
                'Opt-out of marketing communications',
                'Withdraw consent for data processing',
                'File a complaint with supervisory authorities',
              ],
            ),
            const _PrivacySection(
              icon: Icons.share,
              iconColor: Colors.teal,
              title: 'Data Sharing',
              content: 'We may share your data with:',
              items: [
                'Service providers who assist our operations',
                'Analytics partners to improve our service',
                'Law enforcement when legally required',
                'Business partners with your explicit consent',
                'Third parties during a business transaction',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.privacy_tip,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy Policy',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                      const Text(
                        'Last updated: March 2024',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Your privacy is important to us. This policy outlines how we collect, use, and protect your personal information when you use our application.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final List<String> items;

  const _PrivacySection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
