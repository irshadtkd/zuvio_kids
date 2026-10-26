import 'alphabet_letter_entity.dart';

/// Entity representing one of the 4 learning sessions.
/// Layer: Domain (pure Dart)
class AlphabetSessionEntity {
  const AlphabetSessionEntity({
    required this.id,
    required this.sessionNumber,
    required this.isCapital,
    required this.letterRange,
    required this.letters,
    required this.isCompleted,
    required this.isLocked,
    required this.starsEarned,
    this.currentLetterIndex = 0,
  });

  /// Unique session identifier (e.g. 'capital_1', 'capital_2', 'small_3', 'small_4')
  final String id;

  /// Session sequence number (1, 2, 3, or 4)
  final int sessionNumber;

  /// Whether capital letters or small letters
  final bool isCapital;

  /// Letter range label (e.g. 'A–L', 'M–Z', 'a–l', 'm–z')
  final String letterRange;

  /// All letters in this session
  final List<AlphabetLetterEntity> letters;

  /// Whether this session has been completed
  final bool isCompleted;

  /// Whether this session is locked (must complete prior session first)
  final bool isLocked;

  /// Stars earned from completing this session (0 or 10)
  final int starsEarned;

  /// Last active letter index (0-based)
  final int currentLetterIndex;

  AlphabetSessionEntity copyWith({
    bool? isCompleted,
    bool? isLocked,
    int? starsEarned,
    int? currentLetterIndex,
  }) {
    return AlphabetSessionEntity(
      id: id,
      sessionNumber: sessionNumber,
      isCapital: isCapital,
      letterRange: letterRange,
      letters: letters,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      starsEarned: starsEarned ?? this.starsEarned,
      currentLetterIndex: currentLetterIndex ?? this.currentLetterIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlphabetSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isCompleted == other.isCompleted &&
          isLocked == other.isLocked &&
          starsEarned == other.starsEarned;

  @override
  int get hashCode => Object.hash(id, isCompleted, isLocked, starsEarned);
}
