import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Kid-friendly interactive category card on the home dashboard.
class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.visual,
    this.onTap,
  });

  final String title;
  final Color backgroundColor;
  final Widget visual;
  final VoidCallback? onTap;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual Graphic / Icon
              SizedBox(
                height: 52,
                child: Center(child: widget.visual),
              ),
              const SizedBox(height: 10),
              // Category Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.categoryLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined Triangle and Circle for the "Shapes" card.
class ShapesVisual extends StatelessWidget {
  const ShapesVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 40),
      painter: _ShapesPainter(),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Triangle on left
    final trianglePath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.12)
      ..lineTo(size.width * 0.44, size.height * 0.88)
      ..lineTo(size.width * 0.06, size.height * 0.88)
      ..close();
    canvas.drawPath(trianglePath, strokePaint);

    // Circle on right
    final circleCenter = Offset(size.width * 0.74, size.height * 0.52);
    final circleRadius = size.height * 0.38;
    canvas.drawCircle(circleCenter, circleRadius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Two solid dots for the "Colors" card.
class ColorsVisual extends StatelessWidget {
  const ColorsVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.navy,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: AppColors.navy,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// Solid Square and Triangle for the "Puzzles" card.
class PuzzlesVisual extends StatelessWidget {
  const PuzzlesVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(70, 36),
      painter: _PuzzlesPainter(),
    );
  }
}

class _PuzzlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Solid small square on left
    final squareRect = Rect.fromCenter(
      center: Offset(size.width * 0.28, size.height * 0.56),
      width: 14,
      height: 14,
    );
    canvas.drawRect(squareRect, fillPaint);

    // Solid triangle on right
    final trianglePath = Path()
      ..moveTo(size.width * 0.72, size.height * 0.18)
      ..lineTo(size.width * 0.88, size.height * 0.82)
      ..lineTo(size.width * 0.56, size.height * 0.82)
      ..close();
    canvas.drawPath(trianglePath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cute Paw Print visual for the "Animals" card.
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
    final fillPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    // Main pad
    final padRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.65),
      width: size.width * 0.5,
      height: size.height * 0.42,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(padRect, const Radius.circular(8)),
      fillPaint,
    );

    // 4 Toe pads
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.32), 4, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.40, size.height * 0.18), 4.5, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.60, size.height * 0.18), 4.5, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.32), 4, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

