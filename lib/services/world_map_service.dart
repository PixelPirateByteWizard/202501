import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/world_map.dart';
import '../theme/app_theme.dart';
import 'deepseek_service.dart';
import 'achievement_service.dart';

class WorldMapService {
  static const String _mapsKey = 'world_maps';
  static const String _storyEventsKey = 'story_events';
  static const String _currentMapKey = 'current_map';
  
  final DeepSeekService _deepSeekService = DeepSeekService();
  final AchievementService _achievementService = AchievementService();
  final Uuid _uuid = const Uuid();

  Future<List<WorldMap>> getWorldMaps() async {
    final prefs = await SharedPreferences.getInstance();
    final mapsJson = prefs.getString(_mapsKey);
    
    if (mapsJson == null) {
      final defaultMaps = _getDefaultMaps();
      await _saveMaps(defaultMaps);
      return defaultMaps;
    }
    
    final mapsList = jsonDecode(mapsJson) as List;
    return mapsList.map((json) => _mapFromJson(json)).toList();
  }

  Future<void> _saveMaps(List<WorldMap> maps) async {
    final prefs = await SharedPreferences.getInstance();
    final mapsJson = jsonEncode(maps.map((map) => _mapToJson(map)).toList());
    await prefs.setString(_mapsKey, mapsJson);
  }

  Future<String?> getCurrentMapId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentMapKey);
  }

  Future<void> setCurrentMap(String mapId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentMapKey, mapId);
  }

  Future<WorldMap> updateLocationStory(
    String mapId,
    String locationId,
    String playerChoice,
  ) async {
    final maps = await getWorldMaps();
    final mapIndex = maps.indexWhere((m) => m.id == mapId);
    if (mapIndex == -1) throw Exception('Map not found');

    final map = maps[mapIndex];
    final locationIndex = map.locations.indexWhere((l) => l.id == locationId);
    if (locationIndex == -1) throw Exception('Location not found');

    final location = map.locations[locationIndex];
    
    // 生成新的剧情内容
    final newStory = await _deepSeekService.generateStoryContent(
      context: location.description,
      playerAction: playerChoice,
      currentLocation: location.name,
    );

    // 生成新的选择
    final newChoices = await _deepSeekService.generateChoices(
      currentStory: newStory,
      location: location.name,
    );

    // 更新位置状态
    final updatedLocation = location.copyWith(
      currentStory: newStory,
      availableChoices: newChoices,
      status: LocationStatus.active,
    );

    final updatedLocations = List<MapLocation>.from(map.locations);
    updatedLocations[locationIndex] = updatedLocation;

    final updatedMap = map.copyWith(locations: updatedLocations);
    maps[mapIndex] = updatedMap;

    await _saveMaps(maps);

    // 保存故事事件
    await _saveStoryEvent(StoryEvent(
      id: _uuid.v4(),
      locationId: locationId,
      content: newStory,
      choices: newChoices,
      timestamp: DateTime.now(),
    ));

    // 检查成就
    await _checkAchievements();

    return updatedMap;
  }

  Future<void> _saveStoryEvent(StoryEvent event) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_storyEventsKey) ?? '[]';
    final events = jsonDecode(eventsJson) as List;
    
    events.add({
      'id': event.id,
      'locationId': event.locationId,
      'content': event.content,
      'choices': event.choices,
      'timestamp': event.timestamp.toIso8601String(),
      'consequences': event.consequences,
    });

    await prefs.setString(_storyEventsKey, jsonEncode(events));
  }

  Future<List<StoryEvent>> getStoryEvents(String locationId) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_storyEventsKey) ?? '[]';
    final events = jsonDecode(eventsJson) as List;
    
    return events
        .where((e) => e['locationId'] == locationId)
        .map((json) => StoryEvent(
              id: json['id'],
              locationId: json['locationId'],
              content: json['content'],
              choices: List<String>.from(json['choices']),
              timestamp: DateTime.parse(json['timestamp']),
              consequences: Map<String, dynamic>.from(json['consequences'] ?? {}),
            ))
        .toList();
  }

  Future<void> unlockMap(String mapId) async {
    final maps = await getWorldMaps();
    final mapIndex = maps.indexWhere((m) => m.id == mapId);
    if (mapIndex == -1) return;

    final updatedMap = maps[mapIndex].copyWith(isUnlocked: true);
    maps[mapIndex] = updatedMap;
    await _saveMaps(maps);
    
    // 检查成就
    await _checkAchievements();
  }

  Future<void> _checkAchievements() async {
    final maps = await getWorldMaps();
    final allEvents = await _getAllStoryEvents();
    
    final storiesGenerated = allEvents.length;
    final choicesMade = allEvents.length; // 每个事件代表一个选择
    final locationsVisited = allEvents.map((e) => e.locationId).toSet().length;
    final mapsUnlocked = maps.where((m) => m.isUnlocked).length;
    
    await _achievementService.checkStoryAchievements(
      storiesGenerated: storiesGenerated,
      choicesMade: choicesMade,
      locationsVisited: locationsVisited,
      mapsUnlocked: mapsUnlocked,
    );
  }

  Future<List<StoryEvent>> getAllStoryEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_storyEventsKey) ?? '[]';
    final events = jsonDecode(eventsJson) as List;
    
    return events
        .map((json) => StoryEvent(
              id: json['id'],
              locationId: json['locationId'],
              content: json['content'],
              choices: List<String>.from(json['choices']),
              timestamp: DateTime.parse(json['timestamp']),
              consequences: Map<String, dynamic>.from(json['consequences'] ?? {}),
            ))
        .toList();
  }

  Future<List<StoryEvent>> _getAllStoryEvents() async {
    return getAllStoryEvents();
  }

  List<WorldMap> _getDefaultMaps() {
    return [
      WorldMap(
        id: 'overworld',
        name: 'Overworld',
        description: 'Main area of the steampunk city, filled with factory chimneys and mechanical devices',
        type: MapType.overworld,
        isUnlocked: true,
        backgroundImage: 'overworld_bg',
        primaryColor: AppColors.vintageGold,
        secondaryColor: AppColors.slateBlue,
        locations: [
          MapLocation(
            id: 'old_library',
            name: 'Ancient Library',
            description: 'A Victorian-era library containing ancient mechanical texts',
            x: 0.2,
            y: 0.3,
            icon: Icons.book,
            status: LocationStatus.available,
            currentStory: 'The ancient library stands quietly at the corner, steam slowly rising from the pipes. You push open the heavy wooden door and hear the sound of gears turning...',
            availableChoices: ['Search for mechanical books', 'Check the ancient catalog system', 'Look for hidden chambers'],
          ),
          MapLocation(
            id: 'clock_tower',
            name: 'Clock Tower',
            description: 'Massive clock tower in the city center, said to hide the secrets of time',
            x: 0.5,
            y: 0.2,
            icon: Icons.access_time,
            status: LocationStatus.locked,
            requirements: ['Ancient Key', 'Time Gear'],
          ),
          MapLocation(
            id: 'steam_factory',
            name: 'Steam Factory',
            description: 'Massive factory building with mechanical arms working tirelessly',
            x: 0.7,
            y: 0.4,
            icon: Icons.factory,
            status: LocationStatus.available,
          ),
          MapLocation(
            id: 'airship_dock',
            name: 'Airship Dock',
            description: 'Important hub connecting to the sky city',
            x: 0.8,
            y: 0.1,
            icon: Icons.flight,
            status: LocationStatus.locked,
            requirements: ['Flight License'],
          ),
        ],
      ),
      WorldMap(
        id: 'underground',
        name: 'Underground World',
        description: 'Complex network of underground tunnels filled with abandoned machinery and mysterious energy',
        type: MapType.underground,
        isUnlocked: false,
        backgroundImage: 'underground_bg',
        primaryColor: AppColors.accentRose,
        secondaryColor: AppColors.deepNavy,
        locations: [
          MapLocation(
            id: 'steam_tunnels',
            name: 'Steam Tunnels',
            description: 'Hot underground tunnels with crisscrossing pipes',
            x: 0.3,
            y: 0.6,
            icon: Icons.train,
            status: LocationStatus.available,
          ),
          MapLocation(
            id: 'abandoned_lab',
            name: 'Abandoned Laboratory',
            description: 'An abandoned scientific laboratory with unfinished experiments',
            x: 0.6,
            y: 0.7,
            icon: Icons.science,
            status: LocationStatus.available,
          ),
        ],
      ),
      WorldMap(
        id: 'sky_city',
        name: 'Sky City',
        description: 'Mysterious city floating in the clouds, supported by ancient anti-gravity technology',
        type: MapType.skyCity,
        isUnlocked: false,
        backgroundImage: 'sky_city_bg',
        primaryColor: AppColors.statusOptimal,
        secondaryColor: AppColors.lavenderWhite,
        locations: [
          MapLocation(
            id: 'floating_gardens',
            name: 'Floating Gardens',
            description: 'Beautiful gardens floating in the air, maintained by steam power',
            x: 0.4,
            y: 0.3,
            icon: Icons.park,
            status: LocationStatus.available,
          ),
          MapLocation(
            id: 'observatory',
            name: 'Observatory',
            description: 'Massive telescope for stargazing, seemingly searching for something',
            x: 0.7,
            y: 0.2,
            icon: Icons.visibility,
            status: LocationStatus.available,
          ),
        ],
      ),
    ];
  }

  Map<String, dynamic> _mapToJson(WorldMap map) {
    return {
      'id': map.id,
      'name': map.name,
      'description': map.description,
      'type': map.type.index,
      'isUnlocked': map.isUnlocked,
      'backgroundImage': map.backgroundImage,
      'primaryColor': map.primaryColor.value,
      'secondaryColor': map.secondaryColor.value,
      'locations': map.locations.map((loc) => _locationToJson(loc)).toList(),
    };
  }

  WorldMap _mapFromJson(Map<String, dynamic> json) {
    return WorldMap(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: MapType.values[json['type']],
      isUnlocked: json['isUnlocked'],
      backgroundImage: json['backgroundImage'],
      primaryColor: Color(json['primaryColor']),
      secondaryColor: Color(json['secondaryColor']),
      locations: (json['locations'] as List)
          .map((loc) => _locationFromJson(loc))
          .toList(),
    );
  }

  Map<String, dynamic> _locationToJson(MapLocation location) {
    return {
      'id': location.id,
      'name': location.name,
      'description': location.description,
      'x': location.x,
      'y': location.y,
      'icon': location.icon.codePoint,
      'status': location.status.index,
      'requirements': location.requirements,
      'rewards': location.rewards,
      'currentStory': location.currentStory,
      'availableChoices': location.availableChoices,
    };
  }

  MapLocation _locationFromJson(Map<String, dynamic> json) {
    return MapLocation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      x: json['x'],
      y: json['y'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      status: LocationStatus.values[json['status']],
      requirements: List<String>.from(json['requirements'] ?? []),
      rewards: Map<String, dynamic>.from(json['rewards'] ?? {}),
      currentStory: json['currentStory'],
      availableChoices: json['availableChoices'] != null
          ? List<String>.from(json['availableChoices'])
          : null,
    );
  }
}