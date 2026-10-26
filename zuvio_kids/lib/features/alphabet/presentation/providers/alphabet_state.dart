import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_letter_entity.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_session_entity.dart';

/// Presentation state for Alphabet learning feature.
/// Layer: Presentation
class AlphabetState {
  const AlphabetState({
    required this.studentName,
    required this.sessions,
    required this.totalStars,
    this.activeSession,
    this.currentLetterIndex = 0,
    this.currentStep = 0, // 0 = Discover, 1 = Practice, 2 = Play
    this.isTracingComplete = false,
    this.playStars = 0,
    this.selectedWord,
    this.isAnswerCorrect,
    this.isSessionCompleted = false,
  });

  final String studentName;
  final List<AlphabetSessionEntity> sessions;
  final int totalStars;
  final AlphabetSessionEntity? activeSession;
  final int currentLetterIndex;
  final int currentStep;
  final bool isTracingComplete;
  final int playStars;
  final String? selectedWord;
  final bool? isAnswerCorrect;
  final bool isSessionCompleted;

  AlphabetLetterEntity? get currentLetter {
    if (activeSession == null) return null;
    if (currentLetterIndex < 0 ||
        currentLetterIndex >= activeSession!.letters.length) {
      return null;
    }
    return activeSession!.letters[currentLetterIndex];
  }

  bool get isLastLetterInSession {
    if (activeSession == null) return false;
    return currentLetterIndex >= activeSession!.letters.length - 1;
  }

  AlphabetState copyWith({
    String? studentName,
    List<AlphabetSessionEntity>? sessions,
    int? totalStars,
    AlphabetSessionEntity? activeSession,
    int? currentLetterIndex,
    int? currentStep,
    bool? isTracingComplete,
    int? playStars,
    String? selectedWord,
    bool? isAnswerCorrect,
    bool? isSessionCompleted,
    bool clearActiveSession = false,
    bool clearSelectedWord = false,
    bool clearIsAnswerCorrect = false,
  }) {
    return AlphabetState(
      studentName: studentName ?? this.studentName,
      sessions: sessions ?? this.sessions,
      totalStars: totalStars ?? this.totalStars,
      activeSession:
          clearActiveSession ? null : (activeSession ?? this.activeSession),
      currentLetterIndex: currentLetterIndex ?? this.currentLetterIndex,
      currentStep: currentStep ?? this.currentStep,
      isTracingComplete: isTracingComplete ?? this.isTracingComplete,
      playStars: playStars ?? this.playStars,
      selectedWord:
          clearSelectedWord ? null : (selectedWord ?? this.selectedWord),
      isAnswerCorrect: clearIsAnswerCorrect
          ? null
          : (isAnswerCorrect ?? this.isAnswerCorrect),
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
    );
  }
}
