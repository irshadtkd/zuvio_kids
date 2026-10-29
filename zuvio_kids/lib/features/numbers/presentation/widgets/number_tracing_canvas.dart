import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/numbers/data/datasources/number_data.dart';

/// Feedback status for number tracing accuracy validation.
enum NumberTracingFeedbackStatus {
  idle,
  success, // >= 99% accuracy (green tick)
  failure, // < 99% accuracy (red cross)
}

/// Interactive number tracing canvas where children trace dotted numbers.
/// Follows Screenshot 3.
/// Layer: Presentation Widget
class NumberTracingCanvas extends StatefulWidget {
  const NumberTracingCanvas({
    super.key,
    required this.number,
    required this.onComplete,
    this.isCompleted = false,
  });

  final int number;
  final VoidCallback onComplete;
  final bool isCompleted;

  @override
  State<NumberTracingCanvas> createState() => NumberTracingCanvasState();
}

class NumberTracingCanvasState extends State<NumberTracingCanvas>
    with SingleTickerProviderStateMixin {
  final List<Offset?> _userPoints = [];
  Offset? _currentCursor;
  final Set<int> _hitWaypoints = {};
  bool _hasTriggeredCompletion = false;
  double _accuracy = 0.0;
  NumberTracingFeedbackStatus _feedbackStatus =
      NumberTracingFeedbackStatus.idle;

  Timer? _evaluationTimer;
  Timer? _resetTimer;

  // Animation controller for "Show me" animation
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
        setState(() {
          _isDemoPlaying = false;
        });
      }
    });

    if (widget.isCompleted) {
      _hasTriggeredCompletion = true;
      _feedbackStatus = NumberTracingFeedbackStatus.success;
      _accuracy = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant NumberTracingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number != widget.number) {
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

  /// Triggers "Show me" demo animation
  void playShowMeDemo(Size size) {
    if (_isDemoPlaying) return;
    final strokes = NumberData.getTracingStrokes(widget.number);
    final waypoints = _computeInterpolatedWaypoints(strokes, size);

    setState(() {
      _isDemoPlaying = true;
      _feedbackStatus = NumberTracingFeedbackStatus.idle;
      _demoPoints = waypoints;
      _userPoints.clear();
    });

    _demoController.forward(from: 0.0);
  }

  /// Clears all user drawn strokes and restores original dotted guide pattern.
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
      _feedbackStatus = NumberTracingFeedbackStatus.idle;
    });
  }

  List<Offset> _computeInterpolatedWaypoints(
    List<NumberStroke> strokes,
    Size size,
  ) {
    final points = <Offset>[];
    const double stepDist = 10.0;

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = Offset(
          stroke.points[i].dx * size.width,
          stroke.points[i].dy * size.height,
        );
        final p2 = Offset(
          stroke.points[i + 1].dx * size.width,
          stroke.points[i + 1].dy * size.height,
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
        points.add(Offset(last.dx * size.width, last.dy * size.height));
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
      _feedbackStatus = NumberTracingFeedbackStatus.idle;
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
        _feedbackStatus = NumberTracingFeedbackStatus.success;
      });
      KidSoundService.instance.speak('Awesome!');
      widget.onComplete();
    } else {
      setState(() {
        _feedbackStatus = NumberTracingFeedbackStatus.failure;
      });
      KidSoundService.instance.speak('Try again!');

      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(milliseconds: 1600), () {
        if (mounted && !_hasTriggeredCompletion) {
          setState(() {
            _userPoints.clear();
            _hitWaypoints.clear();
            _currentCursor = null;
            _feedbackStatus = NumberTracingFeedbackStatus.idle;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strokes = NumberData.getTracingStrokes(widget.number);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final waypoints = _computeInterpolatedWaypoints(strokes, size);

        final initialPoint =
            strokes.isNotEmpty && strokes.first.points.isNotEmpty
                ? Offset(
                    strokes.first.points.first.dx * size.width,
                    strokes.first.points.first.dy * size.height,
                  )
                : Offset(size.width * 0.5, size.height * 0.5);

        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => _onPanStart(d, waypoints),
              onPanUpdate: (d) => _onPanUpdate(d, waypoints),
              onPanEnd: (d) => _onPanEnd(d, waypoints),
              child: CustomPaint(
                size: size,
                painter: _NumberTracingPainter(
                  strokes: strokes,
                  userPoints: _userPoints,
                  cursor: _currentCursor ?? initialPoint,
                  isCompleted: _hasTriggeredCompletion,
                ),
              ),
            ),

            // Success Overlay: Green Tick Badge
            if (_feedbackStatus == NumberTracingFeedbackStatus.success)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
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
            if (_feedbackStatus == NumberTracingFeedbackStatus.failure)
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
                            color: const Color(0xFFFF4B4B)
                                .withValues(alpha: 0.28),
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

class _NumberTracingPainter extends CustomPainter {
  _NumberTracingPainter({
    required this.strokes,
    required this.userPoints,
    required this.cursor,
    required this.isCompleted,
  });

  final List<NumberStroke> strokes;
  final List<Offset?> userPoints;
  final Offset cursor;
  final bool isCompleted;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Dotted Guide Pattern
    final dotPaint = Paint()
      ..color = AppColors.navy
      ..style = PaintingStyle.fill;

    const double dotRadius = 4.0;
    const double stepDistance = 14.0;

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = Offset(
          stroke.points[i].dx * size.width,
          stroke.points[i].dy * size.height,
        );
        final p2 = Offset(
          stroke.points[i + 1].dx * size.width,
          stroke.points[i + 1].dy * size.height,
        );

        final totalDist = (p2 - p1).distance;
        final numSteps = math.max(1, (totalDist / stepDistance).round());

        for (int s = 0; s <= numSteps; s++) {
          final t = s / numSteps;
          final dotPos = Offset.lerp(p1, p2, t)!;
          canvas.drawCircle(dotPos, dotRadius, dotPaint);
        }
      }
    }

    // 2. Draw User Traced Path (Coral Red thick stroke)
    final validPoints = userPoints.whereType<Offset>().toList();
    if (validPoints.length > 1) {
      final tracePaint = Paint()
        ..color = isCompleted
            ? AppColors.kidGreen
            : const Color(0xFFFF5E5E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      bool isNewSegment = true;

      for (final pt in userPoints) {
        if (pt == null) {
          isNewSegment = true;
        } else if (isNewSegment) {
          path.moveTo(pt.dx, pt.dy);
          isNewSegment = false;
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(path, tracePaint);
    }

    // 3. Draw Green Dot Cursor with Stroke Number Badge
    // Matches Screenshot 3: circular green badge with stroke number (e.g. "1")
    if (!isCompleted) {
      final badgePaint = Paint()
        ..color = AppColors.kidGreen
        ..style = PaintingStyle.fill;

      canvas.drawCircle(cursor, 16.0, badgePaint);

      final textPainter = TextPainter(
        text: const TextSpan(
          text: '1',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          cursor.dx - (textPainter.width / 2),
          cursor.dy - (textPainter.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NumberTracingPainter oldDelegate) => true;
}
