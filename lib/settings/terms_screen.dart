import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: AppConstants.spaceIndigo600,
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.gavel_rounded,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of Service',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.cosmicBlue,
                          ),
                        ),
                        Text(
                          'Last updated: January 2023',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Introduction
              _buildSection(
                context,
                title: '1. Introduction',
                content:
                    'Welcome to Verzephronix. By using our application, you agree to these Terms of Service. Please read them carefully. If you do not agree to these terms, you may not use Verzephronix.',
              ),

              // Using Our Services
              _buildSection(
                context,
                title: '2. Using Our Services',
                content:
                    'You must follow any policies made available to you within the Services. You may use our Services only as permitted by law. We may suspend or stop providing our Services to you if you do not comply with our terms or policies or if we are investigating suspected misconduct.',
              ),

              // Your Verzephronix Account
              _buildSection(
                context,
                title: '3. Your Verzephronix Account',
                content:
                    'To use some features of our application, you may need to create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. Verzephronix is not responsible for any loss or damage arising from your failure to comply with this security obligation.',
              ),

              // Privacy and Copyright Protection
              _buildSection(
                context,
                title: '4. Privacy and Copyright Protection',
                content:
                    'Our privacy policies explain how we treat your personal data and protect your privacy when you use our Services. By using our Services, you agree that Verzephronix can use such data in accordance with our privacy policies. We respond to notices of alleged copyright infringement and terminate accounts of repeat infringers according to applicable copyright laws.',
              ),

              // Your Content in Our Services
              _buildSection(
                context,
                title: '5. Your Content in Our Services',
                content:
                    'Some of our Services allow you to upload, submit, store, send or receive content. You retain ownership of any intellectual property rights that you hold in that content. When you upload, submit, store, send or receive content to or through our Services, you give Verzephronix a worldwide license to use, host, store, reproduce, modify, create derivative works, communicate, publish, publicly perform, publicly display and distribute such content.',
              ),

              // Modifying and Terminating our Services
              _buildSection(
                context,
                title: '6. Modifying and Terminating our Services',
                content:
                    'We are constantly changing and improving our Services. We may add or remove functionalities or features, and we may suspend or stop a Service altogether. You can stop using our Services at any time. Verzephronix may also stop providing Services to you, or add or create new limits to our Services at any time.',
              ),

              // Our Warranties and Disclaimers
              _buildSection(
                context,
                title: '7. Our Warranties and Disclaimers',
                content:
                    'We provide our Services using a commercially reasonable level of skill and care. But there are certain things that we don\'t promise about our Services. OTHER THAN AS EXPRESSLY SET OUT IN THESE TERMS OR ADDITIONAL TERMS, NEITHER VERZEPHRONIX NOR ITS SUPPLIERS OR DISTRIBUTORS MAKE ANY SPECIFIC PROMISES ABOUT THE SERVICES.',
              ),

              // Liability for our Services
              _buildSection(
                context,
                title: '8. Liability for our Services',
                content:
                    'WHEN PERMITTED BY LAW, VERZEPHRONIX, AND ITS SUPPLIERS AND DISTRIBUTORS, WILL NOT BE RESPONSIBLE FOR LOST PROFITS, REVENUES, OR DATA, FINANCIAL LOSSES OR INDIRECT, SPECIAL, CONSEQUENTIAL, EXEMPLARY, OR PUNITIVE DAMAGES.',
              ),

              // About these Terms
              _buildSection(
                context,
                title: '9. About these Terms',
                content:
                    'We may modify these terms or any additional terms that apply to a Service to, for example, reflect changes to the law or changes to our Services. You should look at the terms regularly. We\'ll post notice of modifications to these terms on this page. Changes will not apply retroactively and will become effective no sooner than fourteen days after they are posted.',
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  'By using Verzephronix, you agree to these terms.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.spaceIndigo600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
