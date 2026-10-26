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
        default:
          return const [
            TracingStroke(points: [
              Offset(0.34, 0.44),
              Offset(0.34, 0.88),
            ]),
            TracingStroke(points: [
              Offset(0.34, 0.54),
              Offset(0.66, 0.66),
              Offset(0.34, 0.82),
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
