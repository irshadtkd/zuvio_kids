import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

/// Cross-feature Riverpod AsyncNotifier managing the user's total accumulated star points.
///
/// Star points are awarded (+10) whenever a child completes a step/session and
/// receives the congratulations message. They persist across app restarts and
/// sessions in local storage, and are cleared only when the user logs out.
/// Layer: Core Provider
class StarPointsNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    return _loadStarPoints();
  }

  Future<int> _loadStarPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(AppStrings.prefTotalStarPoints)) {
        return prefs.getInt(AppStrings.prefTotalStarPoints) ?? 0;
      }
      // Initial migration: calculate baseline from existing module storage if present
      final baseline = _calculateInitialFromLegacyPrefs(prefs);
      if (baseline > 0) {
        await prefs.setInt(AppStrings.prefTotalStarPoints, baseline);
      }
      return baseline;
    } catch (e, st) {
      AppLogger.error('StarPointsNotifier: failed to load star points', e, st);
      return 0;
    }
  }

  int _calculateInitialFromLegacyPrefs(SharedPreferences prefs) {
    int total = 0;
    for (final key in prefs.getKeys()) {
      if (key.startsWith(AppStrings.prefAlphabetCompletedSessions) ||
          key.startsWith(AppStrings.prefNumbersCompletedSessions) ||
          key.startsWith(AppStrings.prefColorsCompleted) ||
          key.startsWith(AppStrings.prefShapesCompletedSessions) ||
          key.startsWith(AppStrings.prefAnimalsCompletedSessions)) {
        final raw = prefs.getString(key);
        if (raw != null && raw.contains('"totalStars":')) {
          final match = RegExp(r'"totalStars":\s*(\d+)').firstMatch(raw);
          if (match != null) {
            total += int.tryParse(match.group(1) ?? '0') ?? 0;
          }
        }
      }
    }
    return total;
  }

  /// Awards [points] (defaults to 10) to the user's accumulated star points.
  Future<void> awardPoints([int points = 10]) async {
    final current = state.valueOrNull ?? 0;
    final updated = current + points;
    state = AsyncData(updated);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppStrings.prefTotalStarPoints, updated);
    } catch (e, st) {
      AppLogger.error('StarPointsNotifier: failed to save star points', e, st);
    }
  }

  /// Clears stored star points on user logout.
  Future<void> clearPoints() async {
    state = const AsyncData(0);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppStrings.prefTotalStarPoints);
    } catch (e, st) {
      AppLogger.error('StarPointsNotifier: failed to clear star points', e, st);
    }
  }
}

final starPointsNotifierProvider =
    AsyncNotifierProvider<StarPointsNotifier, int>(
  StarPointsNotifier.new,
);
