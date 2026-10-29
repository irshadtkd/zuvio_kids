import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'animals_provider.dart';
import 'animals_state.dart';

/// Riverpod AsyncNotifier managing Animal Learning sessions, navigation, and audio playback.
/// Layer: Presentation Notifier
class AnimalsNotifier extends AsyncNotifier<AnimalsState> {
  @override
  Future<AnimalsState> build() async {
    return _loadSessions();
  }

  Future<AnimalsState> _loadSessions() async {
    final useCase = ref.read(getAnimalSessionsUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) {
        AppLogger.error('AnimalsNotifier: failed to fetch sessions', failure);
        return const AnimalsState(sessions: []);
      },
      (sessions) {
        final currentSelectedId = state.valueOrNull?.selectedSessionId ??
            (sessions.isNotEmpty ? sessions.first.id : null);
        final currentIndex = state.valueOrNull?.currentAnimalIndex ?? 0;
        return AnimalsState(
          sessions: sessions,
          selectedSessionId: currentSelectedId,
          currentAnimalIndex: currentIndex,
        );
      },
    );
  }

  /// Selects a learning session and resets to the first animal.
  void selectSession(String sessionId) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      selectedSessionId: sessionId,
      currentAnimalIndex: 0,
      isSoundPlaying: false,
    ));

    // Automatically trigger the sound of the first animal on entering
    playCurrentAnimalSound();
  }

  /// Plays the current animal sound and silences any ongoing speech/audio.
  Future<void> playCurrentAnimalSound() async {
    final current = state.valueOrNull;
    final animal = current?.currentAnimal;
    if (animal == null) return;

    try {
      state = AsyncData(current!.copyWith(isSoundPlaying: true));
      await KidSoundService.instance.playAnimalSound(animal.soundAssetId);
    } catch (e, st) {
      AppLogger.error('AnimalsNotifier: playCurrentAnimalSound failed', e, st);
    } finally {
      final updated = state.valueOrNull;
      if (updated != null) {
        state = AsyncData(updated.copyWith(isSoundPlaying: false));
      }
    }
  }

  /// Speaks the animal name aloud using TTS for reinforcement.
  Future<void> speakCurrentAnimalName() async {
    final animal = state.valueOrNull?.currentAnimal;
    if (animal == null) return;
    try {
      await KidSoundService.instance.speak(animal.englishName);
    } catch (e, st) {
      AppLogger.error('AnimalsNotifier: speakCurrentAnimalName failed', e, st);
    }
  }

  /// Advances to the next animal or marks session complete if at the last item.
  /// Returns `true` if the session was completed and congratulations should be shown.
  Future<bool> nextAnimal() async {
    final current = state.valueOrNull;
    if (current == null || current.selectedSession == null) return false;

    final session = current.selectedSession!;
    final nextIndex = current.currentAnimalIndex + 1;

    if (nextIndex < session.animals.length) {
      state = AsyncData(current.copyWith(currentAnimalIndex: nextIndex));
      await playCurrentAnimalSound();
      return false;
    }

    // Completed last animal in the session!
    await _completeSession(session.id);
    return true;
  }

  /// Moves back to the previous animal in the current session.
  void previousAnimal() {
    final current = state.valueOrNull;
    if (current == null || current.currentAnimalIndex <= 0) return;

    final prevIndex = current.currentAnimalIndex - 1;
    state = AsyncData(current.copyWith(currentAnimalIndex: prevIndex));
    playCurrentAnimalSound();
  }

  /// Jumps directly to a specific animal index in the active session.
  void jumpToAnimal(int index) {
    final current = state.valueOrNull;
    if (current == null || current.selectedSession == null) return;

    final maxIndex = current.selectedSession!.animals.length - 1;
    final target = index.clamp(0, maxIndex);
    if (target != current.currentAnimalIndex) {
      state = AsyncData(current.copyWith(currentAnimalIndex: target));
      playCurrentAnimalSound();
    }
  }

  /// Completes session, persists progress, and awards 5 stars.
  Future<void> _completeSession(String sessionId) async {
    final saveUseCase = ref.read(saveAnimalSessionProgressUseCaseProvider);
    await saveUseCase(sessionId, 5);

    // Award 5 stars to user total
    await ref.read(starPointsNotifierProvider.notifier).awardPoints(5);

    // Reload sessions to update completed / unlocked states
    final updatedState = await _loadSessions();
    state = AsyncData(updatedState.copyWith(selectedSessionId: sessionId));
  }

  /// Clears all animal progress and reloads default state.
  Future<void> clearAllProgress() async {
    final resetUseCase = ref.read(resetAnimalsProgressUseCaseProvider);
    await resetUseCase();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadSessions);
  }

  /// Refreshes state.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadSessions);
  }
}
