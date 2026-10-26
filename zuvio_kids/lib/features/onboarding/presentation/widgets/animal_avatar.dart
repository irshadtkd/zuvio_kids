import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';

/// Renders crisp vector cartoon animal faces matching the Figma designs.
class AnimalAvatar extends StatelessWidget {
  const AnimalAvatar({
    super.key,
    required this.avatarType,
    this.size = 100,
  });

  final String avatarType;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _AnimalPainter(avatarType: avatarType.toLowerCase()),
      ),
    );
  }
}

class _AnimalPainter extends CustomPainter {
  const _AnimalPainter({required this.avatarType});

  final String avatarType;

  @override
  void paint(Canvas canvas, Size size) {
    switch (avatarType) {
      case 'bunny':
        _paintBunny(canvas, size);
        break;
      case 'lion':
        _paintLion(canvas, size);
        break;
      case 'frog':
        _paintFrog(canvas, size);
        break;
      case 'cat':
        _paintCat(canvas, size);
        break;
      case 'dog':
        _paintDog(canvas, size);
        break;
      case 'panda':
      default:
        _paintPanda(canvas, size);
        break;
    }
  }

  void _paintPanda(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final navyFill = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // 1. Ears
    final earRadius = size.width * 0.16;
    final leftEarCenter = Offset(size.width * 0.28, size.height * 0.27);
    final rightEarCenter = Offset(size.width * 0.72, size.height * 0.27);

    canvas.drawCircle(leftEarCenter, earRadius, navyFill);
    canvas.drawCircle(rightEarCenter, earRadius, navyFill);

    // 2. Head
    final headCenter = Offset(size.width * 0.5, size.height * 0.58);
    final headRadius = size.width * 0.38;

    canvas.drawCircle(headCenter, headRadius, fillPaint);
    canvas.drawCircle(headCenter, headRadius, strokePaint);

    // 3. Eye Patches
    final eyeWidth = size.width * 0.17;
    final eyeHeight = size.height * 0.23;

    // Left Eye
    final leftEyeRect = Rect.fromCenter(
      center: Offset(size.width * 0.39, size.height * 0.56),
      width: eyeWidth,
      height: eyeHeight,
    );
    canvas.save();
    canvas.translate(leftEyeRect.center.dx, leftEyeRect.center.dy);
    canvas.rotate(-math.pi / 22);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: eyeWidth, height: eyeHeight),
      navyFill,
    );
    // Highlight
    canvas.drawCircle(
      Offset(-eyeWidth * 0.15, -eyeHeight * 0.2),
      size.width * 0.045,
      fillPaint,
    );
    canvas.restore();

    // Right Eye
    final rightEyeRect = Rect.fromCenter(
      center: Offset(size.width * 0.61, size.height * 0.56),
      width: eyeWidth,
      height: eyeHeight,
    );
    canvas.save();
    canvas.translate(rightEyeRect.center.dx, rightEyeRect.center.dy);
    canvas.rotate(math.pi / 22);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: eyeWidth, height: eyeHeight),
      navyFill,
    );
    // Highlight
    canvas.drawCircle(
      Offset(-eyeWidth * 0.15, -eyeHeight * 0.2),
      size.width * 0.045,
      fillPaint,
    );
    canvas.restore();

    // 4. Nose
    final noseRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.69),
      width: size.width * 0.12,
      height: size.height * 0.08,
    );
    canvas.drawOval(noseRect, navyFill);
  }

  void _paintBunny(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final navyFill = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Ears
    final earWidth = size.width * 0.14;
    final earHeight = size.height * 0.42;

    final leftEarRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.38, size.height * 0.28),
        width: earWidth,
        height: earHeight,
      ),
      Radius.circular(earWidth / 2),
    );
    final rightEarRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.62, size.height * 0.28),
        width: earWidth,
        height: earHeight,
      ),
      Radius.circular(earWidth / 2),
    );

    canvas.drawRRect(leftEarRect, fillPaint);
    canvas.drawRRect(leftEarRect, strokePaint);
    canvas.drawRRect(rightEarRect, fillPaint);
    canvas.drawRRect(rightEarRect, strokePaint);

    // Head
    final headCenter = Offset(size.width * 0.5, size.height * 0.62);
    final headRadius = size.width * 0.35;
    canvas.drawCircle(headCenter, headRadius, fillPaint);
    canvas.drawCircle(headCenter, headRadius, strokePaint);

    // Eyes
    canvas.drawCircle(
      Offset(size.width * 0.41, size.height * 0.59),
      size.width * 0.045,
      navyFill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.59, size.height * 0.59),
      size.width * 0.045,
      navyFill,
    );

    // Nose
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.68),
      size.width * 0.035,
      navyFill,
    );
  }

  void _paintLion(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final manePaint = Paint()
      ..color = const Color(0xFFF7941D)
      ..style = PaintingStyle.fill;

    final facePaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.fill;

    final navyFill = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.5, size.height * 0.5);

    // Outer Mane
    final maneRadius = size.width * 0.42;
    canvas.drawCircle(center, maneRadius, manePaint);
    canvas.drawCircle(center, maneRadius, strokePaint);

    // Face
    final faceRadius = size.width * 0.28;
    canvas.drawCircle(center, faceRadius, facePaint);
    canvas.drawCircle(center, faceRadius, strokePaint);

    // Eyes
    canvas.drawCircle(
      Offset(size.width * 0.43, size.height * 0.48),
      size.width * 0.04,
      navyFill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.57, size.height * 0.48),
      size.width * 0.04,
      navyFill,
    );

    // Nose
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.56),
      size.width * 0.035,
      navyFill,
    );
  }

  void _paintFrog(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final frogGreen = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final navyFill = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Eye bumps
    final leftEyeCenter = Offset(size.width * 0.35, size.height * 0.38);
    final rightEyeCenter = Offset(size.width * 0.65, size.height * 0.38);
    final eyeBumpRadius = size.width * 0.16;

    canvas.drawCircle(leftEyeCenter, eyeBumpRadius, whiteFill);
    canvas.drawCircle(leftEyeCenter, eyeBumpRadius, strokePaint);

    canvas.drawCircle(rightEyeCenter, eyeBumpRadius, whiteFill);
    canvas.drawCircle(rightEyeCenter, eyeBumpRadius, strokePaint);

    // Head
    final headRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.58),
      width: size.width * 0.76,
      height: size.height * 0.55,
    );
    canvas.drawOval(headRect, frogGreen);
    canvas.drawOval(headRect, strokePaint);

    // Pupils
    canvas.drawCircle(leftEyeCenter, size.width * 0.07, navyFill);
    canvas.drawCircle(rightEyeCenter, size.width * 0.07, navyFill);

    // Smile
    final smilePath = Path()
      ..moveTo(size.width * 0.38, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.74,
        size.width * 0.62,
        size.height * 0.62,
      );
    canvas.drawPath(smilePath, strokePaint);
  }

  void _paintCat(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final catOrange = Paint()
      ..color = const Color(0xFFFF9E80)
      ..style = PaintingStyle.fill;

    final navyFill = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Ears + Head Path
    final path = Path();
    final center = Offset(size.width * 0.5, size.height * 0.55);
    final radius = size.width * 0.34;

    // Cat with ears path
    path.moveTo(size.width * 0.25, size.height * 0.3);
    path.lineTo(size.width * 0.18, size.height * 0.15); // Left ear tip
    path.lineTo(size.width * 0.38, size.height * 0.24);
    path.lineTo(size.width * 0.62, size.height * 0.24);
    path.lineTo(size.width * 0.82, size.height * 0.15); // Right ear tip
    path.lineTo(size.width * 0.75, size.height * 0.3);
    path.arcToPoint(
      Offset(size.width * 0.25, size.height * 0.3),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    canvas.drawCircle(center, radius, catOrange);
    canvas.drawPath(path, catOrange);
    canvas.drawPath(path, strokePaint);
    canvas.drawCircle(center, radius, strokePaint);

    // Eyes
    canvas.drawCircle(
      Offset(size.width * 0.41, size.height * 0.52),
      size.width * 0.045,
      navyFill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.59, size.height * 0.52),
      size.width * 0.045,
      navyFill,
    );

    // Nose
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.6),
      size.width * 0.035,
      navyFill,
    );
  }

  void _paintDog(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dogFace = Paint()
      ..color = const Color(0xFFECCB9E)
      ..style = PaintingStyle.fill;

    final dogEar = Paint()
      ..color = const Color(0xFF9E653A)
      ..style = PaintingStyle.fill;

    final navyFill = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Floppy ears
    final leftEarRect = Rect.fromCenter(
      center: Offset(size.width * 0.24, size.height * 0.52),
      width: size.width * 0.16,
      height: size.height * 0.34,
    );
    final rightEarRect = Rect.fromCenter(
      center: Offset(size.width * 0.76, size.height * 0.52),
      width: size.width * 0.16,
      height: size.height * 0.34,
    );

    canvas.drawOval(leftEarRect, dogEar);
    canvas.drawOval(leftEarRect, strokePaint);
    canvas.drawOval(rightEarRect, dogEar);
    canvas.drawOval(rightEarRect, strokePaint);

    // Head
    final center = Offset(size.width * 0.5, size.height * 0.52);
    final radius = size.width * 0.32;
    canvas.drawCircle(center, radius, dogFace);
    canvas.drawCircle(center, radius, strokePaint);

    // Eyes
    canvas.drawCircle(
      Offset(size.width * 0.41, size.height * 0.48),
      size.width * 0.045,
      navyFill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.59, size.height * 0.48),
      size.width * 0.045,
      navyFill,
    );

    // Nose
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.58),
      size.width * 0.04,
      navyFill,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimalPainter oldDelegate) =>
      oldDelegate.avatarType != avatarType;
}
