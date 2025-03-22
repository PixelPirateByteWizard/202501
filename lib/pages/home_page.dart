import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/goal.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'add_goal_page.dart';
import '../widgets/animated_goal_card.dart';
import '../widgets/glassmorphic_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Goal> goals = [];
  List<Goal> filteredGoals = [];
  bool isLoading = true;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  // Filter state
  String _selectedFilter = 'All';

  // All possible types and categories
  final List<String> _goalTypes = [
    'All',
    'Personal',
    'Work',
    'Health',
    'Learning',
    'Financial',
    'Other'
  ];

  final List<String> _categories = [
    'Fitness',
    'Career',
    'Education',
    'Savings',
    'Hobby',
    'Travel',
    'Family',
    'Mindfulness',
    'Project',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadGoals();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final goalsJson = prefs.getStringList('goals') ?? [];

      setState(() {
        goals =
            goalsJson.map((json) => Goal.fromJson(jsonDecode(json))).toList();
        goals.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        _applyFilter(); // Apply filter
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> _saveGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final goalsJson = goals.map((goal) => jsonEncode(goal.toJson())).toList();
      await prefs.setStringList('goals', goalsJson);
    } catch (e) {
      // Handle error
    }
  }

  void _deleteGoal(String id) async {
    HapticFeedback.mediumImpact();

    setState(() {
      goals.removeWhere((goal) => goal.id == id);
    });

    await _saveGoals();
  }

  void _updateGoalProgress(String id, double progress,
      {double? value, String? note, bool isTotal = false}) async {
    setState(() {
      final index = goals.indexWhere((goal) => goal.id == id);
      if (index != -1) {
        final goal = goals[index];
        double newCurrentValue;

        if (goal.isNumericGoal) {
          if (isTotal) {
            // If setting total value
            newCurrentValue = value ?? (goal.targetValue * progress);
            progress = newCurrentValue / goal.targetValue;
          } else {
            // If adding value
            newCurrentValue = goal.currentValue + (value ?? 0);
            progress = newCurrentValue / goal.targetValue;
          }
        } else {
          // For non-numeric goals, we directly use the progress value
          // and set a placeholder for currentValue
          newCurrentValue = 0.0;
          // Make sure progress is properly set for non-numeric goals
          progress = progress.clamp(0.0, 1.0);
        }

        // Create a new record for the update
        final newRecord = goal.isNumericGoal
            ? GoalRecord(
                id: const Uuid().v4(),
                date: DateTime.now(),
                value: value ?? 0.0,
                note: note ?? '',
                isTotal: isTotal,
              )
            : null;

        // Update the goal with the new progress
        goals[index] = goal.copyWith(
          progress: progress,
          currentValue: newCurrentValue,
          updatedAt: DateTime.now(),
          records: goal.isNumericGoal && newRecord != null
              ? [...goal.records, newRecord]
              : goal.records,
        );
      }
    });

    // Save the updated goals to persistent storage
    await _saveGoals();

    // Add haptic feedback
    HapticFeedback.mediumImpact();
  }

  // Apply filter method
  void _applyFilter() {
    if (_selectedFilter == 'All') {
      filteredGoals = List.from(goals);
    } else {
      // Check if it's a type filter
      if (_goalTypes.contains(_selectedFilter)) {
        filteredGoals =
            goals.where((goal) => goal.type == _selectedFilter).toList();
      }
      // Check if it's a category filter
      else if (_categories.contains(_selectedFilter)) {
        filteredGoals =
            goals.where((goal) => goal.category == _selectedFilter).toList();
      } else {
        filteredGoals = List.from(goals);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color primaryColor = const Color(0xFF8FB3B0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.08),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: RefreshIndicator(
              color: primaryColor,
              backgroundColor: Colors.white,
              onRefresh: _loadGoals,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 140,
                    floating: true,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.9),
                              primaryColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Decorative elements
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Aetherys',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Track your goals, achieve more',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      titlePadding: EdgeInsets.zero,
                    ),
                    actions: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.refresh,
                              color: Colors.white, size: 20),
                        ),
                        onPressed: _loadGoals,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Goals',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${filteredGoals.length} ${filteredGoals.length == 1 ? 'goal' : 'goals'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Category filter
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildFilterChip(
                                    'All', _selectedFilter == 'All'),
                                // Type filters
                                ..._goalTypes
                                    .where((type) => type != 'All')
                                    .map((type) => _buildFilterChip(
                                        type, _selectedFilter == type)),
                                // Separator
                                Container(
                                  height: 24,
                                  width: 1,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                // Category filters
                                ..._categories.map((category) =>
                                    _buildFilterChip(
                                        category, _selectedFilter == category)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  isLoading
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading your goals...',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filteredGoals.isEmpty
                          ? SliverFillRemaining(
                              child: _buildEmptyFilterState(),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.85,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final goal = filteredGoals[index];
                                    return AnimatedGoalCard(
                                      goal: goal,
                                      onDelete: () => _deleteGoal(goal.id),
                                      onProgressUpdate: (progress,
                                          {double? value,
                                          String? note,
                                          bool isTotal = false}) {
                                        _updateGoalProgress(goal.id, progress,
                                            value: value,
                                            note: note,
                                            isTotal: isTotal);

                                        // Refresh the UI after updating the goal
                                        setState(() {
                                          _applyFilter();
                                        });
                                      },
                                      index: index,
                                    );
                                  },
                                  childCount: filteredGoals.length,
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),

          // Add goal floating button
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8FB3B0),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              _selectedFilter = label;
              _applyFilter();
            });
          }
        },
        backgroundColor: Colors.transparent,
        selectedColor: const Color(0xFF8FB3B0),
        checkmarkColor: Colors.white,
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : const Color(0xFF8FB3B0).withOpacity(0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF8FB3B0).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.filter_list,
            size: 60,
            color: const Color(0xFF8FB3B0).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No goals found',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'No goals match the current filter. Try selecting a different filter or create a new goal.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.5),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _selectedFilter = 'All';
              _applyFilter();
            });
          },
          icon: const Icon(Icons.filter_alt_off),
          label: const Text('Clear Filter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8FB3B0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
