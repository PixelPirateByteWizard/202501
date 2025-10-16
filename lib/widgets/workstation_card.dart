import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/workstation.dart';
import 'animated_gear.dart';

class WorkstationCard extends StatefulWidget {
  final Workstation workstation;
  final VoidCallback? onTap;

  const WorkstationCard({super.key, required this.workstation, this.onTap});

  @override
  State<WorkstationCard> createState() => _WorkstationCardState();
}

class _WorkstationCardState extends State<WorkstationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.workstation.status == WorkstationStatus.error) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.workstation.status) {
      case WorkstationStatus.optimal:
        return AppColors.statusOptimal;
      case WorkstationStatus.warning:
        return AppColors.statusWarning;
      case WorkstationStatus.error:
        return AppColors.statusError;
      case WorkstationStatus.offline:
        return AppColors.lavenderWhite.withValues(alpha: 0.3);
    }
  }

  Widget _getStatusIcon() {
    switch (widget.workstation.status) {
      case WorkstationStatus.optimal:
        return const AnimatedGear(
          size: 32,
          color: AppColors.statusOptimal,
          duration: Duration(seconds: 5),
        );
      case WorkstationStatus.warning:
        return const AnimatedGear(
          size: 32,
          color: AppColors.statusWarning,
          duration: Duration(seconds: 8),
        );
      case WorkstationStatus.error:
        return const Icon(
          Icons.warning,
          color: AppColors.statusError,
          size: 32,
        );
      case WorkstationStatus.offline:
        return const Icon(Icons.add, color: AppColors.lavenderWhite, size: 32);
    }
  }

  String _getStatusText() {
    if (!widget.workstation.isBuilt) {
      return 'Build New Station';
    }

    switch (widget.workstation.status) {
      case WorkstationStatus.optimal:
        return 'Operating';
      case WorkstationStatus.warning:
        return 'Low Efficiency';
      case WorkstationStatus.error:
        return 'Material Shortage';
      case WorkstationStatus.offline:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.workstation.status == WorkstationStatus.error
              ? _pulseAnimation.value
              : 1.0,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: widget.workstation.isBuilt
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.slateBlue, Color(0xFF1E3A5F)],
                      )
                    : null,
                color: widget.workstation.isBuilt
                    ? null
                    : AppColors.slateBlue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.workstation.status == WorkstationStatus.error
                      ? AppColors.statusError
                      : widget.workstation.isBuilt
                      ? AppColors.glassBorder
                      : AppColors.lavenderWhite.withValues(alpha: 0.3),
                  style: widget.workstation.isBuilt
                      ? BorderStyle.solid
                      : BorderStyle.solid,
                ),
              ),
              child: widget.workstation.isBuilt
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.workstation.name,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: AppColors.vintageGold,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Icon/Animation
                        Center(child: _getStatusIcon()),
                        const SizedBox(height: 12),

                        // Input/Output
                        Text(
                          'Input: ${widget.workstation.inputResource}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Output: ${widget.workstation.outputResource}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color:
                                    widget.workstation.status ==
                                        WorkstationStatus.error
                                    ? AppColors.statusError
                                    : AppColors.vintageGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Status text
                        Text(
                          _getStatusText(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color:
                                    widget.workstation.status ==
                                        WorkstationStatus.error
                                    ? AppColors.statusError
                                    : AppColors.lavenderWhite.withValues(
                                        alpha: 0.7,
                                      ),
                                fontSize: 10,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        // Upgrade slots (placeholder)
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: index < widget.workstation.level
                                    ? AppColors.vintageGold
                                    : AppColors.deepNavy,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                  width: 0.5,
                                ),
                              ),
                              child: index < widget.workstation.level
                                  ? const Icon(
                                      Icons.check,
                                      size: 10,
                                      color: AppColors.deepNavy,
                                    )
                                  : null,
                            );
                          }),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: AppColors.lavenderWhite,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Build New\nStation',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.lavenderWhite.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                          textAlign: TextAlign.center,
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
