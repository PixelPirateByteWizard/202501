import 'package:flutter/material.dart';
import '../models/ai_suggestion.dart';
import '../theme/app_theme.dart';

class SuggestionCard extends StatefulWidget {
  final AISuggestion suggestion;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.onAccept,
    required this.onDismiss,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
    
    if (widget.suggestion.isHighPriority) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  IconData _getTypeIcon() {
    switch (widget.suggestion.type) {
      case SuggestionType.reschedule:
        return Icons.schedule;
      case SuggestionType.addFocus:
        return Icons.psychology;
      case SuggestionType.consolidate:
        return Icons.merge;
      case SuggestionType.optimize:
        return Icons.auto_fix_high;
      case SuggestionType.addBreak:
        return Icons.coffee;
      case SuggestionType.energyOptimize:
        return Icons.battery_charging_full;
      case SuggestionType.priorityReorder:
        return Icons.reorder;
      case SuggestionType.timeBlock:
        return Icons.view_agenda;
      case SuggestionType.conflictResolve:
        return Icons.warning;
      case SuggestionType.productivityBoost:
        return Icons.trending_up;
    }
  }

  Color _getTypeColor() {
    switch (widget.suggestion.type) {
      case SuggestionType.reschedule:
        return Colors.blue;
      case SuggestionType.addFocus:
        return Colors.purple;
      case SuggestionType.consolidate:
        return Colors.orange;
      case SuggestionType.optimize:
        return Colors.green;
      case SuggestionType.addBreak:
        return Colors.brown;
      case SuggestionType.energyOptimize:
        return Colors.yellow;
      case SuggestionType.priorityReorder:
        return Colors.red;
      case SuggestionType.timeBlock:
        return Colors.indigo;
      case SuggestionType.conflictResolve:
        return Colors.red;
      case SuggestionType.productivityBoost:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.suggestion.isHighPriority ? _pulseAnimation.value : 1.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.suggestion.isHighPriority 
                        ? _getTypeColor().withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                    width: widget.suggestion.isHighPriority ? 2 : 1,
                  ),
                  boxShadow: widget.suggestion.isHighPriority ? [
                    BoxShadow(
                      color: _getTypeColor().withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getTypeColor().withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getTypeIcon(),
                            color: _getTypeColor(),
                            size: 20,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.suggestion.title,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (widget.suggestion.isHighPriority)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'HIGH',
                                        style: TextStyle(
                                          color: Colors.red.shade300,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.suggestion.description,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              
                              if (widget.suggestion.improvementPercentage != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '+${widget.suggestion.improvementPercentage!.toInt()}% efficiency',
                                    style: TextStyle(
                                      color: Colors.green.shade300,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                    
                    // Expanded content
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          const SizedBox(height: 16),
                          
                          // Additional details
                          if (widget.suggestion.reasoning != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.dark700.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppTheme.textSecondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.suggestion.reasoning!,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: widget.onAccept,
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getTypeColor(),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: widget.onDismiss,
                                  icon: const Icon(Icons.close, size: 16),
                                  label: const Text('Dismiss'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppTheme.dark700,
                                    foregroundColor: AppTheme.textSecondary,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      crossFadeState: _isExpanded 
                          ? CrossFadeState.showSecond 
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}