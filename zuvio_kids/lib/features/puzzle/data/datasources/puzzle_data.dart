import '../../domain/entities/puzzle_item_entity.dart';
import '../../domain/entities/puzzle_session_entity.dart';

/// Static data catalog defining the 4 child-friendly learning puzzles.
/// - Puzzle 1: Geometric Shapes (Circle, Star, Crescent) matching the sample design
/// - Puzzle 2: Wonder Shapes (Square, Triangle, Heart)
/// - Puzzle 3: Pet Friends (Dog, Cat, Bunny)
/// - Puzzle 4: Wild & Pond Friends (Lion, Panda, Frog)
/// Layer: Data Source
abstract final class PuzzleData {
  static const List<PuzzleSessionEntity> defaultSessions = [
    // ── Session 1: Geometric Shapes ──────────────────────────────────────
    PuzzleSessionEntity(
      id: 'puzzle_1',
      sessionNumber: 1,
      title: 'Shapes',
      instruction: 'Match each picture to its shadow!',
      isCompleted: false,
      isLocked: false,
      shadowItems: [
        PuzzleItemEntity(
          id: 'circle',
          name: 'Circle',
          type: PuzzleItemType.shape,
          colorHex: 0xFFEF4444, // Red / Coral
        ),
        PuzzleItemEntity(
          id: 'star',
          name: 'Star',
          type: PuzzleItemType.shape,
          colorHex: 0xFFFBBF24, // Sun Yellow
        ),
        PuzzleItemEntity(
          id: 'crescent',
          name: 'Crescent',
          type: PuzzleItemType.shape,
          colorHex: 0xFFF59E0B, // Amber / Yellow
        ),
      ],
      pictureItems: [
        PuzzleItemEntity(
          id: 'circle',
          name: 'Circle',
          type: PuzzleItemType.shape,
          colorHex: 0xFFEF4444,
        ),
        PuzzleItemEntity(
          id: 'star',
          name: 'Star',
          type: PuzzleItemType.shape,
          colorHex: 0xFFFBBF24,
        ),
        PuzzleItemEntity(
          id: 'crescent',
          name: 'Crescent',
          type: PuzzleItemType.shape,
          colorHex: 0xFFF59E0B,
        ),
      ],
    ),

    // ── Session 2: Wonder Shapes ─────────────────────────────────────────
    PuzzleSessionEntity(
      id: 'puzzle_2',
      sessionNumber: 2,
      title: 'Wonder Shapes',
      instruction: 'Match each picture to its shadow!',
      isCompleted: false,
      isLocked: false,
      shadowItems: [
        PuzzleItemEntity(
          id: 'square',
          name: 'Square',
          type: PuzzleItemType.shape,
          colorHex: 0xFF8B5CF6, // Purple
        ),
        PuzzleItemEntity(
          id: 'triangle',
          name: 'Triangle',
          type: PuzzleItemType.shape,
          colorHex: 0xFF10B981, // Kid Green
        ),
        PuzzleItemEntity(
          id: 'heart',
          name: 'Heart',
          type: PuzzleItemType.shape,
          colorHex: 0xFFEC4899, // Pink
        ),
      ],
      pictureItems: [
        PuzzleItemEntity(
          id: 'triangle',
          name: 'Triangle',
          type: PuzzleItemType.shape,
          colorHex: 0xFF10B981,
        ),
        PuzzleItemEntity(
          id: 'heart',
          name: 'Heart',
          type: PuzzleItemType.shape,
          colorHex: 0xFFEC4899,
        ),
        PuzzleItemEntity(
          id: 'square',
          name: 'Square',
          type: PuzzleItemType.shape,
          colorHex: 0xFF8B5CF6,
        ),
      ],
    ),

    // ── Session 3: Pet Friends ───────────────────────────────────────────
    PuzzleSessionEntity(
      id: 'puzzle_3',
      sessionNumber: 3,
      title: 'Pet Friends',
      instruction: 'Match each picture to its shadow!',
      isCompleted: false,
      isLocked: false,
      shadowItems: [
        PuzzleItemEntity(
          id: 'dog',
          name: 'Dog',
          type: PuzzleItemType.animal,
          colorHex: 0xFFF97316,
          soundKey: 'dog',
        ),
        PuzzleItemEntity(
          id: 'cat',
          name: 'Cat',
          type: PuzzleItemType.animal,
          colorHex: 0xFF38BDF8,
          soundKey: 'cat',
        ),
        PuzzleItemEntity(
          id: 'bunny',
          name: 'Bunny',
          type: PuzzleItemType.animal,
          colorHex: 0xFFF43F5E,
          soundKey: 'bunny',
        ),
      ],
      pictureItems: [
        PuzzleItemEntity(
          id: 'cat',
          name: 'Cat',
          type: PuzzleItemType.animal,
          colorHex: 0xFF38BDF8,
          soundKey: 'cat',
        ),
        PuzzleItemEntity(
          id: 'bunny',
          name: 'Bunny',
          type: PuzzleItemType.animal,
          colorHex: 0xFFF43F5E,
          soundKey: 'bunny',
        ),
        PuzzleItemEntity(
          id: 'dog',
          name: 'Dog',
          type: PuzzleItemType.animal,
          colorHex: 0xFFF97316,
          soundKey: 'dog',
        ),
      ],
    ),

    // ── Session 4: Wild & Pond Friends ───────────────────────────────────
    PuzzleSessionEntity(
      id: 'puzzle_4',
      sessionNumber: 4,
      title: 'Wild Friends',
      instruction: 'Match each picture to its shadow!',
      isCompleted: false,
      isLocked: false,
      shadowItems: [
        PuzzleItemEntity(
          id: 'lion',
          name: 'Lion',
          type: PuzzleItemType.animal,
          colorHex: 0xFFF59E0B,
          soundKey: 'lion',
        ),
        PuzzleItemEntity(
          id: 'panda',
          name: 'Panda',
          type: PuzzleItemType.animal,
          colorHex: 0xFF1E293B,
          soundKey: 'panda',
        ),
        PuzzleItemEntity(
          id: 'frog',
          name: 'Frog',
          type: PuzzleItemType.animal,
          colorHex: 0xFF22C55E,
          soundKey: 'frog',
        ),
      ],
      pictureItems: [
        PuzzleItemEntity(
          id: 'panda',
          name: 'Panda',
          type: PuzzleItemType.animal,
          colorHex: 0xFF1E293B,
          soundKey: 'panda',
        ),
        PuzzleItemEntity(
          id: 'frog',
          name: 'Frog',
          type: PuzzleItemType.animal,
          colorHex: 0xFF22C55E,
          soundKey: 'frog',
        ),
        PuzzleItemEntity(
          id: 'lion',
          name: 'Lion',
          type: PuzzleItemType.animal,
          colorHex: 0xFFF59E0B,
          soundKey: 'lion',
        ),
      ],
    ),
  ];
}
