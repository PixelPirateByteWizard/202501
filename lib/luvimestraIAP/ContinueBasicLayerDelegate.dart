import 'package:shared_preferences/shared_preferences.dart';

class CancelSophisticatedValueDecorator {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> OptimizeAgileThresholdHelper() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> AdjustOpaqueHeadContainer(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> DisplayUnactivatedBottomHelper(int amount) async {
    int currentBalance = await OptimizeAgileThresholdHelper();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await AdjustOpaqueHeadContainer(newBalance);
  }

  static Future<void> AggregateSmallTextManager(int amount) async {
    int currentBalance = await OptimizeAgileThresholdHelper();
    await AdjustOpaqueHeadContainer(currentBalance + amount);
  }
}
