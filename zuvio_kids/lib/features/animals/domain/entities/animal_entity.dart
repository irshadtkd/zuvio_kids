/// Domain entity representing a single animal in the learning curriculum.
/// Layer: Domain (pure Dart, zero Flutter dependencies)
class AnimalEntity {
  const AnimalEntity({
    required this.id,
    required this.nameKey,
    required this.englishName,
    required this.svgAsset,
    required this.soundAssetId,
    required this.colorValue,
  });

  /// Unique animal identifier (e.g. 'elephant', 'cat', 'lion')
  final String id;

  /// ARB localization key for the animal's name (e.g. 'animalElephant')
  final String nameKey;

  /// English name for TTS speech and fallbacks (e.g. 'Elephant')
  final String englishName;

  /// Asset path to the Flutter-compatible SVG illustration
  final String svgAsset;

  /// Audio asset identifier corresponding to assets/audio/animals/[soundAssetId].wav
  final String soundAssetId;

  /// Primary color value (ARGB int) for decorative card and accents
  final int colorValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimalEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
