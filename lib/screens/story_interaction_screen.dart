import 'package:flutter/material.dart';
import '../models/world_map.dart';
import '../services/world_map_service.dart';
import '../services/game_stats_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class StoryInteractionScreen extends StatefulWidget {
  final String mapId;
  final MapLocation location;
  final VoidCallback onStoryUpdate;

  const StoryInteractionScreen({
    super.key,
    required this.mapId,
    required this.location,
    required this.onStoryUpdate,
  });

  @override
  State<StoryInteractionScreen> createState() => _StoryInteractionScreenState();
}

class _StoryInteractionScreenState extends State<StoryInteractionScreen>
    with TickerProviderStateMixin {
  final WorldMapService _mapService = WorldMapService();
  final GameStatsService _statsService = GameStatsService();
  late MapLocation _currentLocation;
  bool _isGeneratingStory = false;
  List<StoryEvent> _storyHistory = [];
  late AnimationController _typewriterController;
  late AnimationController _choiceController;
  String _displayedText = '';
  int _currentCharIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.location;
    
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    
    _choiceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _loadStoryHistory();
    _startTypewriterEffect();
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _choiceController.dispose();
    super.dispose();
  }

  Future<void> _loadStoryHistory() async {
    final history = await _mapService.getStoryEvents(_currentLocation.id);
    setState(() {
      _storyHistory = history;
    });
  }

  void _startTypewriterEffect() {
    final story = _currentLocation.currentStory ?? _currentLocation.description;
    _displayedText = '';
    _currentCharIndex = 0;
    
    _typewriterController.addListener(() {
      if (_currentCharIndex < story.length) {
        setState(() {
          _displayedText = story.substring(0, _currentCharIndex + 1);
          _currentCharIndex++;
        });
      } else {
        _typewriterController.stop();
        _choiceController.forward();
      }
    });
    
    _typewriterController.repeat();
  }

  Future<void> _makeChoice(String choice) async {
    setState(() {
      _isGeneratingStory = true;
    });

    try {
      final updatedMap = await _mapService.updateLocationStory(
        widget.mapId,
        _currentLocation.id,
        choice,
      );

      final updatedLocation = updatedMap.locations
          .firstWhere((loc) => loc.id == _currentLocation.id);

      // 更新统计
      await _statsService.incrementStoriesGenerated();
      await _statsService.incrementChoicesMade();
      await _statsService.addLocationVisited(_currentLocation.id);
      await _statsService.updateLastPlayed();

      setState(() {
        _currentLocation = updatedLocation;
        _isGeneratingStory = false;
      });

      _choiceController.reset();
      _startTypewriterEffect();
      await _loadStoryHistory();
      widget.onStoryUpdate();
    } catch (e) {
      setState(() {
        _isGeneratingStory = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('生成故事时出错: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.lavenderWhite,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _currentLocation.name,
                            style: Theme.of(context).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            _getStatusText(_currentLocation.status),
                            style: TextStyle(
                              color: _getStatusColor(_currentLocation.status),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _showStoryHistory,
                      icon: const Icon(
                        Icons.history,
                        color: AppColors.vintageGold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Location illustration
                      GlassCard(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.slateBlue.withValues(alpha: 0.8),
                                AppColors.deepNavy.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  _currentLocation.icon,
                                  size: 80,
                                  color: AppColors.vintageGold.withValues(alpha: 0.7),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Text(
                                  _currentLocation.description,
                                  style: const TextStyle(
                                    color: AppColors.lavenderWhite,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Story content
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_stories,
                                  color: AppColors.vintageGold,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Current Situation',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.deepNavy.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.vintageGold.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                _displayedText,
                                style: const TextStyle(
                                  color: AppColors.lavenderWhite,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Choices
                      if (!_isGeneratingStory && _currentLocation.availableChoices != null)
                        AnimatedBuilder(
                          animation: _choiceController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _choiceController.value,
                              child: Opacity(
                                opacity: _choiceController.value,
                                child: GlassCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.psychology,
                                            color: AppColors.accentRose,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Your Choices',
                                            style: Theme.of(context).textTheme.headlineSmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      ..._currentLocation.availableChoices!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key;
                                        final choice = entry.value;
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: _buildChoiceButton(choice, index),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // Loading indicator
                      if (_isGeneratingStory)
                        GlassCard(
                          child: Column(
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.vintageGold,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Generating story content...',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Steam gears are turning, weaving new adventures for you...',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String choice, int index) {
    final colors = [
      AppColors.vintageGold,
      AppColors.accentRose,
      AppColors.statusOptimal,
    ];
    
    final color = colors[index % colors.length];
    
    return GestureDetector(
      onTap: () => _makeChoice(choice),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: AppColors.deepNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                choice,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.slateBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.deepNavy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: AppColors.vintageGold,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Story Journey',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.lavenderWhite,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _storyHistory.length,
                itemBuilder: (context, index) {
                  final event = _storyHistory[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.deepNavy.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.vintageGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.content,
                            style: const TextStyle(
                              color: AppColors.lavenderWhite,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
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
    );
  }

  String _getStatusText(LocationStatus status) {
    switch (status) {
      case LocationStatus.locked:
        return 'Locked';
      case LocationStatus.available:
        return 'Available';
      case LocationStatus.exploring:
        return 'Exploring';
      case LocationStatus.completed:
        return 'Completed';
      case LocationStatus.active:
        return 'Active';
    }
  }

  Color _getStatusColor(LocationStatus status) {
    switch (status) {
      case LocationStatus.locked:
        return AppColors.statusError;
      case LocationStatus.available:
        return AppColors.vintageGold;
      case LocationStatus.exploring:
        return AppColors.statusWarning;
      case LocationStatus.completed:
        return AppColors.statusOptimal;
      case LocationStatus.active:
        return AppColors.accentRose;
    }
  }
}