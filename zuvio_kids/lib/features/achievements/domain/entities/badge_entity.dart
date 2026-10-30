/// Represents a single achievement badge the child can earn.
/// Layer: Domain Entity
class BadgeEntity {
  const BadgeEntity({
    required this.id,
    required this.emoji,
    required this.nameKey,
    required this.descriptionKey,
    this.isUnlocked = false,
  });

  final String id;
  final String emoji;
  /// ARB key for the badge name (e.g. 'achievementAnimalExplorer').
  final String nameKey;
  /// ARB key for a short description of how to earn it.
  final String descriptionKey;
  final bool isUnlocked;

  BadgeEntity copyWith({bool? isUnlocked}) => BadgeEntity(
        id: id,
        emoji: emoji,
        nameKey: nameKey,
        descriptionKey: descriptionKey,
        isUnlocked: isUnlocked ?? this.isUnlocked,
      );
}
