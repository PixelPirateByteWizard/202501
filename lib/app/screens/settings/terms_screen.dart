import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glassmorphic_container.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Acceptance of Terms',
                'By accessing and using Enyxora, you accept and agree to be bound by the terms and provision of this agreement.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Use License',
                'Permission is granted to temporarily download one copy of Enyxora for personal, non-commercial transitory viewing only.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Disclaimer',
                'The materials on Enyxora are provided on an \'as is\' basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Limitations',
                'In no event shall Enyxora or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use Enyxora.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Accuracy of Materials',
                'The materials appearing in Enyxora could include technical, typographical, or photographic errors. We do not warrant that any of the materials on Enyxora are accurate, complete, or current.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Links',
                'We have not reviewed all of the sites linked to Enyxora and are not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by us of the site.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Modifications',
                'We may revise these terms of service for Enyxora at any time without notice. By using this application you are agreeing to be bound by the then current version of these terms of service.',
              ),
              const SizedBox(height: 16),
              _buildSection(
                'Governing Law',
                'These terms and conditions are governed by and construed in accordance with the laws and you irrevocably submit to the exclusive jurisdiction of the courts in that location.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: content.length > 200 ? 240 : 160,
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
