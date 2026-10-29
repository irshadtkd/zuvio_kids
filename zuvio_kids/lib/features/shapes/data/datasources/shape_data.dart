import 'dart:math' as math;
import 'package:zuvio_kids/features/shapes/domain/entities/shape_entity.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_session_entity.dart';

/// Static catalog containing all 12 shapes, 4 sessions, and stroke waypoints.
/// Layer: Data
abstract final class ShapeData {
  // ── Colors for shapes ──────────────────────────────────────────────────
  static const int colorRed = 0xFFEF4444;
  static const int colorBlue = 0xFF3B82F6;
  static const int colorYellow = 0xFFF59E0B;
  static const int colorGreen = 0xFF10B981;
  static const int colorPurple = 0xFF8B5CF6;
  static const int colorPink = 0xFFEC4899;
  static const int colorOrange = 0xFFF97316;
  static const int colorTeal = 0xFF14B8A6;
  static const int colorIndigo = 0xFF6366F1;
  static const int colorAmber = 0xFFD97706;
  static const int colorSky = 0xFF0EA5E9;
  static const int colorRose = 0xFFF43F5E;

  // ── Shape Entities ─────────────────────────────────────────────────────

  static final ShapeEntity circle = ShapeEntity(
    id: 'circle',
    nameKey: 'shapeCircle',
    englishName: 'Circle',
    exampleKey: 'exampleBall',
    exampleEnglishName: 'Ball',
    colorValue: colorRed,
    strokes: [ShapeStroke(points: _generateCirclePoints())],
    quizOptionIds: const ['circle', 'square', 'triangle'],
  );

  static final ShapeEntity square = ShapeEntity(
    id: 'square',
    nameKey: 'shapeSquare',
    englishName: 'Square',
    exampleKey: 'exampleGiftBox',
    exampleEnglishName: 'Gift box',
    colorValue: colorBlue,
    strokes: [ShapeStroke(points: _generateSquarePoints())],
    quizOptionIds: const ['circle', 'square', 'triangle'],
  );

  static final ShapeEntity triangle = ShapeEntity(
    id: 'triangle',
    nameKey: 'shapeTriangle',
    englishName: 'Triangle',
    exampleKey: 'examplePizza',
    exampleEnglishName: 'Pizza slice',
    colorValue: colorYellow,
    strokes: [ShapeStroke(points: _generateTrianglePoints())],
    quizOptionIds: const ['circle', 'square', 'triangle'],
  );

  static final ShapeEntity rectangle = ShapeEntity(
    id: 'rectangle',
    nameKey: 'shapeRectangle',
    englishName: 'Rectangle',
    exampleKey: 'exampleDoor',
    exampleEnglishName: 'Door',
    colorValue: colorGreen,
    strokes: [ShapeStroke(points: _generateRectanglePoints())],
    quizOptionIds: const ['rectangle', 'oval', 'star'],
  );

  static final ShapeEntity oval = ShapeEntity(
    id: 'oval',
    nameKey: 'shapeOval',
    englishName: 'Oval',
    exampleKey: 'exampleEgg',
    exampleEnglishName: 'Egg',
    colorValue: colorPurple,
    strokes: [ShapeStroke(points: _generateOvalPoints())],
    quizOptionIds: const ['rectangle', 'oval', 'star'],
  );

  static final ShapeEntity star = ShapeEntity(
    id: 'star',
    nameKey: 'shapeStar',
    englishName: 'Star',
    exampleKey: 'exampleStarfish',
    exampleEnglishName: 'Starfish',
    colorValue: colorAmber,
    strokes: [ShapeStroke(points: _generateStarPoints())],
    quizOptionIds: const ['rectangle', 'oval', 'star'],
  );

  static final ShapeEntity heart = ShapeEntity(
    id: 'heart',
    nameKey: 'shapeHeart',
    englishName: 'Heart',
    exampleKey: 'exampleBalloon',
    exampleEnglishName: 'Balloon',
    colorValue: colorRose,
    strokes: [ShapeStroke(points: _generateHeartPoints())],
    quizOptionIds: const ['heart', 'diamond', 'pentagon'],
  );

  static final ShapeEntity diamond = ShapeEntity(
    id: 'diamond',
    nameKey: 'shapeDiamond',
    englishName: 'Diamond',
    exampleKey: 'exampleKite',
    exampleEnglishName: 'Kite',
    colorValue: colorTeal,
    strokes: [ShapeStroke(points: _generateDiamondPoints())],
    quizOptionIds: const ['heart', 'diamond', 'pentagon'],
  );

  static final ShapeEntity pentagon = ShapeEntity(
    id: 'pentagon',
    nameKey: 'shapePentagon',
    englishName: 'Pentagon',
    exampleKey: 'exampleBirdhouse',
    exampleEnglishName: 'Birdhouse',
    colorValue: colorIndigo,
    strokes: [ShapeStroke(points: _generatePentagonPoints())],
    quizOptionIds: const ['heart', 'diamond', 'pentagon'],
  );

  static final ShapeEntity hexagon = ShapeEntity(
    id: 'hexagon',
    nameKey: 'shapeHexagon',
    englishName: 'Hexagon',
    exampleKey: 'exampleHoneycomb',
    exampleEnglishName: 'Honeycomb',
    colorValue: colorOrange,
    strokes: [ShapeStroke(points: _generateHexagonPoints())],
    quizOptionIds: const ['hexagon', 'crescent', 'semicircle'],
  );

  static final ShapeEntity crescent = ShapeEntity(
    id: 'crescent',
    nameKey: 'shapeCrescent',
    englishName: 'Crescent',
    exampleKey: 'exampleMoon',
    exampleEnglishName: 'Moon',
    colorValue: colorSky,
    strokes: [ShapeStroke(points: _generateCrescentPoints())],
    quizOptionIds: const ['hexagon', 'crescent', 'semicircle'],
  );

  static final ShapeEntity semicircle = ShapeEntity(
    id: 'semicircle',
    nameKey: 'shapeSemicircle',
    englishName: 'Semicircle',
    exampleKey: 'exampleWatermelon',
    exampleEnglishName: 'Watermelon slice',
    colorValue: colorPink,
    strokes: [ShapeStroke(points: _generateSemicirclePoints())],
    quizOptionIds: const ['hexagon', 'crescent', 'semicircle'],
  );

  static final List<ShapeEntity> allShapes = [
    circle,
    square,
    triangle,
    rectangle,
    oval,
    star,
    heart,
    diamond,
    pentagon,
    hexagon,
    crescent,
    semicircle,
  ];

  static ShapeEntity getShapeById(String id) {
    return allShapes.firstWhere(
      (s) => s.id == id,
      orElse: () => circle,
    );
  }

  // ── Default 4 Sessions ─────────────────────────────────────────────────

  static List<ShapeSessionEntity> getDefaultSessions() {
    return [
      ShapeSessionEntity(
        id: 'session_1',
        sessionNumber: 1,
        title: 'Circle, Square, Triangle',
        shapes: [circle, square, triangle],
        isCompleted: false,
        isLocked: false, // Session 1 unlocked by default
        starsEarned: 0,
      ),
      ShapeSessionEntity(
        id: 'session_2',
        sessionNumber: 2,
        title: 'Rectangle, Oval, Star',
        shapes: [rectangle, oval, star],
        isCompleted: false,
        isLocked: true,
        starsEarned: 0,
      ),
      ShapeSessionEntity(
        id: 'session_3',
        sessionNumber: 3,
        title: 'Heart, Diamond, Pentagon',
        shapes: [heart, diamond, pentagon],
        isCompleted: false,
        isLocked: true,
        starsEarned: 0,
      ),
      ShapeSessionEntity(
        id: 'session_4',
        sessionNumber: 4,
        title: 'Hexagon, Crescent, Semicircle',
        shapes: [hexagon, crescent, semicircle],
        isCompleted: false,
        isLocked: true,
        starsEarned: 0,
      ),
    ];
  }

  // ── Waypoint Generators ────────────────────────────────────────────────

  static List<ShapePoint> _generateCirclePoints() {
    const int count = 28;
    const double cx = 0.5;
    const double cy = 0.5;
    const double r = 0.35;
    final points = <ShapePoint>[];
    for (int i = 0; i <= count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      points.add(ShapePoint(cx + r * math.cos(angle), cy + r * math.sin(angle)));
    }
    return points;
  }

  static List<ShapePoint> _generateSquarePoints() {
    return const [
      ShapePoint(0.20, 0.20),
      ShapePoint(0.50, 0.20),
      ShapePoint(0.80, 0.20),
      ShapePoint(0.80, 0.50),
      ShapePoint(0.80, 0.80),
      ShapePoint(0.50, 0.80),
      ShapePoint(0.20, 0.80),
      ShapePoint(0.20, 0.50),
      ShapePoint(0.20, 0.20),
    ];
  }

  static List<ShapePoint> _generateTrianglePoints() {
    return const [
      ShapePoint(0.50, 0.18),
      ShapePoint(0.66, 0.50),
      ShapePoint(0.82, 0.82),
      ShapePoint(0.50, 0.82),
      ShapePoint(0.18, 0.82),
      ShapePoint(0.34, 0.50),
      ShapePoint(0.50, 0.18),
    ];
  }

  static List<ShapePoint> _generateRectanglePoints() {
    return const [
      ShapePoint(0.18, 0.28),
      ShapePoint(0.50, 0.28),
      ShapePoint(0.82, 0.28),
      ShapePoint(0.82, 0.50),
      ShapePoint(0.82, 0.72),
      ShapePoint(0.50, 0.72),
      ShapePoint(0.18, 0.72),
      ShapePoint(0.18, 0.50),
      ShapePoint(0.18, 0.28),
    ];
  }

  static List<ShapePoint> _generateOvalPoints() {
    const int count = 28;
    const double cx = 0.5;
    const double cy = 0.5;
    const double rx = 0.26;
    const double ry = 0.38;
    final points = <ShapePoint>[];
    for (int i = 0; i <= count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      points.add(ShapePoint(cx + rx * math.cos(angle), cy + ry * math.sin(angle)));
    }
    return points;
  }

  static List<ShapePoint> _generateStarPoints() {
    const int pointsCount = 10;
    const double cx = 0.5;
    const double cy = 0.52;
    const double rOuter = 0.38;
    const double rInner = 0.18;
    final points = <ShapePoint>[];
    for (int i = 0; i <= pointsCount; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / pointsCount);
      final r = i.isEven ? rOuter : rInner;
      points.add(ShapePoint(cx + r * math.cos(angle), cy + r * math.sin(angle)));
    }
    return points;
  }

  static List<ShapePoint> _generateHeartPoints() {
    final points = <ShapePoint>[];
    const int count = 30;
    for (int i = 0; i <= count; i++) {
      final t = -math.pi + (2 * math.pi * i / count);
      // Classic heart parametric equations
      final x = 16 * math.pow(math.sin(t), 3);
      final y = -(13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t));
      // Normalize from approx [-16, 16] into [0.15, 0.85]
      points.add(ShapePoint(0.50 + (x / 46), 0.48 + (y / 46)));
    }
    return points;
  }

  static List<ShapePoint> _generateDiamondPoints() {
    return const [
      ShapePoint(0.50, 0.16),
      ShapePoint(0.67, 0.33),
      ShapePoint(0.84, 0.50),
      ShapePoint(0.67, 0.67),
      ShapePoint(0.50, 0.84),
      ShapePoint(0.33, 0.67),
      ShapePoint(0.16, 0.50),
      ShapePoint(0.33, 0.33),
      ShapePoint(0.50, 0.16),
    ];
  }

  static List<ShapePoint> _generatePentagonPoints() {
    const int count = 5;
    const double cx = 0.5;
    const double cy = 0.53;
    const double r = 0.36;
    final points = <ShapePoint>[];
    for (int i = 0; i <= count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      points.add(ShapePoint(cx + r * math.cos(angle), cy + r * math.sin(angle)));
    }
    return points;
  }

  static List<ShapePoint> _generateHexagonPoints() {
    const int count = 6;
    const double cx = 0.5;
    const double cy = 0.5;
    const double r = 0.36;
    final points = <ShapePoint>[];
    for (int i = 0; i <= count; i++) {
      final angle = 2 * math.pi * i / count;
      points.add(ShapePoint(cx + r * math.cos(angle), cy + r * math.sin(angle)));
    }
    return points;
  }

  static List<ShapePoint> _generateCrescentPoints() {
    final points = <ShapePoint>[];
    // Outer arc
    for (int i = 0; i <= 14; i++) {
      final angle = -math.pi / 2 + (math.pi * i / 14);
      points.add(ShapePoint(0.50 + 0.35 * math.cos(angle + 0.5), 0.50 + 0.35 * math.sin(angle + 0.5)));
    }
    // Inner arc back
    for (int i = 14; i >= 0; i--) {
      final angle = -math.pi / 2 + (math.pi * i / 14);
      points.add(ShapePoint(0.62 + 0.28 * math.cos(angle + 0.5), 0.50 + 0.28 * math.sin(angle + 0.5)));
    }
    return points;
  }

  static List<ShapePoint> _generateSemicirclePoints() {
    final points = <ShapePoint>[];
    const int arcCount = 16;
    const double cx = 0.5;
    const double cy = 0.66;
    const double r = 0.34;
    // Curved top arc from left to right
    for (int i = 0; i <= arcCount; i++) {
      final angle = math.pi + (math.pi * i / arcCount);
      points.add(ShapePoint(cx + r * math.cos(angle), cy + r * math.sin(angle)));
    }
    // Bottom baseline straight across
    points.add(const ShapePoint(0.50, 0.66));
    points.add(const ShapePoint(0.16, 0.66));
    return points;
  }
}
