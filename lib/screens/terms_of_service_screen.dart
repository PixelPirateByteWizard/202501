import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen>
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
                        'Terms of Service',
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
                                    Icons.gavel,
                                    color: AppColors.vintageGold,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Agreement Overview',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Welcome to Clockwork Legacy. By downloading, installing, or using this game, you agree to be bound by these Terms of Service. Please read them carefully.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Last Updated: January 12, 2025',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Section 1: Acceptance of Terms
                        _buildSection(
                          '1. Acceptance of Terms',
                          Icons.check_circle,
                          AppColors.statusOptimal,
                          [
                            'By accessing or using Clockwork Legacy, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                            'If you do not agree to these terms, you must not use the game.',
                            'We reserve the right to modify these terms at any time. Continued use of the game constitutes acceptance of any changes.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 2: Game License
                        _buildSection(
                          '2. Game License',
                          Icons.key,
                          AppColors.vintageGold,
                          [
                            'We grant you a limited, non-exclusive, non-transferable license to use Clockwork Legacy for personal entertainment purposes.',
                            'You may not copy, modify, distribute, sell, or lease any part of the game or its content.',
                            'The game and all related intellectual property rights remain the exclusive property of Clockwork Studios.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 3: User Conduct
                        _buildSection(
                          '3. User Conduct',
                          Icons.person_outline,
                          AppColors.accentRose,
                          [
                            'You agree to use the game in a manner consistent with all applicable laws and regulations.',
                            'You will not attempt to hack, reverse engineer, or exploit the game in any unauthorized manner.',
                            'Any attempt to cheat, use unauthorized software, or disrupt the game experience is strictly prohibited.',
                            'We reserve the right to suspend or terminate access for violations of these terms.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 4: Privacy and Data
                        _buildSection(
                          '4. Privacy and Data Collection',
                          Icons.security,
                          AppColors.statusWarning,
                          [
                            'We collect and process data as described in our Privacy Policy.',
                            'Game progress and settings are stored locally on your device.',
                            'We may collect anonymous usage statistics to improve the game experience.',
                            'No personal information is shared with third parties without your consent.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 5: AI Content
                        _buildSection(
                          '5. AI-Generated Content',
                          Icons.psychology,
                          AppColors.statusOptimal,
                          [
                            'Clockwork Legacy uses AI technology to generate dynamic story content.',
                            'AI-generated content is created in real-time and may vary between gameplay sessions.',
                            'While we strive for appropriate content, AI-generated text may occasionally be unexpected.',
                            'Users can report inappropriate content through our feedback system.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 6: Disclaimers
                        _buildSection(
                          '6. Disclaimers and Limitations',
                          Icons.warning,
                          AppColors.statusError,
                          [
                            'The game is provided "as is" without warranties of any kind.',
                            'We do not guarantee uninterrupted or error-free operation.',
                            'Our liability is limited to the maximum extent permitted by law.',
                            'We are not responsible for any loss of game progress or data.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 7: Updates and Changes
                        _buildSection(
                          '7. Updates and Modifications',
                          Icons.system_update,
                          AppColors.vintageGold,
                          [
                            'We may release updates, patches, or new versions of the game.',
                            'Updates may modify gameplay, features, or content without prior notice.',
                            'Continued use of the game after updates constitutes acceptance of changes.',
                            'Some updates may be required for continued access to the game.',
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 8: Termination
                        _buildSection(
                          '8. Termination',
                          Icons.exit_to_app,
                          AppColors.statusError,
                          [
                            'Either party may terminate this agreement at any time.',
                            'Upon termination, you must cease all use of the game.',
                            'We reserve the right to disable access for violations of these terms.',
                            'Termination does not affect any rights or obligations that have already accrued.',
                          ],
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
                                    'Questions or Concerns?',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'If you have any questions about these Terms of Service, please contact us:',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Email: legal@clockworklegacy.com',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.vintageGold,
                                ),
                              ),
                              Text(
                                'Website: www.clockworklegacy.com/legal',
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

  Widget _buildSection(String title, IconData icon, Color iconColor, List<String> content) {
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
          ...content.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
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