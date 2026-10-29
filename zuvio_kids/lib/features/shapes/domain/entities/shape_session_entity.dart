import 'shape_entity.dart';

/// Entity representing one of the 4 shape learning sessions.
/// Layer: Domain (pure Dart)
class ShapeSessionEntity {
  const ShapeSessionEntity({
    required this.id,
    required this.sessionNumber,
    required this.title,
    required this.shapes,
    required this.isCompleted,
    required this.isLocked,
    required this.starsEarned,
    this.currentShapeIndex = 0,
  });

  /// Unique session identifier (e.g. 'session_1', 'session_2', etc.)
  final String id;

  /// Sequence number (1 to 4)
  final int sessionNumber;

  /// Short summary title or shapes list (e.g. 'Circle, Square, Triangle')
  final String title;

  /// The 3 shapes contained in this session
  final List<ShapeEntity> shapes;

  /// Whether this session has been completed
  final bool isCompleted;

  /// Whether this session is locked
  final bool isLocked;

  /// Stars earned from completing this session (0 or 10)
  final int starsEarned;

  /// Last active shape index in the session (0-based)
  final int currentShapeIndex;

  ShapeSessionEntity copyWith({
    bool? isCompleted,
    bool? isLocked,
    int? starsEarned,
    int? currentShapeIndex,
  }) {
    return ShapeSessionEntity(
      id: id,
      sessionNumber: sessionNumber,
      title: title,
      shapes: shapes,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      starsEarned: starsEarned ?? this.starsEarned,
      currentShapeIndex: currentShapeIndex ?? this.currentShapeIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isCompleted == other.isCompleted &&
          isLocked == other.isLocked &&
          starsEarned == other.starsEarned;

  @override
  int get hashCode => Object.hash(id, isCompleted, isLocked, starsEarned);
}
