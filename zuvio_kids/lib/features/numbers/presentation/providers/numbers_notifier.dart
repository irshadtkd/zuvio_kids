import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_session_entity.dart';
import 'package:zuvio_kids/features/numbers/presentation/providers/numbers_state.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'numbers_provider.dart';

/// Riverpod AsyncNotifier managing state and actions for the Numbers learning module.
/// Layer: Presentation
class NumbersNotifier extends AsyncNotifier<NumbersState> {
  @override
  Future<NumbersState> build() async {
    return _fetchInitial();
  }

  Future<NumbersState> _fetchInitial() async {
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final studentName = onboardingState?.name.isNotEmpty == true
        ? onboardingState!.name
        : AppStrings.defaultChildName;

    final getSessionsUseCase = ref.read(getNumberSessionsUseCaseProvider);
    final getProgressUseCase = ref.read(getNumberProgressUseCaseProvider);

    final sessionsResult = await getSessionsUseCase(studentName);
    final progressResult = await getProgressUseCase(studentName);

    final sessions = sessionsResult.fold(
      (failure) {
        AppLogger.error('NumbersNotifier: failed to load sessions', failure);
        return <NumberSessionEntity>[];
      },
      (data) => data,
    );

    final progress = progressResult.fold(
      (failure) {
        AppLogger.error('NumbersNotifier: failed to load progress', failure);
        return null;
      },
      (data) => data,
    );

    return NumbersState(
      studentName: studentName,
      sessions: sessions,
      totalStars: progress?.totalStars ?? 0,
    );
  }

  /// Selects and opens a session for learning.
  /// If incomplete, always starts from the first number (index 0).
  void selectSession(String sessionId) {
    final current = state.valueOrNull;
    if (current == null) return;

    final session = current.sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => current.sessions.first,
    );

    state = AsyncData(current.copyWith(
      activeSession: session,
      currentNumberIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      clearSelectedQuizAnswer: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Sets the active step (0 = Discover, 1 = Practice, 2 = Play).
  void setStep(int stepIndex) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentStep: stepIndex.clamp(0, 2),
      clearSelectedQuizAnswer: true,
      clearIsAnswerCorrect: true,
    ));
  }

  /// Marks the current number tracing activity completed.
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

  /// Handles tapping an answer option in the Play quiz step.
  void onQuizAnswerTapped(int answer) {
    final current = state.valueOrNull;
    if (current == null || current.currentNumber == null) return;

    final isCorrect = answer == current.currentNumber!.correctQuizAnswer;

    state = AsyncData(current.copyWith(
      selectedQuizAnswer: answer,
      isAnswerCorrect: isCorrect,
    ));
  }

  /// Moves to the next step, next number, or completes the session.
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

    // 2: Play -> Next Number or Session Complete
    if (current.currentStep == 2) {
      if (current.isLastNumberInSession) {
        // All 10 numbers in session completed -> grant stars and save
        await completeCurrentSession();
      } else {
        final nextIndex = current.currentNumberIndex + 1;

        state = AsyncData(current.copyWith(
          currentNumberIndex: nextIndex,
          currentStep: 0,
          isTracingComplete: false,
          clearSelectedQuizAnswer: true,
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

    final completeUseCase = ref.read(completeNumberSessionUseCaseProvider);
    final result = await completeUseCase(
      studentName: studentName,
      sessionId: sessionId,
    );

    await result.fold(
      (failure) async {
        AppLogger.error('NumbersNotifier: completeSession failed', failure);
      },
      (progress) async {
        // Refresh session list to update locks and completion status
        final getSessionsUseCase = ref.read(getNumberSessionsUseCaseProvider);
        final sessionsResult = await getSessionsUseCase(studentName);
        final updatedSessions =
            sessionsResult.getOrElse((_) => current.sessions);

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

  /// Replays the current session from the first number (index 0).
  void playAgain() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentNumberIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      clearSelectedQuizAnswer: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Exits back to the numbers sessions hub screen.
  void exitToHub() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      clearActiveSession: true,
      currentNumberIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      clearSelectedQuizAnswer: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Clears all stored numbers progress across all profiles (called on logout).
  Future<void> clearAllProgress() async {
    final clearUseCase = ref.read(clearNumberProgressUseCaseProvider);
    await clearUseCase();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchInitial);
  }
}
