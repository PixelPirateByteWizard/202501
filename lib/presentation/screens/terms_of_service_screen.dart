import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(UIConstants.SPACING_SMALL),
                    borderRadius: BorderRadius.circular(
                      UIConstants.BORDER_RADIUS_XLARGE,
                    ),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                  const Text(
                    "Terms of Service",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance for the back button
                ],
              ),
            ),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.SPACING_MEDIUM,
              ),
              child: GlassCard(
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: UIConstants.PURPLE_COLOR.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      UIConstants.BORDER_RADIUS_SMALL,
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(text: "Terms of Service"),
                    Tab(text: "Privacy Policy"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: UIConstants.SPACING_MEDIUM),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Terms of Service tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermsSection(
                          title: "1. Acceptance of Terms",
                          content:
                              "By downloading, installing, or using Coria, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the application.",
                        ),

                        _buildTermsSection(
                          title: "2. Changes to Terms",
                          content:
                              "We reserve the right to modify these terms at any time. We will notify users of any significant changes. Your continued use of Coria after such modifications constitutes your acceptance of the updated terms.",
                        ),

                        _buildTermsSection(
                          title: "3. User Accounts",
                          content:
                              "Coria may offer optional account creation. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.",
                        ),

                        _buildTermsSection(
                          title: "4. User Conduct",
                          content:
                              "You agree not to use Coria for any unlawful purpose or in any way that could damage, disable, overburden, or impair the service. You also agree not to attempt to gain unauthorized access to any part of the application.",
                        ),

                        _buildTermsSection(
                          title: "5. Intellectual Property",
                          content:
                              "All content included in Coria, such as text, graphics, logos, button icons, images, audio clips, digital downloads, and software, is the property of Coria or its content suppliers and is protected by international copyright laws.",
                        ),

                        _buildTermsSection(
                          title: "6. Limitation of Liability",
                          content:
                              "Coria and its developers shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your access to or use of, or inability to access or use, the application.",
                        ),

                        _buildTermsSection(
                          title: "7. Termination",
                          content:
                              "We reserve the right to terminate or suspend your access to Coria at any time, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms of Service.",
                        ),

                        _buildTermsSection(
                          title: "8. Governing Law",
                          content:
                              "These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which the developers of Coria operate, without regard to its conflict of law provisions.",
                        ),

                        _buildTermsSection(
                          title: "9. Contact Information",
                          content:
                              "If you have any questions about these Terms, please contact us at legal@coriaapp.com.",
                        ),

                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        const Center(
                          child: Text(
                            "Last updated: September 15, 2025",
                            style: TextStyle(
                              fontSize: 14,
                              color: UIConstants.TEXT_SECONDARY_COLOR,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Privacy Policy tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermsSection(
                          title: "1. Information We Collect",
                          content:
                              "Coria collects minimal information necessary for gameplay functionality. This includes game progress, settings preferences, and usage statistics. We do not collect personally identifiable information unless explicitly provided by the user.",
                        ),

                        _buildTermsSection(
                          title: "2. How We Use Information",
                          content:
                              "We use the collected information to provide and improve the Coria experience, troubleshoot issues, and analyze usage patterns to enhance gameplay. All data is stored locally on your device unless you choose to share it.",
                        ),

                        _buildTermsSection(
                          title: "3. Information Sharing",
                          content:
                              "We do not sell, trade, or otherwise transfer your information to outside parties. We may share anonymous, aggregated statistics about app usage with trusted partners for analytical purposes.",
                        ),

                        _buildTermsSection(
                          title: "4. Data Security",
                          content:
                              "We implement appropriate security measures to protect against unauthorized access, alteration, disclosure, or destruction of your information. However, no method of electronic transmission or storage is 100% secure.",
                        ),

                        _buildTermsSection(
                          title: "5. Children's Privacy",
                          content:
                              "Coria is designed for users of all ages. We do not knowingly collect personal information from children under 13. If you believe we have inadvertently collected information from a child under 13, please contact us immediately.",
                        ),

                        _buildTermsSection(
                          title: "6. Your Choices",
                          content:
                              "You can choose to disable certain data collection features through the app settings. You may also request deletion of your data by contacting our support team.",
                        ),

                        _buildTermsSection(
                          title: "7. Changes to Privacy Policy",
                          content:
                              "We may update our Privacy Policy from time to time. We will notify users of any significant changes. Your continued use of Coria after such modifications constitutes your acceptance of the updated policy.",
                        ),

                        _buildTermsSection(
                          title: "8. Contact Information",
                          content:
                              "If you have any questions about this Privacy Policy, please contact us at privacy@coriaapp.com.",
                        ),

                        const SizedBox(height: UIConstants.SPACING_MEDIUM),

                        const Center(
                          child: Text(
                            "Last updated: September 15, 2025",
                            style: TextStyle(
                              fontSize: 14,
                              color: UIConstants.TEXT_SECONDARY_COLOR,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Agreement button
            Padding(
              padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
              child: GlassCard(
                padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                backgroundColor: UIConstants.PURPLE_COLOR.withOpacity(0.3),
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Text(
                    "I Understand and Agree",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.SPACING_MEDIUM),
      child: GlassCard(
        padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: UIConstants.TEXT_SECONDARY_COLOR,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
