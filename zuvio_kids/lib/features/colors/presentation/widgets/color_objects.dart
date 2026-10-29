import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';

/// Interactive paintable objects for Colors Learning:
/// Apple, Banana, Leaf, Balloon, Carrot, Grapes, Flower.
/// Layer: Presentation Widget
class PaintableObjectWidget extends StatelessWidget {
  const PaintableObjectWidget({
    super.key,
    required this.objectName,
    required this.appliedColorValue,
    required this.onTap,
    this.width = 220,
    this.height = 200,
  });

  final String objectName;
  final int? appliedColorValue;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        child: CustomPaint(
          size: Size(width, height),
          painter: _PaintableObjectPainter(
            objectName: objectName,
            fillColor: appliedColorValue != null
                ? Color(appliedColorValue!)
                : const Color(0xFFF1F5F9),
            isColored: appliedColorValue != null,
          ),
        ),
      ),
    );
  }
}

class _PaintableObjectPainter extends CustomPainter {
  _PaintableObjectPainter({
    required this.objectName,
    required this.fillColor,
    required this.isColored,
  });

  final String objectName;
  final Color fillColor;
  final bool isColored;

  @override
  void paint(Canvas canvas, Size size) {
    const refWidth = 220.0;
    const refHeight = 200.0;

    final scaleX = size.width / refWidth;
    final scaleY = size.height / refHeight;
    final scale = math.min(scaleX, scaleY);

    canvas.save();
    // Center within destination bounds while strictly maintaining aspect ratio
    final dx = (size.width - refWidth * scale) / 2;
    final dy = (size.height - refHeight * scale) / 2;
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    const refSize = Size(refWidth, refHeight);

    switch (objectName) {
      case 'apple':
        _drawApple(canvas, refSize);
        break;
      case 'banana':
        _drawBanana(canvas, refSize);
        break;
      case 'leaf':
        _drawLeaf(canvas, refSize);
        break;
      case 'balloon':
        _drawBalloon(canvas, refSize);
        break;
      case 'carrot':
        _drawCarrot(canvas, refSize);
        break;
      case 'grapes':
        _drawGrapes(canvas, refSize);
        break;
      case 'flower':
      default:
        _drawFlower(canvas, refSize);
        break;
    }
    canvas.restore();
  }

  // ── 1. Apple (Matches screenshot) ─────────────────────────────────────────
  void _drawApple(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 15;

    // Green stem
    final stemPaint = Paint()
      ..color = const Color(0xFF38C172)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final stemPath = Path()
      ..moveTo(cx - 4, cy - 50)
      ..quadraticBezierTo(cx + 8, cy - 80, cx + 26, cy - 72);
    canvas.drawPath(stemPath, stemPaint);

    // Apple body fill & outline
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final bodyPath = Path();
    // Two overlapping circular lobes forming the iconic apple shape
    bodyPath.moveTo(cx, cy - 36);
    // Right lobe
    bodyPath.cubicTo(cx + 40, cy - 48, cx + 80, cy - 20, cx + 75, cy + 18);
    bodyPath.cubicTo(cx + 70, cy + 55, cx + 32, cy + 62, cx, cy + 52);
    // Left lobe
    bodyPath.cubicTo(cx - 32, cy + 62, cx - 70, cy + 55, cx - 75, cy + 18);
    bodyPath.cubicTo(cx - 80, cy - 20, cx - 40, cy - 48, cx, cy - 36);
    bodyPath.close();

    canvas.drawPath(bodyPath, fillPaint);
    if (!isColored) {
      canvas.drawPath(bodyPath, borderPaint);
    }
  }

  // ── 2. Banana ─────────────────────────────────────────────────────────────
  void _drawBanana(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final bananaPath = Path()
      ..moveTo(cx - 60, cy - 40)
      ..cubicTo(cx - 10, cy + 70, cx + 50, cy + 60, cx + 70, cy - 10)
      ..cubicTo(cx + 45, cy + 30, cx - 5, cy + 35, cx - 48, cy - 32)
      ..close();

    canvas.drawPath(bananaPath, fillPaint);
    if (!isColored) {
      canvas.drawPath(bananaPath, borderPaint);
    }

    // Stem and tip
    final detailPaint = Paint()
      ..color = const Color(0xFF8B5A2B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 57, cy - 37), 5, detailPaint);
    canvas.drawCircle(Offset(cx + 68, cy - 8), 4, detailPaint);
  }

  // ── 3. Leaf ───────────────────────────────────────────────────────────────
  void _drawLeaf(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final leafPath = Path()
      ..moveTo(cx - 55, cy + 45)
      ..quadraticBezierTo(cx - 50, cy - 50, cx + 55, cy - 50)
      ..quadraticBezierTo(cx + 50, cy + 45, cx - 55, cy + 45)
      ..close();

    canvas.drawPath(leafPath, fillPaint);
    if (!isColored) {
      canvas.drawPath(leafPath, borderPaint);
    }

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - 55, cy + 45),
      Offset(cx - 75, cy + 65),
      stemPaint,
    );
  }

  // ── 4. Balloon ────────────────────────────────────────────────────────────
  void _drawBalloon(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - 18;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    // Balloon oval
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: 120, height: 140);
    canvas.drawOval(rect, fillPaint);
    if (!isColored) {
      canvas.drawOval(rect, borderPaint);
    }

    // Knot
    final knotPath = Path()
      ..moveTo(cx - 8, cy + 70)
      ..lineTo(cx + 8, cy + 70)
      ..lineTo(cx, cy + 78)
      ..close();
    canvas.drawPath(knotPath, fillPaint);

    // String
    final stringPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final stringPath = Path()
      ..moveTo(cx, cy + 78)
      ..quadraticBezierTo(cx - 15, cy + 96, cx, cy + 114);
    canvas.drawPath(stringPath, stringPaint);
  }

  // ── 5. Carrot ─────────────────────────────────────────────────────────────
  void _drawCarrot(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    // Leafy sprigs
    final sprigPaint = Paint()
      ..color = const Color(0xFF38C172)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy - 50), Offset(cx - 25, cy - 80), sprigPaint);
    canvas.drawLine(Offset(cx, cy - 50), Offset(cx, cy - 85), sprigPaint);
    canvas.drawLine(Offset(cx, cy - 50), Offset(cx + 25, cy - 80), sprigPaint);

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final carrotPath = Path()
      ..moveTo(cx - 36, cy - 50)
      ..quadraticBezierTo(cx, cy - 56, cx + 36, cy - 50)
      ..quadraticBezierTo(cx + 25, cy + 20, cx, cy + 65)
      ..quadraticBezierTo(cx - 25, cy + 20, cx - 36, cy - 50)
      ..close();

    canvas.drawPath(carrotPath, fillPaint);
    if (!isColored) {
      canvas.drawPath(carrotPath, borderPaint);
    }
  }

  // ── 6. Grapes ─────────────────────────────────────────────────────────────
  void _drawGrapes(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Vine stem
    final vinePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - 40), Offset(cx, cy - 70), vinePaint);

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Grape cluster circles (3 rows: 3 on top, 2 in mid, 1 at bottom)
    const r = 20.0;
    final points = [
      Offset(cx - 30, cy - 25),
      Offset(cx + 10, cy - 25),
      Offset(cx + 45, cy - 20),
      Offset(cx - 15, cy + 10),
      Offset(cx + 25, cy + 10),
      Offset(cx + 5, cy + 45),
    ];

    for (final pt in points) {
      canvas.drawCircle(pt, r, fillPaint);
      if (!isColored) {
        canvas.drawCircle(pt, r, borderPaint);
      }
    }
  }

  // ── 7. Flower ─────────────────────────────────────────────────────────────
  void _drawFlower(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isColored ? Colors.transparent : const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // 6 petals
    const numPetals = 6;
    const petalRadius = 24.0;
    const dist = 36.0;

    for (int i = 0; i < numPetals; i++) {
      final angle = (i * 2 * math.pi) / numPetals;
      final px = cx + math.cos(angle) * dist;
      final py = cy + math.sin(angle) * dist;

      canvas.drawCircle(Offset(px, py), petalRadius, fillPaint);
      if (!isColored) {
        canvas.drawCircle(Offset(px, py), petalRadius, borderPaint);
      }
    }

    // Center disk (Yellow)
    final centerPaint = Paint()
      ..color = AppColors.starYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 20, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _PaintableObjectPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.objectName != objectName ||
      oldDelegate.isColored != isColored;
}
