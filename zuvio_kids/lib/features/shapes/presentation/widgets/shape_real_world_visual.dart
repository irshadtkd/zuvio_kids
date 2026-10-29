import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Child-friendly custom vector illustration for the real-world shape examples.
/// Layer: Presentation Widget
class ShapeRealWorldVisual extends StatelessWidget {
  const ShapeRealWorldVisual({
    super.key,
    required this.exampleKey,
    this.size = 110,
  });

  final String exampleKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: CustomPaint(
        painter: _RealWorldPainter(exampleKey: exampleKey),
      ),
    );
  }
}

class _RealWorldPainter extends CustomPainter {
  const _RealWorldPainter({required this.exampleKey});

  final String exampleKey;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (exampleKey) {
      case 'exampleBall':
        _drawBall(canvas, w, h);
        break;
      case 'exampleGiftBox':
        _drawGiftBox(canvas, w, h);
        break;
      case 'examplePizza':
        _drawPizza(canvas, w, h);
        break;
      case 'exampleDoor':
        _drawDoor(canvas, w, h);
        break;
      case 'exampleEgg':
        _drawEgg(canvas, w, h);
        break;
      case 'exampleStarfish':
        _drawStarfish(canvas, w, h);
        break;
      case 'exampleBalloon':
        _drawBalloon(canvas, w, h);
        break;
      case 'exampleKite':
        _drawKite(canvas, w, h);
        break;
      case 'exampleBirdhouse':
        _drawBirdhouse(canvas, w, h);
        break;
      case 'exampleHoneycomb':
        _drawHoneycomb(canvas, w, h);
        break;
      case 'exampleMoon':
        _drawMoon(canvas, w, h);
        break;
      case 'exampleWatermelon':
        _drawWatermelon(canvas, w, h);
        break;
      default:
        _drawBall(canvas, w, h);
    }
  }

  void _drawBall(Canvas canvas, double w, double h) {
    final center = Offset(w * 0.5, h * 0.5);
    final r = w * 0.44;
    // Ball base (White/Sky)
    canvas.drawCircle(center, r, Paint()..color = const Color(0xFFF8FAFC));
    // Colorful curved panels
    final p1 = Paint()..color = const Color(0xFFEF4444);
    final p2 = Paint()..color = const Color(0xFF3B82F6);
    final p3 = Paint()..color = const Color(0xFFFBBF24);

    final path1 = Path()
      ..addArc(Rect.fromCircle(center: center, radius: r), -math.pi * 0.5, math.pi * 0.6)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(path1, p1);

    final path2 = Path()
      ..addArc(Rect.fromCircle(center: center, radius: r), math.pi * 0.1, math.pi * 0.6)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(path2, p2);

    final path3 = Path()
      ..addArc(Rect.fromCircle(center: center, radius: r), math.pi * 0.7, math.pi * 0.6)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(path3, p3);

    // Ball outline
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _drawGiftBox(Canvas canvas, double w, double h) {
    final boxRect = Rect.fromLTWH(w * 0.16, h * 0.32, w * 0.68, h * 0.54);
    // Box
    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFF3B82F6),
    );
    // Lid
    final lidRect = Rect.fromLTWH(w * 0.12, h * 0.22, w * 0.76, h * 0.14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lidRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFF2563EB),
    );
    // Yellow Ribbon
    final ribbonPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawRect(Rect.fromLTWH(w * 0.44, h * 0.22, w * 0.12, h * 0.64), ribbonPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.16, h * 0.54, w * 0.68, h * 0.10), ribbonPaint);
    // Bow
    canvas.drawCircle(Offset(w * 0.42, h * 0.16), w * 0.08, ribbonPaint);
    canvas.drawCircle(Offset(w * 0.58, h * 0.16), w * 0.08, ribbonPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.18), w * 0.05, Paint()..color = const Color(0xFFD97706));
  }

  void _drawPizza(Canvas canvas, double w, double h) {
    final slice = Path()
      ..moveTo(w * 0.50, h * 0.86)
      ..lineTo(w * 0.86, h * 0.24)
      ..arcToPoint(
        Offset(w * 0.14, h * 0.24),
        radius: Radius.circular(w * 0.6),
        clockwise: false,
      )
      ..close();
    // Crust
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.88, h * 0.24)
        ..arcToPoint(
          Offset(w * 0.12, h * 0.24),
          radius: Radius.circular(w * 0.6),
          clockwise: false,
        )
        ..lineTo(w * 0.14, h * 0.28)
        ..arcToPoint(
          Offset(w * 0.86, h * 0.28),
          radius: Radius.circular(w * 0.6),
        )
        ..close(),
      Paint()..color = const Color(0xFFD97706),
    );
    // Cheese
    canvas.drawPath(slice, Paint()..color = const Color(0xFFFBBF24));
    // Pepperoni
    final pep = Paint()..color = const Color(0xFFDC2626);
    canvas.drawCircle(Offset(w * 0.50, h * 0.42), w * 0.07, pep);
    canvas.drawCircle(Offset(w * 0.36, h * 0.54), w * 0.06, pep);
    canvas.drawCircle(Offset(w * 0.64, h * 0.54), w * 0.06, pep);
    canvas.drawCircle(Offset(w * 0.50, h * 0.68), w * 0.05, pep);
  }

  void _drawDoor(Canvas canvas, double w, double h) {
    final doorRect = Rect.fromLTWH(w * 0.22, h * 0.12, w * 0.56, h * 0.76);
    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(doorRect, const Radius.circular(10)),
      Paint()..color = const Color(0xFF10B981),
    );
    // Panels
    final panelPaint = Paint()..color = const Color(0xFF059669);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.18, w * 0.44, h * 0.30),
        const Radius.circular(6),
      ),
      panelPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.52, w * 0.44, h * 0.30),
        const Radius.circular(6),
      ),
      panelPaint,
    );
    // Knob
    canvas.drawCircle(Offset(w * 0.64, h * 0.50), w * 0.05, Paint()..color = const Color(0xFFFBBF24));
  }

  void _drawEgg(Canvas canvas, double w, double h) {
    final eggPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.52),
        width: w * 0.60,
        height: h * 0.80,
      ));
    canvas.drawPath(eggPath, Paint()..color = const Color(0xFFC084FC));
    // Speckles
    final speckle = Paint()..color = const Color(0xFF7E22CE);
    canvas.drawCircle(Offset(w * 0.45, h * 0.40), 3, speckle);
    canvas.drawCircle(Offset(w * 0.58, h * 0.48), 4, speckle);
    canvas.drawCircle(Offset(w * 0.42, h * 0.60), 3, speckle);
    canvas.drawCircle(Offset(w * 0.55, h * 0.68), 3.5, speckle);
  }

  void _drawStarfish(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.52;
    final rOuter = w * 0.44;
    final rInner = rOuter * 0.46;
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / 10);
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
    canvas.drawPath(path, Paint()..color = const Color(0xFFF59E0B));
    // Cute smile face
    final eyePaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(Offset(cx - 7, cy - 4), 3, eyePaint);
    canvas.drawCircle(Offset(cx + 7, cy - 4), 3, eyePaint);
    final smilePath = Path()
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy + 2), radius: 6),
        0.1,
        math.pi - 0.2,
        false,
      );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawBalloon(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.42;
    final scale = w / 44;
    final path = Path();
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
    canvas.drawPath(path, Paint()..color = const Color(0xFFF43F5E));
    // Knot
    canvas.drawCircle(Offset(cx, cy + 18 * scale), 3, Paint()..color = const Color(0xFFE11D48));
    // String
    final stringPath = Path()
      ..moveTo(cx, cy + 20 * scale)
      ..quadraticBezierTo(cx - 10, h * 0.76, cx + 5, h * 0.90);
    canvas.drawPath(
      stringPath,
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawKite(Canvas canvas, double w, double h) {
    final path = Path()
      ..moveTo(w * 0.50, h * 0.12)
      ..lineTo(w * 0.84, h * 0.44)
      ..lineTo(w * 0.50, h * 0.78)
      ..lineTo(w * 0.16, h * 0.44)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF14B8A6));
    // Cross struts
    final strutPaint = Paint()
      ..color = const Color(0xFF0F766E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(w * 0.50, h * 0.12), Offset(w * 0.50, h * 0.78), strutPaint);
    canvas.drawLine(Offset(w * 0.16, h * 0.44), Offset(w * 0.84, h * 0.44), strutPaint);
    // Tail
    final tailPath = Path()
      ..moveTo(w * 0.50, h * 0.78)
      ..quadraticBezierTo(w * 0.40, h * 0.88, w * 0.55, h * 0.96);
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = const Color(0xFFF43F5E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawBirdhouse(Canvas canvas, double w, double h) {
    // Birdhouse house pentagon
    final cx = w * 0.5;
    final cy = h * 0.52;
    final r = w * 0.40;
    final path = Path();
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
    canvas.drawPath(path, Paint()..color = const Color(0xFF6366F1));
    // Entrance hole
    canvas.drawCircle(Offset(cx, cy + 4), w * 0.12, Paint()..color = const Color(0xFF1E1B4B));
    // Perch
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 20), width: 14, height: 6),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFBBF24),
    );
  }

  void _drawHoneycomb(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.5;
    final r = w * 0.38;
    final path = Path();
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
    canvas.drawPath(path, Paint()..color = const Color(0xFFF97316));
    // Inner honeycomb lines
    final innerPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(cx, cy), r * 0.5, innerPaint);
  }

  void _drawMoon(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.5;
    final r1 = w * 0.40;
    final r2 = r1 * 0.82;
    final path = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx - r1 * 0.1, cy), radius: r1), -math.pi * 0.6, math.pi * 1.2)
      ..arcTo(Rect.fromCircle(center: Offset(cx + r1 * 0.22, cy), radius: r2), math.pi * 0.55, -math.pi * 1.1, false)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFBBF24));
    // Sleeping eye
    final eyePath = Path()
      ..arcTo(Rect.fromCircle(center: Offset(cx - 5, cy - 4), radius: 5), 0.1, math.pi - 0.2, false);
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = const Color(0xFF78350F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawWatermelon(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.66;
    final r = w * 0.40;
    // Green Rind
    final rind = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), math.pi, math.pi)
      ..close();
    canvas.drawPath(rind, Paint()..color = const Color(0xFF10B981));
    // White layer
    final whiteLayer = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.90), math.pi, math.pi)
      ..close();
    canvas.drawPath(whiteLayer, Paint()..color = const Color(0xFFF8FAFC));
    // Red Pulp
    final pulp = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.82), math.pi, math.pi)
      ..close();
    canvas.drawPath(pulp, Paint()..color = const Color(0xFFEF4444));
    // Seeds
    final seedPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(Offset(cx - 14, cy - 14), 2.5, seedPaint);
    canvas.drawCircle(Offset(cx, cy - 20), 2.5, seedPaint);
    canvas.drawCircle(Offset(cx + 14, cy - 14), 2.5, seedPaint);
  }

  @override
  bool shouldRepaint(covariant _RealWorldPainter oldDelegate) =>
      oldDelegate.exampleKey != exampleKey;
}
