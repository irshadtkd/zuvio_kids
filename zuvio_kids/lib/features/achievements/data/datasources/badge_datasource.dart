import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/achievements/domain/entities/badge_entity.dart';

/// Local datasource managing which achievement badges are unlocked.
/// Stores a comma-separated list of unlocked badge IDs in SharedPreferences.
/// Layer: Data Datasource
class BadgeDatasource {
  static const String _prefKey = 'pref_unlocked_badges';

  static const List<BadgeEntity> allBadges = [
    BadgeEntity(
      id: 'animal_explorer',
      emoji: '🐾',
      nameKey: 'achievementAnimalExplorer',
      descriptionKey: 'achievementAnimalExplorer',
    ),
    BadgeEntity(
      id: 'animal_master',
      emoji: '🦁',
      nameKey: 'achievementAnimalMaster',
      descriptionKey: 'achievementAnimalMaster',
    ),
    BadgeEntity(
      id: 'alphabet_star',
      emoji: '📖',
      nameKey: 'achievementAlphabetStar',
      descriptionKey: 'achievementAlphabetStar',
    ),
    BadgeEntity(
      id: 'number_ninja',
      emoji: '🔢',
      nameKey: 'achievementNumberNinja',
      descriptionKey: 'achievementNumberNinja',
    ),
    BadgeEntity(
      id: 'color_artist',
      emoji: '🌈',
      nameKey: 'achievementColorArtist',
      descriptionKey: 'achievementColorArtist',
    ),
    BadgeEntity(
      id: 'shape_finder',
      emoji: '🔷',
      nameKey: 'achievementShapeFinder',
      descriptionKey: 'achievementShapeFinder',
    ),
    BadgeEntity(
      id: 'puzzle_champion',
      emoji: '🧩',
      nameKey: 'achievementPuzzleChampion',
      descriptionKey: 'achievementPuzzleChampion',
    ),
    BadgeEntity(
      id: 'on_fire',
      emoji: '🔥',
      nameKey: 'achievementOnFire',
      descriptionKey: 'achievementOnFire',
    ),
    BadgeEntity(
      id: 'star_collector',
      emoji: '⭐',
      nameKey: 'achievementStarCollector',
      descriptionKey: 'achievementStarCollector',
    ),
  ];

  /// Loads all badges with their unlock state.
  Future<List<BadgeEntity>> loadBadges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefKey) ?? '';
      final unlocked = raw.isEmpty ? <String>{} : raw.split(',').toSet();
      return allBadges
          .map((b) => b.copyWith(isUnlocked: unlocked.contains(b.id)))
          .toList();
    } catch (e, st) {
      AppLogger.error('BadgeDatasource: failed to load badges', e, st);
      return allBadges;
    }
  }

  /// Unlocks a badge by [id]. Returns true if newly unlocked.
  Future<bool> unlockBadge(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefKey) ?? '';
      final unlocked = raw.isEmpty ? <String>{} : raw.split(',').toSet();
      if (unlocked.contains(id)) return false;
      unlocked.add(id);
      await prefs.setString(_prefKey, unlocked.join(','));
      return true;
    } catch (e, st) {
      AppLogger.error('BadgeDatasource: failed to unlock badge $id', e, st);
      return false;
    }
  }

  /// Clears all badge progress (called on logout).
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
    } catch (e) {
      AppLogger.error('BadgeDatasource: failed to clear badges', e);
    }
  }
}
