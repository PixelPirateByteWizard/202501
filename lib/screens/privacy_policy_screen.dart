import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
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
                        'Privacy Policy',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Introduction
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.privacy_tip,
                                    color: AppColors.statusOptimal,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Your Privacy Matters',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'At Clockwork Studios, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use Clockwork Legacy.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Effective Date: January 12, 2025',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Information We Collect
                        _buildSection(
                          'Information We Collect',
                          Icons.info,
                          AppColors.vintageGold,
                          [
                            {
                              'title': 'Game Progress Data',
                              'content': 'Your game saves, achievements, settings, and progress are stored locally on your device. This data never leaves your device unless you explicitly choose to back it up.',
                            },
                            {
                              'title': 'Usage Analytics',
                              'content': 'We may collect anonymous usage statistics such as gameplay duration, feature usage, and crash reports to improve the game experience.',
                            },
                            {
                              'title': 'Device Information',
                              'content': 'Basic device information like operating system version and device model may be collected for compatibility and optimization purposes.',
                            },
                          ],
                        ),

                        const SizedBox(height: 16),

                        // How We Use Information
                        _buildSection(
                          'How We Use Your Information',
                          Icons.settings,
                          AppColors.accentRose,
                          [
                            {
                              'title': 'Game Functionality',
                              'content': 'To provide core game features, save your progress, and maintain your personalized experience.',
                            },
                            {
                              'title': 'Improvement and Development',
                              'content': 'To analyze usage patterns, fix bugs, and develop new features that enhance the gaming experience.',
                            },
                            {
                              'title': 'Technical Support',
                              'content': 'To provide customer support and troubleshoot technical issues you may encounter.',
                            },
                          ],
                        ),

                        const SizedBox(height: 16),

                        // AI and Data Processing
                        _buildSection(
                          'AI Story Generation',
                          Icons.psychology,
                          AppColors.statusOptimal,
                          [
                            {
                              'title': 'Story Content Creation',
                              'content': 'Our AI system generates story content based on your gameplay choices. This processing happens in real-time and does not store personal information.',
                            },
                            {
                              'title': 'No Personal Data in Stories',
                              'content': 'The AI story generation does not access or use any personal information. It only uses game context and your current choices.',
                            },
                            {
                              'title': 'Content Filtering',
                              'content': 'We implement content filtering to ensure appropriate story generation, but cannot guarantee all AI-generated content will be perfect.',
                            },
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Data Storage and Security
                        _buildSection(
                          'Data Storage and Security',
                          Icons.security,
                          AppColors.statusWarning,
                          [
                            {
                              'title': 'Local Storage',
                              'content': 'All game data is stored locally on your device using secure storage mechanisms provided by your operating system.',
                            },
                            {
                              'title': 'No Cloud Storage',
                              'content': 'We do not automatically upload your game data to cloud servers. Any cloud backup is handled by your device\'s built-in backup systems.',
                            },
                            {
                              'title': 'Data Encryption',
                              'content': 'Sensitive game data is encrypted using industry-standard encryption methods to protect against unauthorized access.',
                            },
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Third-Party Services
                        _buildSection(
                          'Third-Party Services',
                          Icons.link,
                          AppColors.statusError,
                          [
                            {
                              'title': 'AI Service Providers',
                              'content': 'We use DeepSeek AI services for story generation. Only game context (not personal data) is sent to generate stories.',
                            },
                            {
                              'title': 'Analytics Services',
                              'content': 'Anonymous usage data may be processed by analytics services to help us understand how the game is used.',
                            },
                            {
                              'title': 'No Advertising Networks',
                              'content': 'Clockwork Legacy does not use advertising networks or share data with advertisers.',
                            },
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Your Rights and Choices
                        _buildSection(
                          'Your Rights and Choices',
                          Icons.account_circle,
                          AppColors.vintageGold,
                          [
                            {
                              'title': 'Data Access',
                              'content': 'You can access all your game data through the in-game settings and progress screens.',
                            },
                            {
                              'title': 'Data Deletion',
                              'content': 'You can delete your game data at any time through the settings menu or by uninstalling the game.',
                            },
                            {
                              'title': 'Opt-Out Options',
                              'content': 'You can disable analytics collection in the game settings if you prefer not to share usage data.',
                            },
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Children's Privacy
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.child_care,
                                    color: AppColors.accentRose,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Children\'s Privacy',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Clockwork Legacy is designed to be appropriate for players of all ages. We do not knowingly collect personal information from children under 13. If you are a parent and believe your child has provided personal information, please contact us.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Changes to Privacy Policy
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.update,
                                    color: AppColors.statusWarning,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Policy Updates',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'We may update this Privacy Policy from time to time. Any changes will be posted in the game and on our website. Continued use of the game after changes constitutes acceptance of the updated policy.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
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
                                    Icons.contact_support,
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
                              Text(
                                'If you have questions about this Privacy Policy or our data practices:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Email: privacy@clockworklegacy.com',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.vintageGold,
                                ),
                              ),
                              Text(
                                'Website: www.clockworklegacy.com/privacy',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.vintageGold,
                                ),
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

  Widget _buildSection(String title, IconData icon, Color iconColor, List<Map<String, String>> items) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.vintageGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['content']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}