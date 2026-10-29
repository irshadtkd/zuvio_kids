import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_session_entity.dart';
import 'package:zuvio_kids/features/shapes/presentation/providers/shapes_state.dart';
import 'shapes_provider.dart';

/// Riverpod AsyncNotifier managing state and actions for the Shapes learning module.
/// Layer: Presentation
class ShapesNotifier extends AsyncNotifier<ShapesState> {
  @override
  Future<ShapesState> build() async {
    return _fetchInitial();
  }

  Future<ShapesState> _fetchInitial() async {
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final studentName = onboardingState?.name.isNotEmpty == true
        ? onboardingState!.name
        : AppStrings.defaultChildName;

    final getSessionsUseCase = ref.read(getShapeSessionsUseCaseProvider);
    final getProgressUseCase = ref.read(getShapeProgressUseCaseProvider);

    final sessionsResult = await getSessionsUseCase(studentName);
    final progressResult = await getProgressUseCase(studentName);

    final sessions = sessionsResult.fold(
      (failure) {
        AppLogger.error('ShapesNotifier: failed to load sessions', failure);
        return <ShapeSessionEntity>[];
      },
      (data) => data,
    );

    final progress = progressResult.fold(
      (failure) {
        AppLogger.error('ShapesNotifier: failed to load progress', failure);
        return null;
      },
      (data) => data,
    );

    return ShapesState(
      studentName: studentName,
      sessions: sessions,
      totalStars: progress?.totalStars ?? 0,
    );
  }

  /// Selects and opens a session for learning.
  /// Incomplete sessions always start from the first shape (index 0).
  void selectSession(String sessionId) {
    final current = state.valueOrNull;
    if (current == null) return;

    final session = current.sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => current.sessions.first,
    );

    state = AsyncData(current.copyWith(
      activeSession: session,
      currentShapeIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      clearSelectedMatchingOption: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Sets the active step (0 = Discover, 1 = Practice, 2 = Matching).
  void setStep(int stepIndex) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentStep: stepIndex.clamp(0, 2),
      clearSelectedMatchingOption: true,
      clearIsAnswerCorrect: true,
    ));
  }

  /// Marks tracing completed.
  void markTracingComplete() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isTracingComplete: true));
  }

  /// Resets tracing so the child can trace again.
  void resetTracing() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(isTracingComplete: false));
  }

  /// Handles tapping a shape option in the Matching step.
  void onMatchingOptionTapped(String selectedShapeId) {
    final current = state.valueOrNull;
    if (current == null || current.currentShape == null) return;

    final isCorrect = selectedShapeId == current.currentShape!.id;

    state = AsyncData(current.copyWith(
      selectedMatchingOption: selectedShapeId,
      isAnswerCorrect: isCorrect,
    ));
  }

  /// Moves to the next step, next shape, or completes the session.
  Future<void> nextStep() async {
    final current = state.valueOrNull;
    if (current == null || current.activeSession == null) return;

    // 0: Discover -> 1: Practice
    if (current.currentStep == 0) {
      setStep(1);
      return;
    }

    // 1: Practice -> 2: Matching
    if (current.currentStep == 1) {
      setStep(2);
      return;
    }

    // 2: Matching -> Next Shape or Complete Session
    if (current.currentStep == 2) {
      if (current.isLastShapeInSession) {
        await completeCurrentSession();
      } else {
        final nextIndex = current.currentShapeIndex + 1;
        state = AsyncData(current.copyWith(
          currentShapeIndex: nextIndex,
          currentStep: 0,
          isTracingComplete: false,
          clearSelectedMatchingOption: true,
          clearIsAnswerCorrect: true,
        ));
      }
    }
  }

  /// Completes the active session, awards 10 stars and unlocks the next session.
  Future<void> completeCurrentSession() async {
    final current = state.valueOrNull;
    if (current == null || current.activeSession == null) return;

    final studentName = current.studentName;
    final sessionId = current.activeSession!.id;

    final completeUseCase = ref.read(completeShapeSessionUseCaseProvider);
    final result = await completeUseCase(studentName, sessionId);

    await result.fold(
      (failure) async {
        AppLogger.error('ShapesNotifier: completeSession failed', failure);
      },
      (_) async {
        // Refresh session list and progress
        final getSessionsUseCase = ref.read(getShapeSessionsUseCaseProvider);
        final getProgressUseCase = ref.read(getShapeProgressUseCaseProvider);

        final sessionsResult = await getSessionsUseCase(studentName);
        final progressResult = await getProgressUseCase(studentName);

        final updatedSessions =
            sessionsResult.getOrElse((_) => current.sessions);
        final updatedStars = progressResult.map((p) => p.totalStars).getOrElse((_) => current.totalStars);

        // Award star points for completing session
        await ref.read(starPointsNotifierProvider.notifier).awardPoints();

        state = AsyncData(current.copyWith(
          sessions: updatedSessions,
          totalStars: updatedStars,
          isSessionCompleted: true,
        ));
      },
    );
  }

  /// Replays the current session from the first shape (index 0).
  void playAgain() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentShapeIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      clearSelectedMatchingOption: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Exits back to the shapes sessions hub screen.
  void exitToHub() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      clearActiveSession: true,
      currentShapeIndex: 0,
      currentStep: 0,
      isTracingComplete: false,
      clearSelectedMatchingOption: true,
      clearIsAnswerCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Clears all stored shapes progress across all profiles (called on logout).
  Future<void> clearAllProgress() async {
    final clearUseCase = ref.read(clearShapeProgressUseCaseProvider);
    await clearUseCase();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchInitial);
  }
}
