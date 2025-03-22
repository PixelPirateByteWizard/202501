import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
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
                          Icons.help_outline,
                          color: Color(0xFF8FB3B0),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildExpandableFAQ(
                      'How do I create a new task?',
                      'Tap the + button on the home screen to create a new task. Fill in the task details such as title, description, and due date, then tap Save.',
                    ),
                    _buildExpandableFAQ(
                      'How do I mark a task as complete?',
                      'Simply tap the checkbox next to any task to mark it as complete. You can uncheck it to mark it as incomplete.',
                    ),
                    _buildExpandableFAQ(
                      'Can I categorize my tasks?',
                      'Yes! When creating or editing a task, you can assign it to different categories. You can also create new categories in the settings.',
                    ),
                    _buildExpandableFAQ(
                      'How do I edit a task?',
                      'Tap on any task to view its details, then tap the edit icon to modify the task information.',
                    ),
                    _buildExpandableFAQ(
                      'Is my data backed up?',
                      "Yes, all your data is automatically synced to the cloud when you're connected to the internet.",
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.support_agent,
                          color: Color(0xFF8FB3B0),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Need More Help?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'If you need additional assistance, please contact our support team:',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      Icons.email_outlined,
                      'support@aetherys.com',
                    ),
                    const SizedBox(height: 8),
                    _buildContactItem(
                      Icons.access_time,
                      'Support Hours: 24/7',
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

  Widget _buildExpandableFAQ(String question, String answer) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 16),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        children: [
          Text(
            answer,
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

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF8FB3B0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF8FB3B0),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
