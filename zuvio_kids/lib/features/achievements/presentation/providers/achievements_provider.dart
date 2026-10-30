import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/achievements/data/datasources/badge_datasource.dart';
import 'package:zuvio_kids/features/achievements/domain/entities/badge_entity.dart';

/// Manages achievement badges across all features.
/// Layer: Presentation Provider
class AchievementsNotifier extends AsyncNotifier<List<BadgeEntity>> {
  final _datasource = BadgeDatasource();

  @override
  Future<List<BadgeEntity>> build() => _datasource.loadBadges();

  /// Attempts to unlock badge [id]. Returns true if newly unlocked.
  Future<bool> unlock(String id) async {
    try {
      final wasNew = await _datasource.unlockBadge(id);
      if (wasNew) {
        // Refresh state
        state = AsyncData(await _datasource.loadBadges());
      }
      return wasNew;
    } catch (e, st) {
      AppLogger.error('AchievementsNotifier: unlock failed for $id', e, st);
      return false;
    }
  }

  /// Evaluates and unlocks star-count based badges.
  Future<void> checkStarBadges(int totalStars) async {
    if (totalStars >= 50) await unlock('star_collector');
  }

  /// Clears all achievements (logout).
  Future<void> clearAll() async {
    await _datasource.clearAll();
    state = AsyncData(await _datasource.loadBadges());
  }
}

final achievementsNotifierProvider =
    AsyncNotifierProvider<AchievementsNotifier, List<BadgeEntity>>(
  AchievementsNotifier.new,
);
