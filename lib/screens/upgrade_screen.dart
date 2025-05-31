import 'package:flutter/material.dart';
import '../components/upgrade_card.dart';
import '../models/player.dart';
import '../models/upgrade.dart';
import '../utils/constants.dart';
import 'dart:async';

class UpgradeScreen extends StatefulWidget {
  final Player player;
  final Function(Upgrade) onUpgradeSelected;

  const UpgradeScreen({
    Key? key,
    required this.player,
    required this.onUpgradeSelected,
  }) : super(key: key);

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen>
    with SingleTickerProviderStateMixin {
  late List<Upgrade> _upgradeOptions;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Upgrade? _selectedUpgrade;

  @override
  void initState() {
    super.initState();
    // Generate three upgrade options
    _upgradeOptions = Upgrade.generateUpgradeOptions(
      widget.player.bullets,
      widget.player.cultivationLevel,
      widget.player.passiveSkills, // Using passiveSkills as acquiredUpgrades
    );

    // Setup animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 375;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.upgradeScreenGradient,
          ),
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              );
            },
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmallScreen ? 12 : 20),
                      Text(
                        'Celestial Choices',
                        style: AppConstants.headlineMedium.copyWith(
                          fontSize: isSmallScreen ? 22 : 26,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 10 : 16),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12.0 : 16.0),
                        child: Text(
                          'Choose a celestial enhancement to strengthen your abilities',
                          style: AppConstants.bodyLarge.copyWith(
                            color: Colors.purple.shade200,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 16 : 24),
                      _buildUpgradeCards(),
                      SizedBox(height: isSmallScreen ? 16 : 24),
                      AnimatedOpacity(
                        opacity: _selectedUpgrade != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12.0 : 16.0),
                          child: Text(
                            _selectedUpgrade != null
                                ? 'You chose: ${_selectedUpgrade!.name}'
                                : '',
                            style: AppConstants.bodyLarge.copyWith(
                              color: Colors.amber.shade300,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get screen size information
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        // Optimization for different screen sizes
        final isVerySmallScreen = screenWidth < 330;
        final isSmallScreen = screenWidth < 375;
        final isIPhoneSE = screenWidth <= 320 && screenHeight <= 568;
        final isIPhone13Mini = screenWidth <= 375 && screenWidth > 320;

        // Calculate card width
        double cardWidth;
        if (screenWidth > 900) {
          cardWidth = 250.0;
        } else if (isVerySmallScreen &&
            !isLandscape &&
            !isIPhone13Mini &&
            screenWidth < 300) {
          // Only very small screens use single-column layout
          cardWidth = screenWidth * 0.8;
        } else {
          // All other screens use three-column layout, ensuring cards can be displayed properly
          // Reduce margins and spacing so three cards can fit
          cardWidth = (screenWidth - 24) / 3;
        }

        // Single-column layout for extremely small screens (screens smaller than 300px)
        if (screenWidth < 300 && !isLandscape) {
          return Column(
            children: _upgradeOptions.map((upgrade) {
              return Container(
                width: cardWidth,
                margin: EdgeInsets.only(
                  bottom: 8,
                  left: 8,
                  right: 8,
                ),
                child: UpgradeCard(
                  upgrade: upgrade,
                  isSelected: _selectedUpgrade == upgrade,
                  onSelect: (selectedUpgrade) {
                    setState(() {
                      _selectedUpgrade = selectedUpgrade;
                    });

                    // Brief delay before returning and applying upgrade
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        widget.onUpgradeSelected(selectedUpgrade);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          );
        }

        // Three-column layout for all other screens
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 8),
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? screenWidth : 900,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_upgradeOptions.length, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 2 : 4,
                    ),
                    child: UpgradeCard(
                      upgrade: _upgradeOptions[index],
                      isSelected: _selectedUpgrade == _upgradeOptions[index],
                      onSelect: (upgrade) {
                        setState(() {
                          _selectedUpgrade = upgrade;
                        });

                        // Brief delay before returning and applying upgrade
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (mounted) {
                            widget.onUpgradeSelected(upgrade);
                          }
                        });
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
