/// Entity representing stored user progress for Shapes learning.
/// Layer: Domain (pure Dart)
class ShapeProgressEntity {
  const ShapeProgressEntity({
    required this.studentName,
    required this.completedSessionIds,
    required this.unlockedSessionIds,
    required this.totalStars,
  });

  final String studentName;
  final List<String> completedSessionIds;
  final List<String> unlockedSessionIds;
  final int totalStars;

  ShapeProgressEntity copyWith({
    String? studentName,
    List<String>? completedSessionIds,
    List<String>? unlockedSessionIds,
    int? totalStars,
  }) {
    return ShapeProgressEntity(
      studentName: studentName ?? this.studentName,
      completedSessionIds: completedSessionIds ?? this.completedSessionIds,
      unlockedSessionIds: unlockedSessionIds ?? this.unlockedSessionIds,
      totalStars: totalStars ?? this.totalStars,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeProgressEntity &&
          runtimeType == other.runtimeType &&
          studentName == other.studentName &&
          totalStars == other.totalStars;

  @override
  int get hashCode => Object.hash(studentName, totalStars);
}
