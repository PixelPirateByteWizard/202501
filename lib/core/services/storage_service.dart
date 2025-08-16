import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingKey = 'onboarding_complete';
  static const String _watchlistKey = 'watchlist';

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> saveWatchlist(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_watchlistKey, ids);
  }

  static Future<List<String>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_watchlistKey) ?? [];
  }

  static Future<void> addToWatchlist(String coinId) async {
    final watchlist = await getWatchlist();
    if (!watchlist.contains(coinId)) {
      watchlist.add(coinId);
      await saveWatchlist(watchlist);
    }
  }

  static Future<void> removeFromWatchlist(String coinId) async {
    final watchlist = await getWatchlist();
    watchlist.remove(coinId);
    await saveWatchlist(watchlist);
  }
}