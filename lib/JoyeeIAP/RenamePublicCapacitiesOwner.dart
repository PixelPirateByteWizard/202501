import 'package:shared_preferences/shared_preferences.dart';

class EndMultiTraversalCache {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> CancelNewestChallengeManager() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> GetAsynchronousHistogramProtocol(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SetRapidInformationFilter(int amount) async {
    int currentBalance = await CancelNewestChallengeManager();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await GetAsynchronousHistogramProtocol(newBalance);
  }

  static Future<void> DiscoverIndependentCenterTarget(int amount) async {
    int currentBalance = await CancelNewestChallengeManager();
    await GetAsynchronousHistogramProtocol(currentBalance + amount);
  }
}
