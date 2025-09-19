import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/ai_provider.dart';
import '../models/event.dart';
import '../models/chat_message.dart';
import '../widgets/week_heatmap.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/chat_bubble.dart';
import '../services/time_analytics_service.dart';
import '../services/navigation_service.dart';
import '../theme/app_theme.dart';

class ForgeScreen extends StatefulWidget {
  const ForgeScreen({super.key});

  @override
  State<ForgeScreen> createState() => _ForgeScreenState();
}

class _ForgeScreenState extends State<ForgeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  int _selectedTab = 0; // 0: Overview, 1: Analytics, 2: Optimization, 3: AI Assistant
  final TextEditingController _aiMessageController = TextEditingController();
  final ScrollController _aiScrollController = ScrollController();
  
  // Loading states for buttons
  bool _isAddingFocusTime = false;
  bool _isOptimizing = false;
  bool _isFindingFreeTime = false;
  bool _isResolvingConflicts = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _aiMessageController.dispose();
    _aiScrollController.dispose();
    super.dispose();
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap, {bool isLoading = false}) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 80,
        maxHeight: 120,
        minWidth: 140,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () async {
            // Add haptic feedback for better user experience
            try {
              // Show immediate visual feedback
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              
              // Execute the action
              onTap();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              gradient: isLoading 
                ? LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade700])
                : AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isLoading ? Colors.grey : AppTheme.primaryEnd).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoading 
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isLoading ? 'Processing...' : title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addFocusTime(BuildContext context) async {
    if (_isAddingFocusTime) return;
    
    setState(() {
      _isAddingFocusTime = true;
    });
    
    try {
      final eventProvider = context.read<EventProvider>();
      final now = DateTime.now();
      
      // Find the next available slot
      final availableSlots = eventProvider.getAvailableSlots(const Duration(hours: 2));
      DateTime focusTime;
      
      if (availableSlots.isNotEmpty) {
        focusTime = availableSlots.first;
      } else {
        // Default to next hour if no slots available
        focusTime = DateTime(now.year, now.month, now.day, now.hour + 1);
      }
      
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Focus Time',
        description: 'Deep work session - Added by Forge',
        startTime: focusTime,
        endTime: focusTime.add(const Duration(hours: 2)),
        category: EventCategory.focus,
        priority: 4,
      );
      
      await eventProvider.addEvent(event);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Focus time added for ${_formatTime(focusTime)}'),
            backgroundColor: AppTheme.primaryEnd,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // Just dismiss the snackbar, user is already in the app
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add focus time: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingFocusTime = false;
        });
      }
    }
  }

  void _optimizeSchedule(BuildContext context) async {
    if (_isOptimizing) return;
    
    setState(() {
      _isOptimizing = true;
    });
    
    try {
      final eventProvider = context.read<EventProvider>();
      final aiProvider = context.read<AIProvider>();
      
      // Show loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Analyzing your schedule for optimization...'),
            ],
          ),
          backgroundColor: AppTheme.primaryEnd,
          duration: Duration(seconds: 3),
        ),
      );
      
      // Load AI suggestions
      await aiProvider.loadSuggestions(eventProvider.events);
      
      // Optimize schedule
      await eventProvider.optimizeSchedule();
      
      if (context.mounted) {
        // Switch to optimize tab
        setState(() {
          _selectedTab = 2;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Schedule optimization complete!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Results',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  _selectedTab = 2;
                });
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Optimization failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOptimizing = false;
        });
      }
    }
  }

  void _acceptSuggestion(BuildContext context, String suggestionId, AIProvider aiProvider, EventProvider eventProvider) {
    aiProvider.acceptSuggestion(suggestionId);
    
    // Simulate applying the suggestion by adding a sample event
    final now = DateTime.now();
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Optimized Event',
      description: 'Event created from Kaelix suggestion',
      startTime: now.add(const Duration(hours: 2)),
      endTime: now.add(const Duration(hours: 3)),
      category: EventCategory.work,
    );
    
    eventProvider.addEvent(event);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Suggestion applied successfully!'),
        backgroundColor: AppTheme.primaryEnd,
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Overview', 'Analytics', 'Optimize', 'AI Assistant'];
    
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _selectedTab == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTheme.primaryGradient : null,
                  color: isSelected ? null : AppTheme.dark700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildAnalyticsTab();
      case 2:
        return _buildOptimizeTab();
      case 3:
        return _buildAIAssistantTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      key: ValueKey('overview'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week Heatmap
          Text(
            'This Week',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<EventProvider>(
            builder: (context, eventProvider, child) {
              return WeekHeatmap(
                heatmapData: eventProvider.getWeekHeatmap(),
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Use GridView for better iPad layout
          LayoutBuilder(
            builder: (context, constraints) {
              // Adjust grid based on screen width (better for iPad)
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              final childAspectRatio = constraints.maxWidth > 600 ? 2.5 : 2.2;
              
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
            children: [
              _buildQuickActionCard(
                context,
                'Add Focus Time',
                Icons.psychology,
                () => _addFocusTime(context),
                isLoading: _isAddingFocusTime,
              ),
              _buildQuickActionCard(
                context,
                'Optimize Schedule',
                Icons.auto_fix_high,
                () => _optimizeSchedule(context),
                isLoading: _isOptimizing,
              ),
              _buildQuickActionCard(
                context,
                'Find Free Time',
                Icons.schedule,
                () => _findFreeTime(context),
                isLoading: _isFindingFreeTime,
              ),
              _buildQuickActionCard(
                context,
                'Resolve Conflicts',
                Icons.warning,
                () => _resolveConflicts(context),
                isLoading: _isResolvingConflicts,
              ),
            ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      key: ValueKey('analytics'),
      child: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          final weekAnalytics = eventProvider.getWeekAnalytics();
          // final todayAnalytics = eventProvider.getTodayAnalytics();
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Efficiency Score
              _buildAnalyticsCard(
                'Efficiency Score',
                '${weekAnalytics.efficiency.toInt()}%',
                Icons.trending_up,
                weekAnalytics.efficiency >= 70 ? Colors.green : 
                weekAnalytics.efficiency >= 50 ? Colors.orange : Colors.red,
              ),
              const SizedBox(height: 16),
              
              // Time Breakdown
              _buildTimeBreakdownCard(weekAnalytics),
              const SizedBox(height: 16),
              
              // Productivity Trends
              _buildProductivityTrendsCard(eventProvider),
              const SizedBox(height: 16),
              
              // Insights
              _buildInsightsCard(weekAnalytics.insights),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOptimizeTab() {
    return SingleChildScrollView(
      key: ValueKey('optimize'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Suggestions
          Text(
            'AI Suggestions',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Consumer2<AIProvider, EventProvider>(
            builder: (context, aiProvider, eventProvider, child) {
              // Auto-load suggestions
              if (aiProvider.suggestions.isEmpty && !aiProvider.isLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  aiProvider.loadSuggestions(eventProvider.events);
                });
              }
              
              if (aiProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryEnd),
                );
              }

              final suggestions = aiProvider.suggestions;
              
              if (suggestions.isEmpty) {
                return _buildOptimizedState();
              }

              return Column(
                children: suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SuggestionCard(
                      suggestion: suggestion,
                      onAccept: () => _acceptSuggestion(context, suggestion.id, aiProvider, eventProvider),
                      onDismiss: () => aiProvider.dismissSuggestion(suggestion.id),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBreakdownCard(TimeAnalytics analytics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Breakdown',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeBreakdownItem('Focus Time', analytics.focusHours, EventCategory.focus.color),
          _buildTimeBreakdownItem('Meetings', analytics.meetingHours, EventCategory.meeting.color),
          _buildTimeBreakdownItem('Work', analytics.workHours, EventCategory.work.color),
          _buildTimeBreakdownItem('Personal', analytics.personalHours, EventCategory.personal.color),
        ],
      ),
    );
  }

  Widget _buildTimeBreakdownItem(String label, double hours, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            '${hours.toStringAsFixed(1)}h',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductivityTrendsCard(EventProvider eventProvider) {
    final trends = eventProvider.getProductivityTrends(7);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Productivity Trends (7 days)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trends.entries.map((entry) {
                final efficiency = entry.value;
                final height = (efficiency / 100.0) * 80.0;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 20,
                      height: height.clamp(10.0, 80.0),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(List<String> insights) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.dark800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppTheme.primaryEnd,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Insights',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEnd,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insight,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildOptimizedState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Schedule Optimized!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your schedule is running efficiently',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _findFreeTime(BuildContext context) async {
    if (_isFindingFreeTime) return;
    
    setState(() {
      _isFindingFreeTime = true;
    });
    
    try {
      final eventProvider = context.read<EventProvider>();
      
      // Simulate some processing time
      await Future.delayed(const Duration(milliseconds: 800));
      
      final freeSlots = eventProvider.findOptimalFocusSlots(const Duration(hours: 1));
      final todaySlots = eventProvider.getAvailableSlots(const Duration(hours: 1));
      
      if (context.mounted) {
        if (freeSlots.isNotEmpty || todaySlots.isNotEmpty) {
          final totalSlots = freeSlots.length + todaySlots.length;
          final nextSlot = freeSlots.isNotEmpty ? freeSlots.first : todaySlots.first;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Found $totalSlots available slots. Next: ${_formatTime(nextSlot)}'),
              backgroundColor: AppTheme.primaryEnd,
              action: SnackBarAction(
                label: 'Schedule',
                textColor: Colors.white,
                onPressed: () => _scheduleInSlot(context, nextSlot),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No available time slots found today'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'Add Anyway',
                textColor: Colors.white,
                onPressed: () => _addFocusTime(context),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error finding free time: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFindingFreeTime = false;
        });
      }
    }
  }

  void _resolveConflicts(BuildContext context) async {
    if (_isResolvingConflicts) return;
    
    setState(() {
      _isResolvingConflicts = true;
    });
    
    try {
      final eventProvider = context.read<EventProvider>();
      final conflicts = eventProvider.getConflictingEvents();
      
      if (conflicts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No schedule conflicts found!'),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }
      
      // Simulate processing time
      await Future.delayed(const Duration(milliseconds: 1000));
      
      await eventProvider.optimizeSchedule();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resolved ${conflicts.length} schedule conflicts!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View Calendar',
              textColor: Colors.white,
              onPressed: () {
                // Switch to agenda tab using navigation service
                NavigationService().switchToAgenda();
                
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Switched to Calendar view'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resolve conflicts: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingConflicts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Tabs
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(_slideAnimation),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forge',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optimize your schedule with AI insights',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTabBar(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Tab Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildTabContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIAssistantTab() {
    return SingleChildScrollView(
      key: ValueKey('ai_assistant'),
      child: Column(
        children: [
        // AI Assistant Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Forge AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Get personalized schedule optimization advice',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Quick Actions for Forge
        Text(
          'Quick Optimization Actions',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildForgeQuickAction('Analyze my productivity patterns'),
            _buildForgeQuickAction('Find optimal focus time slots'),
            _buildForgeQuickAction('Suggest meeting time improvements'),
            _buildForgeQuickAction('Balance work and personal time'),
          ],
        ),
        const SizedBox(height: 20),
        
        // Chat Messages
        SizedBox(
          height: 300,
          child: Consumer<AIProvider>(
            builder: (context, aiProvider, child) {
              final messages = aiProvider.chatMessages
                  .where((msg) => msg.content.toLowerCase().contains('forge') ||
                                 msg.content.toLowerCase().contains('optimize') ||
                                 msg.content.toLowerCase().contains('productivity') ||
                                 msg.content.toLowerCase().contains('schedule'))
                  .toList();
              
              if (messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 48,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ask me about optimizing your schedule',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _aiScrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: messages.length + (aiProvider.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && aiProvider.isLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ChatBubble(
                        message: ChatMessage(
                          id: 'loading',
                          content: '...',
                          type: MessageType.ai,
                          timestamp: DateTime.now(),
                        ),
                        isLoading: true,
                      ),
                    );
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ChatBubble(message: messages[index]),
                  );
                },
              );
            },
          ),
        ),
        
        // Input Area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.dark800,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _aiMessageController,
                  decoration: const InputDecoration(
                    hintText: 'Ask about schedule optimization...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                  maxLines: null,
                  onSubmitted: (_) => _sendForgeMessage(),
                ),
              ),
              const SizedBox(width: 12),
              Consumer<AIProvider>(
                builder: (context, aiProvider, child) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: aiProvider.isLoading 
                        ? LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade700])
                        : AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: aiProvider.isLoading ? null : _sendForgeMessage,
                      icon: Icon(
                        aiProvider.isLoading ? Icons.hourglass_empty : Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildForgeQuickAction(String message) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _sendForgeQuickMessage(message),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _sendForgeMessage() {
    final message = _aiMessageController.text.trim();
    if (message.isNotEmpty) {
      _sendForgeQuickMessage(message);
      _aiMessageController.clear();
    }
  }

  void _sendForgeQuickMessage(String message) {
    // Add context about Forge optimization
    final forgeMessage = "In the context of schedule optimization and productivity analysis: $message";
    
    context.read<AIProvider>().sendMessage(forgeMessage, onEventCreated: (event) {
      context.read<EventProvider>().addEvent(event);
    });
    
    _scrollAIToBottom();
  }

  void _scrollAIToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_aiScrollController.hasClients) {
        _aiScrollController.animateTo(
          _aiScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    String dateStr;
    if (eventDate == today) {
      dateStr = 'Today';
    } else if (eventDate == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}';
    }
    
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$dateStr at $displayHour:${minute.toString().padLeft(2, '0')} $amPm';
  }

  void _scheduleInSlot(BuildContext context, DateTime slotTime) async {
    try {
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Available Time Block',
        description: 'Free time slot found by Forge',
        startTime: slotTime,
        endTime: slotTime.add(const Duration(hours: 1)),
        category: EventCategory.focus,
        priority: 3,
      );
      
      await context.read<EventProvider>().addEvent(event);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event scheduled for ${_formatTime(slotTime)}'),
            backgroundColor: AppTheme.primaryEnd,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}