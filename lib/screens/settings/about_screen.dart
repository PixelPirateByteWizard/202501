import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo and Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Solakai',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Smart Calendar Assistant',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Mission Section
              _buildSection(
                title: 'Our Mission',
                content: 'Solakai is designed to revolutionize how you manage your time and schedule. We believe that everyone deserves an intelligent assistant that understands their unique needs and helps them achieve optimal productivity.',
              ),
              const SizedBox(height: 24),
              
              // Features Section
              _buildSection(
                title: 'What We Offer',
                content: '',
                children: [
                  _buildFeatureItem(
                    icon: Icons.psychology,
                    title: 'AI-Powered Scheduling',
                    description: 'Smart suggestions and automatic optimization for your calendar',
                  ),
                  _buildFeatureItem(
                    icon: Icons.analytics,
                    title: 'Productivity Analytics',
                    description: 'Detailed insights into your time usage and productivity patterns',
                  ),
                  _buildFeatureItem(
                    icon: Icons.auto_fix_high,
                    title: 'Schedule Optimization',
                    description: 'Intelligent recommendations to improve your daily workflow',
                  ),
                  _buildFeatureItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Natural Language Processing',
                    description: 'Create events and manage your calendar using natural conversation',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Team Section
              _buildSection(
                title: 'Our Team',
                content: 'Solakai is built by a passionate team of developers, designers, and AI specialists who are committed to creating the most intuitive and powerful calendar experience possible.',
              ),
              const SizedBox(height: 24),
              
              // Vision Section
              _buildSection(
                title: 'Our Vision',
                content: 'We envision a world where technology seamlessly integrates with human productivity, where scheduling conflicts become a thing of the past, and where everyone can achieve their full potential through intelligent time management.',
              ),
              const SizedBox(height: 24),
              
              // Contact Section
              _buildSection(
                title: 'Get in Touch',
                content: 'We love hearing from our users! Whether you have feedback, suggestions, or just want to say hello, we\'re always here to listen.',
                children: [
                  _buildContactItem(
                    icon: Icons.email,
                    title: 'Email',
                    value: 'hello@Solakai.app',
                  ),
                  _buildContactItem(
                    icon: Icons.language,
                    title: 'Website',
                    value: 'www.Solakai.app',
                  ),
                  _buildContactItem(
                    icon: Icons.support_agent,
                    title: 'Support',
                    value: 'support@Solakai.app',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Version Info
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.dark800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Built with ❤️ for productivity enthusiasts',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<Widget>? children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primaryEnd,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (content.isNotEmpty)
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        if (children != null) ...children,
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryEnd.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryEnd,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryEnd,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            '$title: ',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}