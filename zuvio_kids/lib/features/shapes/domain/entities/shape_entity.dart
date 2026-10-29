/// Normalized 2D coordinate point (0.0 to 1.0) for shape tracing waypoints.
/// Layer: Domain (pure Dart, zero Flutter dependencies)
class ShapePoint {
  const ShapePoint(this.x, this.y);

  final double x;
  final double y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapePoint &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

/// Waypoint stroke for drawing/tracing a shape.
class ShapeStroke {
  const ShapeStroke({
    required this.points,
    this.strokeNumber = 1,
  });

  final List<ShapePoint> points;
  final int strokeNumber;
}

/// Entity representing a single geometric shape.
/// Layer: Domain (pure Dart)
class ShapeEntity {
  const ShapeEntity({
    required this.id,
    required this.nameKey,
    required this.englishName,
    required this.exampleKey,
    required this.exampleEnglishName,
    required this.colorValue,
    required this.strokes,
    required this.quizOptionIds,
  });

  /// Unique identifier (e.g. 'circle', 'square', 'triangle', etc.)
  final String id;

  /// Localization key for the shape's name (e.g. 'shapeCircle')
  final String nameKey;

  /// English shape name for TTS audio announcements (e.g. 'Circle')
  final String englishName;

  /// Localization key for the real-world example (e.g. 'exampleBall')
  final String exampleKey;

  /// English example name for TTS audio announcements (e.g. 'Ball')
  final String exampleEnglishName;

  /// Hex ARGB color value for vibrant display
  final int colorValue;

  /// Dotted tracing strokes and waypoints
  final List<ShapeStroke> strokes;

  /// Shape IDs for the matching/quiz step (includes this shape's id)
  final List<String> quizOptionIds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
