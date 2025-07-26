import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
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
            image: AssetImage("assets/background/background_3.png"),
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
                _buildSectionTitle('How to Play'),
                const SizedBox(height: 16),
                _buildBodyText(
                  'The goal of the game is to sort the colored water in the bottles until all colors are in separate bottles.\n\n'
                  '1. Tap a bottle to select it.\n'
                  '2. Tap another bottle to pour the top layer of water.\n'
                  '3. You can only pour water into a bottle that has the same color on top or is empty.\n'
                  '4. The level is complete when all bottles are sorted.',
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Power-ups'),
                const SizedBox(height: 16),
                _buildPowerUpItem(
                  'Add Bottle:',
                  'Adds an empty bottle to the game, giving you more space to sort.',
                ),
                _buildPowerUpItem(
                  'Eliminate:',
                  'Removes one color from a bottle, which can help simplify the puzzle.',
                ),
                _buildPowerUpItem(
                  'Undo:',
                  'Reverts your last move, allowing you to correct mistakes.',
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Frequently Asked Questions'),
                const SizedBox(height: 16),
                _buildFaqItem(
                  'Q: I\'m stuck on a level. What should I do?',
                  'A: Try using a power-up! Adding a new bottle or undoing a move can often open up new possibilities. If you\'re still stuck, take a break and come back with a fresh perspective.',
                ),
                _buildFaqItem(
                  'Q: How are stars awarded?',
                  'A: Stars are awarded based on the number of moves you take to complete a level. Fewer moves earn you more stars. Try to solve each puzzle as efficiently as possible!',
                ),
                _buildFaqItem(
                  'Q: Can I play offline?',
                  'A: Yes! Sort Story can be played entirely offline, so you can enjoy the game anytime, anywhere.',
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

  Widget _buildPowerUpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF333333)),
          children: [
            TextSpan(
              text: '• $title ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }
}