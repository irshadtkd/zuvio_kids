import '../../domain/entities/puzzle_session_entity.dart';

/// Immutable presentation state for the puzzle feature.
/// Layer: Presentation State
class PuzzleState {
  const PuzzleState({
    required this.sessions,
    this.currentSessionIndex = 0,
    this.matchedItemIds = const <String, Set<String>>{},
    this.selectedPictureId,
  });

  /// The 4 puzzle sessions.
  final List<PuzzleSessionEntity> sessions;

  /// Index of the active puzzle session (0 to 3).
  final int currentSessionIndex;

  /// Map of sessionId -> set of item IDs successfully matched.
  final Map<String, Set<String>> matchedItemIds;

  /// Currently selected picture ID for tap-to-match interaction.
  final String? selectedPictureId;

  /// Active puzzle session.
  PuzzleSessionEntity get currentSession {
    if (sessions.isEmpty) {
      throw StateError('No puzzle sessions available');
    }
    final safeIndex = currentSessionIndex.clamp(0, sessions.length - 1);
    return sessions[safeIndex];
  }

  /// Whether all items in the active session have been matched.
  bool get isCurrentSessionCompleted {
    if (sessions.isEmpty) return false;
    final current = currentSession;
    final matched = matchedItemIds[current.id] ?? <String>{};
    return current.shadowItems.every((item) => matched.contains(item.id));
  }

  /// Whether all 4 sessions are marked completed.
  bool get areAllSessionsCompleted {
    return sessions.isNotEmpty && sessions.every((s) => s.isCompleted);
  }

  /// Number of matched items in the current session.
  int get currentMatchedCount {
    if (sessions.isEmpty) return 0;
    return (matchedItemIds[currentSession.id] ?? <String>{}).length;
  }

  PuzzleState copyWith({
    List<PuzzleSessionEntity>? sessions,
    int? currentSessionIndex,
    Map<String, Set<String>>? matchedItemIds,
    String? selectedPictureId,
    bool clearSelectedPicture = false,
  }) {
    return PuzzleState(
      sessions: sessions ?? this.sessions,
      currentSessionIndex: currentSessionIndex ?? this.currentSessionIndex,
      matchedItemIds: matchedItemIds ?? this.matchedItemIds,
      selectedPictureId: clearSelectedPicture
          ? null
          : (selectedPictureId ?? this.selectedPictureId),
    );
  }
}
