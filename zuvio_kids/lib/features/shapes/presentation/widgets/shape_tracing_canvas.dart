import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_entity.dart';

enum ShapeTracingFeedbackStatus {
  idle,
  success, // >= 99% accuracy
  failure, // < 99% accuracy
}

/// Interactive shape tracing canvas where children trace dotted shapes.
/// Layer: Presentation Widget
class ShapeTracingCanvas extends StatefulWidget {
  const ShapeTracingCanvas({
    super.key,
    required this.shape,
    required this.onComplete,
    this.isCompleted = false,
  });

  final ShapeEntity shape;
  final VoidCallback onComplete;
  final bool isCompleted;

  @override
  State<ShapeTracingCanvas> createState() => ShapeTracingCanvasState();
}

class ShapeTracingCanvasState extends State<ShapeTracingCanvas>
    with SingleTickerProviderStateMixin {
  final List<Offset?> _userPoints = [];
  Offset? _currentCursor;
  final Set<int> _hitWaypoints = {};
  bool _hasTriggeredCompletion = false;
  double _accuracy = 0.0;
  ShapeTracingFeedbackStatus _feedbackStatus = ShapeTracingFeedbackStatus.idle;

  Timer? _evaluationTimer;
  Timer? _resetTimer;

  late final AnimationController _demoController;
  bool _isDemoPlaying = false;
  List<Offset> _demoPoints = [];

  @override
  void initState() {
    super.initState();
    _demoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _demoController.addListener(_onDemoTick);
    _demoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isDemoPlaying = false);
      }
    });

    if (widget.isCompleted) {
      _hasTriggeredCompletion = true;
      _feedbackStatus = ShapeTracingFeedbackStatus.success;
      _accuracy = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ShapeTracingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shape.id != widget.shape.id) {
      _resetCanvas();
    }
  }

  @override
  void dispose() {
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();
    _demoController.dispose();
    super.dispose();
  }

  void _onDemoTick() {
    if (!_isDemoPlaying || _demoPoints.isEmpty) return;
    final total = _demoPoints.length;
    final count = (_demoController.value * total).round().clamp(0, total);
    setState(() {
      _userPoints.clear();
      _userPoints.addAll(_demoPoints.take(count));
      if (_userPoints.isNotEmpty) {
        _currentCursor = _userPoints.last;
      }
    });
  }

  /// Triggers demo animation
  void playShowMeDemo(Size size) {
    if (_isDemoPlaying) return;
    final waypoints = _computeInterpolatedWaypoints(widget.shape.strokes, size);

    setState(() {
      _isDemoPlaying = true;
      _feedbackStatus = ShapeTracingFeedbackStatus.idle;
      _demoPoints = waypoints;
      _userPoints.clear();
    });

    _demoController.forward(from: 0.0);
  }

  /// Clears user drawing and resets feedback state.
  void resetCanvas() {
    _resetCanvas();
  }

  void _resetCanvas() {
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();
    _demoController.stop();
    setState(() {
      _isDemoPlaying = false;
      _userPoints.clear();
      _hitWaypoints.clear();
      _currentCursor = null;
      _hasTriggeredCompletion = false;
      _accuracy = 0.0;
      _feedbackStatus = ShapeTracingFeedbackStatus.idle;
    });
  }

  List<Offset> _computeInterpolatedWaypoints(
    List<ShapeStroke> strokes,
    Size size,
  ) {
    final points = <Offset>[];
    const double stepDist = 10.0;
    final side = math.min(size.width, size.height);
    final offsetX = (size.width - side) / 2;
    final offsetY = (size.height - side) / 2;

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = Offset(
          offsetX + stroke.points[i].x * side,
          offsetY + stroke.points[i].y * side,
        );
        final p2 = Offset(
          offsetX + stroke.points[i + 1].x * side,
          offsetY + stroke.points[i + 1].y * side,
        );

        final dist = (p2 - p1).distance;
        final steps = math.max(1, (dist / stepDist).round());

        for (int s = 0; s < steps; s++) {
          final t = s / steps;
          points.add(Offset.lerp(p1, p2, t)!);
        }
      }
      if (stroke.points.isNotEmpty) {
        final last = stroke.points.last;
        points.add(Offset(
          offsetX + last.x * side,
          offsetY + last.y * side,
        ));
      }
    }
    return points;
  }

  void _onPanStart(DragStartDetails details, List<Offset> waypoints) {
    if (_hasTriggeredCompletion || _isDemoPlaying) return;
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();

    final localPos = details.localPosition;
    setState(() {
      _feedbackStatus = ShapeTracingFeedbackStatus.idle;
      _userPoints.add(localPos);
      _currentCursor = localPos;
      _checkWaypointHit(localPos, waypoints);
    });
  }

  void _onPanUpdate(DragUpdateDetails details, List<Offset> waypoints) {
    if (_hasTriggeredCompletion || _isDemoPlaying) return;
    final localPos = details.localPosition;
    setState(() {
      _userPoints.add(localPos);
      _currentCursor = localPos;
      _checkWaypointHit(localPos, waypoints);
    });
  }

  void _onPanEnd(DragEndDetails details, List<Offset> waypoints) {
    if (_hasTriggeredCompletion || _isDemoPlaying) return;
    setState(() => _userPoints.add(null));

    _evaluationTimer?.cancel();
    _evaluationTimer = Timer(const Duration(milliseconds: 400), () {
      _evaluateAccuracy(waypoints);
    });
  }

  void _checkWaypointHit(Offset point, List<Offset> waypoints) {
    const double hitRadius = 36.0;
    for (int i = 0; i < waypoints.length; i++) {
      if (!_hitWaypoints.contains(i)) {
        if ((waypoints[i] - point).distance <= hitRadius) {
          _hitWaypoints.add(i);
        }
      }
    }
  }

  void _evaluateAccuracy(List<Offset> waypoints) {
    if (waypoints.isEmpty || _hasTriggeredCompletion || !mounted) return;

    final ratio = _hitWaypoints.length / waypoints.length;
    _accuracy = ratio;

    if (ratio >= 0.99) {
      setState(() {
        _hasTriggeredCompletion = true;
        _feedbackStatus = ShapeTracingFeedbackStatus.success;
      });
      KidSoundService.instance.speak('Awesome tracing!');
      widget.onComplete();
    } else {
      setState(() {
        _feedbackStatus = ShapeTracingFeedbackStatus.failure;
      });
      KidSoundService.instance.speak('Try again!');

      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(milliseconds: 1600), () {
        if (mounted && !_hasTriggeredCompletion) {
          setState(() {
            _userPoints.clear();
            _hitWaypoints.clear();
            _currentCursor = null;
            _feedbackStatus = ShapeTracingFeedbackStatus.idle;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strokes = widget.shape.strokes;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        final waypoints = _computeInterpolatedWaypoints(strokes, canvasSize);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Gesture Detector
            GestureDetector(
              onPanStart: (d) => _onPanStart(d, waypoints),
              onPanUpdate: (d) => _onPanUpdate(d, waypoints),
              onPanEnd: (d) => _onPanEnd(d, waypoints),
              child: CustomPaint(
                size: canvasSize,
                painter: _ShapeTracingPainter(
                  strokes: strokes,
                  userPoints: _userPoints,
                  cursor: _currentCursor,
                  isCompleted: _hasTriggeredCompletion,
                  shapeThemeColor: Color(widget.shape.colorValue),
                ),
              ),
            ),

            // Success Overlay: Green Tick Badge
            if (_feedbackStatus == ShapeTracingFeedbackStatus.success)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.kidGreen,
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kidGreen.withValues(alpha: 0.35),
                            blurRadius: 18,
                            spreadRadius: 4,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.kidGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.tracingSuccess,
                            style: AppTextStyles.headerTitle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.kidGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Failure Overlay: Red Cross Badge
            if (_feedbackStatus == ShapeTracingFeedbackStatus.failure)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFFFF4B4B),
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4B4B).withValues(alpha: 0.28),
                            blurRadius: 20,
                            spreadRadius: 4,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4B4B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.tracingTryAgain,
                                style: AppTextStyles.headerTitle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFFF4B4B),
                                ),
                              ),
                              Text(
                                '${(_accuracy * 100).round()}%',
                                style: AppTextStyles.base.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _ShapeTracingPainter extends CustomPainter {
  _ShapeTracingPainter({
    required this.strokes,
    required this.userPoints,
    required this.cursor,
    required this.isCompleted,
    required this.shapeThemeColor,
  });

  final List<ShapeStroke> strokes;
  final List<Offset?> userPoints;
  final Offset? cursor;
  final bool isCompleted;
  final Color shapeThemeColor;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Dotted Guide Pattern
    final dotPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    const double dotRadius = 4.0;
    const double stepDistance = 14.0;

    final side = math.min(size.width, size.height);
    final offsetX = (size.width - side) / 2;
    final offsetY = (size.height - side) / 2;

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = Offset(
          offsetX + stroke.points[i].x * side,
          offsetY + stroke.points[i].y * side,
        );
        final p2 = Offset(
          offsetX + stroke.points[i + 1].x * side,
          offsetY + stroke.points[i + 1].y * side,
        );

        final dist = (p2 - p1).distance;
        final steps = math.max(1, (dist / stepDistance).round());

        for (int s = 0; s < steps; s++) {
          final t = s / steps;
          final dotPos = Offset.lerp(p1, p2, t)!;
          canvas.drawCircle(dotPos, dotRadius, dotPaint);
        }
      }
      if (stroke.points.isNotEmpty) {
        final last = stroke.points.last;
        canvas.drawCircle(
          Offset(offsetX + last.x * side, offsetY + last.y * side),
          dotRadius,
          dotPaint,
        );
      }
    }

    // 2. Draw User Traced Lines
    final userStrokePaint = Paint()
      ..color = isCompleted ? AppColors.kidGreen : shapeThemeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < userPoints.length - 1; i++) {
      final p1 = userPoints[i];
      final p2 = userPoints[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, userStrokePaint);
      }
    }

    // 3. Draw Active Hand / Finger Cursor
    if (cursor != null && !isCompleted) {
      final haloPaint = Paint()
        ..color = shapeThemeColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cursor!, 26, haloPaint);

      final fingerPaint = Paint()
        ..color = shapeThemeColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cursor!, 14, fingerPaint);

      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cursor!, 6, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeTracingPainter oldDelegate) => true;
}
