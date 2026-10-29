import 'package:flutter/material.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_letter_entity.dart';

/// Tracing stroke waypoint data for a letter.
class TracingStroke {
  const TracingStroke({required this.points});
  final List<Offset> points;
}

/// Static catalog of all 26 letters and their learning materials.
/// Strictly separates Capital Letters (A–Z) and Small Letters (a–z).
/// Layer: Data
abstract final class AlphabetLetterData {
  static const List<AlphabetLetterEntity> capitalLetters = [
    AlphabetLetterEntity(
      letter: 'A',
      displayPair: 'A',
      primaryWord: 'Apple',
      phrase: 'A for Apple',
      supportingWords: ['Apple', 'Ant', 'Aeroplane'],
      quizOptions: ['Apple', 'Sun', 'Dog'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'B',
      displayPair: 'B',
      primaryWord: 'Ball',
      phrase: 'B for Ball',
      supportingWords: ['Ball', 'Bear', 'Boat'],
      quizOptions: ['Ball', 'Cat', 'Sun'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'C',
      displayPair: 'C',
      primaryWord: 'Cat',
      phrase: 'C for Cat',
      supportingWords: ['Cat', 'Car', 'Cup'],
      quizOptions: ['Cat', 'Sun', 'Dog'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'D',
      displayPair: 'D',
      primaryWord: 'Dog',
      phrase: 'D for Dog',
      supportingWords: ['Dog', 'Duck', 'Drum'],
      quizOptions: ['Dog', 'Ball', 'Fish'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'E',
      displayPair: 'E',
      primaryWord: 'Elephant',
      phrase: 'E for Elephant',
      supportingWords: ['Elephant', 'Egg', 'Eye'],
      quizOptions: ['Elephant', 'Star', 'Cat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'F',
      displayPair: 'F',
      primaryWord: 'Fish',
      phrase: 'F for Fish',
      supportingWords: ['Fish', 'Frog', 'Flower'],
      quizOptions: ['Fish', 'Sun', 'Hat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'G',
      displayPair: 'G',
      primaryWord: 'Grapes',
      phrase: 'G for Grapes',
      supportingWords: ['Grapes', 'Giraffe', 'Guitar'],
      quizOptions: ['Grapes', 'Apple', 'Moon'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'H',
      displayPair: 'H',
      primaryWord: 'Hat',
      phrase: 'H for Hat',
      supportingWords: ['Hat', 'Horse', 'House'],
      quizOptions: ['Hat', 'Duck', 'Ball'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'I',
      displayPair: 'I',
      primaryWord: 'Ice cream',
      phrase: 'I for Ice cream',
      supportingWords: ['Ice cream', 'Iguana', 'Island'],
      quizOptions: ['Ice cream', 'Cat', 'Dog'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'J',
      displayPair: 'J',
      primaryWord: 'Juice',
      phrase: 'J for Juice',
      supportingWords: ['Juice', 'Jam', 'Jellyfish'],
      quizOptions: ['Juice', 'Star', 'Fish'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'K',
      displayPair: 'K',
      primaryWord: 'Kite',
      phrase: 'K for Kite',
      supportingWords: ['Kite', 'Kangaroo', 'King'],
      quizOptions: ['Kite', 'Apple', 'Sun'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'L',
      displayPair: 'L',
      primaryWord: 'Lion',
      phrase: 'L for Lion',
      supportingWords: ['Lion', 'Leaf', 'Lemon'],
      quizOptions: ['Lion', 'Boat', 'Hat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'M',
      displayPair: 'M',
      primaryWord: 'Monkey',
      phrase: 'M for Monkey',
      supportingWords: ['Monkey', 'Moon', 'Mango'],
      quizOptions: ['Monkey', 'Ball', 'Duck'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'N',
      displayPair: 'N',
      primaryWord: 'Nest',
      phrase: 'N for Nest',
      supportingWords: ['Nest', 'Nut', 'Net'],
      quizOptions: ['Nest', 'Cat', 'Star'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'O',
      displayPair: 'O',
      primaryWord: 'Orange',
      phrase: 'O for Orange',
      supportingWords: ['Orange', 'Owl', 'Octopus'],
      quizOptions: ['Orange', 'Fish', 'Dog'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'P',
      displayPair: 'P',
      primaryWord: 'Panda',
      phrase: 'P for Panda',
      supportingWords: ['Panda', 'Pen', 'Pizza'],
      quizOptions: ['Panda', 'Sun', 'Hat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'Q',
      displayPair: 'Q',
      primaryWord: 'Queen',
      phrase: 'Q for Queen',
      supportingWords: ['Queen', 'Quilt', 'Quill'],
      quizOptions: ['Queen', 'Moon', 'Ball'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'R',
      displayPair: 'R',
      primaryWord: 'Rabbit',
      phrase: 'R for Rabbit',
      supportingWords: ['Rabbit', 'Ring', 'Rainbow'],
      quizOptions: ['Rabbit', 'Cat', 'Star'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'S',
      displayPair: 'S',
      primaryWord: 'Sun',
      phrase: 'S for Sun',
      supportingWords: ['Sun', 'Star', 'Ship'],
      quizOptions: ['Sun', 'Dog', 'Apple'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'T',
      displayPair: 'T',
      primaryWord: 'Tiger',
      phrase: 'T for Tiger',
      supportingWords: ['Tiger', 'Tree', 'Tomato'],
      quizOptions: ['Tiger', 'Fish', 'Boat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'U',
      displayPair: 'U',
      primaryWord: 'Umbrella',
      phrase: 'U for Umbrella',
      supportingWords: ['Umbrella', 'Unicorn', 'Urchin'],
      quizOptions: ['Umbrella', 'Duck', 'Cat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'V',
      displayPair: 'V',
      primaryWord: 'Van',
      phrase: 'V for Van',
      supportingWords: ['Van', 'Vase', 'Violin'],
      quizOptions: ['Van', 'Sun', 'Star'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'W',
      displayPair: 'W',
      primaryWord: 'Watch',
      phrase: 'W for Watch',
      supportingWords: ['Watch', 'Whale', 'Water'],
      quizOptions: ['Watch', 'Ball', 'Hat'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'X',
      displayPair: 'X',
      primaryWord: 'Xylophone',
      phrase: 'X for Xylophone',
      supportingWords: ['Xylophone', 'X-ray', 'Fox'],
      quizOptions: ['Xylophone', 'Cat', 'Fish'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'Y',
      displayPair: 'Y',
      primaryWord: 'Yo-yo',
      phrase: 'Y for Yo-yo',
      supportingWords: ['Yo-yo', 'Yak', 'Yacht'],
      quizOptions: ['Yo-yo', 'Dog', 'Sun'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
    AlphabetLetterEntity(
      letter: 'Z',
      displayPair: 'Z',
      primaryWord: 'Zebra',
      phrase: 'Z for Zebra',
      supportingWords: ['Zebra', 'Zoo', 'Zero'],
      quizOptions: ['Zebra', 'Star', 'Duck'],
      correctQuizIndex: 0,
      isCapital: true,
    ),
  ];

  /// Small letters derived strictly with lowercase letters (a–z).
  static List<AlphabetLetterEntity> get smallLetters =>
      capitalLetters.map((c) {
        final sm = c.letter.toLowerCase();
        return AlphabetLetterEntity(
          letter: sm,
          displayPair: sm,
          primaryWord: c.primaryWord,
          phrase: '${c.letter.toUpperCase()} for ${c.primaryWord}',
          supportingWords: c.supportingWords,
          quizOptions: c.quizOptions,
          correctQuizIndex: c.correctQuizIndex,
          isCapital: false,
        );
      }).toList();

  /// Normalized waypoints (from 0.0 to 1.0) for letter tracing outlines.
  static List<TracingStroke> getTracingStrokes(String letter, {bool isCapital = true}) {
    if (!isCapital) {
      final sm = letter.toLowerCase();
      switch (sm) {
        case 'a':
          return const [
            TracingStroke(points: [
              Offset(0.66, 0.48),
              Offset(0.48, 0.44),
              Offset(0.34, 0.58),
              Offset(0.36, 0.78),
              Offset(0.52, 0.88),
              Offset(0.66, 0.76),
            ]),
            TracingStroke(points: [
              Offset(0.66, 0.44),
              Offset(0.66, 0.88),
            ]),
          ];
        case 'b':
          return const [
            TracingStroke(points: [
              Offset(0.34, 0.12),
              Offset(0.34, 0.88),
            ]),
            TracingStroke(points: [
              Offset(0.34, 0.50),
              Offset(0.56, 0.46),
              Offset(0.68, 0.66),
              Offset(0.56, 0.88),
              Offset(0.34, 0.88),
            ]),
          ];
        case 'c':
          return const [
            TracingStroke(points: [
              Offset(0.66, 0.50),
              Offset(0.48, 0.44),
              Offset(0.34, 0.64),
              Offset(0.48, 0.88),
              Offset(0.66, 0.82),
            ]),
          ];
        case 'd':
          return const [
            // Circle (left side)
            TracingStroke(points: [
              Offset(0.62, 0.50),
              Offset(0.46, 0.44),
              Offset(0.32, 0.58),
              Offset(0.32, 0.76),
              Offset(0.46, 0.88),
              Offset(0.62, 0.76),
            ]),
            // Right vertical (full height)
            TracingStroke(points: [
              Offset(0.62, 0.12),
              Offset(0.62, 0.88),
            ]),
          ];
        case 'e':
          return const [
            TracingStroke(points: [
              Offset(0.32, 0.66),
              Offset(0.62, 0.66),
              Offset(0.68, 0.58),
              Offset(0.54, 0.44),
              Offset(0.36, 0.50),
              Offset(0.30, 0.66),
              Offset(0.36, 0.84),
              Offset(0.56, 0.88),
              Offset(0.68, 0.80),
            ]),
          ];
        case 'f':
          return const [
            // Vertical stem
            TracingStroke(points: [
              Offset(0.46, 0.20),
              Offset(0.46, 0.88),
            ]),
            // Curve at top
            TracingStroke(points: [
              Offset(0.46, 0.20),
              Offset(0.54, 0.14),
              Offset(0.62, 0.18),
            ]),
            // Crossbar
            TracingStroke(points: [
              Offset(0.30, 0.46),
              Offset(0.62, 0.46),
            ]),
          ];
        case 'g':
          return const [
            // Bowl (mid height)
            TracingStroke(points: [
              Offset(0.66, 0.50),
              Offset(0.48, 0.44),
              Offset(0.34, 0.58),
              Offset(0.36, 0.76),
              Offset(0.52, 0.86),
              Offset(0.66, 0.74),
            ]),
            // Right stem + descender hook
            TracingStroke(points: [
              Offset(0.66, 0.44),
              Offset(0.66, 0.94),
              Offset(0.54, 1.00),
              Offset(0.38, 0.96),
            ]),
          ];
        case 'h':
          return const [
            // Left vertical (full height)
            TracingStroke(points: [
              Offset(0.30, 0.12),
              Offset(0.30, 0.88),
            ]),
            // Arch + right leg
            TracingStroke(points: [
              Offset(0.30, 0.48),
              Offset(0.44, 0.42),
              Offset(0.58, 0.44),
              Offset(0.64, 0.54),
              Offset(0.64, 0.88),
            ]),
          ];
        case 'i':
          return const [
            // Dot
            TracingStroke(points: [
              Offset(0.50, 0.22),
              Offset(0.50, 0.24),
            ]),
            // Stem
            TracingStroke(points: [
              Offset(0.50, 0.42),
              Offset(0.50, 0.88),
            ]),
          ];
        case 'j':
          return const [
            // Dot
            TracingStroke(points: [
              Offset(0.56, 0.22),
              Offset(0.56, 0.24),
            ]),
            // Stem + hook
            TracingStroke(points: [
              Offset(0.56, 0.42),
              Offset(0.56, 0.88),
              Offset(0.46, 0.96),
              Offset(0.34, 0.90),
            ]),
          ];
        case 'k':
          return const [
            // Left vertical
            TracingStroke(points: [
              Offset(0.32, 0.12),
              Offset(0.32, 0.88),
            ]),
            // Upper arm (top-right to mid)
            TracingStroke(points: [
              Offset(0.66, 0.44),
              Offset(0.32, 0.66),
            ]),
            // Lower leg (mid to bottom-right)
            TracingStroke(points: [
              Offset(0.32, 0.66),
              Offset(0.66, 0.88),
            ]),
          ];
        case 'l':
          return const [
            TracingStroke(points: [
              Offset(0.50, 0.12),
              Offset(0.50, 0.88),
            ]),
          ];
        case 'm':
          return const [
            // Left stem
            TracingStroke(points: [
              Offset(0.18, 0.44),
              Offset(0.18, 0.88),
            ]),
            // Left arch
            TracingStroke(points: [
              Offset(0.18, 0.46),
              Offset(0.30, 0.40),
              Offset(0.42, 0.42),
              Offset(0.46, 0.54),
              Offset(0.46, 0.88),
            ]),
            // Right arch
            TracingStroke(points: [
              Offset(0.46, 0.46),
              Offset(0.58, 0.40),
              Offset(0.70, 0.42),
              Offset(0.74, 0.54),
              Offset(0.74, 0.88),
            ]),
          ];
        case 'n':
          return const [
            // Left stem
            TracingStroke(points: [
              Offset(0.30, 0.44),
              Offset(0.30, 0.88),
            ]),
            // Arch + right stem
            TracingStroke(points: [
              Offset(0.30, 0.46),
              Offset(0.44, 0.40),
              Offset(0.58, 0.42),
              Offset(0.64, 0.54),
              Offset(0.64, 0.88),
            ]),
          ];
        case 'o':
          return const [
            TracingStroke(points: [
              Offset(0.50, 0.44),
              Offset(0.34, 0.54),
              Offset(0.32, 0.68),
              Offset(0.38, 0.82),
              Offset(0.50, 0.88),
              Offset(0.62, 0.82),
              Offset(0.68, 0.68),
              Offset(0.66, 0.54),
              Offset(0.50, 0.44),
            ]),
          ];
        case 'p':
          return const [
            // Stem (goes below baseline as descender)
            TracingStroke(points: [
              Offset(0.32, 0.44),
              Offset(0.32, 1.00),
            ]),
            // Bowl
            TracingStroke(points: [
              Offset(0.32, 0.46),
              Offset(0.52, 0.42),
              Offset(0.66, 0.56),
              Offset(0.66, 0.72),
              Offset(0.52, 0.86),
              Offset(0.32, 0.82),
            ]),
          ];
        case 'q':
          return const [
            // Bowl
            TracingStroke(points: [
              Offset(0.62, 0.46),
              Offset(0.44, 0.42),
              Offset(0.30, 0.56),
              Offset(0.30, 0.72),
              Offset(0.44, 0.86),
              Offset(0.62, 0.82),
            ]),
            // Stem (descender)
            TracingStroke(points: [
              Offset(0.62, 0.44),
              Offset(0.62, 1.00),
            ]),
          ];
        case 'r':
          return const [
            // Stem
            TracingStroke(points: [
              Offset(0.32, 0.44),
              Offset(0.32, 0.88),
            ]),
            // Arch (short curve)
            TracingStroke(points: [
              Offset(0.32, 0.48),
              Offset(0.46, 0.42),
              Offset(0.60, 0.44),
            ]),
          ];
        case 's':
          return const [
            TracingStroke(points: [
              Offset(0.64, 0.50),
              Offset(0.50, 0.44),
              Offset(0.36, 0.52),
              Offset(0.50, 0.64),
              Offset(0.64, 0.74),
              Offset(0.52, 0.88),
              Offset(0.36, 0.82),
            ]),
          ];
        case 't':
          return const [
            // Stem
            TracingStroke(points: [
              Offset(0.50, 0.18),
              Offset(0.50, 0.88),
            ]),
            // Crossbar
            TracingStroke(points: [
              Offset(0.30, 0.46),
              Offset(0.66, 0.46),
            ]),
          ];
        case 'u':
          return const [
            TracingStroke(points: [
              Offset(0.32, 0.44),
              Offset(0.32, 0.76),
              Offset(0.38, 0.86),
              Offset(0.50, 0.88),
              Offset(0.62, 0.84),
              Offset(0.66, 0.74),
              Offset(0.66, 0.44),
              Offset(0.66, 0.88),
            ]),
          ];
        case 'v':
          return const [
            TracingStroke(points: [
              Offset(0.28, 0.44),
              Offset(0.50, 0.88),
              Offset(0.72, 0.44),
            ]),
          ];
        case 'w':
          return const [
            TracingStroke(points: [
              Offset(0.18, 0.44),
              Offset(0.30, 0.88),
              Offset(0.50, 0.68),
              Offset(0.70, 0.88),
              Offset(0.82, 0.44),
            ]),
          ];
        case 'x':
          return const [
            // Top-left to bottom-right
            TracingStroke(points: [
              Offset(0.32, 0.44),
              Offset(0.66, 0.88),
            ]),
            // Top-right to bottom-left
            TracingStroke(points: [
              Offset(0.66, 0.44),
              Offset(0.32, 0.88),
            ]),
          ];
        case 'y':
          return const [
            // Left arm to center
            TracingStroke(points: [
              Offset(0.28, 0.44),
              Offset(0.50, 0.70),
            ]),
            // Right arm to descender
            TracingStroke(points: [
              Offset(0.72, 0.44),
              Offset(0.50, 0.70),
              Offset(0.44, 0.88),
              Offset(0.34, 0.96),
            ]),
          ];
        case 'z':
          return const [
            // Top bar
            TracingStroke(points: [
              Offset(0.30, 0.44),
              Offset(0.66, 0.44),
            ]),
            // Diagonal
            TracingStroke(points: [
              Offset(0.66, 0.44),
              Offset(0.30, 0.88),
            ]),
            // Bottom bar
            TracingStroke(points: [
              Offset(0.30, 0.88),
              Offset(0.66, 0.88),
            ]),
          ];
        default:
          return const [
            TracingStroke(points: [
              Offset(0.34, 0.44),
              Offset(0.34, 0.88),
            ]),
          ];
      }
    }

    final char = letter.toUpperCase();
    switch (char) {
      case 'A':
        return const [
          TracingStroke(points: [
            Offset(0.22, 0.88),
            Offset(0.35, 0.50),
            Offset(0.50, 0.12),
          ]),
          TracingStroke(points: [
            Offset(0.50, 0.12),
            Offset(0.65, 0.50),
            Offset(0.78, 0.88),
          ]),
          TracingStroke(points: [
            Offset(0.32, 0.60),
            Offset(0.50, 0.60),
            Offset(0.68, 0.60),
          ]),
        ];
      case 'B':
        return const [
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.50),
            Offset(0.30, 0.88),
          ]),
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.56, 0.12),
            Offset(0.68, 0.28),
            Offset(0.56, 0.48),
            Offset(0.30, 0.48),
          ]),
          TracingStroke(points: [
            Offset(0.30, 0.48),
            Offset(0.60, 0.48),
            Offset(0.72, 0.68),
            Offset(0.58, 0.88),
            Offset(0.30, 0.88),
          ]),
        ];
      case 'C':
        return const [
          TracingStroke(points: [
            Offset(0.74, 0.24),
            Offset(0.52, 0.12),
            Offset(0.30, 0.32),
            Offset(0.26, 0.52),
            Offset(0.32, 0.72),
            Offset(0.54, 0.88),
            Offset(0.74, 0.76),
          ]),
        ];
      case 'D':
        return const [
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.50),
            Offset(0.30, 0.88),
          ]),
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.55, 0.12),
            Offset(0.74, 0.36),
            Offset(0.74, 0.64),
            Offset(0.55, 0.88),
            Offset(0.30, 0.88),
          ]),
        ];
      case 'E':
        return const [
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.88),
          ]),
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.72, 0.12),
          ]),
          TracingStroke(points: [
            Offset(0.30, 0.50),
            Offset(0.64, 0.50),
          ]),
          TracingStroke(points: [
            Offset(0.30, 0.88),
            Offset(0.72, 0.88),
          ]),
        ];
      case 'O':
        return const [
          TracingStroke(points: [
            Offset(0.50, 0.12),
            Offset(0.26, 0.32),
            Offset(0.24, 0.54),
            Offset(0.28, 0.74),
            Offset(0.50, 0.88),
            Offset(0.72, 0.74),
            Offset(0.76, 0.54),
            Offset(0.74, 0.32),
            Offset(0.50, 0.12),
          ]),
        ];
      case 'S':
        return const [
          TracingStroke(points: [
            Offset(0.70, 0.22),
            Offset(0.50, 0.12),
            Offset(0.32, 0.26),
            Offset(0.48, 0.48),
            Offset(0.68, 0.66),
            Offset(0.52, 0.88),
            Offset(0.30, 0.78),
          ]),
        ];
      // ── F ─────────────────────────────────────────────────────────────
      case 'F':
        return const [
          // Vertical stroke
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.88),
          ]),
          // Top horizontal bar
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.72, 0.12),
          ]),
          // Mid horizontal bar
          TracingStroke(points: [
            Offset(0.30, 0.50),
            Offset(0.62, 0.50),
          ]),
        ];

      // ── G ─────────────────────────────────────────────────────────────
      case 'G':
        return const [
          TracingStroke(points: [
            Offset(0.74, 0.24),
            Offset(0.52, 0.12),
            Offset(0.28, 0.30),
            Offset(0.24, 0.52),
            Offset(0.30, 0.72),
            Offset(0.52, 0.88),
            Offset(0.74, 0.74),
            Offset(0.74, 0.52),
            Offset(0.54, 0.52),
          ]),
        ];

      // ── H ─────────────────────────────────────────────────────────────
      case 'H':
        return const [
          // Left vertical
          TracingStroke(points: [
            Offset(0.28, 0.12),
            Offset(0.28, 0.88),
          ]),
          // Right vertical
          TracingStroke(points: [
            Offset(0.72, 0.12),
            Offset(0.72, 0.88),
          ]),
          // Crossbar
          TracingStroke(points: [
            Offset(0.28, 0.50),
            Offset(0.72, 0.50),
          ]),
        ];

      // ── I ─────────────────────────────────────────────────────────────
      case 'I':
        return const [
          // Top serif
          TracingStroke(points: [
            Offset(0.32, 0.12),
            Offset(0.68, 0.12),
          ]),
          // Vertical stroke
          TracingStroke(points: [
            Offset(0.50, 0.12),
            Offset(0.50, 0.88),
          ]),
          // Bottom serif
          TracingStroke(points: [
            Offset(0.32, 0.88),
            Offset(0.68, 0.88),
          ]),
        ];

      // ── J ─────────────────────────────────────────────────────────────
      case 'J':
        return const [
          // Top serif
          TracingStroke(points: [
            Offset(0.32, 0.12),
            Offset(0.68, 0.12),
          ]),
          // Vertical + hook
          TracingStroke(points: [
            Offset(0.58, 0.12),
            Offset(0.58, 0.72),
            Offset(0.50, 0.86),
            Offset(0.36, 0.84),
            Offset(0.30, 0.72),
          ]),
        ];

      // ── K ─────────────────────────────────────────────────────────────
      case 'K':
        return const [
          // Left vertical
          TracingStroke(points: [
            Offset(0.28, 0.12),
            Offset(0.28, 0.88),
          ]),
          // Upper diagonal (top-right to mid)
          TracingStroke(points: [
            Offset(0.72, 0.12),
            Offset(0.28, 0.50),
          ]),
          // Lower diagonal (mid to bottom-right)
          TracingStroke(points: [
            Offset(0.28, 0.50),
            Offset(0.72, 0.88),
          ]),
        ];

      // ── L ─────────────────────────────────────────────────────────────
      case 'L':
        return const [
          // Vertical stroke
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.88),
          ]),
          // Horizontal base
          TracingStroke(points: [
            Offset(0.30, 0.88),
            Offset(0.72, 0.88),
          ]),
        ];


      // ── M ─────────────────────────────────────────────────────────────
      case 'M':
        return const [
          // Left leg
          TracingStroke(points: [
            Offset(0.18, 0.88),
            Offset(0.18, 0.12),
          ]),
          // Left diagonal down to valley
          TracingStroke(points: [
            Offset(0.18, 0.12),
            Offset(0.50, 0.55),
          ]),
          // Right diagonal up from valley
          TracingStroke(points: [
            Offset(0.50, 0.55),
            Offset(0.82, 0.12),
          ]),
          // Right leg
          TracingStroke(points: [
            Offset(0.82, 0.12),
            Offset(0.82, 0.88),
          ]),
        ];

      // ── N ─────────────────────────────────────────────────────────────
      case 'N':
        return const [
          // Left vertical
          TracingStroke(points: [
            Offset(0.26, 0.12),
            Offset(0.26, 0.88),
          ]),
          // Diagonal
          TracingStroke(points: [
            Offset(0.26, 0.12),
            Offset(0.74, 0.88),
          ]),
          // Right vertical
          TracingStroke(points: [
            Offset(0.74, 0.12),
            Offset(0.74, 0.88),
          ]),
        ];

      // ── P ─────────────────────────────────────────────────────────────
      case 'P':
        return const [
          // Vertical
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.88),
          ]),
          // Bump (top half only)
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.58, 0.12),
            Offset(0.72, 0.28),
            Offset(0.58, 0.50),
            Offset(0.30, 0.50),
          ]),
        ];

      // ── Q ─────────────────────────────────────────────────────────────
      case 'Q':
        return const [
          // Circle (O shape)
          TracingStroke(points: [
            Offset(0.50, 0.12),
            Offset(0.26, 0.32),
            Offset(0.24, 0.54),
            Offset(0.28, 0.74),
            Offset(0.50, 0.88),
            Offset(0.72, 0.74),
            Offset(0.76, 0.54),
            Offset(0.74, 0.32),
            Offset(0.50, 0.12),
          ]),
          // Tail (bottom-right)
          TracingStroke(points: [
            Offset(0.58, 0.68),
            Offset(0.76, 0.88),
          ]),
        ];

      // ── R ─────────────────────────────────────────────────────────────
      case 'R':
        return const [
          // Vertical
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.30, 0.88),
          ]),
          // Bump (top half)
          TracingStroke(points: [
            Offset(0.30, 0.12),
            Offset(0.58, 0.12),
            Offset(0.72, 0.28),
            Offset(0.58, 0.50),
            Offset(0.30, 0.50),
          ]),
          // Leg (diagonal from mid to bottom-right)
          TracingStroke(points: [
            Offset(0.48, 0.50),
            Offset(0.72, 0.88),
          ]),
        ];

      // ── T ─────────────────────────────────────────────────────────────
      case 'T':
        return const [
          // Top bar
          TracingStroke(points: [
            Offset(0.20, 0.12),
            Offset(0.50, 0.12),
            Offset(0.80, 0.12),
          ]),
          // Vertical stem
          TracingStroke(points: [
            Offset(0.50, 0.12),
            Offset(0.50, 0.88),
          ]),
        ];

      // ── U ─────────────────────────────────────────────────────────────
      case 'U':
        return const [
          TracingStroke(points: [
            Offset(0.28, 0.12),
            Offset(0.28, 0.68),
            Offset(0.34, 0.82),
            Offset(0.50, 0.88),
            Offset(0.66, 0.82),
            Offset(0.72, 0.68),
            Offset(0.72, 0.12),
          ]),
        ];

      // ── V ─────────────────────────────────────────────────────────────
      case 'V':
        return const [
          TracingStroke(points: [
            Offset(0.22, 0.12),
            Offset(0.50, 0.88),
            Offset(0.78, 0.12),
          ]),
        ];

      // ── W ─────────────────────────────────────────────────────────────
      case 'W':
        return const [
          TracingStroke(points: [
            Offset(0.14, 0.12),
            Offset(0.30, 0.88),
            Offset(0.50, 0.42),
            Offset(0.70, 0.88),
            Offset(0.86, 0.12),
          ]),
        ];

      // ── X ─────────────────────────────────────────────────────────────
      case 'X':
        return const [
          // Top-left to bottom-right
          TracingStroke(points: [
            Offset(0.26, 0.12),
            Offset(0.74, 0.88),
          ]),
          // Top-right to bottom-left
          TracingStroke(points: [
            Offset(0.74, 0.12),
            Offset(0.26, 0.88),
          ]),
        ];

      // ── Y ─────────────────────────────────────────────────────────────
      case 'Y':
        return const [
          // Left arm to center
          TracingStroke(points: [
            Offset(0.24, 0.12),
            Offset(0.50, 0.50),
          ]),
          // Right arm to center
          TracingStroke(points: [
            Offset(0.76, 0.12),
            Offset(0.50, 0.50),
          ]),
          // Stem down
          TracingStroke(points: [
            Offset(0.50, 0.50),
            Offset(0.50, 0.88),
          ]),
        ];

      // ── Z ─────────────────────────────────────────────────────────────
      case 'Z':
        return const [
          // Top bar
          TracingStroke(points: [
            Offset(0.26, 0.12),
            Offset(0.74, 0.12),
          ]),
          // Diagonal
          TracingStroke(points: [
            Offset(0.74, 0.12),
            Offset(0.26, 0.88),
          ]),
          // Bottom bar
          TracingStroke(points: [
            Offset(0.26, 0.88),
            Offset(0.74, 0.88),
          ]),
        ];

      default:
        return const [
          TracingStroke(points: [
            Offset(0.32, 0.14),
            Offset(0.32, 0.50),
            Offset(0.32, 0.86),
          ]),
          TracingStroke(points: [
            Offset(0.32, 0.24),
            Offset(0.68, 0.40),
            Offset(0.68, 0.60),
            Offset(0.32, 0.76),
          ]),
        ];
    }
  }
}
