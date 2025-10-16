import 'package:flutter/material.dart';

enum MapType {
  overworld,
  underground,
  skyCity,
  industrialDistrict,
  ancientRuins,
}

class WorldMap {
  final String id;
  final String name;
  final String description;
  final MapType type;
  final List<MapLocation> locations;
  final bool isUnlocked;
  final String backgroundImage;
  final Color primaryColor;
  final Color secondaryColor;

  const WorldMap({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.locations,
    required this.isUnlocked,
    required this.backgroundImage,
    required this.primaryColor,
    required this.secondaryColor,
  });

  WorldMap copyWith({
    String? id,
    String? name,
    String? description,
    MapType? type,
    List<MapLocation>? locations,
    bool? isUnlocked,
    String? backgroundImage,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return WorldMap(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      locations: locations ?? this.locations,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}

class MapLocation {
  final String id;
  final String name;
  final String description;
  final double x; // 0.0 to 1.0
  final double y; // 0.0 to 1.0
  final IconData icon;
  final LocationStatus status;
  final List<String> requirements;
  final Map<String, dynamic> rewards;
  final String? currentStory;
  final List<String>? availableChoices;

  const MapLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.x,
    required this.y,
    required this.icon,
    required this.status,
    this.requirements = const [],
    this.rewards = const {},
    this.currentStory,
    this.availableChoices,
  });

  MapLocation copyWith({
    String? id,
    String? name,
    String? description,
    double? x,
    double? y,
    IconData? icon,
    LocationStatus? status,
    List<String>? requirements,
    Map<String, dynamic>? rewards,
    String? currentStory,
    List<String>? availableChoices,
  }) {
    return MapLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      x: x ?? this.x,
      y: y ?? this.y,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      requirements: requirements ?? this.requirements,
      rewards: rewards ?? this.rewards,
      currentStory: currentStory ?? this.currentStory,
      availableChoices: availableChoices ?? this.availableChoices,
    );
  }
}

enum LocationStatus {
  locked,
  available,
  exploring,
  completed,
  active,
}

class StoryEvent {
  final String id;
  final String locationId;
  final String content;
  final List<String> choices;
  final DateTime timestamp;
  final Map<String, dynamic> consequences;

  const StoryEvent({
    required this.id,
    required this.locationId,
    required this.content,
    required this.choices,
    required this.timestamp,
    this.consequences = const {},
  });

  StoryEvent copyWith({
    String? id,
    String? locationId,
    String? content,
    List<String>? choices,
    DateTime? timestamp,
    Map<String, dynamic>? consequences,
  }) {
    return StoryEvent(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      content: content ?? this.content,
      choices: choices ?? this.choices,
      timestamp: timestamp ?? this.timestamp,
      consequences: consequences ?? this.consequences,
    );
  }
}