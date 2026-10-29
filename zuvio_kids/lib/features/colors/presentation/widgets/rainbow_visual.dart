import 'package:flutter/material.dart';

/// Cheerful Rainbow illustration shown at the top of the Color Magic card.
/// Matches the reference screenshot.
/// Layer: Presentation Widget
class RainbowVisual extends StatelessWidget {
  const RainbowVisual({
    super.key,
    this.width = 170,
    this.height = 95,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _RainbowPainter(),
    );
  }
}

class _RainbowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    const strokeWidth = 14.0;

    // 4 Rainbow Bands matching screenshot: Coral Red, Yellow, Green, Blue
    final colors = [
      const Color(0xFFFF5A5A), // Coral Red
      const Color(0xFFFFC83A), // Yellow
      const Color(0xFF38C172), // Green
      const Color(0xFF3B82F6), // Blue
    ];

    double currentRadius = size.width / 2 - (strokeWidth / 2);

    for (final color in colors) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final rect = Rect.fromCircle(center: center, radius: currentRadius);
      canvas.drawArc(rect, 3.141592653589793, 3.141592653589793, false, paint);
      currentRadius -= strokeWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
