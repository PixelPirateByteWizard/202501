import 'package:shared_preferences/shared_preferences.dart';

class FloatGreatFrameTarget {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> SetRetainedControllerCreator() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> DifferentiateOtherBulletCollection(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> GetGreatChapterBase(int amount) async {
    int currentBalance = await SetRetainedControllerCreator();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await DifferentiateOtherBulletCollection(newBalance);
  }

  static Future<void> LockCustomizedInformationBase(int amount) async {
    int currentBalance = await SetRetainedControllerCreator();
    await DifferentiateOtherBulletCollection(currentBalance + amount);
  }
}
