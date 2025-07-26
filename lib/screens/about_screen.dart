import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
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
            image: AssetImage("assets/background/background_1.png"),
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
                _buildSectionTitle('Sort Story'),
                const SizedBox(height: 8),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                _buildBodyText(
                  'Welcome to Sort Story, a fun and challenging water sort puzzle game designed to test your logic and problem-solving skills. Our mission is to provide a relaxing yet engaging experience for players of all ages, with beautifully designed levels and intuitive gameplay.',
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Our Philosophy'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We believe that games should be more than just a way to pass the time. They should be an opportunity to relax, think, and feel a sense of accomplishment. In Sort Story, every level is carefully crafted to provide a satisfying challenge that respects your intelligence and time.',
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Our Team'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We are a small team of passionate developers and designers dedicated to creating high-quality mobile games. We believe in the power of play and strive to create games that are not only fun but also beautiful and intuitive. Our goal is to create experiences that we ourselves would love to play.',
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Contact Us'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We love hearing from our players! If you have any questions, feedback, or suggestions, please don’t hesitate to reach out. Your input helps us make Sort Story even better.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'support@sortstorygame.com',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.purple,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Future Plans'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'We are constantly working on new features and levels to enhance your experience. Stay tuned for exciting updates, including new game modes, daily challenges, and much more!',
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
        fontSize: 22,
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