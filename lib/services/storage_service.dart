import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress_model.dart';

class StorageService {
  static const String _userProgressKey = 'user_progress';
  static const String _lastStepResetKey = 'last_step_reset';
  static const String _totalStepsKey = 'total_steps';

  Future<void> saveUserProgress(UserProgressModel progress) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(progress.toJson());
    await prefs.setString(_userProgressKey, jsonString);
  }

  Future<UserProgressModel?> loadUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userProgressKey);

    if (jsonString == null) {
      return null;
    }

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProgressModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveLastStepResetDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastStepResetKey, date.toIso8601String());
  }

  Future<DateTime?> loadLastStepResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_lastStepResetKey);

    if (dateString == null) {
      return null;
    }

    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveTotalSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalStepsKey, steps);
  }

  Future<int> loadTotalSteps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalStepsKey) ?? 0;
  }

  Future<bool> shouldResetDailySteps() async {
    final lastReset = await loadLastStepResetDate();
    if (lastReset == null) {
      return true;
    }

    final now = DateTime.now();
    final lastResetDate = DateTime(lastReset.year, lastReset.month, lastReset.day);
    final todayDate = DateTime(now.year, now.month, now.day);

    return todayDate.isAfter(lastResetDate);
  }

  Future<void> clearUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProgressKey);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
