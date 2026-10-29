import 'animal_entity.dart';

/// Domain entity representing one of the 2 Animal Learning Sessions.
/// Layer: Domain (pure Dart, zero Flutter dependencies)
class AnimalSessionEntity {
  const AnimalSessionEntity({
    required this.id,
    required this.sessionNumber,
    required this.titleKey,
    required this.subtitleKey,
    required this.animals,
    required this.isCompleted,
    required this.isLocked,
    required this.starsEarned,
    this.currentAnimalIndex = 0,
  });

  /// Unique session identifier (e.g. 'animals_session_1', 'animals_session_2')
  final String id;

  /// Session number (1 or 2)
  final int sessionNumber;

  /// ARB localization key for title (e.g. 'animalsSession1Title')
  final String titleKey;

  /// ARB localization key for subtitle (e.g. 'animalsSession1Subtitle')
  final String subtitleKey;

  /// The 10 animals included in this session
  final List<AnimalEntity> animals;

  /// Whether the user has completed this session
  final bool isCompleted;

  /// Whether this session is locked
  final bool isLocked;

  /// Stars earned from completing this session (0 or 5)
  final int starsEarned;

  /// Current 0-based active animal index
  final int currentAnimalIndex;

  AnimalSessionEntity copyWith({
    bool? isCompleted,
    bool? isLocked,
    int? starsEarned,
    int? currentAnimalIndex,
  }) {
    return AnimalSessionEntity(
      id: id,
      sessionNumber: sessionNumber,
      titleKey: titleKey,
      subtitleKey: subtitleKey,
      animals: animals,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      starsEarned: starsEarned ?? this.starsEarned,
      currentAnimalIndex: currentAnimalIndex ?? this.currentAnimalIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimalSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isCompleted == other.isCompleted &&
          isLocked == other.isLocked &&
          starsEarned == other.starsEarned;

  @override
  int get hashCode => Object.hash(id, isCompleted, isLocked, starsEarned);
}
