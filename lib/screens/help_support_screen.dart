import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text(
          'Help & Support',
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
            _buildHeader('Frequently Asked Questions'),
            const SizedBox(height: 20),
            _buildFaqItem(
                question: 'What is the Pomodoro Technique?',
                answer:
                    'The Pomodoro Technique is a time management method that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. These intervals are called "pomodoros".'),
            _buildFaqItem(
                question: 'How do I use Dysphor app?',
                answer:
                    'Start by setting your desired work duration, break duration, and number of sessions. Then press the play button to begin your first pomodoro session. The app will notify you when it\'s time to take a break and when to resume work.'),
            _buildFaqItem(
                question: 'Can I customize the timer?',
                answer:
                    'Yes! You can customize the work duration, break duration, long break duration, and the number of sessions before a long break. Go to Settings to make these changes.'),
            _buildFaqItem(
                question: 'How do I track my progress?',
                answer:
                    'Your completed sessions are automatically saved in the History tab. You can view your past sessions, edit their titles, and see statistics about your productivity.'),
            _buildFaqItem(
                question: 'Can I use the app offline?',
                answer:
                    'Yes, Dysphor works completely offline. All your data is stored locally on your device.'),
            const SizedBox(height: 30),
            _buildHeader('Contact Support'),
            const SizedBox(height: 20),
            _buildInfoCard(
              icon: Icons.email_outlined,
              title: 'Email',
              description: 'support@dysphor.app',
              onTap: () {
                // Open email client
              },
            ),
            _buildInfoCard(
              icon: Icons.web_outlined,
              title: 'Website',
              description: 'www.dysphor.app/support',
              onTap: () {
                // Open website
              },
            ),
            _buildInfoCard(
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              description: 'Available Mon-Fri, 9am-5pm EST',
              onTap: () {
                // Open chat support
              },
            ),
            const SizedBox(height: 30),
            _buildHeader('Troubleshooting'),
            const SizedBox(height: 20),
            _buildTroubleshootingItem(
                issue: 'Notifications not working',
                solution:
                    'Ensure notifications are enabled for Dysphor in your device settings. Also check that you have enabled sound and/or vibration in the app settings.'),
            _buildTroubleshootingItem(
                issue: 'Timer stops when screen is locked',
                solution:
                    'This may happen on some devices. Go to your device battery settings and disable battery optimization for Dysphor.'),
            _buildTroubleshootingItem(
                issue: 'Data not saving',
                solution:
                    'Ensure you have sufficient storage space on your device. If the problem persists, please contact our support team.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF7F5AF0),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF24263A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.white70,
        iconColor: const Color(0xFF7F5AF0),
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF24263A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF7F5AF0).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF7F5AF0),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingItem(
      {required String issue, required String solution}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF24263A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFF87171),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  issue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            solution,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
