import 'package:flutter/material.dart';
import '../models/world_map.dart';
import '../services/world_map_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'story_interaction_screen.dart';

class EnhancedMapScreen extends StatefulWidget {
  const EnhancedMapScreen({super.key});

  @override
  State<EnhancedMapScreen> createState() => _EnhancedMapScreenState();
}

class _EnhancedMapScreenState extends State<EnhancedMapScreen>
    with TickerProviderStateMixin {
  final WorldMapService _mapService = WorldMapService();
  List<WorldMap> _maps = [];
  WorldMap? _currentMap;
  bool _isLoading = true;
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _loadMaps();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _loadMaps() async {
    final maps = await _mapService.getWorldMaps();
    final currentMapId = await _mapService.getCurrentMapId();

    setState(() {
      _maps = maps;
      _currentMap = currentMapId != null
          ? maps.firstWhere(
              (m) => m.id == currentMapId,
              orElse: () => maps.first,
            )
          : maps.first;
      _isLoading = false;
    });
  }

  Future<void> _switchMap(WorldMap map) async {
    if (!map.isUnlocked) {
      _showUnlockDialog(map);
      return;
    }

    await _mapService.setCurrentMap(map.id);
    setState(() {
      _currentMap = map;
    });
  }

  void _showUnlockDialog(WorldMap map) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          'Area Locked',
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: Text(
          '${map.name} is not yet unlocked. Continue exploring the current area to gain access to new regions.',
          style: const TextStyle(color: AppColors.lavenderWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  void _onLocationTap(MapLocation location) {
    if (location.status == LocationStatus.locked) {
      _showLocationLockedDialog(location);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryInteractionScreen(
          mapId: _currentMap!.id,
          location: location,
          onStoryUpdate: _loadMaps,
        ),
      ),
    );
  }

  void _showLocationLockedDialog(MapLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          location.name,
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This location is locked. The following conditions are required:',
              style: const TextStyle(color: AppColors.lavenderWhite),
            ),
            const SizedBox(height: 8),
            ...location.requirements.map(
              (req) => Text(
                '• $req',
                style: const TextStyle(color: AppColors.statusWarning),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLocationColor(LocationStatus status) {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vintageGold),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _currentMap?.primaryColor ?? AppColors.deepNavy,
              _currentMap?.secondaryColor ?? AppColors.slateBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with map selector
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
                      child: Text(
                        _currentMap?.name ?? 'World Map',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    PopupMenuButton<WorldMap>(
                      icon: const Icon(
                        Icons.map,
                        color: AppColors.lavenderWhite,
                      ),
                      color: AppColors.slateBlue,
                      itemBuilder: (context) => _maps.map((map) {
                        return PopupMenuItem<WorldMap>(
                          value: map,
                          child: Row(
                            children: [
                              Icon(
                                map.isUnlocked ? Icons.lock_open : Icons.lock,
                                color: map.isUnlocked
                                    ? AppColors.statusOptimal
                                    : AppColors.statusError,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                map.name,
                                style: TextStyle(
                                  color: map.isUnlocked
                                      ? AppColors.lavenderWhite
                                      : AppColors.lavenderWhite.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onSelected: _switchMap,
                    ),
                  ],
                ),
              ),

              // Map description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  child: Text(
                    _currentMap?.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Interactive Map
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassCard(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.deepNavy.withValues(alpha: 0.8),
                            AppColors.slateBlue.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MapBackgroundPainter(
                                _currentMap?.type ?? MapType.overworld,
                              ),
                            ),
                          ),

                          // Locations
                          if (_currentMap != null)
                            ..._currentMap!.locations.map((location) {
                              return Positioned(
                                left:
                                    location.x *
                                    (MediaQuery.of(context).size.width - 64),
                                top: location.y * 400,
                                child: _buildLocationMarker(location),
                              );
                            }),

                          // Animated effects
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _rotationController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: AnimatedEffectsPainter(
                                    _rotationController.value,
                                    _currentMap?.type ?? MapType.overworld,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Quick actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickAction(
                      Icons.history,
                      'Story History',
                      () => _showStoryHistory(),
                    ),
                    _buildQuickAction(
                      Icons.explore,
                      'Auto Explore',
                      () => _startAutoExploration(),
                    ),
                    _buildQuickAction(
                      Icons.settings,
                      'Map Settings',
                      () => _showMapSettings(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationMarker(MapLocation location) {
    return GestureDetector(
      onTap: () => _onLocationTap(location),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = location.status == LocationStatus.active
              ? 1.0 + (_pulseController.value * 0.2)
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getLocationColor(location.status),
                    border: Border.all(color: AppColors.deepNavy, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _getLocationColor(
                          location.status,
                        ).withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    location.icon,
                    color: AppColors.deepNavy,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.deepNavy.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getLocationColor(
                        location.status,
                      ).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    location.name,
                    style: TextStyle(
                      color: _getLocationColor(location.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.slateBlue.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.vintageGold.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.vintageGold, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.lavenderWhite,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoryHistory() async {
    final allEvents = await _mapService.getAllStoryEvents();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                  const Icon(Icons.history, color: AppColors.vintageGold),
                  const SizedBox(width: 8),
                  Text(
                    'Story History',
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
              child: allEvents.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_stories,
                            size: 64,
                            color: AppColors.vintageGold,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No stories yet',
                            style: TextStyle(
                              color: AppColors.lavenderWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start exploring locations to create your story!',
                            style: TextStyle(
                              color: AppColors.lavenderWhite,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: allEvents.length,
                      itemBuilder: (context, index) {
                        final event =
                            allEvents[allEvents.length -
                                1 -
                                index]; // Reverse order
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.deepNavy.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.vintageGold.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.vintageGold.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        event.locationId,
                                        style: const TextStyle(
                                          color: AppColors.vintageGold,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: AppColors.lavenderWhite
                                            .withValues(alpha: 0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  event.content,
                                  style: const TextStyle(
                                    color: AppColors.lavenderWhite,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                if (event.choices.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Available Choices:',
                                    style: TextStyle(
                                      color: AppColors.accentRose,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ...event.choices.map(
                                    (choice) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        top: 2,
                                      ),
                                      child: Text(
                                        '• $choice',
                                        style: TextStyle(
                                          color: AppColors.lavenderWhite
                                              .withValues(alpha: 0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

  void _startAutoExploration() {
    if (_currentMap == null) return;

    final availableLocations = _currentMap!.locations
        .where((loc) => loc.status == LocationStatus.available)
        .toList();

    if (availableLocations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available locations to explore automatically'),
          backgroundColor: AppColors.statusWarning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.vintageGold),
            SizedBox(width: 8),
            Text(
              'Auto Exploration',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deploy your automaton to explore available locations automatically?',
              style: const TextStyle(color: AppColors.lavenderWhite),
            ),
            const SizedBox(height: 16),
            Text(
              'Available locations: ${availableLocations.length}',
              style: const TextStyle(
                color: AppColors.vintageGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...availableLocations
                .take(3)
                .map(
                  (loc) => Text(
                    '• ${loc.name}',
                    style: const TextStyle(color: AppColors.statusOptimal),
                  ),
                ),
            if (availableLocations.length > 3)
              Text(
                '• And ${availableLocations.length - 3} more...',
                style: const TextStyle(color: AppColors.statusOptimal),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performAutoExploration(availableLocations);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vintageGold,
            ),
            child: const Text(
              'Deploy Automaton',
              style: TextStyle(color: AppColors.deepNavy),
            ),
          ),
        ],
      ),
    );
  }

  void _performAutoExploration(List<MapLocation> locations) async {
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.vintageGold),
            const SizedBox(height: 16),
            Text(
              'Automaton exploring...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    // Simulate exploration delay
    await Future.delayed(const Duration(seconds: 2));

    // Randomly select a location to explore
    final randomLocation =
        locations[DateTime.now().millisecond % locations.length];

    // Generate story for the selected location
    try {
      await _mapService.updateLocationStory(
        _currentMap!.id,
        randomLocation.id,
        'Explore automatically with automaton',
      );

      await _loadMaps();

      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Automaton discovered something at ${randomLocation.name}!',
            ),
            backgroundColor: AppColors.statusOptimal,
            action: SnackBarAction(
              label: 'View',
              textColor: AppColors.vintageGold,
              onPressed: () => _onLocationTap(randomLocation),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Automaton exploration failed: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    }
  }

  void _showMapSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.slateBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lavenderWhite.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.settings, color: AppColors.vintageGold),
                const SizedBox(width: 8),
                Text(
                  'Map Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Animation Speed Setting
            _buildSettingItem(
              Icons.speed,
              'Animation Speed',
              'Adjust map animation speed',
              () => _showAnimationSpeedDialog(),
            ),

            // Show/Hide Effects
            _buildSettingItem(
              Icons.auto_fix_high,
              'Visual Effects',
              'Toggle animated effects on map',
              () => _toggleVisualEffects(),
            ),

            // Reset Map Progress
            _buildSettingItem(
              Icons.refresh,
              'Reset Progress',
              'Reset all location progress',
              () => _showResetProgressDialog(),
            ),

            // Map Information
            _buildSettingItem(
              Icons.info,
              'Map Information',
              'View current map details',
              () => _showMapInformation(),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.vintageGold.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.vintageGold, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.lavenderWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.lavenderWhite.withValues(alpha: 0.7),
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.vintageGold),
      onTap: onTap,
    );
  }

  void _showAnimationSpeedDialog() {
    Navigator.of(context).pop(); // Close settings sheet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: const Text(
          'Animation Speed',
          style: TextStyle(color: AppColors.vintageGold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose animation speed:',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
            const SizedBox(height: 16),
            _buildSpeedOption('Slow', 0.5),
            _buildSpeedOption('Normal', 1.0),
            _buildSpeedOption('Fast', 2.0),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedOption(String label, double speed) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: AppColors.lavenderWhite),
      ),
      trailing: Radio<double>(
        value: speed,
        groupValue: 1.0, // Default speed
        onChanged: (value) {
          // Update animation speed
          _pulseController.duration = Duration(
            milliseconds: (2000 / speed).round(),
          );
          _rotationController.duration = Duration(
            milliseconds: (10000 / speed).round(),
          );
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Animation speed set to $label'),
              backgroundColor: AppColors.statusOptimal,
            ),
          );
        },
        activeColor: AppColors.vintageGold,
      ),
    );
  }

  void _toggleVisualEffects() {
    Navigator.of(context).pop(); // Close settings sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visual effects toggled'),
        backgroundColor: AppColors.statusOptimal,
      ),
    );
  }

  void _showResetProgressDialog() {
    Navigator.of(context).pop(); // Close settings sheet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.statusError),
            SizedBox(width: 8),
            Text(
              'Reset Progress',
              style: TextStyle(color: AppColors.statusError),
            ),
          ],
        ),
        content: const Text(
          'This will reset all location progress and story history. This action cannot be undone.',
          style: TextStyle(color: AppColors.lavenderWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement actual reset functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress reset functionality coming soon'),
                  backgroundColor: AppColors.statusWarning,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusError,
            ),
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
          ),
        ],
      ),
    );
  }

  void _showMapInformation() {
    Navigator.of(context).pop(); // Close settings sheet
    if (_currentMap == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          _currentMap!.name,
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentMap!.description,
              style: const TextStyle(color: AppColors.lavenderWhite),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Type', _currentMap!.type.name),
            _buildInfoRow(
              'Status',
              _currentMap!.isUnlocked ? 'Unlocked' : 'Locked',
            ),
            _buildInfoRow('Locations', '${_currentMap!.locations.length}'),
            _buildInfoRow(
              'Explored',
              '${_currentMap!.locations.where((l) => l.status != LocationStatus.locked).length}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.vintageGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.lavenderWhite,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.vintageGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  final MapType mapType;

  MapBackgroundPainter(this.mapType);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    switch (mapType) {
      case MapType.overworld:
        _paintOverworldBackground(canvas, size, paint);
        break;
      case MapType.underground:
        _paintUndergroundBackground(canvas, size, paint);
        break;
      case MapType.skyCity:
        _paintSkyCityBackground(canvas, size, paint);
        break;
      default:
        _paintOverworldBackground(canvas, size, paint);
    }
  }

  void _paintOverworldBackground(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.vintageGold.withValues(alpha: 0.2);
    paint.strokeWidth = 1;

    // 绘制街道网格
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int i = 0; i < 8; i++) {
      final y = (size.height / 8) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintUndergroundBackground(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.accentRose.withValues(alpha: 0.3);
    paint.strokeWidth = 2;

    // 绘制隧道网络
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.6,
      size.width,
      size.height * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  void _paintSkyCityBackground(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.statusOptimal.withValues(alpha: 0.2);
    paint.strokeWidth = 1;

    // 绘制云朵和浮岛
    for (int i = 0; i < 5; i++) {
      final center = Offset(
        size.width * (0.2 + i * 0.15),
        size.height * (0.3 + (i % 2) * 0.3),
      );
      canvas.drawCircle(center, 30, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedEffectsPainter extends CustomPainter {
  final double animationValue;
  final MapType mapType;

  AnimatedEffectsPainter(this.animationValue, this.mapType);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (mapType) {
      case MapType.overworld:
        _paintSteamEffects(canvas, size, paint);
        break;
      case MapType.underground:
        _paintGlowEffects(canvas, size, paint);
        break;
      case MapType.skyCity:
        _paintFloatingEffects(canvas, size, paint);
        break;
      default:
        break;
    }
  }

  void _paintSteamEffects(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.lavenderWhite.withValues(alpha: 0.1);

    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.2 + i * 0.3);
      final y = size.height * 0.8 - (animationValue * 100);
      canvas.drawCircle(Offset(x, y), 10 + animationValue * 5, paint);
    }
  }

  void _paintGlowEffects(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.accentRose.withValues(alpha: 0.2);

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = 50 + animationValue * 20;
    canvas.drawCircle(center, radius, paint);
  }

  void _paintFloatingEffects(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.statusOptimal.withValues(alpha: 0.1);

    for (int i = 0; i < 4; i++) {
      final x = size.width * (0.1 + i * 0.25);
      final y =
          size.height * 0.6 + (animationValue * 20 * (i % 2 == 0 ? 1 : -1));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 20, height: 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
