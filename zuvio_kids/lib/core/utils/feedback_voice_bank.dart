import 'dart:math';

/// Provides randomised, encouraging voice feedback phrases for kid interactions.
///
/// Use [randomCorrect] to get a phrase for correct answers, and
/// [randomEncourage] for gentle wrong-answer support.
/// Layer: Core Utility
abstract final class FeedbackVoiceBank {
  static final _rng = Random();

  static const List<String> _correctPhrases = [
    'Yes! That is right! You are so smart!',
    'Woohoo! Amazing answer!',
    'Brilliant! Give yourself a clap!',
    'Perfect! You are a genius!',
    'Incredible! Fantastic job!',
    'Super! You got it!',
    'Excellent! Way to go!',
  ];

  static const List<String> _encouragePhrases = [
    'Almost! Have another look!',
    'Hmm, let us try again — you can do it!',
    'Do not worry, try once more!',
    'Keep going! You are almost there!',
    'Good try! Have another go!',
  ];

  static const List<String> _celebrationPhrases = [
    'Amazing! You did it! You are a superstar!',
    'Wow! You finished the whole session! Incredible!',
    'You are on fire! Brilliant work today!',
    'Look at you go! You are a real champion!',
  ];

  /// Returns a random encouraging correct-answer phrase.
  static String randomCorrect() =>
      _correctPhrases[_rng.nextInt(_correctPhrases.length)];

  /// Returns a random gentle wrong-answer encouragement phrase.
  static String randomEncourage() =>
      _encouragePhrases[_rng.nextInt(_encouragePhrases.length)];

  /// Returns a random session-completion celebration phrase.
  static String randomCelebration() =>
      _celebrationPhrases[_rng.nextInt(_celebrationPhrases.length)];
}
