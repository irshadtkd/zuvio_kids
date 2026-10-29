import 'dart:math' as math;
import 'package:zuvio_kids/features/alphabet/data/datasources/alphabet_letter_data.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_data.dart';
import 'package:zuvio_kids/features/numbers/data/datasources/number_data.dart';
import 'package:zuvio_kids/features/shapes/data/datasources/shape_data.dart';
import '../../domain/entities/puzzle_item_entity.dart';
import '../../domain/entities/puzzle_session_entity.dart';

/// Service that randomly generates puzzle sessions across the 4 learning categories:
/// 1. Shapes
/// 2. Colors
/// 3. Numbers (1–100)
/// 4. Alphabet (A–Z)
///
/// Ensures puzzles are not repeated until all variations have been exhausted.
/// Layer: Data Source
abstract final class PuzzleGenerator {
  static final math.Random _random = math.Random();

  // Child-friendly vibrant colors for numbers and letters
  static const List<int> _vibrantPalette = [
    0xFFEF4444, // Red
    0xFF3B82F6, // Blue
    0xFF10B981, // Kid Green
    0xFFF59E0B, // Amber / Sun
    0xFF8B5CF6, // Purple
    0xFFEC4899, // Pink
    0xFF0EA5E9, // Sky Blue
    0xFFF97316, // Orange
    0xFF14B8A6, // Teal
  ];

  // ── 1. Shapes Pool (12 shapes from Shapes learning session) ───────────────
  static List<PuzzleItemEntity> get _shapesPool {
    final shapeList = [
      ShapeData.circle,
      ShapeData.square,
      ShapeData.triangle,
      ShapeData.star,
      ShapeData.heart,
      ShapeData.crescent,
      ShapeData.diamond,
      ShapeData.oval,
      ShapeData.rectangle,
      ShapeData.pentagon,
      ShapeData.hexagon,
      ShapeData.semicircle,
    ];

    return shapeList.map((s) {
      return PuzzleItemEntity(
        id: s.id,
        name: s.englishName,
        type: PuzzleItemType.shape,
        colorHex: s.colorValue,
        soundKey: s.englishName,
      );
    }).toList();
  }

  // ── 2. Colors Pool (7 colors from Colors learning session) ────────────────
  static List<PuzzleItemEntity> get _colorsPool {
    return ColorData.items.map((c) {
      return PuzzleItemEntity(
        id: c.id,
        name: c.name,
        type: PuzzleItemType.color,
        colorHex: c.colorValue,
        displayText: c.objectName, // 'apple', 'banana', 'balloon', etc.
        soundKey: c.name,
      );
    }).toList();
  }

  // ── 3. Alphabet Pool (A–Z from Alphabet learning session) ─────────────────
  static List<PuzzleItemEntity> get _alphabetPool {
    const letters = AlphabetLetterData.capitalLetters;
    final items = <PuzzleItemEntity>[];

    for (var i = 0; i < letters.length; i++) {
      final letter = letters[i];
      final color = _vibrantPalette[i % _vibrantPalette.length];
      items.add(PuzzleItemEntity(
        id: 'letter_${letter.letter}',
        name: letter.letter,
        type: PuzzleItemType.alphabet,
        colorHex: color,
        displayText: letter.letter,
        soundKey: letter.letter,
      ));
    }
    return items;
  }

  // ── 4. Numbers Pool (1–100 from Numbers learning session) ─────────────────
  static List<PuzzleItemEntity> get _numbersPool {
    final items = <PuzzleItemEntity>[];
    for (var n = 1; n <= 100; n++) {
      final color = _vibrantPalette[(n - 1) % _vibrantPalette.length];
      items.add(PuzzleItemEntity(
        id: 'num_$n',
        name: '$n',
        type: PuzzleItemType.number,
        colorHex: color,
        displayText: '$n',
        soundKey: NumberData.getWordName(n),
      ));
    }
    return items;
  }

  /// Generates a set of 4 puzzle sessions (Shapes, Colors, Numbers, Alphabet).
  /// Tracks and avoids variations that exist in [completedVariationKeys].
  static List<PuzzleSessionEntity> generatePuzzleSet({
    Set<String> completedVariationKeys = const {},
    void Function(String category)? onHistoryResetNeeded,
  }) {
    // 1. Shapes Session
    final shapes = _pickThreeUnique(
      pool: _shapesPool,
      category: 'shapes',
      completedKeys: completedVariationKeys,
      onReset: onHistoryResetNeeded,
    );

    // 2. Colors Session
    final colors = _pickThreeUnique(
      pool: _colorsPool,
      category: 'colors',
      completedKeys: completedVariationKeys,
      onReset: onHistoryResetNeeded,
    );

    // 3. Numbers Session
    final numbers = _pickThreeUnique(
      pool: _numbersPool,
      category: 'numbers',
      completedKeys: completedVariationKeys,
      onReset: onHistoryResetNeeded,
    );

    // 4. Alphabet Session
    final alphabet = _pickThreeUnique(
      pool: _alphabetPool,
      category: 'alphabet',
      completedKeys: completedVariationKeys,
      onReset: onHistoryResetNeeded,
    );

    return [
      _createSession(
        id: 'puzzle_1',
        sessionNumber: 1,
        title: 'Shapes',
        category: 'shapes',
        items: shapes,
      ),
      _createSession(
        id: 'puzzle_2',
        sessionNumber: 2,
        title: 'Colors',
        category: 'colors',
        items: colors,
      ),
      _createSession(
        id: 'puzzle_3',
        sessionNumber: 3,
        title: 'Numbers',
        category: 'numbers',
        items: numbers,
      ),
      _createSession(
        id: 'puzzle_4',
        sessionNumber: 4,
        title: 'Alphabet',
        category: 'alphabet',
        items: alphabet,
      ),
    ];
  }

  static List<PuzzleItemEntity> _pickThreeUnique({
    required List<PuzzleItemEntity> pool,
    required String category,
    required Set<String> completedKeys,
    void Function(String category)? onReset,
  }) {
    if (pool.length < 3) return pool;

    List<PuzzleItemEntity>? chosen;

    // Try up to 60 times to find a variation not yet completed
    for (var attempt = 0; attempt < 60; attempt++) {
      final shuffled = List<PuzzleItemEntity>.from(pool)..shuffle(_random);
      final candidate = shuffled.take(3).toList();
      final key = computeVariationKey(category, candidate);

      if (!completedKeys.contains(key)) {
        chosen = candidate;
        break;
      }
    }

    // If all variations in pool were completed, reset history for this category
    if (chosen == null) {
      onReset?.call(category);
      final shuffled = List<PuzzleItemEntity>.from(pool)..shuffle(_random);
      chosen = shuffled.take(3).toList();
    }

    return chosen;
  }

  static PuzzleSessionEntity _createSession({
    required String id,
    required int sessionNumber,
    required String title,
    required String category,
    required List<PuzzleItemEntity> items,
  }) {
    // Shuffle picture items so they don't match 1:1 order with shadows
    final pictureList = List<PuzzleItemEntity>.from(items)..shuffle(_random);

    // Guarantee that at least one position is shuffled if possible
    if (pictureList.length == 3 &&
        pictureList[0].id == items[0].id &&
        pictureList[1].id == items[1].id &&
        pictureList[2].id == items[2].id) {
      final temp = pictureList[0];
      pictureList[0] = pictureList[1];
      pictureList[1] = temp;
    }

    final key = computeVariationKey(category, items);

    return PuzzleSessionEntity(
      id: id,
      sessionNumber: sessionNumber,
      title: title,
      instruction: 'Match each picture to its shadow!',
      shadowItems: items,
      pictureItems: pictureList,
      isCompleted: false,
      isLocked: false,
      variationKey: key,
    );
  }

  /// Calculates a deterministic variation signature for a set of items.
  static String computeVariationKey(
    String category,
    List<PuzzleItemEntity> items,
  ) {
    final sortedIds = items.map((e) => e.id).toList()..sort();
    return '$category:${sortedIds.join(',')}';
  }
}
