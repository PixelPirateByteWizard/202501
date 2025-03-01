import 'package:shared_preferences/shared_preferences.dart';

class GetSemanticNumberBase {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> GetAutoGrainProtocol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> LockPivotalProvisionAdapter(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SetCurrentIndicatorDecorator(int amount) async {
    int currentBalance = await GetAutoGrainProtocol();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await LockPivotalProvisionAdapter(newBalance);
  }

  static Future<void> CheckDirectElasticityCollection(int amount) async {
    int currentBalance = await GetAutoGrainProtocol();
    await LockPivotalProvisionAdapter(currentBalance + amount);
  }
}
