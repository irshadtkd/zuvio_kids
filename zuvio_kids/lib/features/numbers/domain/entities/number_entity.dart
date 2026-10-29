/// Entity representing a single number (1–100) and its learning materials.
/// Layer: Domain (pure Dart, zero Flutter dependencies)
class NumberEntity {
  const NumberEntity({
    required this.value,
    required this.wordName,
    required this.quizOptions,
  });

  /// The numeric value (1 to 100)
  final int value;

  /// English word name (e.g. "Seven", "Twenty-one", "One hundred")
  final String wordName;

  /// 3 numeric answer options for the Play quiz step
  final List<int> quizOptions;

  /// The correct quiz answer is always the number's own value
  int get correctQuizAnswer => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberEntity &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
