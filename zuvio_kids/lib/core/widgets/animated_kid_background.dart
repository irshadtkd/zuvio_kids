import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Whimsical, animated background for kids with drifting clouds, twinkling sparkles, and floating bubbles.
/// Layer: Core Reusable Widget
class AnimatedKidBackground extends StatefulWidget {
  const AnimatedKidBackground({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFFBCE4FD),
    this.secondaryColor = const Color(0xFFE4F3FF),
  });

  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  State<AnimatedKidBackground> createState() => _AnimatedKidBackgroundState();
}

class _AnimatedKidBackgroundState extends State<AnimatedKidBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.secondaryColor,
            widget.primaryColor,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Drifting animated elements (clouds, sparkles, bubbles)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _SkyElementsPainter(progress: _controller.value),
                );
              },
            ),
          ),
          // Screen content
          widget.child,
        ],
      ),
    );
  }
}

class _SkyElementsPainter extends CustomPainter {
  const _SkyElementsPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // ── 1. Twinkling Little Stars ──────────────────────────────────────────
    final starPaint = Paint()..style = PaintingStyle.fill;
    final starOffsets = [
      Offset(size.width * 0.12, size.height * 0.08),
      Offset(size.width * 0.88, size.height * 0.07),
      Offset(size.width * 0.50, size.height * 0.14),
      Offset(size.width * 0.06, size.height * 0.28),
      Offset(size.width * 0.92, size.height * 0.32),
      Offset(size.width * 0.48, size.height * 0.52),
      Offset(size.width * 0.10, size.height * 0.82),
      Offset(size.width * 0.85, size.height * 0.86),
    ];

    for (int i = 0; i < starOffsets.length; i++) {
      final phase = (progress * 2 * math.pi) + (i * 1.1);
      final alpha = (0.25 + 0.45 * (0.5 + 0.5 * math.sin(phase))).clamp(0.0, 1.0);
      starPaint.color = Colors.white.withValues(alpha: alpha);
      _drawSparkle(canvas, starOffsets[i], 6.0 + (i % 3) * 2.0, starPaint);
    }

    // ── 2. Drifting Soft Clouds ────────────────────────────────────────────
    final cloudPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.42);

    _drawFluffyCloud(
      canvas,
      Offset(((progress * 1.0 + 0.1) % 1.3 - 0.2) * size.width, size.height * 0.12),
      44,
      cloudPaint,
    );

    _drawFluffyCloud(
      canvas,
      Offset(((progress * 0.7 + 0.6) % 1.4 - 0.25) * size.width, size.height * 0.38),
      56,
      cloudPaint,
    );

    _drawFluffyCloud(
      canvas,
      Offset(((progress * 0.5 + 0.3) % 1.3 - 0.2) * size.width, size.height * 0.75),
      38,
      cloudPaint,
    );

    // ── 3. Floating Joy Bubbles ───────────────────────────────────────────
    final bubbleStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white.withValues(alpha: 0.5);

    final bubbleFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.12);

    final bubblePositions = [
      Offset(size.width * 0.22, (1.0 - (progress * 1.4 + 0.2) % 1.2) * size.height),
      Offset(size.width * 0.78, (1.0 - (progress * 1.1 + 0.6) % 1.2) * size.height),
      Offset(size.width * 0.45, (1.0 - (progress * 0.9 + 0.8) % 1.2) * size.height),
    ];

    for (int i = 0; i < bubblePositions.length; i++) {
      final pos = bubblePositions[i];
      final radius = 12.0 + i * 4.0;
      canvas.drawCircle(pos, radius, bubbleFill);
      canvas.drawCircle(pos, radius, bubbleStroke);
      // Bubble shine dot
      canvas.drawCircle(
        Offset(pos.dx - radius * 0.35, pos.dy - radius * 0.35),
        radius * 0.25,
        Paint()..color = Colors.white.withValues(alpha: 0.6),
      );
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.quadraticBezierTo(center.dx, center.dy, center.dx + size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + size);
    path.quadraticBezierTo(center.dx, center.dy, center.dx - size, center.dy);
    path.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - size);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawFluffyCloud(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(Offset(center.dx - radius * 0.6, center.dy + radius * 0.15), radius * 0.75, paint);
    canvas.drawCircle(Offset(center.dx + radius * 0.6, center.dy + radius * 0.15), radius * 0.75, paint);
    canvas.drawCircle(Offset(center.dx + radius * 1.1, center.dy + radius * 0.25), radius * 0.55, paint);
    canvas.drawCircle(Offset(center.dx - radius * 1.0, center.dy + radius * 0.25), radius * 0.55, paint);
  }

  @override
  bool shouldRepaint(covariant _SkyElementsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
