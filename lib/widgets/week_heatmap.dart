import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeekHeatmap extends StatefulWidget {
  final List<double> heatmapData;
  final Function(int)? onDayTap;

  const WeekHeatmap({
    super.key,
    required this.heatmapData,
    this.onDayTap,
  });

  @override
  State<WeekHeatmap> createState() => _WeekHeatmapState();
}

class _WeekHeatmapState extends State<WeekHeatmap> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(7, (index) => 
      AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      )
    );
    
    _animations = _controllers.map((controller) => 
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      )
    ).toList();
    
    // Start animations with stagger
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final today = now.weekday - 1; // Monday = 0
    
    return Column(
      children: [
        // Day labels
        Row(
          children: days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final isToday = index == today;
            
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isToday ? AppTheme.primaryEnd : AppTheme.textSecondary,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Heatmap cells
        Row(
          children: List.generate(7, (index) {
            final intensity = index < widget.heatmapData.length ? widget.heatmapData[index] : 0.0;
            final isToday = index == today;
            final isHovered = _hoveredIndex == index;
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animations[index].value,
                      child: MouseRegion(
                        onEnter: (_) => setState(() => _hoveredIndex = index),
                        onExit: (_) => setState(() => _hoveredIndex = null),
                        child: GestureDetector(
                          onTap: () => widget.onDayTap?.call(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: isHovered ? 56 : 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppTheme.primaryEnd.withValues(alpha: 0.3 + (intensity * 0.7)),
                                  AppTheme.primaryStart.withValues(alpha: 0.3 + (intensity * 0.7)),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: isToday ? Border.all(
                                color: AppTheme.primaryEnd,
                                width: 2,
                              ) : null,
                              boxShadow: isHovered ? [
                                BoxShadow(
                                  color: AppTheme.primaryEnd.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ] : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(intensity * 12).toInt()}h',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: isHovered ? 14 : 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isHovered) ...[
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
        
        const SizedBox(height: 12),
        
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Light', 0.2),
            const SizedBox(width: 16),
            _buildLegendItem('Moderate', 0.5),
            const SizedBox(width: 16),
            _buildLegendItem('Heavy', 0.8),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, double intensity) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryEnd.withValues(alpha: 0.3 + (intensity * 0.7)),
                AppTheme.primaryStart.withValues(alpha: 0.3 + (intensity * 0.7)),
              ],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}