import 'color_item_entity.dart';

/// Entity representing the single session of 7 colors.
/// Layer: Domain (pure Dart)
class ColorSessionEntity {
  const ColorSessionEntity({
    required this.id,
    required this.colors,
    required this.isCompleted,
    required this.starsEarned,
    this.currentColorIndex = 0,
  });

  final String id;
  final List<ColorItemEntity> colors;
  final bool isCompleted;
  final int starsEarned;
  final int currentColorIndex;

  ColorSessionEntity copyWith({
    List<ColorItemEntity>? colors,
    bool? isCompleted,
    int? starsEarned,
    int? currentColorIndex,
  }) {
    return ColorSessionEntity(
      id: id,
      colors: colors ?? this.colors,
      isCompleted: isCompleted ?? this.isCompleted,
      starsEarned: starsEarned ?? this.starsEarned,
      currentColorIndex: currentColorIndex ?? this.currentColorIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isCompleted == other.isCompleted &&
          starsEarned == other.starsEarned;

  @override
  int get hashCode => Object.hash(id, isCompleted, starsEarned);
}
