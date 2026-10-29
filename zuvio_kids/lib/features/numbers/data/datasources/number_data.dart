import 'package:flutter/material.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_entity.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_session_entity.dart';

/// Waypoint points for a single tracing stroke of a number.
class NumberStroke {
  const NumberStroke({
    required this.points,
    this.strokeNumber = 1,
  });

  final List<Offset> points;
  final int strokeNumber;
}

/// Static catalog of all 100 numbers, 10 learning sessions, word names,
/// and tracing strokes for digits 0–9 and composite numbers 1–100.
/// Layer: Data
abstract final class NumberData {
  /// Converts an integer (1–100) into its English word name.
  static String getWordName(int n) {
    if (n < 1 || n > 100) return '$n';
    if (n == 100) return 'One hundred';

    const units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
    ];

    if (n < 20) return units[n];

    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety',
    ];

    final tenPart = tens[n ~/ 10];
    final unitPart = n % 10;
    if (unitPart == 0) return tenPart;
    return '$tenPart-${units[unitPart].toLowerCase()}';
  }

  /// Generates 3 distinct quiz options including [n] and 2 distractors.
  static List<int> generateQuizOptions(int n) {
    final set = <int>{n};
    final candidates = [
      if (n > 2) n - 2,
      if (n > 1) n - 1,
      if (n < 100) n + 1,
      if (n < 99) n + 2,
      if (n > 3) n - 3,
      if (n < 98) n + 3,
    ];

    for (final c in candidates) {
      if (set.length == 3) break;
      if (c > 0 && c <= 100) {
        set.add(c);
      }
    }

    int fallback = 1;
    while (set.length < 3) {
      if (!set.contains(fallback)) {
        set.add(fallback);
      }
      fallback++;
    }

    return set.toList();
  }

  /// Normalized base stroke paths for digits 0–9.
  /// Coordinates are normalized within [0.0, 1.0] for both width and height.
  static List<List<Offset>> getRawDigitStrokes(int digit) {
    switch (digit) {
      case 0:
        return [
          [
            const Offset(0.50, 0.18),
            const Offset(0.32, 0.28),
            const Offset(0.25, 0.50),
            const Offset(0.32, 0.72),
            const Offset(0.50, 0.82),
            const Offset(0.68, 0.72),
            const Offset(0.75, 0.50),
            const Offset(0.68, 0.28),
            const Offset(0.50, 0.18),
          ],
        ];

      case 1:
        return [
          [
            const Offset(0.35, 0.32),
            const Offset(0.50, 0.18),
            const Offset(0.50, 0.82),
          ],
        ];

      case 2:
        return [
          [
            const Offset(0.30, 0.32),
            const Offset(0.40, 0.20),
            const Offset(0.62, 0.20),
            const Offset(0.72, 0.32),
            const Offset(0.68, 0.44),
            const Offset(0.28, 0.82),
            const Offset(0.75, 0.82),
          ],
        ];

      case 3:
        return [
          [
            const Offset(0.30, 0.22),
            const Offset(0.70, 0.22),
            const Offset(0.50, 0.46),
            const Offset(0.72, 0.58),
            const Offset(0.66, 0.76),
            const Offset(0.45, 0.82),
            const Offset(0.30, 0.76),
          ],
        ];

      case 4:
        return [
          [
            const Offset(0.64, 0.20),
            const Offset(0.28, 0.58),
            const Offset(0.74, 0.58),
          ],
          [
            const Offset(0.64, 0.20),
            const Offset(0.64, 0.82),
          ],
        ];

      case 5:
        return [
          [
            const Offset(0.70, 0.20),
            const Offset(0.32, 0.20),
            const Offset(0.32, 0.46),
            const Offset(0.68, 0.52),
            const Offset(0.72, 0.70),
            const Offset(0.52, 0.82),
            const Offset(0.30, 0.78),
          ],
        ];

      case 6:
        return [
          [
            const Offset(0.66, 0.22),
            const Offset(0.44, 0.36),
            const Offset(0.28, 0.56),
            const Offset(0.38, 0.82),
            const Offset(0.66, 0.82),
            const Offset(0.72, 0.66),
            const Offset(0.56, 0.50),
            const Offset(0.32, 0.54),
          ],
        ];

      case 7:
        // Matches Screenshot 3: horizontal bar across top, then diagonal stroke down-left
        return [
          [
            const Offset(0.28, 0.22),
            const Offset(0.74, 0.22),
            const Offset(0.42, 0.82),
          ],
        ];

      case 8:
        return [
          [
            const Offset(0.50, 0.48),
            const Offset(0.34, 0.34),
            const Offset(0.50, 0.20),
            const Offset(0.66, 0.34),
            const Offset(0.50, 0.48),
            const Offset(0.30, 0.64),
            const Offset(0.50, 0.82),
            const Offset(0.70, 0.64),
            const Offset(0.50, 0.48),
          ],
        ];

      case 9:
        return [
          [
            const Offset(0.70, 0.46),
            const Offset(0.70, 0.32),
            const Offset(0.50, 0.20),
            const Offset(0.30, 0.32),
            const Offset(0.50, 0.46),
            const Offset(0.70, 0.46),
            const Offset(0.66, 0.74),
            const Offset(0.44, 0.82),
          ],
        ];

      default:
        return [];
    }
  }

  /// Calculates composite tracing strokes for any number from 1 to 100.
  /// Multi-digit numbers place each digit side-by-side cleanly centered.
  static List<NumberStroke> getTracingStrokes(int number) {
    final digitChars = number.toString().split('');
    final numDigits = digitChars.length;

    final strokes = <NumberStroke>[];
    int currentStrokeNumber = 1;

    // Layout configuration
    final double digitWidth;
    final double gap;
    final double totalWidth;

    if (numDigits == 1) {
      digitWidth = 0.62;
      gap = 0.0;
      totalWidth = digitWidth;
    } else if (numDigits == 2) {
      digitWidth = 0.38;
      gap = 0.06;
      totalWidth = (digitWidth * 2) + gap;
    } else {
      // 3 digits (100)
      digitWidth = 0.27;
      gap = 0.04;
      totalWidth = (digitWidth * 3) + (gap * 2);
    }

    final startX = (1.0 - totalWidth) / 2.0;

    for (int i = 0; i < numDigits; i++) {
      final digit = int.parse(digitChars[i]);
      final digitRawStrokes = getRawDigitStrokes(digit);

      final digitStartX = startX + i * (digitWidth + gap);

      for (final rawStroke in digitRawStrokes) {
        final scaledPoints = rawStroke.map((pt) {
          final x = digitStartX + (pt.dx * digitWidth);
          final y = pt.dy;
          return Offset(x, y);
        }).toList();

        strokes.add(
          NumberStroke(
            points: scaledPoints,
            strokeNumber: currentStrokeNumber++,
          ),
        );
      }
    }

    return strokes;
  }

  /// All 100 [NumberEntity] objects grouped in 10 sessions.
  static final List<NumberSessionEntity> defaultSessions = List.generate(10, (sIdx) {
    final sessionNum = sIdx + 1;
    final startNum = (sIdx * 10) + 1;
    final endNum = sessionNum * 10;
    final range = '$startNum-$endNum';

    final numbers = List.generate(10, (nIdx) {
      final val = startNum + nIdx;
      return NumberEntity(
        value: val,
        wordName: getWordName(val),
        quizOptions: generateQuizOptions(val),
      );
    });

    return NumberSessionEntity(
      id: 'session_$sessionNum',
      sessionNumber: sessionNum,
      rangeLabel: range,
      numbers: numbers,
      isCompleted: false,
      isLocked: sessionNum != 1, // Only Session 1 is unlocked initially
      starsEarned: 0,
    );
  });
}
