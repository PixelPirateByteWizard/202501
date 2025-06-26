import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'About',
          style: SafeFonts.imFellEnglishSc(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game Logo and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accent.withOpacity(0.3),
                              AppColors.accent,
                              AppColors.cyanAccent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.palette,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Alchemist's Palette",
                        style: SafeFonts.imFellEnglishSc(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Master the Art of Color Synthesis',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondaryText,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Version Info
                _buildInfoCard(
                  title: 'Version Information',
                  children: [
                    _buildInfoRow('Version', '1.0.0'),
                    _buildInfoRow('Build', '1'),
                    _buildInfoRow('Release Date', 'January 2025'),
                    _buildInfoRow('Platform', 'iOS'),
                  ],
                ),
                const SizedBox(height: 16),

                // Game Description
                _buildInfoCard(
                  title: 'About the Game',
                  children: [
                    const Text(
                      "Alchemist's Palette is an innovative color-matching puzzle game that combines strategy, creativity, and the ancient art of alchemy. Players synthesize primary colors to create secondary colors while completing challenging alchemical orders.",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Key Features:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem('🧪', 'Unique color synthesis mechanics'),
                    _buildFeatureItem('🏆', 'Comprehensive achievement system'),
                    _buildFeatureItem('📊', 'Detailed statistics tracking'),
                    _buildFeatureItem('♾️', 'Infinite procedural levels'),
                    _buildFeatureItem('✨', 'Beautiful animations and effects'),
                    _buildFeatureItem('🎵', 'Immersive audio experience'),
                  ],
                ),
                const SizedBox(height: 16),

                // Developer Info
                _buildInfoCard(
                  title: 'Development Team',
                  children: [
                    _buildInfoRow('Developer', 'Indie Game Studio'),
                    _buildInfoRow('Game Design', 'Creative Team'),
                    _buildInfoRow('Programming', 'Flutter Developers'),
                    _buildInfoRow('Art & Design', 'Visual Artists'),
                    const SizedBox(height: 12),
                    const Text(
                      'Made with ❤️ using Flutter framework for cross-platform mobile gaming excellence.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Credits
                _buildInfoCard(
                  title: 'Credits & Acknowledgments',
                  children: [
                    const Text(
                      'Special thanks to:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCreditItem(
                        'Flutter Team', 'Amazing cross-platform framework'),
                    _buildCreditItem(
                        'Material Design', 'Beautiful UI components'),
                    _buildCreditItem('Open Source Community',
                        'Invaluable tools and libraries'),
                    _buildCreditItem(
                        'Beta Testers', 'Feedback and bug reports'),
                    _buildCreditItem('Players', 'Making this game meaningful'),
                  ],
                ),
                const SizedBox(height: 32),

                // Copyright
                Center(
                  child: Text(
                    '© 2025 Alchemist\'s Palette\nAll rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SafeFonts.imFellEnglishSc(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditItem(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
