import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_data.dart';
import 'package:zuvio_kids/features/colors/presentation/providers/colors_state.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'colors_provider.dart';

/// Riverpod AsyncNotifier managing state and actions for the Colors learning module.
/// Layer: Presentation
class ColorsNotifier extends AsyncNotifier<ColorsState> {
  @override
  Future<ColorsState> build() async {
    return _fetchInitial();
  }

  Future<ColorsState> _fetchInitial() async {
    final onboardingState = ref.read(onboardingNotifierProvider).valueOrNull;
    final studentName = onboardingState?.name.isNotEmpty == true
        ? onboardingState!.name
        : AppStrings.defaultChildName;

    final getSessionUseCase = ref.read(getColorSessionUseCaseProvider);
    final getProgressUseCase = ref.read(getColorProgressUseCaseProvider);

    final sessionResult = await getSessionUseCase(studentName);
    final progressResult = await getProgressUseCase(studentName);

    final session = sessionResult.fold(
      (failure) {
        AppLogger.error('ColorsNotifier: failed to load session', failure);
        return ColorData.defaultSession;
      },
      (data) => data,
    );

    final progress = progressResult.fold(
      (failure) {
        AppLogger.error('ColorsNotifier: failed to load progress', failure);
        return null;
      },
      (data) => data,
    );

    return ColorsState(
      studentName: studentName,
      session: session,
      totalStars: progress?.totalStars ?? 0,
    );
  }

  /// Sets the active step (0 = Discover, 1 = Paint).
  void setStep(int stepIndex) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentStep: stepIndex.clamp(0, 1),
      currentColorIndex: 0,
      clearSelectedPaletteColor: true,
      clearAppliedColor: true,
      clearIsPaintCorrect: true,
    ));
  }

  /// Selects a color swatch from the palette and immediately applies it to the object.
  void selectPaletteColor(int colorValue) {
    final current = state.valueOrNull;
    if (current == null) return;

    final isCorrect = colorValue == current.currentColor.colorValue;

    state = AsyncData(current.copyWith(
      selectedPaletteColorValue: colorValue,
      appliedColorValue: colorValue,
      isPaintCorrect: isCorrect,
    ));

    if (isCorrect) {
      KidSoundService.instance.speak(
        'Awesome! You painted it ${current.currentColor.name}!',
      );
    } else {
      KidSoundService.instance.speak('Try again!');
    }
  }

  /// Applies the selected color onto the object and evaluates correctness.
  void paintObject() {
    final current = state.valueOrNull;
    if (current == null) return;

    final selectedColor = current.selectedPaletteColorValue;
    if (selectedColor == null) return;

    final isCorrect = selectedColor == current.currentColor.colorValue;

    state = AsyncData(current.copyWith(
      appliedColorValue: selectedColor,
      isPaintCorrect: isCorrect,
    ));

    if (isCorrect) {
      KidSoundService.instance.speak(
        'Awesome! You painted it ${current.currentColor.name}!',
      );
    } else {
      KidSoundService.instance.speak('Try again!');
    }
  }

  /// Clears the applied color and resets validation so child can paint again.
  void resetPaint() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      clearSelectedPaletteColor: true,
      clearAppliedColor: true,
      clearIsPaintCorrect: true,
    ));
  }

  /// Moves to the next color in the current step, or to the next step,
  /// or completes the session.
  Future<void> nextStep() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final totalColors = current.session.colors.length;

    // Step 0: Color Recognition (7 colors)
    if (current.currentStep == 0) {
      if (current.currentColorIndex < totalColors - 1) {
        state = AsyncData(current.copyWith(
          currentColorIndex: current.currentColorIndex + 1,
        ));
      } else {
        // Completed all 7 colors in Color Recognition -> Move to Step 1 (Drawing and Coloring)
        state = AsyncData(current.copyWith(
          currentStep: 1,
          currentColorIndex: 0,
          clearSelectedPaletteColor: true,
          clearAppliedColor: true,
          clearIsPaintCorrect: true,
        ));
      }
      return;
    }

    // Step 1: Drawing and Coloring (7 colors/objects)
    if (current.currentStep == 1) {
      if (current.currentColorIndex < totalColors - 1) {
        state = AsyncData(current.copyWith(
          currentColorIndex: current.currentColorIndex + 1,
          clearSelectedPaletteColor: true,
          clearAppliedColor: true,
          clearIsPaintCorrect: true,
        ));
      } else {
        // Completed all 7 objects in Drawing and Coloring -> Session Complete!
        await completeCurrentSession();
      }
    }
  }

  /// Completes the Colors session and grants +10 stars.
  Future<void> completeCurrentSession() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final studentName = current.studentName;
    final completeUseCase = ref.read(completeColorSessionUseCaseProvider);
    final result = await completeUseCase(studentName);

    await result.fold(
      (failure) async {
        AppLogger.error('ColorsNotifier: completeSession failed', failure);
      },
      (progress) async {
        // Award star points for completing session
        await ref.read(starPointsNotifierProvider.notifier).awardPoints();

        state = AsyncData(current.copyWith(
          totalStars: progress.totalStars,
          isSessionCompleted: true,
        ));
      },
    );
  }

  /// Replays the Colors session from the first color.
  void playAgain() {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      currentColorIndex: 0,
      currentStep: 0,
      clearSelectedPaletteColor: true,
      clearAppliedColor: true,
      clearIsPaintCorrect: true,
      isSessionCompleted: false,
    ));
  }

  /// Clears all stored colors learning data (called on logout).
  Future<void> clearAllProgress() async {
    final clearUseCase = ref.read(clearColorProgressUseCaseProvider);
    await clearUseCase();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchInitial);
  }
}
