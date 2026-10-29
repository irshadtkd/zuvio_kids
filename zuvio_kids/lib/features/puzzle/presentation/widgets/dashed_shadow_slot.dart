import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import '../../domain/entities/puzzle_item_entity.dart';
import 'puzzle_item_visual.dart';

/// Target shadow slot displayed inside the "Shadows" row.
/// Features a dashed navy border, accepts draggable items, and supports tap-to-match.
/// Layer: Presentation Widget
class DashedShadowSlot extends StatefulWidget {
  const DashedShadowSlot({
    super.key,
    required this.item,
    required this.isMatched,
    required this.onMatchAttempt,
    this.size = 88.0,
  });

  final PuzzleItemEntity item;
  final bool isMatched;
  final ValueChanged<String> onMatchAttempt;
  final double size;

  @override
  State<DashedShadowSlot> createState() => _DashedShadowSlotState();
}

class _DashedShadowSlotState extends State<DashedShadowSlot>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _popController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _popController,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.isMatched) {
      _popController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant DashedShadowSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isMatched && widget.isMatched) {
      _popController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isHovered = true);
        return !widget.isMatched;
      },
      onLeave: (_) {
        setState(() => _isHovered = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isHovered = false);
        widget.onMatchAttempt(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (!widget.isMatched) {
              // Trigger tap-to-match with self
              widget.onMatchAttempt('');
            }
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dashed container
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _DashedRRectPainter(
                      color: widget.isMatched
                          ? AppColors.kidGreen
                          : (_isHovered
                              ? AppColors.primary
                              : const Color(0xFF1E293B)),
                      strokeWidth: 2.5,
                      dashLength: 7.0,
                      gapLength: 5.0,
                      radius: 20.0,
                      fillColor: widget.isMatched
                          ? const Color(0xFFECFDF5)
                          : (_isHovered
                              ? const Color(0xFFEFF6FF)
                              : const Color(0xFFF1F5F9)),
                    ),
                  ),

                  // Visual content: Silhouette when pending, colorful when matched
                  Center(
                    child: widget.isMatched
                        ? PuzzleItemVisual(
                            item: widget.item,
                            size: widget.size * 0.64,
                          )
                        : PuzzleItemVisual(
                            item: widget.item,
                            size: widget.size * 0.64,
                            isSilhouette: true,
                          ),
                  ),

                  // Green checkmark badge on matched
                  if (widget.isMatched)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.kidGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.radius,
    required this.fillColor,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double radius;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // Draw background fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, fillPaint);

    // Draw dashed path
    final path = Path()..addRRect(rrect);
    final dashedPath = _createDashedPath(path, dashLength, gapLength);

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(dashedPath, strokePaint);
  }

  Path _createDashedPath(Path source, double dash, double gap) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? dash : gap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
