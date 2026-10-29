/// Entity tracking the student's completed numbers sessions and star rewards.
/// Layer: Domain (pure Dart)
class NumberProgressEntity {
  const NumberProgressEntity({
    required this.studentName,
    required this.completedSessionIds,
    required this.totalStars,
  });

  final String studentName;
  final Set<String> completedSessionIds;
  final int totalStars;

  bool isSessionCompleted(String sessionId) =>
      completedSessionIds.contains(sessionId);

  NumberProgressEntity copyWith({
    String? studentName,
    Set<String>? completedSessionIds,
    int? totalStars,
  }) {
    return NumberProgressEntity(
      studentName: studentName ?? this.studentName,
      completedSessionIds: completedSessionIds ?? this.completedSessionIds,
      totalStars: totalStars ?? this.totalStars,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberProgressEntity &&
          runtimeType == other.runtimeType &&
          studentName == other.studentName &&
          totalStars == other.totalStars;

  @override
  int get hashCode => Object.hash(studentName, totalStars);
}
