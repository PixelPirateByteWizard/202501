import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Use Enyxora',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 24),
              _buildHelpSection(
                'Generating QR Codes',
                '1. Select the type of QR code you want to create\n'
                    '2. Enter the required information\n'
                    '3. Customize appearance if desired\n'
                    '4. Tap "Generate QR Code"\n'
                    '5. Save or share the generated QR code',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Scanning QR Codes',
                '1. Tap the scan button in the bottom navigation\n'
                    '2. Point your camera at the QR code\n'
                    '3. Hold steady until the code is recognized\n'
                    '4. View the scanned content and take action',
              ),
              const SizedBox(height: 24),
              Text(
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 24),
              _buildFAQItem(
                'What types of QR codes can I create?',
                'You can create QR codes for plain text, URLs, contact information (vCard), and WiFi network credentials.',
              ),
              const SizedBox(height: 16),
              _buildFAQItem(
                'Can I customize the QR code appearance?',
                'Yes, you can change the QR code color and adjust the error correction level to balance between code size and reliability.',
              ),
              const SizedBox(height: 16),
              _buildFAQItem(
                'How do I share a generated QR code?',
                'After generating a QR code, use the share button to save it to your device or share it through other apps.',
              ),
              const SizedBox(height: 16),
              _buildFAQItem(
                'What should I do if scanning fails?',
                'Ensure good lighting, hold your device steady, and make sure the QR code is within the scanning frame. Clean your camera lens if necessary.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withOpacity(0.1),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 160,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 0.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withOpacity(0.1),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
