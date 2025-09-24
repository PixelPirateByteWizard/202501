import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_checkin.dart';

class DailyCheckinService {
  static const String _lastCheckinKey = 'last_checkin_date';
  static const String _currentDayKey = 'current_checkin_day';
  static const String _consecutiveDaysKey = 'consecutive_checkin_days';
  static const String _totalDaysKey = 'total_checkin_days';

  static Future<DailyCheckinData> getCheckinData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckinString = prefs.getString(_lastCheckinKey);
    final currentDay = prefs.getInt(_currentDayKey) ?? 1;
    final consecutiveDays = prefs.getInt(_consecutiveDaysKey) ?? 0;
    final totalDays = prefs.getInt(_totalDaysKey) ?? 0;

    DateTime? lastCheckinDate;
    bool hasCheckedToday = false;

    if (lastCheckinString != null) {
      lastCheckinDate = DateTime.parse(lastCheckinString);
      final today = DateTime.now();
      hasCheckedToday = _isSameDay(lastCheckinDate, today);
    }

    return DailyCheckinData(
      rewards: DailyCheckinData.getDefaultRewards(),
      currentDay: currentDay,
      hasCheckedToday: hasCheckedToday,
      lastCheckinDate: lastCheckinDate,
      consecutiveDays: consecutiveDays,
      totalDays: totalDays,
    );
  }

  static Future<bool> performCheckin() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final lastCheckinString = prefs.getString(_lastCheckinKey);

    // 检查是否已经签到
    if (lastCheckinString != null) {
      final lastCheckinDate = DateTime.parse(lastCheckinString);
      if (_isSameDay(lastCheckinDate, today)) {
        return false; // 今天已经签到过了
      }
    }

    // 更新签到数据
    final currentDay = prefs.getInt(_currentDayKey) ?? 1;
    final consecutiveDays = prefs.getInt(_consecutiveDaysKey) ?? 0;
    final totalDays = prefs.getInt(_totalDaysKey) ?? 0;

    int nextDay = currentDay + 1;
    if (nextDay > 7) nextDay = 1; // 重置为第一天

    // 计算连续签到天数
    int newConsecutiveDays = consecutiveDays + 1;
    if (lastCheckinString != null) {
      final lastCheckinDate = DateTime.parse(lastCheckinString);
      final yesterday = today.subtract(const Duration(days: 1));
      if (!_isSameDay(lastCheckinDate, yesterday)) {
        // 不是连续签到，重置连续天数
        newConsecutiveDays = 1;
      }
    } else {
      newConsecutiveDays = 1; // 首次签到
    }

    await prefs.setString(_lastCheckinKey, today.toIso8601String());
    await prefs.setInt(_currentDayKey, nextDay);
    await prefs.setInt(_consecutiveDaysKey, newConsecutiveDays);
    await prefs.setInt(_totalDaysKey, totalDays + 1);

    return true;
  }

  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static Future<void> resetCheckin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastCheckinKey);
    await prefs.setInt(_currentDayKey, 1);
    await prefs.setInt(_consecutiveDaysKey, 0);
    // 总签到天数不重置
  }
}
