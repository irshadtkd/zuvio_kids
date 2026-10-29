import '../../domain/entities/animal_entity.dart';
import '../../domain/entities/animal_session_entity.dart';

/// State representation for the Animals learning feature.
/// Layer: Presentation State
class AnimalsState {
  const AnimalsState({
    required this.sessions,
    this.selectedSessionId,
    this.currentAnimalIndex = 0,
    this.isSoundPlaying = false,
  });

  /// All animal sessions
  final List<AnimalSessionEntity> sessions;

  /// Currently selected session ID
  final String? selectedSessionId;

  /// 0-based index of current animal in the active session
  final int currentAnimalIndex;

  /// Whether animal sound is currently actively playing
  final bool isSoundPlaying;

  /// Returns the currently active session
  AnimalSessionEntity? get selectedSession {
    if (selectedSessionId == null) return null;
    try {
      return sessions.firstWhere((s) => s.id == selectedSessionId);
    } catch (_) {
      return null;
    }
  }

  /// Returns the currently active animal in the selected session
  AnimalEntity? get currentAnimal {
    final session = selectedSession;
    if (session == null || session.animals.isEmpty) return null;
    if (currentAnimalIndex < 0 || currentAnimalIndex >= session.animals.length) {
      return session.animals.first;
    }
    return session.animals[currentAnimalIndex];
  }

  /// Total stars earned across animal sessions
  int get totalStars =>
      sessions.fold<int>(0, (sum, s) => sum + s.starsEarned);

  AnimalsState copyWith({
    List<AnimalSessionEntity>? sessions,
    String? selectedSessionId,
    int? currentAnimalIndex,
    bool? isSoundPlaying,
  }) {
    return AnimalsState(
      sessions: sessions ?? this.sessions,
      selectedSessionId: selectedSessionId ?? this.selectedSessionId,
      currentAnimalIndex: currentAnimalIndex ?? this.currentAnimalIndex,
      isSoundPlaying: isSoundPlaying ?? this.isSoundPlaying,
    );
  }
}
