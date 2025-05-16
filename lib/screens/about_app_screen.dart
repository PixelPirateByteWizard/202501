import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161A),
      appBar: AppBar(
        title: const Text(
          'About App',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF7F5AF0).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.timer,
                  color: Color(0xFF7F5AF0),
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dysphor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoSection(
                title: 'About Dysphor',
                content:
                    'Dysphor is a productivity app designed to help you focus and manage your time effectively using the Pomodoro Technique. Break your work into intervals, typically 25 minutes in length, separated by short breaks. Track your progress, set goals, and boost your productivity.'),
            const SizedBox(height: 30),
            _buildInfoSection(
                title: 'The Pomodoro Technique',
                content:
                    'The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. It uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. Each interval is known as a "pomodoro", from the Italian word for tomato, after the tomato-shaped kitchen timer Cirillo used as a university student.'),
            const SizedBox(height: 30),
            _buildInfoSection(
                title: 'How to Use',
                content:
                    '1. Choose a task you want to work on\n2. Set the timer for 25 minutes (default)\n3. Work on the task until the timer rings\n4. Take a short break (5 minutes)\n5. After 4 pomodoros, take a longer break (15-30 minutes)'),
            const SizedBox(height: 30),
            _buildInfoSection(
                title: 'Contact Us',
                content:
                    'Email: support@dysphor.app\nWebsite: www.dysphor.app'),
            const SizedBox(height: 40),
            Text(
              '© 2025 Dysphor Team. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF24263A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7F5AF0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
