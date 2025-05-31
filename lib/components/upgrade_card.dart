import 'package:flutter/material.dart';
import '../models/upgrade.dart';
import '../utils/constants.dart';

class UpgradeCard extends StatefulWidget {
  final Upgrade upgrade;
  final Function(Upgrade) onSelect;
  final bool isSelected;

  const UpgradeCard({
    Key? key,
    required this.upgrade,
    required this.onSelect,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<UpgradeCard> createState() => _UpgradeCardState();
}

class _UpgradeCardState extends State<UpgradeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || widget.isSelected;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final isVerySmallScreen = screenWidth < 330;

    if (isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    // Use a ConstrainedBox instead of a fixed SizedBox to make it more responsive
    return LayoutBuilder(builder: (context, constraints) {
      // Determine if we're in a vertical (column) layout
      final isVertical = constraints.maxWidth < 200;

      // Calculate a reasonable height constraint - using aspect ratio of approx 3:4
      // For small screens, use a smaller height to make cards more compact
      final height = isSmallScreen
          ? constraints.maxWidth * 1.1 // More compact height for small screens
          : isVertical
              ? constraints.maxWidth * 1.5 // When displayed in column
              : constraints.maxWidth * 1.2; // When displayed in row

      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: isVerySmallScreen ? 130 : (isSmallScreen ? 140 : 180),
          maxHeight: height,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () => widget.onSelect(widget.upgrade),
              child: Card(
                elevation: isActive ? 8 : 4, // Reduced elevation
                shape: RoundedRectangleBorder(
                  borderRadius: isSmallScreen
                      ? BorderRadius.circular(10)
                      : AppConstants.borderRadiusLarge,
                  side: BorderSide(
                    color: isActive
                        ? AppConstants.primaryColor
                        : const Color(0xFF4B5563),
                    width: isActive ? 2 : 1,
                  ),
                ),
                color: Colors.black87.withOpacity(0.8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: isSmallScreen
                        ? BorderRadius.circular(10)
                        : AppConstants.borderRadiusLarge,
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              AppConstants.secondaryColor.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  padding: EdgeInsets.all(
                      isVerySmallScreen ? 6 : (isSmallScreen ? 8 : 16)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Only take up needed space
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.upgrade.icon,
                        size: isVerySmallScreen
                            ? 20
                            : (isSmallScreen
                                ? 24
                                : (isVertical
                                    ? 32
                                    : 48)), // Smaller icon on small screens
                        color: _getColorForEffect(widget.upgrade.effect),
                      ),
                      SizedBox(
                          height:
                              isVerySmallScreen ? 4 : (isSmallScreen ? 6 : 12)),
                      Text(
                        widget.upgrade.name,
                        style: isVerySmallScreen
                            ? AppConstants.titleLarge.copyWith(fontSize: 12)
                            : (isSmallScreen
                                ? AppConstants.titleLarge.copyWith(fontSize: 14)
                                : AppConstants.titleLarge),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height:
                              isVerySmallScreen ? 2 : (isSmallScreen ? 4 : 8)),
                      Flexible(
                        // Make text adaptable
                        child: SingleChildScrollView(
                          // Allow scrolling if text overflows
                          child: Text(
                            widget.upgrade.description,
                            style: AppConstants.bodyMedium.copyWith(
                              color: Colors.grey.shade300,
                              fontSize: isVerySmallScreen
                                  ? 10
                                  : (isSmallScreen ? 11 : null),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              isVerySmallScreen ? 6 : (isSmallScreen ? 8 : 16)),
                      ElevatedButton(
                        onPressed: () => widget.onSelect(widget.upgrade),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: AppConstants.darkTextColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: isVerySmallScreen
                                ? 4
                                : (isSmallScreen
                                    ? 6
                                    : (isVertical
                                        ? 8
                                        : 16)), // Smaller padding on small screens
                            vertical: isVerySmallScreen
                                ? 2
                                : (isSmallScreen ? 4 : (isVertical ? 6 : 8)),
                          ),
                          minimumSize:
                              isSmallScreen ? const Size(60, 24) : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppConstants.borderRadiusSmall,
                          ),
                        ),
                        child: Text(
                          'Choose This Path',
                          style: TextStyle(
                            fontSize: isVerySmallScreen
                                ? 10
                                : (isSmallScreen ? 12 : 14),
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
      );
    });
  }

  Color _getColorForEffect(String effect) {
    switch (effect) {
      case 'bolt_damage':
        return Colors.amber;
      case 'unlock_bullet':
        if (widget.upgrade.value == 0) {
          return Colors.deepOrange; // Fire
        } else if (widget.upgrade.value == 1) {
          return Colors.lightBlue; // Frost
        } else if (widget.upgrade.value == 2) {
          return Colors.purple; // Spirit Energy
        } else {
          return Colors.teal; // Storm
        }
      case 'max_health':
      case 'health_regen':
      case 'instant_health':
        return Colors.red;
      case 'damage_reflect':
        return Colors.yellow;
      case 'fire_rate':
        return Colors.green;
      case 'multi_shot':
        return Colors.blueAccent;
      case 'enlightenment_gain':
        return Colors.purpleAccent;
      case 'cultivation_gain':
        return Colors.orange;
      default:
        return AppConstants.primaryColor;
    }
  }
}
