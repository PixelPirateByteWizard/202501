import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Terms of Service',
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
            const _AgreementSection(
              icon: Icons.gavel,
              iconColor: Colors.blue,
              title: 'Terms of Use',
              content:
                  'By using our application, you agree to the following terms:',
              items: [
                'The app is for personal use only and not for commercial purposes',
                'You must be at least 13 years old to use this service',
                'You are responsible for maintaining the security of your account',
                'We reserve the right to modify or terminate services',
                'Users must comply with all applicable laws and regulations',
              ],
            ),
            const _AgreementSection(
              icon: Icons.person,
              iconColor: Colors.green,
              title: 'User Responsibilities',
              content: 'As a user of our service, you agree to:',
              items: [
                'Provide accurate and complete personal information',
                'Maintain the confidentiality of your account credentials',
                'Not share or transfer your account to others',
                'Report any unauthorized use of your account',
                'Use the service in a manner consistent with its intended purpose',
              ],
            ),
            const _AgreementSection(
              icon: Icons.content_paste,
              iconColor: Colors.orange,
              title: 'Content Guidelines',
              content: 'When using our platform, you must ensure:',
              items: [
                'All uploaded content complies with our community standards',
                'You have necessary rights to share any content you post',
                'No posting of harmful, offensive, or illegal content',
                'Respect for intellectual property rights of others',
                'No distribution of spam or misleading information',
              ],
            ),
            const _AgreementSection(
              icon: Icons.warning,
              iconColor: Colors.red,
              title: 'Disclaimer',
              content: 'We are not liable for:',
              items: [
                'Service interruptions due to technical issues or maintenance',
                'Loss of data or content during service usage',
                'Accuracy of third-party content or links',
                'Personal disputes between users',
                'Damages resulting from unauthorized account access',
              ],
            ),
            const _AgreementSection(
              icon: Icons.update,
              iconColor: Colors.purple,
              title: 'Changes to Terms',
              content: 'Regarding updates to these terms:',
              items: [
                'We may modify these terms at any time',
                'Users will be notified of significant changes',
                'Continued use implies acceptance of new terms',
                'Regular review of terms is recommended',
                'Previous versions may be available upon request',
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
                  Icons.description,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms of Service',
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
              'Welcome to our application. These terms of service outline the rules and regulations for the use of our platform. By accessing or using our service, you agree to be bound by these terms.',
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

class _AgreementSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;
  final List<String> items;

  const _AgreementSection({
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
