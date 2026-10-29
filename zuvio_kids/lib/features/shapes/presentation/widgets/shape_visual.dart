import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ShapeVisualMode {
  filled,
  outline,
  silhouette,
  dotted,
}

/// Dynamic vector visual rendering any of the 12 geometric shapes.
/// Layer: Presentation Widget
class ShapeVisualWidget extends StatelessWidget {
  const ShapeVisualWidget({
    super.key,
    required this.shapeId,
    this.size = 140,
    this.color = const Color(0xFFEF4444),
    this.mode = ShapeVisualMode.filled,
    this.strokeWidth = 6.0,
  });

  final String shapeId;
  final double size;
  final Color color;
  final ShapeVisualMode mode;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ShapeCustomPainter(
          shapeId: shapeId,
          color: color,
          mode: mode,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _ShapeCustomPainter extends CustomPainter {
  const _ShapeCustomPainter({
    required this.shapeId,
    required this.color,
    required this.mode,
    required this.strokeWidth,
  });

  final String shapeId;
  final Color color;
  final ShapeVisualMode mode;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = getShapePath(shapeId, size);

    if (mode == ShapeVisualMode.filled) {
      // 3D Drop Shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(0, 5);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();

      // Main Fill
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Inner Highlight / Border
      final borderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, borderPaint);

      final outerBorderPaint = Paint()
        ..color = color.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawPath(path, outerBorderPaint);
    } else if (mode == ShapeVisualMode.outline) {
      // Outline Shape: Pure border without any fill
      final borderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, borderPaint);
    } else if (mode == ShapeVisualMode.silhouette) {
      // Silhouette / Slot outline
      final fillPaint = Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      final dashPaint = Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, dashPaint);
    } else if (mode == ShapeVisualMode.dotted) {
      final dottedPaint = Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, dottedPaint);
    }
  }

  static Path getShapePath(String shapeId, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    switch (shapeId) {
      case 'circle':
        path.addOval(Rect.fromCircle(
          center: Offset(w * 0.5, h * 0.5),
          radius: math.min(w, h) * 0.42,
        ));
        break;

      case 'square':
        final s = math.min(w, h) * 0.76;
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: s, height: s),
          const Radius.circular(16),
        ));
        break;

      case 'triangle':
        path.moveTo(w * 0.50, h * 0.12);
        path.lineTo(w * 0.88, h * 0.86);
        path.lineTo(w * 0.12, h * 0.86);
        path.close();
        break;

      case 'rectangle':
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(w * 0.5, h * 0.5),
            width: w * 0.84,
            height: h * 0.54,
          ),
          const Radius.circular(16),
        ));
        break;

      case 'oval':
        path.addOval(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.5),
          width: w * 0.62,
          height: h * 0.84,
        ));
        break;

      case 'star':
        final cx = w * 0.5;
        final cy = h * 0.52;
        final rOuter = math.min(w, h) * 0.46;
        final rInner = rOuter * 0.45;
        const count = 10;
        for (int i = 0; i < count; i++) {
          final angle = -math.pi / 2 + (2 * math.pi * i / count);
          final r = i.isEven ? rOuter : rInner;
          final px = cx + r * math.cos(angle);
          final py = cy + r * math.sin(angle);
          if (i == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        break;

      case 'heart':
        final cx = w * 0.5;
        final cy = h * 0.52;
        final scale = math.min(w, h) / 36;
        for (int i = 0; i <= 36; i++) {
          final t = -math.pi + (2 * math.pi * i / 36);
          final x = 16 * math.pow(math.sin(t), 3);
          final y = -(13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t));
          final px = cx + x * scale;
          final py = cy + y * scale;
          if (i == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        break;

      case 'diamond':
        path.moveTo(w * 0.50, h * 0.12);
        path.lineTo(w * 0.88, h * 0.50);
        path.lineTo(w * 0.50, h * 0.88);
        path.lineTo(w * 0.12, h * 0.50);
        path.close();
        break;

      case 'pentagon':
        final cx = w * 0.5;
        final cy = h * 0.54;
        final r = math.min(w, h) * 0.44;
        for (int i = 0; i < 5; i++) {
          final angle = -math.pi / 2 + (2 * math.pi * i / 5);
          final px = cx + r * math.cos(angle);
          final py = cy + r * math.sin(angle);
          if (i == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        break;

      case 'hexagon':
        final cx = w * 0.5;
        final cy = h * 0.5;
        final r = math.min(w, h) * 0.44;
        for (int i = 0; i < 6; i++) {
          final angle = 2 * math.pi * i / 6;
          final px = cx + r * math.cos(angle);
          final py = cy + r * math.sin(angle);
          if (i == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        break;

      case 'crescent':
        final cx = w * 0.5;
        final cy = h * 0.5;
        final r1 = math.min(w, h) * 0.42;
        final r2 = r1 * 0.82;
        path.addArc(
          Rect.fromCircle(center: Offset(cx - r1 * 0.1, cy), radius: r1),
          -math.pi * 0.6,
          math.pi * 1.2,
        );
        path.arcTo(
          Rect.fromCircle(center: Offset(cx + r1 * 0.22, cy), radius: r2),
          math.pi * 0.55,
          -math.pi * 1.1,
          false,
        );
        path.close();
        break;

      case 'semicircle':
        final cx = w * 0.5;
        final cy = h * 0.66;
        final r = math.min(w, h) * 0.42;
        path.addArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: r),
          math.pi,
          math.pi,
        );
        path.close();
        break;

      default:
        path.addOval(Rect.fromCircle(
          center: Offset(w * 0.5, h * 0.5),
          radius: math.min(w, h) * 0.4,
        ));
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _ShapeCustomPainter oldDelegate) =>
      oldDelegate.shapeId != shapeId ||
      oldDelegate.color != color ||
      oldDelegate.mode != mode ||
      oldDelegate.strokeWidth != strokeWidth;
}
