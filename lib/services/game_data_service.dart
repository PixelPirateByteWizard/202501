import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resource.dart';
import '../models/workstation.dart';
import '../models/clue.dart';
import '../models/expedition.dart';

class GameDataService {
  static const String _resourcesKey = 'resources';
  static const String _workstationsKey = 'workstations';
  static const String _cluesKey = 'clues';
  static const String _expeditionsKey = 'expeditions';
  static const String _gameProgressKey = 'gameProgress';

  // Resources
  Future<List<Resource>> getResources() async {
    final prefs = await SharedPreferences.getInstance();
    final resourcesJson = prefs.getString(_resourcesKey);

    if (resourcesJson == null) {
      return _getDefaultResources();
    }

    final List<dynamic> resourcesList = json.decode(resourcesJson);
    return resourcesList.map((json) => Resource.fromJson(json)).toList();
  }

  Future<void> saveResources(List<Resource> resources) async {
    final prefs = await SharedPreferences.getInstance();
    final resourcesJson = json.encode(
      resources.map((r) => r.toJson()).toList(),
    );
    await prefs.setString(_resourcesKey, resourcesJson);
  }

  List<Resource> _getDefaultResources() {
    return [
      const Resource(
        id: 'brass_ingot',
        name: 'Brass Ingot',
        icon: '🔩',
        amount: 1247,
      ),
      const Resource(
        id: 'quartz_sand',
        name: 'Quartz Sand',
        icon: '⏳',
        amount: 855,
      ),
      const Resource(
        id: 'raw_rubber',
        name: 'Raw Rubber',
        icon: '🌿',
        amount: 340,
      ),
      const Resource(id: 'stardust', name: 'Stardust', icon: '✨', amount: 12),
      const Resource(id: 'gears', name: 'Gears', icon: '⚙️', amount: 247),
      const Resource(id: 'energy', name: 'Energy', icon: '⚡', amount: 89),
    ];
  }

  // Workstations
  Future<List<Workstation>> getWorkstations() async {
    final prefs = await SharedPreferences.getInstance();
    final workstationsJson = prefs.getString(_workstationsKey);

    if (workstationsJson == null) {
      return _getDefaultWorkstations();
    }

    final List<dynamic> workstationsList = json.decode(workstationsJson);
    return workstationsList.map((json) => Workstation.fromJson(json)).toList();
  }

  Future<void> saveWorkstations(List<Workstation> workstations) async {
    final prefs = await SharedPreferences.getInstance();
    final workstationsJson = json.encode(
      workstations.map((w) => w.toJson()).toList(),
    );
    await prefs.setString(_workstationsKey, workstationsJson);
  }

  List<Workstation> _getDefaultWorkstations() {
    return [
      const Workstation(
        id: 'smelter_t1',
        name: 'T1 Smelter',
        icon: '🔥',
        status: WorkstationStatus.optimal,
        inputResource: 'Ore',
        outputResource: 'Ingots',
        efficiency: 0.85,
      ),
      const Workstation(
        id: 'gear_cutter',
        name: 'Gear Cutter',
        icon: '⚙️',
        status: WorkstationStatus.optimal,
        inputResource: 'Ingots',
        outputResource: 'Gears',
        efficiency: 0.92,
      ),
      const Workstation(
        id: 'steam_core',
        name: 'Steam Core',
        icon: '💨',
        status: WorkstationStatus.error,
        inputResource: 'Gears+Rods',
        outputResource: 'Steam',
        efficiency: 0.0,
      ),
      const Workstation(
        id: 'new_station',
        name: 'Build New Station',
        icon: '➕',
        status: WorkstationStatus.offline,
        inputResource: '',
        outputResource: '',
        efficiency: 0.0,
        isBuilt: false,
      ),
    ];
  }

  // Clues
  Future<List<Clue>> getClues() async {
    final prefs = await SharedPreferences.getInstance();
    final cluesJson = prefs.getString(_cluesKey);

    if (cluesJson == null) {
      return _getDefaultClues();
    }

    final List<dynamic> cluesList = json.decode(cluesJson);
    return cluesList.map((json) => Clue.fromJson(json)).toList();
  }

  Future<void> saveClues(List<Clue> clues) async {
    final prefs = await SharedPreferences.getInstance();
    final cluesJson = json.encode(clues.map((c) => c.toJson()).toList());
    await prefs.setString(_cluesKey, cluesJson);
  }

  List<Clue> _getDefaultClues() {
    return [
      Clue(
        id: 'fathers_journal_1',
        title: "Father's Journal #1",
        description:
            'A worn leather journal with cryptic notes about clockwork mechanisms.',
        icon: '📖',
        acquiredDate: DateTime.now(),
        isNew: true,
        category: 'journal',
      ),
      Clue(
        id: 'incomplete_blueprint',
        title: 'Incomplete Blueprint',
        description: 'Technical drawings of an unknown mechanical device.',
        icon: '🧩',
        acquiredDate: DateTime.now().subtract(const Duration(days: 1)),
        category: 'blueprint',
      ),
      Clue(
        id: 'city_district_map',
        title: 'City District Map',
        description:
            'An old map showing the layout of the industrial district.',
        icon: '🗺️',
        acquiredDate: DateTime.now().subtract(const Duration(days: 2)),
        category: 'map',
      ),
      Clue(
        id: 'strange_key',
        title: 'Strange Key',
        description: 'An ornate brass key with unusual engravings.',
        icon: '🗝️',
        acquiredDate: DateTime.now().subtract(const Duration(days: 3)),
        category: 'artifact',
      ),
    ];
  }

  // Expeditions
  Future<List<Expedition>> getExpeditions() async {
    final prefs = await SharedPreferences.getInstance();
    final expeditionsJson = prefs.getString(_expeditionsKey);

    if (expeditionsJson == null) {
      return _getDefaultExpeditions();
    }

    final List<dynamic> expeditionsList = json.decode(expeditionsJson);
    return expeditionsList.map((json) => Expedition.fromJson(json)).toList();
  }

  Future<void> saveExpeditions(List<Expedition> expeditions) async {
    final prefs = await SharedPreferences.getInstance();
    final expeditionsJson = json.encode(
      expeditions.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_expeditionsKey, expeditionsJson);
  }

  List<Expedition> _getDefaultExpeditions() {
    return [
      const Expedition(
        id: 'old_town_survey',
        name: 'Old Town Survey',
        description:
            'Survey the abandoned industrial district for useful materials.',
        status: ExpeditionStatus.ready,
        duration: Duration(hours: 2),
        successRate: 0.85,
        rewards: {'brass_ingot': 50, 'gears': 10},
        requirements: {'energy': 20},
      ),
      const Expedition(
        id: 'clocktower_investigation',
        name: 'Clocktower Investigation',
        description: 'Investigate the mysterious clocktower for clues.',
        status: ExpeditionStatus.ready,
        duration: Duration(hours: 4),
        successRate: 0.65,
        rewards: {'stardust': 5, 'clue': 1},
        requirements: {'energy': 40, 'gears': 5},
      ),
    ];
  }

  // Game Progress
  Future<Map<String, dynamic>> getGameProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_gameProgressKey);

    if (progressJson == null) {
      return _getDefaultGameProgress();
    }

    return json.decode(progressJson);
  }

  Future<void> saveGameProgress(Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = json.encode(progress);
    await prefs.setString(_gameProgressKey, progressJson);
  }

  Map<String, dynamic> _getDefaultGameProgress() {
    return {
      'workshopEfficiency': 0.78,
      'powerOutput': 42,
      'maxPower': 50,
      'completedTutorial': false,
      'unlockedScreens': ['workshop', 'archive', 'map', 'quick_craft', 'truth_table'],
      'musicBoxSolved': false,
      'prologueCompleted': true, // Skip prologue by default
      'playerLevel': 1,
      'experience': 0,
      'experienceToNext': 1000,
      'totalPlayTime': 0,
      'lastPlayDate': DateTime.now().toIso8601String(),
      'dailyStreak': 1,
      'weeklyGoals': {
        'expeditions_completed': {'current': 2, 'target': 5},
        'items_crafted': {'current': 7, 'target': 15},
        'resources_collected': {'current': 1247, 'target': 2000},
      },
      'monthlyGoals': {
        'districts_explored': {'current': 1, 'target': 3},
        'achievements_unlocked': {'current': 3, 'target': 10},
        'workstations_built': {'current': 4, 'target': 8},
      },
      'seasonalEvents': {
        'current_event': 'clockwork_festival',
        'event_progress': 0.3,
        'event_rewards_claimed': [],
      },
    };
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
