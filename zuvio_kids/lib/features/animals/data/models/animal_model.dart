import '../../domain/entities/animal_entity.dart';

/// Data Transfer Object for [AnimalEntity].
/// Layer: Data Model
class AnimalModel extends AnimalEntity {
  const AnimalModel({
    required super.id,
    required super.nameKey,
    required super.englishName,
    required super.svgAsset,
    required super.soundAssetId,
    required super.colorValue,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) => AnimalModel(
        id: json['id'] as String,
        nameKey: json['nameKey'] as String,
        englishName: json['englishName'] as String,
        svgAsset: json['svgAsset'] as String,
        soundAssetId: json['soundAssetId'] as String,
        colorValue: json['colorValue'] as int,
      );

  factory AnimalModel.fromEntity(AnimalEntity entity) => AnimalModel(
        id: entity.id,
        nameKey: entity.nameKey,
        englishName: entity.englishName,
        svgAsset: entity.svgAsset,
        soundAssetId: entity.soundAssetId,
        colorValue: entity.colorValue,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameKey': nameKey,
        'englishName': englishName,
        'svgAsset': svgAsset,
        'soundAssetId': soundAssetId,
        'colorValue': colorValue,
      };
}
