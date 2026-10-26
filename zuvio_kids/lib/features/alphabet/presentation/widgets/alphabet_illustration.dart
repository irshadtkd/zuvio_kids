import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';

/// Kid-friendly vector illustrations for alphabet words and quiz cards.
/// Matches the reference illustrations (Apple, Cat, Sun, Dog, Ball, etc.).
/// Layer: Presentation Widget
class AlphabetIllustration extends StatelessWidget {
  const AlphabetIllustration({
    super.key,
    required this.word,
    this.size = 80,
  });

  final String word;
  final double size;

  @override
  Widget build(BuildContext context) {
    final key = word.trim().toLowerCase();

    Widget illustration;
    switch (key) {
      case 'apple':
        illustration = const _AppleVisual();
        break;
      case 'ball':
        illustration = const _BallVisual();
        break;
      case 'cat':
        illustration = const _CatVisual();
        break;
      case 'sun':
        illustration = const _SunVisual();
        break;
      case 'dog':
        illustration = const _DogVisual();
        break;
      case 'star':
        illustration = const _StarVisual();
        break;
      case 'car':
        illustration = const _CarVisual();
        break;
      case 'cup':
        illustration = const _CupVisual();
        break;
      case 'duck':
        illustration = const _DuckVisual();
        break;
      case 'fish':
        illustration = const _FishVisual();
        break;
      case 'hat':
        illustration = const _HatVisual();
        break;
      case 'moon':
        illustration = const _MoonVisual();
        break;
      case 'boat':
        illustration = const _BoatVisual();
        break;
      default:
        illustration = _GenericVisual(text: word.isNotEmpty ? word[0].toUpperCase() : '?');
        break;
    }

    return SizedBox(
      width: size,
      height: size,
      child: Center(child: illustration),
    );
  }
}

/// Red rounded apple with green curved stem (matches Image 1).
class _AppleVisual extends StatelessWidget {
  const _AppleVisual();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 64),
      painter: _ApplePainter(),
    );
  }
}

class _ApplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..color = const Color(0xFFFF5E5E)
      ..style = PaintingStyle.fill;

    // Left and right lobes
    final leftLobe = Rect.fromCenter(
      center: Offset(size.width * 0.40, size.height * 0.60),
      width: size.width * 0.52,
      height: size.height * 0.58,
    );
    final rightLobe = Rect.fromCenter(
      center: Offset(size.width * 0.60, size.height * 0.60),
      width: size.width * 0.52,
      height: size.height * 0.58,
    );

    canvas.drawRRect(RRect.fromRectAndRadius(leftLobe, const Radius.circular(20)), bodyPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rightLobe, const Radius.circular(20)), bodyPaint);

    // Green curved leaf / stem
    final stemPaint = Paint()
      ..color = const Color(0xFF33B763)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final stemPath = Path()
      ..moveTo(size.width * 0.50, size.height * 0.38)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.16,
        size.width * 0.64,
        size.height * 0.16,
      );
    canvas.drawPath(stemPath, stemPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cute Cat head visual (matches Image 3 Yellow Card).
class _CatVisual extends StatelessWidget {
  const _CatVisual();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 60),
      painter: _CatPainter(),
    );
  }
}

class _CatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFFFAE68)
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.5;
    final cy = size.height * 0.56;
    final r = size.width * 0.36;

    // Ears
    final leftEar = Path()
      ..moveTo(cx - r * 0.8, cy - r * 0.4)
      ..lineTo(cx - r * 0.9, cy - r * 1.3)
      ..lineTo(cx - r * 0.2, cy - r * 0.8)
      ..close();
    canvas.drawPath(leftEar, fillPaint);
    canvas.drawPath(leftEar, strokePaint);

    final rightEar = Path()
      ..moveTo(cx + r * 0.8, cy - r * 0.4)
      ..lineTo(cx + r * 0.9, cy - r * 1.3)
      ..lineTo(cx + r * 0.2, cy - r * 0.8)
      ..close();
    canvas.drawPath(rightEar, fillPaint);
    canvas.drawPath(rightEar, strokePaint);

    // Head circle
    canvas.drawCircle(Offset(cx, cy), r, fillPaint);
    canvas.drawCircle(Offset(cx, cy), r, strokePaint);

    // Eyes
    final dotPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(cx - 8, cy - 2), 3.2, dotPaint);
    canvas.drawCircle(Offset(cx + 8, cy - 2), 3.2, dotPaint);

    // Nose
    canvas.drawCircle(Offset(cx, cy + 6), 2.4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cute Sun visual (matches Image 3 Green Card).
class _SunVisual extends StatelessWidget {
  const _SunVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD13B),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.navy, width: 2.8),
      ),
    );
  }
}

/// Cute Dog head visual (matches Image 3 Lavender Card).
class _DogVisual extends StatelessWidget {
  const _DogVisual();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 60),
      painter: _DogPainter(),
    );
  }
}

class _DogPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8;

    final fillPaint = Paint()
      ..color = const Color(0xFFE2B77D)
      ..style = PaintingStyle.fill;

    final earPaint = Paint()
      ..color = const Color(0xFF9E6534)
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.5;
    final cy = size.height * 0.54;

    // Floppy ears
    final leftEar = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx - 24, cy), width: 14, height: 32),
      const Radius.circular(8),
    );
    canvas.drawRRect(leftEar, earPaint);
    canvas.drawRRect(leftEar, strokePaint);

    final rightEar = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 24, cy), width: 14, height: 32),
      const Radius.circular(8),
    );
    canvas.drawRRect(rightEar, earPaint);
    canvas.drawRRect(rightEar, strokePaint);

    // Head
    canvas.drawCircle(Offset(cx, cy), 20, fillPaint);
    canvas.drawCircle(Offset(cx, cy), 20, strokePaint);

    // Eyes
    final dotPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(cx - 8, cy - 2), 3.2, dotPaint);
    canvas.drawCircle(Offset(cx + 8, cy - 2), 3.2, dotPaint);

    // Nose
    canvas.drawCircle(Offset(cx, cy + 6), 3.4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Colorful ball visual
class _BallVisual extends StatelessWidget {
  const _BallVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFF5E5E),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.navy, width: 2.8),
      ),
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFFFD13B),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// Star visual
class _StarVisual extends StatelessWidget {
  const _StarVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.star_rounded,
      color: Color(0xFFFFD13B),
      size: 50,
    );
  }
}

/// Car visual
class _CarVisual extends StatelessWidget {
  const _CarVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.directions_car_rounded,
      color: Color(0xFF4A90D9),
      size: 48,
    );
  }
}

/// Cup visual
class _CupVisual extends StatelessWidget {
  const _CupVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.local_cafe_rounded,
      color: Color(0xFF33B763),
      size: 46,
    );
  }
}

/// Duck / Bird visual
class _DuckVisual extends StatelessWidget {
  const _DuckVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.flutter_dash_rounded,
      color: Color(0xFFFFB800),
      size: 48,
    );
  }
}

/// Fish visual
class _FishVisual extends StatelessWidget {
  const _FishVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.set_meal_rounded,
      color: Color(0xFFFF7E67),
      size: 48,
    );
  }
}

/// Hat visual
class _HatVisual extends StatelessWidget {
  const _HatVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.storefront_rounded,
      color: Color(0xFF8CD4F7),
      size: 46,
    );
  }
}

/// Moon visual
class _MoonVisual extends StatelessWidget {
  const _MoonVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.nightlight_round,
      color: Color(0xFFFFD13B),
      size: 46,
    );
  }
}

/// Boat visual
class _BoatVisual extends StatelessWidget {
  const _BoatVisual();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.sailing_rounded,
      color: Color(0xFF4A90D9),
      size: 46,
    );
  }
}

/// Fallback generic visual
class _GenericVisual extends StatelessWidget {
  const _GenericVisual({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardYellow,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.navy, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}
