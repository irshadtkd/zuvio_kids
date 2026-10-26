/// Entity representing a single alphabet letter and its learning data.
/// Layer: Domain (pure Dart, zero Flutter SDK dependencies)
class AlphabetLetterEntity {
  const AlphabetLetterEntity({
    required this.letter,
    required this.displayPair,
    required this.primaryWord,
    required this.phrase,
    required this.supportingWords,
    required this.quizOptions,
    required this.correctQuizIndex,
    required this.isCapital,
  });

  /// The active letter ('A'..'Z' or 'a'..'z')
  final String letter;

  /// Display string (e.g. 'A' for capital sessions, 'a' for small sessions)
  final String displayPair;

  /// Explicit display letter property strictly respecting case
  String get displayLetter => isCapital ? letter.toUpperCase() : letter.toLowerCase();

  /// Primary associated word (e.g. 'Apple')
  final String primaryWord;

  /// Spoken phrase (e.g. 'A for Apple' or 'a for Apple')
  final String phrase;

  /// Supporting words starting with this letter (e.g. ['Apple', 'Ant', 'Aeroplane'])
  final List<String> supportingWords;

  /// Quiz options for Play step (e.g. ['Apple', 'Sun', 'Dog'])
  final List<String> quizOptions;

  /// Index of the correct answer in quizOptions
  final int correctQuizIndex;

  /// Whether this belongs to capital letter sessions
  final bool isCapital;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlphabetLetterEntity &&
          runtimeType == other.runtimeType &&
          letter == other.letter &&
          isCapital == other.isCapital;

  @override
  int get hashCode => Object.hash(letter, isCapital);
}
