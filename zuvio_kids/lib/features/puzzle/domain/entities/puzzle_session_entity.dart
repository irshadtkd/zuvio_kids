import 'puzzle_item_entity.dart';

/// Entity representing one of the 4 puzzle sessions.
/// Layer: Domain (pure Dart)
class PuzzleSessionEntity {
  const PuzzleSessionEntity({
    required this.id,
    required this.sessionNumber,
    required this.title,
    required this.instruction,
    required this.shadowItems,
    required this.pictureItems,
    required this.isCompleted,
    required this.isLocked,
    this.variationKey = '',
    this.starsEarned = 0,
  });

  /// Unique session identifier (e.g. 'puzzle_1')
  final String id;

  /// Sequence number (1 to 4)
  final int sessionNumber;

  /// Session title
  final String title;

  /// Instruction text
  final String instruction;

  /// The 3 target shadow items in displayed order
  final List<PuzzleItemEntity> shadowItems;

  /// The 3 selectable/draggable pictures in displayed order
  final List<PuzzleItemEntity> pictureItems;

  /// Whether all 3 shadows in this session have been matched
  final bool isCompleted;

  /// Whether this session is locked
  final bool isLocked;

  /// Unique signature of this puzzle's item combination (e.g. 'shapes:circle,star,triangle')
  final String variationKey;

  /// Stars earned for completing this session
  final int starsEarned;

  PuzzleSessionEntity copyWith({
    bool? isCompleted,
    bool? isLocked,
    String? variationKey,
    int? starsEarned,
  }) {
    return PuzzleSessionEntity(
      id: id,
      sessionNumber: sessionNumber,
      title: title,
      instruction: instruction,
      shadowItems: shadowItems,
      pictureItems: pictureItems,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      variationKey: variationKey ?? this.variationKey,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PuzzleSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
