import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pomodoro_model.dart';
import '../models/milestone_model.dart';

class StorageUtils {
  static const String _pomodoroSettingsKey = 'pomodoro_settings';
  static const String _pomodoroSessionsKey = 'pomodoro_sessions';
  static const String _milestonesKey = 'milestones';
  static const String _streakKey = 'streak_days';

  // Pomodoro Settings
  static Future<void> savePomodoroSettings(PomodoroSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pomodoroSettingsKey, jsonEncode(settings.toJson()));
  }

  static Future<PomodoroSettings> getPomodoroSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_pomodoroSettingsKey);
    if (settingsJson == null) {
      return PomodoroSettings();
    }
    return PomodoroSettings.fromJson(jsonDecode(settingsJson));
  }

  // Pomodoro Sessions
  static Future<List<PomodoroSession>> getPomodoroSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList(_pomodoroSessionsKey);
    if (sessionsJson == null) {
      return [];
    }
    return sessionsJson
        .map((json) => PomodoroSession.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> savePomodoroSession(PomodoroSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getPomodoroSessions();
    sessions.add(session);
    await prefs.setStringList(
      _pomodoroSessionsKey,
      sessions.map((session) => jsonEncode(session.toJson())).toList(),
    );
  }

  static Future<void> updatePomodoroSession(
      PomodoroSession updatedSession) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getPomodoroSessions();
    final index =
        sessions.indexWhere((session) => session.id == updatedSession.id);
    if (index != -1) {
      sessions[index] = updatedSession;
      await prefs.setStringList(
        _pomodoroSessionsKey,
        sessions.map((session) => jsonEncode(session.toJson())).toList(),
      );
    }
  }

  static Future<void> clearPomodoroSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pomodoroSessionsKey);
  }

  // Milestones
  static Future<List<Milestone>> getMilestones() async {
    final prefs = await SharedPreferences.getInstance();
    final milestonesJson = prefs.getStringList(_milestonesKey);
    if (milestonesJson == null) {
      return [];
    }
    return milestonesJson
        .map((json) => Milestone.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveMilestone(Milestone milestone) async {
    final prefs = await SharedPreferences.getInstance();
    final milestones = await getMilestones();
    milestones.add(milestone);
    await prefs.setStringList(
      _milestonesKey,
      milestones.map((milestone) => jsonEncode(milestone.toJson())).toList(),
    );
  }

  static Future<void> updateMilestone(Milestone updatedMilestone) async {
    final prefs = await SharedPreferences.getInstance();
    final milestones = await getMilestones();
    final index = milestones
        .indexWhere((milestone) => milestone.id == updatedMilestone.id);
    if (index != -1) {
      milestones[index] = updatedMilestone;
      await prefs.setStringList(
        _milestonesKey,
        milestones.map((milestone) => jsonEncode(milestone.toJson())).toList(),
      );
    }
  }

  static Future<void> deleteMilestone(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final milestones = await getMilestones();
    milestones.removeWhere((milestone) => milestone.id == id);
    await prefs.setStringList(
      _milestonesKey,
      milestones.map((milestone) => jsonEncode(milestone.toJson())).toList(),
    );
  }

  // Streak
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> updateStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
  }
}
