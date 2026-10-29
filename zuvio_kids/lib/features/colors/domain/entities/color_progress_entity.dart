/// Entity tracking completion and stars earned for Colors learning module.
/// Layer: Domain (pure Dart)
class ColorProgressEntity {
  const ColorProgressEntity({
    required this.studentName,
    required this.isCompleted,
    required this.totalStars,
  });

  final String studentName;
  final bool isCompleted;
  final int totalStars;

  ColorProgressEntity copyWith({
    String? studentName,
    bool? isCompleted,
    int? totalStars,
  }) {
    return ColorProgressEntity(
      studentName: studentName ?? this.studentName,
      isCompleted: isCompleted ?? this.isCompleted,
      totalStars: totalStars ?? this.totalStars,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorProgressEntity &&
          runtimeType == other.runtimeType &&
          studentName == other.studentName &&
          isCompleted == other.isCompleted &&
          totalStars == other.totalStars;

  @override
  int get hashCode => Object.hash(studentName, isCompleted, totalStars);
}
