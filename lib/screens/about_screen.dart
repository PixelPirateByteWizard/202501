import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gear.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.lavenderWhite,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'About Us',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      children: [
                        // Logo and Title
                        GlassCard(
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationController.value * 0.5,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            AppColors.vintageGold.withValues(alpha: 0.8),
                                            AppColors.vintageGold.withValues(alpha: 0.3),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.vintageGold.withValues(alpha: 0.3),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: AnimatedGear(
                                          size: 40,
                                          color: AppColors.deepNavy,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Clockwork Legacy',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppColors.vintageGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Version 1.0.0',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Game Description
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.auto_stories,
                                    color: AppColors.vintageGold,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'About the Game',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Clockwork Legacy is an immersive steampunk adventure game that combines AI-powered storytelling with strategic gameplay. Set in a Victorian-era world filled with mechanical wonders and ancient mysteries, players embark on a journey to uncover the secrets of clockwork technology.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Key Features:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.vintageGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...[
                                'AI-generated dynamic storylines',
                                'Multiple explorable world regions',
                                'Mechanical workshop system',
                                'Achievement and progression tracking',
                                'Daily quest challenges',
                              ].map((feature) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.statusOptimal,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Development Team
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.group,
                                    color: AppColors.accentRose,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Development Team',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTeamMember(
                                'Clockwork Studios',
                                'Game Development',
                                Icons.code,
                              ),
                              _buildTeamMember(
                                'Steampunk Arts Collective',
                                'Visual Design & Art Direction',
                                Icons.palette,
                              ),
                              _buildTeamMember(
                                'Narrative Engine AI',
                                'Story Generation Technology',
                                Icons.psychology,
                              ),
                              _buildTeamMember(
                                'Victorian Sound Works',
                                'Audio Design & Music',
                                Icons.music_note,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Technology
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.settings,
                                    color: AppColors.statusWarning,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Technology Stack',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTechItem('Flutter Framework', 'Cross-platform development'),
                              _buildTechItem('DeepSeek AI', 'Dynamic story generation'),
                              _buildTechItem('Dart Language', 'Application logic'),
                              _buildTechItem('Material Design', 'User interface components'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Contact Information
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.contact_mail,
                                    color: AppColors.statusOptimal,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Contact Us',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildContactItem(
                                Icons.email,
                                'Email',
                                'support@clockworklegacy.com',
                              ),
                              _buildContactItem(
                                Icons.web,
                                'Website',
                                'www.clockworklegacy.com',
                              ),
                              _buildContactItem(
                                Icons.forum,
                                'Community',
                                'community.clockworklegacy.com',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Copyright
                        GlassCard(
                          child: Column(
                            children: [
                              Text(
                                '© 2025 Clockwork Studios',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'All rights reserved. Made with ⚙️ and passion.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentRose.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accentRose, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lavenderWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String tech, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.statusWarning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: tech,
                    style: const TextStyle(
                      color: AppColors.vintageGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' - $description',
                    style: TextStyle(
                      color: AppColors.lavenderWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.statusOptimal, size: 16),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.vintageGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}