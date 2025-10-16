import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/clue.dart';

class ClueItem extends StatefulWidget {
  final Clue clue;
  final String timeAgo;
  final bool isSelected;
  final VoidCallback? onTap;

  const ClueItem({
    super.key,
    required this.clue,
    required this.timeAgo,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ClueItem> createState() => _ClueItemState();
}

class _ClueItemState extends State<ClueItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _backgroundAnimation =
        ColorTween(
          begin: Colors.transparent,
          end: AppColors.vintageGold.withValues(alpha: 0.1),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ClueItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _onTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundAnimation.value,
                borderRadius: BorderRadius.circular(8),
                border: widget.isSelected
                    ? Border.all(color: AppColors.vintageGold, width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  // Clue Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.vintageGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.vintageGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.clue.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Clue Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.clue.title,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.vintageGold,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            if (widget.clue.isNew)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentRose,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'NEW',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.lavenderWhite,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Acquired: ${widget.timeAgo}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.lavenderWhite.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 12,
                              ),
                        ),
                        if (widget.clue.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.clue.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 11,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Selection indicator
                  if (widget.isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.vintageGold,
                      size: 20,
                    )
                  else
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.glassBorder,
                          width: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
