import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';

import '../widgets/event_card.dart';
import '../widgets/now_card.dart';
import '../theme/app_theme.dart';

import 'add_event_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedFilter = 0; // 0: All, 1: Today, 2: Tomorrow, 3: High Priority

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              // Header with Analytics
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Agenda',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Consumer<EventProvider>(
                          builder: (context, eventProvider, child) {
                            final analytics = eventProvider.getTodayAnalytics();
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${analytics.efficiency.toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Consumer<EventProvider>(
                      builder: (context, eventProvider, child) {
                        final todayEvents = eventProvider.todayEvents;
                        final inProgress = eventProvider.getEventsInProgress();
                        
                        return Text(
                          inProgress.isNotEmpty 
                              ? 'Currently: ${inProgress.first.title}'
                              : '${todayEvents.length} events today',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              

              
              // Filter Tabs
              _buildFilterTabs(),
              const SizedBox(height: 20),
              
              // Now Card
              const NowCard(),
              const SizedBox(height: 24),
              
              // Events List
              Expanded(
                child: Consumer<EventProvider>(
                  builder: (context, eventProvider, child) {
                    if (eventProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryEnd,
                        ),
                      );
                    }

                    if (eventProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading events',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => eventProvider.loadEvents(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SingleChildScrollView(
                        key: ValueKey(_selectedFilter),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quick Insights
                            _buildQuickInsights(eventProvider),
                            const SizedBox(height: 20),
                            
                            // Filtered Events
                            ..._buildFilteredEventSections(eventProvider),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEventScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryEnd,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Today', 'Tomorrow', 'Priority'];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : AppTheme.dark700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickInsights(EventProvider eventProvider) {
    final analytics = eventProvider.getTodayAnalytics();
    
    if (analytics.insights.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dark800.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryEnd.withValues(alpha: 0.3)),
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
                'Today\'s Insights',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryEnd,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            analytics.insights.first,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredEventSections(EventProvider eventProvider) {
    List<Event> events;
    List<Widget> sections = [];

    switch (_selectedFilter) {
      case 0: // All
        if (eventProvider.todayEvents.isNotEmpty) {
          sections.add(_buildEventSection('Today', eventProvider.todayEvents));
        }
        if (eventProvider.tomorrowEvents.isNotEmpty) {
          sections.add(_buildEventSection('Tomorrow', eventProvider.tomorrowEvents));
        }
        break;
      case 1: // Today
        events = eventProvider.todayEvents;
        if (events.isNotEmpty) {
          sections.add(_buildEventSection('Today', events));
        }
        break;
      case 2: // Tomorrow
        events = eventProvider.tomorrowEvents;
        if (events.isNotEmpty) {
          sections.add(_buildEventSection('Tomorrow', events));
        }
        break;
      case 3: // Priority
        events = eventProvider.getEventsByPriority(4);
        if (events.isNotEmpty) {
          sections.add(_buildEventSection('High Priority', events));
        }
        break;
    }

    if (sections.isEmpty) {
      sections.add(_buildEmptyState());
    }

    return sections;
  }

  Widget _buildEventSection(String title, List<Event> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (events.any((e) => e.hasConflict))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red.shade300,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Conflicts',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildEventTimeline(events),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildEventTimeline(List<Event> events) {
    return Column(
      children: events.asMap().entries.map((entry) {
        final index = entry.key;
        final event = entry.value;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 50)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EventCard(event: event),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    IconData icon;

    switch (_selectedFilter) {
      case 1:
        message = 'No events today';
        subtitle = 'Perfect time for deep work!';
        icon = Icons.wb_sunny;
        break;
      case 2:
        message = 'Tomorrow is clear';
        subtitle = 'Plan something amazing';
        icon = Icons.calendar_today;
        break;
      case 3:
        message = 'No high priority events';
        subtitle = 'All caught up!';
        icon = Icons.check_circle;
        break;
      default:
        message = 'No events scheduled';
        subtitle = 'Tap the + button to add an event';
        icon = Icons.calendar_today;
    }

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
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}