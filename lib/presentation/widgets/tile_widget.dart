import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/game_logic.dart';

class TileWidget extends StatefulWidget {
  final int value;
  final bool isNew;
  final bool isMerging;
  final double size;
  final int? previousX;
  final int? previousY;
  final int currentX;
  final int currentY;
  final bool isFromEdge;
  final Direction? fromDirection;

  const TileWidget({
    super.key,
    required this.value,
    this.isNew = false,
    this.isMerging = false,
    this.size = 70.0,
    this.previousX,
    this.previousY,
    required this.currentX,
    required this.currentY,
    this.isFromEdge = false,
    this.fromDirection,
  });

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.isNew
          ? GameConstants.TILE_APPEAR_DURATION
          : GameConstants.TILE_MOVE_DURATION,
    );

    // Calculate start position for slide animation
    Offset startOffset = Offset.zero;

    // If the tile has previous position data, animate from there
    if (widget.previousX != null && widget.previousY != null) {
      final dx = widget.previousX! - widget.currentX;
      final dy = widget.previousY! - widget.currentY;
      startOffset = Offset(dx.toDouble(), dy.toDouble());
    }
    // If the tile is new and from an edge, animate from that edge
    else if (widget.isNew &&
        widget.isFromEdge &&
        widget.fromDirection != null) {
      switch (widget.fromDirection) {
        case Direction.up:
          startOffset = const Offset(0, -1); // From top
          break;
        case Direction.right:
          startOffset = const Offset(1, 0); // From right
          break;
        case Direction.down:
          startOffset = const Offset(0, 1); // From bottom
          break;
        case Direction.left:
          startOffset = const Offset(-1, 0); // From left
          break;
        default:
          startOffset = Offset.zero;
          break;
      }
    }

    _slideAnimation = Tween<Offset>(begin: startOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.isNew
                ? Curves.easeOutBack
                : (widget.isMerging
                      ? Curves.easeOutCubic
                      : Curves.easeOutQuint),
          ),
        );

    // Scale animation for new tiles or merging
    double beginScale = widget.isNew ? 0.5 : (widget.isMerging ? 1.0 : 1.0);
    double endScale = widget.isMerging ? 1.2 : 1.0;

    _scaleAnimation = Tween<double>(begin: beginScale, end: endScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.isNew
            ? Curves.elasticOut
            : (widget.isMerging ? Curves.easeInOutBack : Curves.linear),
      ),
    );

    // Start the animation
    _controller.forward();

    // If it's a merge animation, reverse back to normal size
    if (widget.isMerging) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine tile color and text color based on value
    Color backgroundColor;
    Color textColor;
    Gradient? gradient;

    if (widget.value == 1) {
      backgroundColor = UIConstants.TILE_ONE_COLOR;
      textColor = UIConstants.TILE_TEXT_COLOR;
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          UIConstants.TILE_ONE_COLOR,
          UIConstants.TILE_ONE_COLOR.withOpacity(0.7),
        ],
      );
    } else if (widget.value == 2) {
      backgroundColor = UIConstants.TILE_TWO_COLOR;
      textColor = UIConstants.TILE_TEXT_COLOR;
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          UIConstants.TILE_TWO_COLOR,
          UIConstants.TILE_TWO_COLOR.withOpacity(0.7),
        ],
      );
    } else {
      // For higher value tiles, create a gradient based on the value
      backgroundColor = UIConstants.TILE_THREE_PLUS_COLOR;
      textColor = UIConstants.TILE_THREE_PLUS_TEXT_COLOR;

      // Create different gradients based on tile value
      if (widget.value >= 96) {
        // Gold gradient for high-value tiles
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700), // Gold
            const Color(0xFFFFA500), // Orange
          ],
        );
        textColor = Colors.white;
      } else if (widget.value >= 48) {
        // Purple gradient for high-value tiles
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIConstants.PURPLE_COLOR,
            UIConstants.PURPLE_COLOR.withOpacity(0.7),
          ],
        );
        textColor = Colors.white;
      } else if (widget.value >= 24) {
        // Cyan gradient for medium-high tiles
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIConstants.CYAN_COLOR,
            UIConstants.CYAN_COLOR.withOpacity(0.7),
          ],
        );
        textColor = Colors.white;
      } else if (widget.value >= 12) {
        // Light gradient for medium tiles
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withOpacity(0.85)],
        );
      } else {
        // Default white gradient for lower value tiles
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withOpacity(0.9)],
        );
      }
    }

    // Enhanced tile widget with more sophisticated visual effects
    Widget tile = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        // Enhanced gradient for all tiles
        gradient: gradient,
        color: backgroundColor, // Fallback color
        borderRadius: BorderRadius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
        boxShadow: [
          // Add a more pronounced glow effect for merged tiles
          if (widget.isMerging)
            BoxShadow(
              color: backgroundColor.withOpacity(0.7),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          // Add a subtle inner shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Add a highlight shadow at the top for 3D effect
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            blurRadius: 3,
            offset: const Offset(0, -1),
            spreadRadius: -1,
          ),
        ],
        // Add a more sophisticated border with gradient effect
        border: Border.all(
          color: widget.isMerging
              ? Colors.white.withOpacity(0.6)
              : Colors.white.withOpacity(0.2),
          width: widget.isMerging ? 2.0 : 0.8,
        ),
      ),
      alignment: Alignment.center,
      // Add a subtle inner padding
      padding: const EdgeInsets.all(2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow for high-value tiles
          if (widget.value >= 12)
            Container(
              width: widget.size * 0.85,
              height: widget.size * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(
                      widget.value >= 48 ? 0.6 : 0.3,
                    ),
                    blurRadius: widget.value >= 48 ? 25 : 15,
                    spreadRadius: widget.value >= 48 ? 5 : 2,
                  ),
                ],
              ),
            ),

          // Text shadow/glow effect with improved appearance
          if (widget.isMerging || widget.value >= 24)
            Text(
              widget.value.toString(),
              style: TextStyle(
                color: Colors.black.withOpacity(0.25),
                fontSize: widget.value < 100
                    ? 34
                    : (widget.value < 1000 ? 30 : 26),
                fontWeight: FontWeight.w900,
              ),
            ),

          // Main text with enhanced 3D effect
          Text(
            widget.value.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: widget.value < 100
                  ? 34
                  : (widget.value < 1000 ? 30 : 26),
              fontWeight: FontWeight.w900,
              shadows: [
                // Enhanced text shadow for depth
                Shadow(
                  color: Colors.black.withOpacity(widget.isMerging ? 0.7 : 0.5),
                  blurRadius: widget.isMerging ? 4 : 2,
                  offset: const Offset(0, 2),
                ),
                // Enhanced highlight shadow for 3D effect
                Shadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
                // Additional subtle shadow for more depth
                if (widget.value >= 24)
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
              letterSpacing: -0.5,
            ),
          ),

          // Add a subtle highlight overlay for a polished look
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: widget.size * 0.3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
                  topRight: Radius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Apply combined animations - wrapped in RepaintBoundary for better performance
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(scale: _scaleAnimation.value, child: child),
          );
        },
        child: tile, // Pass tile as a child for better performance
      ),
    );
  }
}
