/// Type of visual representation for puzzle items.
enum PuzzleItemType {
  shape,
  color,
  alphabet,
  number,
  animal,
}

/// Entity representing one puzzle item (e.g. shape, color, letter, number, or animal).
/// Layer: Domain (pure Dart, no Flutter or json dependencies)
class PuzzleItemEntity {
  const PuzzleItemEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.colorHex,
    this.displayText,
    this.soundKey,
  });

  /// Unique item identifier (e.g. 'circle', 'red', 'letter_A', 'num_7')
  final String id;

  /// User-friendly label (e.g. 'Circle', 'Red', 'A', '7')
  final String name;

  /// Visual type of item
  final PuzzleItemType type;

  /// 32-bit ARGB color integer for the colorful picture
  final int colorHex;

  /// Text to render (e.g. 'A' for letter, '7' for number digit)
  final String? displayText;

  /// Optional sound key (e.g. phonetic letter, animal sound, or word name)
  final String? soundKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PuzzleItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
