/// Entity tracking the student's completed alphabet sessions and star rewards.
/// Layer: Domain (pure Dart)
class AlphabetProgressEntity {
  const AlphabetProgressEntity({
    required this.studentName,
    required this.completedSessionIds,
    required this.totalStars,
  });

  final String studentName;
  final Set<String> completedSessionIds;
  final int totalStars;

  bool isSessionCompleted(String sessionId) =>
      completedSessionIds.contains(sessionId);

  AlphabetProgressEntity copyWith({
    String? studentName,
    Set<String>? completedSessionIds,
    int? totalStars,
  }) {
    return AlphabetProgressEntity(
      studentName: studentName ?? this.studentName,
      completedSessionIds: completedSessionIds ?? this.completedSessionIds,
      totalStars: totalStars ?? this.totalStars,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlphabetProgressEntity &&
          runtimeType == other.runtimeType &&
          studentName == other.studentName &&
          totalStars == other.totalStars;

  @override
  int get hashCode => Object.hash(studentName, totalStars);
}
