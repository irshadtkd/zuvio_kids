import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

/// Manages the daily learning streak for the child.
///
/// A streak increments if the child completes at least one activity per day.
/// The streak resets to 1 if they miss a day.
/// Layer: Core Utility
class StreakService {
  StreakService._();
  static final StreakService instance = StreakService._();

  static const String _prefStreakCount = 'pref_streak_count';
  static const String _prefStreakLastDate = 'pref_streak_last_date';
  static const String _prefStreakRecord = 'pref_streak_record';

  /// Returns the current streak count and updates it if a new day has started.
  Future<int> checkAndUpdateStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = _dateString(DateTime.now());
      final lastDate = prefs.getString(_prefStreakLastDate) ?? '';
      final current = prefs.getInt(_prefStreakCount) ?? 0;
      final record = prefs.getInt(_prefStreakRecord) ?? 0;

      if (lastDate == today) {
        // Already recorded today — return current streak
        return current;
      }

      final yesterday = _dateString(DateTime.now().subtract(const Duration(days: 1)));
      int newStreak;

      if (lastDate == yesterday) {
        // Consecutive day — increment streak
        newStreak = current + 1;
      } else if (lastDate.isEmpty) {
        // First time ever
        newStreak = 1;
      } else {
        // Missed a day — reset
        newStreak = 1;
      }

      await prefs.setInt(_prefStreakCount, newStreak);
      await prefs.setString(_prefStreakLastDate, today);

      if (newStreak > record) {
        await prefs.setInt(_prefStreakRecord, newStreak);
      }

      return newStreak;
    } catch (e, st) {
      AppLogger.error('StreakService: failed to update streak', e, st);
      return 0;
    }
  }

  /// Returns the current streak without updating.
  Future<int> getCurrentStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_prefStreakCount) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Returns the all-time best streak.
  Future<int> getStreakRecord() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_prefStreakRecord) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Returns true if more than 18 hours have passed since last session
  /// (used for the "Welcome Back" animation).
  Future<bool> isWelcomeBackEligible() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastDate = prefs.getString(_prefStreakLastDate) ?? '';
      if (lastDate.isEmpty) return false;
      final today = _dateString(DateTime.now());
      return lastDate != today;
    } catch (e) {
      return false;
    }
  }

  /// Clears streak data (called on logout).
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefStreakCount);
      await prefs.remove(_prefStreakLastDate);
      await prefs.remove(_prefStreakRecord);
    } catch (e) {
      AppLogger.error('StreakService: failed to clear streak', e);
    }
  }

  String _dateString(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
