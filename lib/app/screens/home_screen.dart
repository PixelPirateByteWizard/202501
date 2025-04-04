import 'package:flutter/material.dart';
import '../widgets/glassmorphic_container.dart';
import '../theme/app_colors.dart';
import 'qr_code/qr_generator_screen.dart';
import 'encryption/encryption_screen.dart';
import 'word_count/word_count_screen.dart';
import 'settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Widget> _screens = const [
    QrGeneratorScreen(),
    EncryptionScreen(),
    WordCountScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    'QR Code',
    'Encryption',
    'Word Count',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8F9FF),
                  Color(0xFFF0F1FA),
                ],
              ),
            ),
          ),

          // Background decorative elements
          Positioned(
            top: -80,
            right: -100,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            left: -150,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.1),
              ),
            ),
          ),

          // App content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _titles[_currentIndex],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const PageScrollPhysics(),
                    children: _screens,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Custom bottom navigation bar
      bottomNavigationBar: SafeArea(
        // Use SafeArea instead of Padding for more reliable results
        child: SizedBox(
          height: 60, // Fixed height
          child: ClipRect(
            // Add ClipRect to ensure nothing renders outside the container
            child: GlassmorphicContainer(
              width: double.infinity,
              height: 60,
              borderRadius: 0,
              blur: 20,
              alignment: Alignment.center, // Changed to center alignment
              border: 0,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                stops: const [0.1, 1],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.5),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    _tabController.animateTo(index);
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textLight,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                // Reduce item padding
                selectedFontSize: 12.0, // Smaller font size
                unselectedFontSize: 12.0, // Smaller font size
                iconSize: 24.0, // Smaller icon size
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_rounded),
                    label: 'QR Code',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.lock_rounded),
                    label: 'Encryption',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.text_fields_rounded),
                    label: 'Word Count',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
