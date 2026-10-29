import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import '../../domain/entities/puzzle_item_entity.dart';
import '../../domain/repositories/puzzle_repository.dart';
import '../../domain/usecases/get_puzzle_sessions.dart';
import '../../domain/usecases/save_puzzle_progress.dart';
import 'puzzle_provider.dart';
import 'puzzle_state.dart';

/// Riverpod notifier managing state and actions for the Puzzle Playground.
/// Generates randomized puzzles from Alphabet, Numbers, Colors, and Shapes,
/// avoiding repeating previously completed variations.
/// Layer: Presentation Provider
class PuzzleNotifier extends AsyncNotifier<PuzzleState> {
  late final GetPuzzleSessions _getSessions;
  late final SavePuzzleProgress _saveProgress;
  late final PuzzleRepository _repository;

  @override
  Future<PuzzleState> build() async {
    _repository = ref.watch(puzzleRepositoryProvider);
    _getSessions = GetPuzzleSessions(_repository);
    _saveProgress = SavePuzzleProgress(_repository);

    final result = await _getSessions();
    return result.fold(
      (failure) {
        AppLogger.error('PuzzleNotifier: failed to generate sessions', failure);
        return const PuzzleState(sessions: []);
      },
      (sessions) {
        return PuzzleState(
          sessions: sessions,
        );
      },
    );
  }

  /// Generates a brand-new set of 4 randomized puzzles avoiding completed variations.
  /// Used when starting a new game, opening the puzzle section, or tapping "Play Again".
  Future<void> generateNewSet() async {
    state = const AsyncLoading();
    final result = await _getSessions();
    result.fold(
      (failure) {
        AppLogger.error('PuzzleNotifier: failed to generate new puzzle set', failure);
      },
      (sessions) {
        state = AsyncData(PuzzleState(
          sessions: sessions,
        ));
      },
    );
  }

  /// Changes the currently active puzzle session (0 to 3).
  void selectSession(int index) {
    final current = state.valueOrNull;
    if (current == null || index < 0 || index >= current.sessions.length) return;
    state = AsyncData(current.copyWith(
      currentSessionIndex: index,
      clearSelectedPicture: true,
    ));
  }

  /// Selects or deselects a picture for tap-to-match interaction.
  void selectPicture(String? itemId) {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.selectedPictureId == itemId) {
      state = AsyncData(current.copyWith(clearSelectedPicture: true));
    } else {
      state = AsyncData(current.copyWith(selectedPictureId: itemId));
    }
  }

  /// Attempts to match a picture with a target shadow slot.
  /// Returns `true` if correct, `false` if mismatch.
  bool tryMatch(String targetItemId, String candidateItemId) {
    final current = state.valueOrNull;
    if (current == null) return false;

    final sessionId = current.currentSession.id;
    final currentMatched = Set<String>.from(
      current.matchedItemIds[sessionId] ?? <String>{},
    );

    // If target already matched, ignore
    if (currentMatched.contains(targetItemId)) return false;

    if (targetItemId.toLowerCase() == candidateItemId.toLowerCase()) {
      // Correct match!
      currentMatched.add(targetItemId);

      final updatedMatchedMap = Map<String, Set<String>>.from(current.matchedItemIds)
        ..[sessionId] = currentMatched;

      // Speak educational voice for the matched item
      final matchedItem = current.currentSession.pictureItems
          .where((it) => it.id == candidateItemId)
          .firstOrNull;

      if (matchedItem != null) {
        _playMatchedItemSound(matchedItem);
      }

      // Check if all 3 items are now matched in this session
      final isNowComplete = current.currentSession.shadowItems
          .every((it) => currentMatched.contains(it.id));

      var updatedSessions = current.sessions;
      if (isNowComplete) {
        updatedSessions = current.sessions.map((s) {
          if (s.id == sessionId) {
            return s.copyWith(isCompleted: true, starsEarned: 10);
          }
          return s;
        }).toList();

        // Persist completed variation signature so it's not repeated
        if (current.currentSession.variationKey.isNotEmpty) {
          _saveProgress(current.currentSession.variationKey);
        }

        // If all 4 sessions are now completed, award 10 star points!
        if (updatedSessions.every((s) => s.isCompleted)) {
          ref.read(starPointsNotifierProvider.notifier).awardPoints();
        }
      }

      state = AsyncData(current.copyWith(
        sessions: updatedSessions,
        matchedItemIds: updatedMatchedMap,
        clearSelectedPicture: true,
      ));

      return true;
    } else {
      // Mismatch
      state = AsyncData(current.copyWith(clearSelectedPicture: true));
      return false;
    }
  }

  void _playMatchedItemSound(PuzzleItemEntity item) {
    final sound = KidSoundService.instance;
    switch (item.type) {
      case PuzzleItemType.alphabet:
        sound.speakLetter(item.name);
        break;
      case PuzzleItemType.number:
      case PuzzleItemType.color:
      case PuzzleItemType.shape:
        sound.speak(item.soundKey ?? item.name);
        break;
      case PuzzleItemType.animal:
        if (item.soundKey != null) {
          sound.playAnimalSound(item.soundKey!);
        } else {
          sound.speak(item.name);
        }
        break;
    }
  }

  /// Advances to the next session, or returns `true` if all 4 sessions are complete.
  bool nextSession() {
    final current = state.valueOrNull;
    if (current == null) return false;

    if (current.currentSessionIndex < current.sessions.length - 1) {
      selectSession(current.currentSessionIndex + 1);
      return false;
    }
    return true; // Reached end of sessions
  }

  /// Resets matched items for the active session so the child can replay the current puzzle.
  void playAgain() {
    final current = state.valueOrNull;
    if (current == null) return;

    final sessionId = current.currentSession.id;
    final updatedMatched = Map<String, Set<String>>.from(current.matchedItemIds)
      ..remove(sessionId);

    state = AsyncData(current.copyWith(
      matchedItemIds: updatedMatched,
      clearSelectedPicture: true,
    ));
  }

  /// Clears all puzzle completion progress and variation history (e.g. on user logout).
  Future<void> clearAllProgress() async {
    await _repository.clearProgress();
    await generateNewSet();
  }
}
