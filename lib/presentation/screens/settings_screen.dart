import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/settings_model.dart';
import '../../data/repositories/local_game_repository.dart';
import '../utils/constants.dart';
import '../utils/haptic_feedback.dart';
import '../widgets/glass_card_widget.dart';
import 'about_us_screen.dart';
import 'help_center_screen.dart';
import 'feedback_screen.dart';
import 'customer_support_screen.dart';
import 'safety_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final _repository = LocalGameRepository();
  late SettingsModel _settings;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.loadSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });

    // Start animations after data is loaded
    _animationController.forward();
  }

  Future<void> _updateSettings(SettingsModel newSettings) async {
    await _repository.saveSettings(newSettings);
    setState(() {
      _settings = newSettings;
    });

    // Update haptic feedback service
    HapticFeedbackService.setEnabled(newSettings.hapticFeedbackEnabled);

    // Provide haptic feedback when enabling
    if (newSettings.hapticFeedbackEnabled) {
      HapticFeedbackService.vibrate();
    }
  }

  void _navigateTo(Widget screen) {
    if (_settings.hapticFeedbackEnabled) {
      HapticFeedbackService.vibrate();
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: UIConstants.BACKGROUND_COLOR,
        body: Center(
          child: CircularProgressIndicator(color: UIConstants.PURPLE_COLOR),
        ),
      );
    }

    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside of text fields
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and title
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.SPACING_MEDIUM,
                  vertical: UIConstants.SPACING_MEDIUM,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      UIConstants.PURPLE_COLOR.withOpacity(0.3),
                      UIConstants.BACKGROUND_COLOR,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(
                      UIConstants.BORDER_RADIUS_MEDIUM,
                    ),
                    bottomRight: Radius.circular(
                      UIConstants.BORDER_RADIUS_MEDIUM,
                    ),
                  ),
                ),
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
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  UIConstants.PURPLE_COLOR,
                                  UIConstants.CYAN_COLOR,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: UIConstants.PURPLE_COLOR.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: UIConstants.SPACING_SMALL),
                          const Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40), // Balance for the back button
                  ],
                ),
              ),

              // Settings list
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.SPACING_MEDIUM,
                      vertical: UIConstants.SPACING_MEDIUM,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_animationController),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section header
                            const SizedBox(height: UIConstants.SPACING_LARGE),

                            // Section header
                            _buildSectionHeader("Information", Icons.info),
                            const SizedBox(height: UIConstants.SPACING_SMALL),

                            // Information Card
                            GlassCard(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(
                                UIConstants.BORDER_RADIUS_MEDIUM,
                              ),
                              child: Column(
                                children: [
                                  // About Us
                                  _buildSettingsItem(
                                    icon: Icons.info_outline,
                                    iconColor: Colors.blue,
                                    title: "About Us",
                                    subtitle: "Learn about Coria and our team",
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white60,
                                    ),
                                    showDivider: true,
                                    onTap: () =>
                                        _navigateTo(const AboutUsScreen()),
                                  ),

                                  // Help Center
                                  _buildSettingsItem(
                                    icon: Icons.help_outline,
                                    iconColor: Colors.amber,
                                    title: "Help Center",
                                    subtitle:
                                        "Find answers to common questions",
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white60,
                                    ),
                                    showDivider: true,
                                    onTap: () =>
                                        _navigateTo(const HelpCenterScreen()),
                                  ),

                                  // Feedback
                                  _buildSettingsItem(
                                    icon: Icons.comment_outlined,
                                    iconColor: Colors.orange,
                                    title: "Feedback",
                                    subtitle: "Share your thoughts with us",
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white60,
                                    ),
                                    showDivider: false,
                                    onTap: () =>
                                        _navigateTo(const FeedbackScreen()),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: UIConstants.SPACING_LARGE),

                            // Section header
                            _buildSectionHeader(
                              "Support & Legal",
                              Icons.support_agent,
                            ),
                            const SizedBox(height: UIConstants.SPACING_SMALL),

                            // Support & Legal Card
                            GlassCard(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(
                                UIConstants.BORDER_RADIUS_MEDIUM,
                              ),
                              child: Column(
                                children: [
                                  // Customer Support
                                  _buildSettingsItem(
                                    icon: Icons.headset_mic_outlined,
                                    iconColor: Colors.teal,
                                    title: "Customer Support",
                                    subtitle: "Get help from our support team",
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white60,
                                    ),
                                    showDivider: true,
                                    onTap: () => _navigateTo(
                                      const CustomerSupportScreen(),
                                    ),
                                  ),

                                  // Safety & Anti-addiction
                                  _buildSettingsItem(
                                    icon: Icons.shield_outlined,
                                    iconColor: Colors.purple,
                                    title: "Safety & Anti-addiction",
                                    subtitle: "Gaming health guidelines",
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white60,
                                    ),
                                    showDivider: true,
                                    onTap: () =>
                                        _navigateTo(const SafetyScreen()),
                                  ),

                                  // Terms of Service
                                  _buildSettingsItem(
                                    icon: Icons.description_outlined,
                                    iconColor: Colors.indigo,
                                    title: "Terms of Service",
                                    subtitle:
                                        "Legal information and privacy policy",
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white60,
                                    ),
                                    showDivider: false,
                                    onTap: () => _navigateTo(
                                      const TermsOfServiceScreen(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: UIConstants.SPACING_LARGE),

                            // App version
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: UIConstants.SPACING_MEDIUM,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            UIConstants.PURPLE_COLOR,
                                            UIConstants.CYAN_COLOR,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: UIConstants.PURPLE_COLOR
                                                .withOpacity(0.3),
                                            blurRadius: 15,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "C",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: UIConstants.SPACING_MEDIUM,
                                    ),
                                    const Text(
                                      "Coria v1.0.0",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: UIConstants.TEXT_SECONDARY_COLOR,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.SPACING_SMALL,
        vertical: UIConstants.SPACING_SMALL,
      ),
      child: Row(
        children: [
          Icon(icon, color: UIConstants.CYAN_COLOR, size: 18),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: UIConstants.TEXT_SECONDARY_COLOR,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: UIConstants.TEXT_SECONDARY_COLOR.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget trailing,
    required bool showDivider,
    VoidCallback? onTap,
  }) {
    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withOpacity(0.8),
                      iconColor.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: UIConstants.SPACING_MEDIUM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: UIConstants.TEXT_SECONDARY_COLOR,
                        ),
                      ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
        if (showDivider)
          Divider(color: Colors.white.withOpacity(0.1), height: 1, indent: 72),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: () {
          if (_settings.hapticFeedbackEnabled) {
            HapticFeedbackService.vibrate();
          }
          onTap!(); // Corrected: Assert non-null call
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.white.withOpacity(0.05),
        child: content,
      );
    }

    return content;
  }
}
