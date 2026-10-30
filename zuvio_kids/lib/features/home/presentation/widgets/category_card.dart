import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Kid-friendly interactive category card on the home dashboard.
/// Features: stagger entrance pop-in, gentle idle float, and tap spring.
class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.visual,
    this.onTap,
    this.entranceDelayMs = 0,
  });

  final String title;
  final Color backgroundColor;
  final Widget visual;
  final VoidCallback? onTap;
  /// Milliseconds delay before the entrance animation starts (stagger effect).
  final int entranceDelayMs;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with TickerProviderStateMixin {
  // Entrance pop-in
  late final AnimationController _entranceController;
  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceFade;

  // Gentle floating idle
  late final AnimationController _floatController;

  // Tap spring
  late final AnimationController _tapController;
  late final Animation<double> _tapScale;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // ── Entrance ────────────────────────────────────────────────────────
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut),
    );
    _entranceFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    // ── Float idle ──────────────────────────────────────────────────────
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2200 + (widget.entranceDelayMs % 600),
      ),
    )..repeat(reverse: true);

    // ── Tap spring ──────────────────────────────────────────────────────
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tapScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.90)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.90, end: 1.06)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_tapController);

    // Delayed entrance
    Future.delayed(Duration(milliseconds: widget.entranceDelayMs), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _tapController.reset();
    _tapController.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onTap?.call();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _entranceController,
        _floatController,
        _tapController,
      ]),
      builder: (context, child) {
        final floatY = math.sin(_floatController.value * math.pi * 2) * 3.5;
        final scale = _entranceScale.value * _tapScale.value;
        final opacity = _entranceFade.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(widget.backgroundColor, Colors.white, 0.28)!,
                widget.backgroundColor,
              ],
            ),
            boxShadow: [
              // 3D tactile bottom bevel
              BoxShadow(
                color: Color.lerp(widget.backgroundColor, Colors.black, 0.28)!,
                offset: Offset(0, _isPressed ? 2 : 6),
              ),
              // Soft ambient drop shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: _isPressed ? 0.04 : 0.10),
                blurRadius: _isPressed ? 4 : 12,
                offset: Offset(0, _isPressed ? 2 : 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle curved gloss highlight at the top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Main card content
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circular glossy badge container for the graphic
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(child: widget.visual),
                    ),
                    const SizedBox(height: 10),
                    // Category Title with high contrast
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.categoryLabel.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bouncy 3D cartoon "A B C" letters for the Alphabet card.
class AlphabetVisual extends StatelessWidget {
  const AlphabetVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CartoonLetter(letter: 'A', color: Color(0xFFFF5252), angle: -0.1),
        SizedBox(width: 3),
        _CartoonLetter(letter: 'B', color: Color(0xFFFFB300), angle: 0.0),
        SizedBox(width: 3),
        _CartoonLetter(letter: 'C', color: Color(0xFF29B6F6), angle: 0.1),
      ],
    );
  }
}

class _CartoonLetter extends StatelessWidget {
  const _CartoonLetter({
    required this.letter,
    required this.color,
    required this.angle,
  });

  final String letter;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: color,
          shadows: [
            Shadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouncy 3D cartoon "1 2 3" numbers for the Numbers card.
class NumbersVisual extends StatelessWidget {
  const NumbersVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CartoonLetter(letter: '1', color: Color(0xFF5C6BC0), angle: -0.08),
        SizedBox(width: 3),
        _CartoonLetter(letter: '2', color: Color(0xFF26A69A), angle: 0.0),
        SizedBox(width: 3),
        _CartoonLetter(letter: '3', color: Color(0xFFFF7043), angle: 0.08),
      ],
    );
  }
}

/// Outlined Triangle and Circle with vibrant colors for the "Shapes" card.
class ShapesVisual extends StatelessWidget {
  const ShapesVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(44, 34),
      painter: _ShapesPainter(),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Ruby Triangle on left
    final triPaint = Paint()
      ..color = const Color(0xFFFF4D6D)
      ..style = PaintingStyle.fill;
    final triOutline = Paint()
      ..color = const Color(0xFFC9184A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final triPath = Path()
      ..moveTo(size.width * 0.28, size.height * 0.12)
      ..lineTo(size.width * 0.48, size.height * 0.88)
      ..lineTo(size.width * 0.06, size.height * 0.88)
      ..close();
    canvas.drawPath(triPath, triPaint);
    canvas.drawPath(triPath, triOutline);

    // 2. Sunny Circle on right
    final circlePaint = Paint()
      ..color = const Color(0xFFFFB703)
      ..style = PaintingStyle.fill;
    final circleOutline = Paint()
      ..color = const Color(0xFFFB8500)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final circleCenter = Offset(size.width * 0.74, size.height * 0.52);
    final circleRadius = size.height * 0.36;
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);
    canvas.drawCircle(circleCenter, circleRadius, circleOutline);

    // White shine dot on circle
    final shinePaint = Paint()..color = Colors.white.withValues(alpha: 0.7);
    canvas.drawCircle(
      Offset(circleCenter.dx - 3, circleCenter.dy - 3),
      2.5,
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// An artist's paint palette with 4 glowing color drops for the "Colors" card.
class ColorsVisual extends StatelessWidget {
  const ColorsVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(42, 38),
      painter: _ColorsPainter(),
    );
  }
}

class _ColorsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Palette body
    final palettePaint = Paint()
      ..color = const Color(0xFFFFF0D4)
      ..style = PaintingStyle.fill;
    final paletteOutline = Paint()
      ..color = const Color(0xFFE2C499)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromLTWH(2, 4, size.width - 4, size.height - 8);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(14));
    canvas.drawRRect(rrect, palettePaint);
    canvas.drawRRect(rrect, paletteOutline);

    // 4 vibrant drops
    final drops = [
      (Offset(size.width * 0.30, size.height * 0.32), const Color(0xFFFF3366)),
      (Offset(size.width * 0.68, size.height * 0.30), const Color(0xFFFFB800)),
      (Offset(size.width * 0.72, size.height * 0.68), const Color(0xFF00B4D8)),
      (Offset(size.width * 0.35, size.height * 0.68), const Color(0xFF7209B7)),
    ];

    for (final d in drops) {
      canvas.drawCircle(d.$1, 4.5, Paint()..color = d.$2);
      canvas.drawCircle(
        Offset(d.$1.dx - 1.2, d.$1.dy - 1.2),
        1.2,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Two interlocking colorful puzzle pieces for the "Puzzles" card.
class PuzzlesVisual extends StatelessWidget {
  const PuzzlesVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(44, 34),
      painter: _PuzzlesPainter(),
    );
  }
}

class _PuzzlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPiece = Paint()
      ..color = const Color(0xFFFFC107)
      ..style = PaintingStyle.fill;
    final goldStroke = Paint()
      ..color = const Color(0xFFFFA000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final cyanPiece = Paint()
      ..color = const Color(0xFF00BCD4)
      ..style = PaintingStyle.fill;
    final cyanStroke = Paint()
      ..color = const Color(0xFF0097A7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Piece 1 (Gold) on left
    final r1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.18, 16, 20),
      const Radius.circular(5),
    );
    canvas.drawRRect(r1, goldPiece);
    canvas.drawRRect(r1, goldStroke);
    // Interlocking knob
    canvas.drawCircle(
      Offset(size.width * 0.08 + 16, size.height * 0.18 + 10),
      4,
      goldPiece,
    );
    canvas.drawCircle(
      Offset(size.width * 0.08 + 16, size.height * 0.18 + 10),
      4,
      goldStroke,
    );

    // Piece 2 (Cyan) on right
    final r2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.08 + 16, size.height * 0.18, 16, 20),
      const Radius.circular(5),
    );
    canvas.drawRRect(r2, cyanPiece);
    canvas.drawRRect(r2, cyanStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cute Warm Cartoon Paw Print visual for the "Animals" card.
class AnimalsVisual extends StatelessWidget {
  const AnimalsVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(40, 36),
      painter: _PawPainter(),
    );
  }
}

class _PawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final padPaint = Paint()
      ..color = const Color(0xFFFF7043)
      ..style = PaintingStyle.fill;
    final padOutline = Paint()
      ..color = const Color(0xFFD84315)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Main palm pad
    final padRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.65),
      width: size.width * 0.52,
      height: size.height * 0.44,
    );
    final padRRect =
        RRect.fromRectAndRadius(padRect, const Radius.circular(9));
    canvas.drawRRect(padRRect, padPaint);
    canvas.drawRRect(padRRect, padOutline);

    // 4 cute toe beans
    final toes = [
      Offset(size.width * 0.20, size.height * 0.34),
      Offset(size.width * 0.40, size.height * 0.18),
      Offset(size.width * 0.60, size.height * 0.18),
      Offset(size.width * 0.80, size.height * 0.34),
    ];

    for (final toe in toes) {
      canvas.drawCircle(toe, 4.2, padPaint);
      canvas.drawCircle(toe, 4.2, padOutline);
      canvas.drawCircle(
        Offset(toe.dx - 1.2, toe.dy - 1.2),
        1.2,
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


