import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Terms of Service',
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
                // Header
                Container(
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
                        'Terms of Service',
                        style: SafeFonts.imFellEnglishSc(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last Updated: January 2025',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Please read these Terms of Service carefully before using Alchemist\'s Palette. By using our game, you agree to be bound by these terms.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Terms Sections
                _buildTermsSection(
                  '1. Acceptance of Terms',
                  'By downloading, installing, or using Alchemist\'s Palette ("the Game"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, do not use the Game.',
                ),

                _buildTermsSection(
                  '2. License to Use',
                  'We grant you a limited, non-exclusive, non-transferable license to use the Game for personal, non-commercial purposes. This license does not include the right to:\n\n• Modify, adapt, or hack the Game\n• Reverse engineer or decompile the Game\n• Use the Game for commercial purposes\n• Distribute or resell the Game',
                ),

                _buildTermsSection(
                  '3. User Conduct',
                  'You agree to use the Game in accordance with all applicable laws and regulations. You will not:\n\n• Use the Game for any unlawful purpose\n• Attempt to gain unauthorized access to our systems\n• Interfere with other users\' enjoyment of the Game\n• Upload or transmit harmful content',
                ),

                _buildTermsSection(
                  '4. Intellectual Property',
                  'All content in the Game, including but not limited to graphics, music, sound effects, text, and code, is owned by us or our licensors and is protected by copyright and other intellectual property laws.',
                ),

                _buildTermsSection(
                  '5. Privacy and Data',
                  'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use the Game. By using the Game, you consent to our Privacy Policy.',
                ),

                _buildTermsSection(
                  '6. Game Content and Features',
                  'The Game includes various features such as:\n\n• Color synthesis gameplay mechanics\n• Achievement and statistics systems\n• Local data storage\n• Audio and visual effects\n\nWe reserve the right to modify, update, or discontinue any features at our discretion.',
                ),

                _buildTermsSection(
                  '7. Disclaimers',
                  'THE GAME IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.',
                ),

                _buildTermsSection(
                  '8. Limitation of Liability',
                  'TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING FROM YOUR USE OF THE GAME.',
                ),

                _buildTermsSection(
                  '9. Updates and Modifications',
                  'We may update the Game and these Terms from time to time. Continued use of the Game after such updates constitutes acceptance of the revised Terms.',
                ),

                _buildTermsSection(
                  '10. Termination',
                  'We may terminate your access to the Game at any time, with or without cause. Upon termination, you must cease all use of the Game and delete all copies from your devices.',
                ),

                _buildTermsSection(
                  '11. Governing Law',
                  'These Terms are governed by and construed in accordance with the laws of the jurisdiction where the Game is developed, without regard to conflict of law principles.',
                ),

                _buildTermsSection(
                  '12. Contact Information',
                  'If you have any questions about these Terms of Service, please contact us through the feedback option in the Game settings.',
                ),

                const SizedBox(height: 20),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.accent,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Thank you for playing Alchemist\'s Palette!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We hope you enjoy your alchemical journey.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
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
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
