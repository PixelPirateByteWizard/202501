import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Agreement',
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
            image: AssetImage("assets/background/background_5.png"),
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
                _buildSectionTitle('1. Introduction'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'Welcome to Sort Story. This User Agreement ("Agreement") governs your use of our game. By accessing or using Sort Story, you agree to be bound by this Agreement. If you do not agree to these terms, please do not use the game.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('2. License to Use'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'Sort Story grants you a non-exclusive, non-transferable, revocable license to use the game for your personal, non-commercial entertainment purposes. You agree not to use the game for any other purpose.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('3. User Conduct'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'You agree not to use the game for any unlawful purpose or in any way that could harm, disable, overburden, or impair the game. Prohibited activities include, but are not limited to, cheating, hacking, or exploiting the game in any way.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('4. Intellectual Property'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'All content and materials in Sort Story, including, but not limited to, text, graphics, logos, and software, are the property of the Sort Story team or its licensors and are protected by copyright and other intellectual property laws.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('5. Termination'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We may terminate or suspend your access to the game at any time, without prior notice or liability, for any reason, including if you breach this Agreement. Upon termination, your right to use the game will immediately cease.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('6. Disclaimer of Warranties'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'The game is provided "as is" and "as available" without warranties of any kind, either express or implied. We do not warrant that the game will be uninterrupted or error-free.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('7. Governing Law'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'This Agreement shall be governed by and construed in accordance with the laws of the jurisdiction in which our company is established, without regard to its conflict of law provisions.',
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