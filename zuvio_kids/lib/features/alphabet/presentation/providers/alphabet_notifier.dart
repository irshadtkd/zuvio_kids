import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_session_entity.dart';
import 'package:zuvio_kids/features/alphabet/presentation/providers/alphabet_state.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'alphabet_provider.dart';

/// Riverpod AsyncNotifier managing the state and actions of Alphabet learning module.
/// Layer: Presentation
class AlphabetNotifier extends AsyncNotifier<AlphabetState> {
  @override
  Future<AlphabetState> build() async {
    return _fetchInitial();
  }

  Future<AlphabetState> _fetchInitial() async {
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final studentName = onboardingState?.name.isNotEmpty == true
        ? onboardingState!.name
        : AppStrings.defaultChildName;

    final getSessionsUseCase = ref.read(getAlphabetSessionsUseCaseProvider);
    final getProgressUseCase = ref.read(getAlphabetProgressUseCaseProvider);

    final sessionsResult = await getSessionsUseCase(studentName);
    final progressResult = await getProgressUseCase(studentName);

    final sessions = sessionsResult.fold(
      (failure) {
        AppLogger.error('AlphabetNotifier: failed to load sessions', failure);
        return <AlphabetSessionEntity>[];
      },
      (data) => data,
    );

    final progress = progressResult.fold(
      (failure) {
        AppLogger.error('AlphabetNotifier: failed to load progress', failure);
        return null;
      },
      (data) => data,
    );

    return AlphabetState(
      studentName: studentName,
      sessions: sessions,
      totalStars: progress?.totalStars ?? 0,
    );
  }

  /// Selects and opens a session for learning.
  /// An incomplete session always starts from its first letter (index 0).
  void selectSession(String sessionId) {
    final current = state.valueOrNull;
    if (current == null) return;

    final session = current.sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => current.sessions.first,
    );

    state = AsyncData(current.copyWith(
      activeSession: session,
      currentLetterIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      playStars: 0,
      clearSelectedWord: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Sets the active step tab (0 = Discover, 1 = Practice, 2 = Play).
  void setStep(int stepIndex) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentStep: stepIndex.clamp(0, 2),
      clearSelectedWord: true,
      clearIsAnswerCorrect: true,
    ));
  }

  /// Marks the current letter tracing activity completed.
  void markTracingComplete() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isTracingComplete: true));
  }

  /// Resets the tracing completion state so the child can trace again.
  void resetTracing() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isTracingComplete: false));
  }

  /// Handles tapping a word in Play step.
  void onWordTapped(String word) {
    final current = state.valueOrNull;
    if (current == null || current.currentLetter == null) return;

    final letter = current.currentLetter!;
    final isCorrect =
        word.toLowerCase().startsWith(letter.letter.toLowerCase());

    final newStars =
        isCorrect ? (current.playStars + 1).clamp(0, 3) : current.playStars;

    state = AsyncData(current.copyWith(
      selectedWord: word,
      isAnswerCorrect: isCorrect,
      playStars: newStars,
    ));
  }

  /// Moves to the next step, next letter, or completes the session.
  Future<void> nextStep() async {
    final current = state.valueOrNull;
    if (current == null || current.activeSession == null) return;

    // 0: Discover -> 1: Practice
    if (current.currentStep == 0) {
      setStep(1);
      return;
    }

    // 1: Practice -> 2: Play
    if (current.currentStep == 1) {
      setStep(2);
      return;
    }

    // 2: Play -> Next Letter or Session Complete
    if (current.currentStep == 2) {
      if (current.isLastLetterInSession) {
        // Automatically mark completed & persist immediately to local storage
        await completeCurrentSession();
      } else {
        final nextIndex = current.currentLetterIndex + 1;

        // Progress within session is kept only in memory during the active session.
        // It restarts from 0 if the user exits/closes before finishing.
        state = AsyncData(current.copyWith(
          currentLetterIndex: nextIndex,
          currentStep: 0,
          isTracingComplete: false,
          playStars: 0,
          clearSelectedWord: true,
          clearIsAnswerCorrect: true,
        ));
      }
    }
  }

  /// Completes the active session and grants +10 stars.
  Future<void> completeCurrentSession() async {
    final current = state.valueOrNull;
    if (current == null || current.activeSession == null) return;

    final studentName = current.studentName;
    final sessionId = current.activeSession!.id;

    final completeUseCase = ref.read(completeAlphabetSessionUseCaseProvider);
    final result = await completeUseCase(
      studentName: studentName,
      sessionId: sessionId,
    );

    result.fold(
      (failure) {
        AppLogger.error('AlphabetNotifier: completeSession failed', failure);
      },
      (progress) async {
        // Refresh session list to update locks and completion status
        final getSessionsUseCase = ref.read(getAlphabetSessionsUseCaseProvider);
        final sessionsResult = await getSessionsUseCase(studentName);
        final updatedSessions = sessionsResult.getOrElse((_) => current.sessions);

        // Award star points for completing session
        await ref.read(starPointsNotifierProvider.notifier).awardPoints();

        state = AsyncData(current.copyWith(
          sessions: updatedSessions,
          totalStars: progress.totalStars,
          isSessionCompleted: true,
        ));
      },
    );
  }

  /// Restarts the session from the first letter.
  void playAgain(String sessionId) {
    selectSession(sessionId);
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentLetterIndex: 0,
      currentStep: 0,
      isSessionCompleted: false,
      isTracingComplete: false,
      playStars: 0,
      clearSelectedWord: true,
      clearIsAnswerCorrect: true,
    ));
  }

  /// Clears active session and returns to session hub.
  void exitToHub() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      clearActiveSession: true,
      isSessionCompleted: false,
      currentStep: 0,
    ));
  }

  /// Clears all saved alphabet progress and resets state (called on student logout/profile reset).
  Future<void> clearAllProgress() async {
    final clearUseCase = ref.read(clearAlphabetProgressUseCaseProvider);
    await clearUseCase();

    final getSessionsUseCase = ref.read(getAlphabetSessionsUseCaseProvider);
    final onboardingState = ref.read(onboardingNotifierProvider).valueOrNull;
    final studentName = onboardingState?.name.isNotEmpty == true
        ? onboardingState!.name
        : AppStrings.defaultChildName;

    final sessionsResult = await getSessionsUseCase(studentName);
    final freshSessions = sessionsResult.getOrElse((_) => []);

    state = AsyncData(AlphabetState(
      studentName: studentName,
      sessions: freshSessions,
      totalStars: 0,
    ));
  }
}
