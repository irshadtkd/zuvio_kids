/// Entity representing a single color and its associated coloring object.
/// Layer: Domain (pure Dart, zero Flutter dependencies)
class ColorItemEntity {
  const ColorItemEntity({
    required this.id,
    required this.name,
    required this.objectName,
    required this.colorValue,
    required this.paletteOptions,
  });

  /// Unique identifier (e.g. 'red', 'yellow', 'green', 'blue', 'orange', 'purple', 'pink')
  final String id;

  /// English color name (e.g. 'Red')
  final String name;

  /// Name of the object to paint (e.g. 'apple', 'banana', 'leaf', 'balloon', 'carrot', 'grapes', 'flower')
  final String objectName;

  /// 32-bit ARGB color value (e.g. 0xFFFF4D4D for Red)
  final int colorValue;

  /// Palette color options (5 distinct 32-bit ARGB values) for the swatch selector
  final List<int> paletteOptions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
