import 'package:zuvio_kids/features/numbers/domain/entities/number_entity.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_session_entity.dart';

/// Presentation state for Numbers learning feature.
/// Layer: Presentation
class NumbersState {
  const NumbersState({
    required this.studentName,
    required this.sessions,
    required this.totalStars,
    this.activeSession,
    this.currentNumberIndex = 0,
    this.currentStep = 0, // 0 = Discover, 1 = Practice, 2 = Play
    this.isTracingComplete = false,
    this.selectedQuizAnswer,
    this.isAnswerCorrect,
    this.isSessionCompleted = false,
  });

  final String studentName;
  final List<NumberSessionEntity> sessions;
  final int totalStars;
  final NumberSessionEntity? activeSession;
  final int currentNumberIndex;
  final int currentStep;
  final bool isTracingComplete;
  final int? selectedQuizAnswer;
  final bool? isAnswerCorrect;
  final bool isSessionCompleted;

  NumberEntity? get currentNumber {
    if (activeSession == null) return null;
    if (currentNumberIndex < 0 ||
        currentNumberIndex >= activeSession!.numbers.length) {
      return null;
    }
    return activeSession!.numbers[currentNumberIndex];
  }

  bool get isLastNumberInSession {
    if (activeSession == null) return false;
    return currentNumberIndex >= activeSession!.numbers.length - 1;
  }

  NumbersState copyWith({
    String? studentName,
    List<NumberSessionEntity>? sessions,
    int? totalStars,
    NumberSessionEntity? activeSession,
    int? currentNumberIndex,
    int? currentStep,
    bool? isTracingComplete,
    int? selectedQuizAnswer,
    bool? isAnswerCorrect,
    bool? isSessionCompleted,
    bool clearActiveSession = false,
    bool clearSelectedQuizAnswer = false,
    bool clearIsAnswerCorrect = false,
  }) {
    return NumbersState(
      studentName: studentName ?? this.studentName,
      sessions: sessions ?? this.sessions,
      totalStars: totalStars ?? this.totalStars,
      activeSession:
          clearActiveSession ? null : (activeSession ?? this.activeSession),
      currentNumberIndex: currentNumberIndex ?? this.currentNumberIndex,
      currentStep: currentStep ?? this.currentStep,
      isTracingComplete: isTracingComplete ?? this.isTracingComplete,
      selectedQuizAnswer: clearSelectedQuizAnswer
          ? null
          : (selectedQuizAnswer ?? this.selectedQuizAnswer),
      isAnswerCorrect: clearIsAnswerCorrect
          ? null
          : (isAnswerCorrect ?? this.isAnswerCorrect),
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
    );
  }
}
