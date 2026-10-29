import '../../domain/entities/animal_session_entity.dart';
import 'animal_model.dart';

/// Data Transfer Object for [AnimalSessionEntity].
/// Layer: Data Model
class AnimalSessionModel extends AnimalSessionEntity {
  const AnimalSessionModel({
    required super.id,
    required super.sessionNumber,
    required super.titleKey,
    required super.subtitleKey,
    required super.animals,
    required super.isCompleted,
    required super.isLocked,
    required super.starsEarned,
    super.currentAnimalIndex = 0,
  });

  factory AnimalSessionModel.fromJson(Map<String, dynamic> json) =>
      AnimalSessionModel(
        id: json['id'] as String,
        sessionNumber: json['sessionNumber'] as int,
        titleKey: json['titleKey'] as String,
        subtitleKey: json['subtitleKey'] as String,
        animals: (json['animals'] as List<dynamic>)
            .map((e) => AnimalModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        isCompleted: json['isCompleted'] as bool? ?? false,
        isLocked: json['isLocked'] as bool? ?? false,
        starsEarned: json['starsEarned'] as int? ?? 0,
        currentAnimalIndex: json['currentAnimalIndex'] as int? ?? 0,
      );

  factory AnimalSessionModel.fromEntity(AnimalSessionEntity entity) =>
      AnimalSessionModel(
        id: entity.id,
        sessionNumber: entity.sessionNumber,
        titleKey: entity.titleKey,
        subtitleKey: entity.subtitleKey,
        animals: entity.animals,
        isCompleted: entity.isCompleted,
        isLocked: entity.isLocked,
        starsEarned: entity.starsEarned,
        currentAnimalIndex: entity.currentAnimalIndex,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionNumber': sessionNumber,
        'titleKey': titleKey,
        'subtitleKey': subtitleKey,
        'animals': animals
            .map((e) => AnimalModel.fromEntity(e).toJson())
            .toList(),
        'isCompleted': isCompleted,
        'isLocked': isLocked,
        'starsEarned': starsEarned,
        'currentAnimalIndex': currentAnimalIndex,
      };
}
