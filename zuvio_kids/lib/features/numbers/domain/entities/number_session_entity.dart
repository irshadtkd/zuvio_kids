import 'number_entity.dart';

/// Entity representing one of the 10 number learning sessions.
/// Layer: Domain (pure Dart)
class NumberSessionEntity {
  const NumberSessionEntity({
    required this.id,
    required this.sessionNumber,
    required this.rangeLabel,
    required this.numbers,
    required this.isCompleted,
    required this.isLocked,
    required this.starsEarned,
    this.currentNumberIndex = 0,
  });

  /// Unique session identifier (e.g. 'session_1', 'session_2', ..., 'session_10')
  final String id;

  /// Sequence number (1 to 10)
  final int sessionNumber;

  /// Range label (e.g. '1-10', '11-20', ..., '91-100')
  final String rangeLabel;

  /// Numbers included in this session (10 numbers)
  final List<NumberEntity> numbers;

  /// Whether this session has been completed
  final bool isCompleted;

  /// Whether this session is locked
  final bool isLocked;

  /// Stars earned from completing this session (0 or 10)
  final int starsEarned;

  /// Last active number index in the session (0-based)
  final int currentNumberIndex;

  NumberSessionEntity copyWith({
    bool? isCompleted,
    bool? isLocked,
    int? starsEarned,
    int? currentNumberIndex,
  }) {
    return NumberSessionEntity(
      id: id,
      sessionNumber: sessionNumber,
      rangeLabel: rangeLabel,
      numbers: numbers,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      starsEarned: starsEarned ?? this.starsEarned,
      currentNumberIndex: currentNumberIndex ?? this.currentNumberIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isCompleted == other.isCompleted &&
          isLocked == other.isLocked &&
          starsEarned == other.starsEarned;

  @override
  int get hashCode => Object.hash(id, isCompleted, isLocked, starsEarned);
}
