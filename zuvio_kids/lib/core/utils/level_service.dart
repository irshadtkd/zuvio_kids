/// Computes the child's current level name from total star count.
///
/// Levels:
/// 0–15   → Little Learner   🌱
/// 16–35  → Rising Star      🌟
/// 36–60  → Explorer         🚀
/// 61–100 → Learning Hero    🦁
/// 101+   → ZuvioKids Champion 👑
/// Layer: Core Utility
abstract final class LevelService {
  static const int _risingStar = 16;
  static const int _explorer = 36;
  static const int _hero = 61;
  static const int _champion = 101;

  /// Returns the emoji + key for the level at [stars].
  static ({String emoji, String key}) levelAt(int stars) {
    if (stars >= _champion) return (emoji: '👑', key: 'levelChampion');
    if (stars >= _hero) return (emoji: '🦁', key: 'levelHero');
    if (stars >= _explorer) return (emoji: '🚀', key: 'levelExplorer');
    if (stars >= _risingStar) return (emoji: '🌟', key: 'levelRisingStar');
    return (emoji: '🌱', key: 'levelLittleLearner');
  }

  /// Returns 0–1 progress toward the next level threshold.
  static double progressToNextLevel(int stars) {
    if (stars >= _champion) return 1.0;
    if (stars >= _hero) return (stars - _hero) / (_champion - _hero);
    if (stars >= _explorer) return (stars - _explorer) / (_hero - _explorer);
    if (stars >= _risingStar) return (stars - _risingStar) / (_explorer - _risingStar);
    return stars / _risingStar;
  }

  /// Returns true if [newStars] crossed a level boundary compared to [oldStars].
  static bool didLevelUp(int oldStars, int newStars) {
    return levelAt(oldStars).key != levelAt(newStars).key;
  }
}
