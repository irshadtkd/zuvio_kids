import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/core/utils/streak_service.dart';

/// Manages the child's daily learning streak count.
/// Auto-updates on first read each session.
/// Layer: Core Provider
class StreakNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    return StreakService.instance.checkAndUpdateStreak();
  }

  /// Refreshes the streak (call after completing a session).
  Future<int> refresh() async {
    final streak = await StreakService.instance.checkAndUpdateStreak();
    state = AsyncData(streak);
    return streak;
  }

  /// Clears streak data (call on logout).
  Future<void> clear() async {
    try {
      await StreakService.instance.clear();
      state = const AsyncData(0);
    } catch (e, st) {
      AppLogger.error('StreakNotifier: failed to clear', e, st);
    }
  }
}

final streakNotifierProvider = AsyncNotifierProvider<StreakNotifier, int>(
  StreakNotifier.new,
);
