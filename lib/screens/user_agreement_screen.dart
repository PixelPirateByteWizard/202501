import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgrounds_5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'User Agreement',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Agreement Overview',
              'Welcome to the Spirit Dream game! To protect your rights, please carefully read this agreement before using our services. By using this game, you agree to accept all terms and conditions of this agreement.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Account Registration',
              '''1. You must provide true, accurate, and complete personal information.
2. You must properly protect your account and password.
3. Accounts may not be transferred or sold to others without permission.
4. One account may only be used by one user.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'User Conduct Standards',
              '''1. Use of plugins, scripts, or other third-party tools is prohibited.
2. Exploiting game bugs for profit is prohibited.
3. Publishing illegal, inappropriate, or adult content is prohibited.
4. Harassment or insulting other players is prohibited.
5. Any form of real-money trading of game currency or items is prohibited.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Virtual Items and Game Currency',
              '''1. All virtual items in the game are owned by the game company.
2. Users only have usage rights to virtual items.
3. Game currency cannot be exchanged for real money.
4. The game company reserves the right to adjust virtual item properties.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Paid Services',
              '''1. Please confirm your payment capability before making purchases.
2. All payments are one-time and non-refundable.
3. Minors must have guardian consent before making purchases.
4. Contact customer service promptly if payment issues occur.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Privacy Protection',
              '''1. We will protect your personal information in accordance with law.
2. We will not disclose your information to third parties without your consent.
3. We will take reasonable measures to protect your account security.
4. Please refer to the "Privacy Policy" document for specific privacy policies.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Disclaimer',
              '''1. The company is not responsible for service interruptions due to force majeure.
2. Users bear losses caused by violating the agreement themselves.
3. Game content may be updated or adjusted periodically.
4. The company reserves the right to modify this agreement.''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Agreement Changes',
              'We reserve the right to modify this agreement at any time. After modification, we will publish the changes in-game or on our official website. If you continue to use our services, it means you accept the modified agreement.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Contact Information',
              '''If you have any questions about this agreement, please contact us through:
• Customer Service Email: support@spiritdream.com
• Official Website: www.spiritdream.com
• Customer Service Phone: +1-XXX-XXX-XXXX''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
