import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static ValueNotifier<int> manaPoints = ValueNotifier<int>(60);

  static Future<void> loadManaPoints() async {
    final prefs = await SharedPreferences.getInstance();
    manaPoints.value = prefs.getInt('manaPoints') ?? 60;
  }

  static Future<void> saveManaPoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('manaPoints', manaPoints.value);
  }

  static Future<void> initialize() async {
    await loadManaPoints(); // 加载法力值
  }
}
