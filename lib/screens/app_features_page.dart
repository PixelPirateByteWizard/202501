import 'package:flutter/material.dart';

class AppFeaturesPage extends StatelessWidget {
  const AppFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B2E),
      body: SafeArea(
        child: Stack(
          children: [
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
                          'Smart Features',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore Our Innovative Solutions',
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
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  final feature = _features[index];
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  feature.color.withOpacity(0.8),
                                  feature.color,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: feature.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              feature.icon,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            feature.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              feature.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final List<FeatureItem> _features = [
    FeatureItem(
      icon: Icons.camera_alt,
      color: const Color(0xFF8B6BF3),
      title: 'AI Recognition',
      description:
          'Instantly identify waste items using advanced computer vision technology for accurate classification',
    ),
    FeatureItem(
      icon: Icons.search,
      color: const Color(0xFF4CAF50),
      title: 'Smart Search',
      description:
          'Quick and intuitive search functionality to find waste disposal guidelines and recycling information',
    ),
    FeatureItem(
      icon: Icons.school,
      color: const Color(0xFFFF9800),
      title: 'Learning Hub',
      description:
          'Comprehensive educational resources about waste management and environmental protection',
    ),
    FeatureItem(
      icon: Icons.chat_bubble,
      color: const Color(0xFF9C27B0),
      title: 'AI Assistant',
      description:
          'Get instant answers to your environmental questions from our intelligent chatbot',
    ),
    FeatureItem(
      icon: Icons.article,
      color: const Color(0xFF009688),
      title: 'Eco News',
      description:
          'Stay updated with the latest environmental news, trends, and sustainable living tips',
    ),
    FeatureItem(
      icon: Icons.emoji_events,
      color: const Color(0xFFFFB300),
      title: 'Green Rewards',
      description:
          'Earn points and rewards for your environmental contributions and recycling efforts',
    ),
    FeatureItem(
      icon: Icons.people,
      color: const Color(0xFF2196F3),
      title: 'Community',
      description:
          'Connect with like-minded individuals and share your environmental journey',
    ),
    FeatureItem(
      icon: Icons.analytics,
      color: const Color(0xFFE91E63),
      title: 'Impact Tracking',
      description:
          'Monitor your environmental impact and track your progress towards sustainability goals',
    ),
  ];
}

class FeatureItem {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}
