import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

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
                    TextConstants.HOW_TO_PLAY,
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

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  UIConstants.SPACING_MEDIUM,
                  0,
                  UIConstants.SPACING_MEDIUM,
                  UIConstants.SPACING_LARGE,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Rules section
                    const Text(
                      TextConstants.BASIC_RULES,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UIConstants.PURPLE_COLOR,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Swipe rule
                    _buildRuleCard(
                      icon: Icons.swipe,
                      iconColor: UIConstants.PURPLE_COLOR,
                      title: TextConstants.SWIPE,
                      description: TextConstants.SWIPE_DESC,
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Merge rule
                    _buildRuleCard(
                      icon: Icons.add_box,
                      iconColor: UIConstants.CYAN_COLOR,
                      title: TextConstants.MERGE,
                      description: TextConstants.MERGE_DESC,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: UIConstants.SPACING_SMALL,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTileExample(1, UIConstants.TILE_ONE_COLOR),
                            const Text(
                              ' + ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildTileExample(2, UIConstants.TILE_TWO_COLOR),
                            const Text(
                              ' = ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildTileExample(
                              3,
                              UIConstants.TILE_THREE_PLUS_COLOR,
                              UIConstants.TILE_THREE_PLUS_TEXT_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: UIConstants.SPACING_LARGE),

                    // Core Strategy section
                    const Text(
                      TextConstants.CORE_STRATEGY,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UIConstants.PURPLE_COLOR,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Predict new tiles strategy
                    _buildRuleCard(
                      icon: Icons.lightbulb,
                      iconColor: Colors.amber,
                      title: TextConstants.PREDICT_NEW_TILES,
                      description: TextConstants.PREDICT_NEW_TILES_DESC,
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Space management strategy
                    _buildRuleCard(
                      icon: Icons.grid_4x4,
                      iconColor: Colors.green,
                      title: TextConstants.SPACE_MANAGEMENT,
                      description: TextConstants.SPACE_MANAGEMENT_DESC,
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Game over condition
                    _buildRuleCard(
                      icon: Icons.lock,
                      iconColor: Colors.red,
                      title: TextConstants.GAME_OVER,
                      description: TextConstants.GAME_OVER_DESC,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    Widget? child,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(
                UIConstants.BORDER_RADIUS_SMALL,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: UIConstants.SPACING_MEDIUM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: UIConstants.TEXT_SECONDARY_COLOR,
                    height: 1.5,
                  ),
                ),
                if (child != null) child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTileExample(
    int value,
    Color backgroundColor, [
    Color textColor = Colors.white,
  ]) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
