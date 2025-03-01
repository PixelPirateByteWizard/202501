import 'package:flutter/material.dart';

class AppIntroductionPage extends StatelessWidget {
  const AppIntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B2E),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCard(
                      context,
                      title: 'About Gelro',
                      content:
                          'Gelro is your intelligent companion for waste sorting and environmental protection. '
                          'Using advanced AI technology and comprehensive knowledge base, we make waste classification '
                          'simple, engaging, and educational for everyone.',
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Our Mission',
                      content:
                          'We are committed to promoting environmental awareness and sustainable living through '
                          'technology. By making waste sorting accessible and engaging, we aim to create a cleaner, '
                          'greener future for our planet.',
                    ),
                    const SizedBox(height: 20),
                    _buildFeaturesCard(context),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: 'Why Choose Gelro',
                      content: '• Accurate AI Recognition\n'
                          '• Comprehensive Knowledge Base\n'
                          '• User-Friendly Interface\n'
                          '• Regular Updates\n'
                          '• Community Engagement\n'
                          '• Environmental Impact Tracking',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to Gelro',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Smart Waste Sorting Assistant',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required String content}) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Key Features',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFF3D4075)),
            _buildFeatureItem(
              context,
              icon: Icons.camera_alt,
              title: 'AI Recognition',
              description:
                  'Instantly identify waste categories with our advanced AI technology',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.search,
              title: 'Smart Search',
              description:
                  'Quick and accurate waste classification guide at your fingertips',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.school,
              title: 'Educational Content',
              description:
                  'Comprehensive learning resources about waste management',
            ),
            _buildFeatureItem(
              context,
              icon: Icons.people,
              title: 'Community',
              description:
                  'Connect with eco-conscious individuals and share experiences',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8B6BF3),
                  Color(0xFF6B4DE3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B6BF3).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFF3D4075)),
      ],
    );
  }
}
