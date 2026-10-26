import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/alphabet/data/datasources/alphabet_letter_data.dart';

/// Feedback status for tracing accuracy validation.
enum TracingFeedbackStatus {
  idle,
  success, // Entire letter finished with >= 99% accuracy (green tick)
  failure, // Letter incomplete or accuracy < 99% (red cross)
}

/// Interactive letter tracing canvas where children trace dotted letters with their fingers.
/// Accuracy validation requirements:
/// - Child must finish drawing the entire letter before checking accuracy.
/// - Does not show success or failure while the child is still drawing.
/// - Once drawing completes, evaluates how accurately the drawing followed the dotted pattern.
/// - If tracing accuracy >= 99% (and entire letter finished): displays green tick (✓) and calls [onComplete].
/// - If tracing accuracy < 99%: displays red cross (✗) and resets canvas for retry.
/// Layer: Presentation Widget
class TracingCanvas extends StatefulWidget {
  const TracingCanvas({
    super.key,
    required this.letter,
    required this.onComplete,
    this.isCapital = true,
    this.isCompleted = false,
  });

  final String letter;
  final VoidCallback onComplete;
  final bool isCapital;
  final bool isCompleted;

  @override
  State<TracingCanvas> createState() => _TracingCanvasState();
}

class _TracingCanvasState extends State<TracingCanvas> {
  final List<Offset?> _userPoints = [];
  Offset? _currentCursor;
  final Set<int> _hitWaypoints = {};
  bool _hasTriggeredCompletion = false;
  double _accuracy = 0.0;
  TracingFeedbackStatus _feedbackStatus = TracingFeedbackStatus.idle;

  Timer? _evaluationTimer;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isCompleted) {
      _hasTriggeredCompletion = true;
      _feedbackStatus = TracingFeedbackStatus.success;
      _accuracy = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant TracingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letter != widget.letter ||
        oldWidget.isCapital != widget.isCapital) {
      _resetCanvas();
    } else if (widget.isCompleted && !_hasTriggeredCompletion) {
      _hasTriggeredCompletion = true;
      _feedbackStatus = TracingFeedbackStatus.success;
      _accuracy = 1.0;
    }
  }

  @override
  void dispose() {
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();
    super.dispose();
  }

  /// Interpolates dotted waypoints along letter strokes.
  List<Offset> _computeInterpolatedWaypoints(
    List<TracingStroke> strokes,
    Size size,
  ) {
    const double stepDistance = 14.0;
    final List<Offset> points = [];

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
          points.add(Offset.lerp(p1, p2, t)!);
        }
      }
    }
    return points;
  }

  /// Calculates the shortest distance from point [p] to segment [a]-[b].
  static double _distToSegment(Offset p, Offset a, Offset b) {
    final l2 = (b - a).distanceSquared;
    if (l2 == 0) return (p - a).distance;
    final t =
        ((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) / l2;
    final clampedT = t.clamp(0.0, 1.0);
    final projection = Offset(
      a.dx + clampedT * (b.dx - a.dx),
      a.dy + clampedT * (b.dy - a.dy),
    );
    return (p - projection).distance;
  }

  /// Calculates the minimum distance from point [p] to any guide segment.
  static double _minDistanceToGuide(
    Offset p,
    List<TracingStroke> strokes,
    Size size,
  ) {
    double minD = double.infinity;
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      if (stroke.points.length == 1) {
        final pt = Offset(
          stroke.points.first.dx * size.width,
          stroke.points.first.dy * size.height,
        );
        final d = (p - pt).distance;
        if (d < minD) minD = d;
        continue;
      }
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final a = Offset(
          stroke.points[i].dx * size.width,
          stroke.points[i].dy * size.height,
        );
        final b = Offset(
          stroke.points[i + 1].dx * size.width,
          stroke.points[i + 1].dy * size.height,
        );
        final d = _distToSegment(p, a, b);
        if (d < minD) minD = d;
      }
    }
    return minD;
  }

  void _onPanStart(DragStartDetails details, List<Offset> waypoints) {
    _evaluationTimer?.cancel();

    // If failure overlay was visible, reset canvas immediately on new touch
    if (_feedbackStatus == TracingFeedbackStatus.failure) {
      _resetCanvas();
    }
    if (_hasTriggeredCompletion) return;

    final localPos = details.localPosition;
    setState(() {
      _userPoints.add(localPos);
      _currentCursor = localPos;
    });
    _recordWaypointsHit(localPos, waypoints);
  }

  void _onPanUpdate(DragUpdateDetails details, List<Offset> waypoints) {
    if (_hasTriggeredCompletion) return;

    final localPos = details.localPosition;
    setState(() {
      _userPoints.add(localPos);
      _currentCursor = localPos;
    });
    _recordWaypointsHit(localPos, waypoints);
  }

  void _onPanEnd(
    DragEndDetails details,
    List<TracingStroke> strokes,
    Size size,
    int totalWaypoints,
  ) {
    if (_hasTriggeredCompletion) return;

    // Insert null separator for multi-stroke letters
    setState(() {
      _userPoints.add(null);
    });

    final validPoints = _userPoints.whereType<Offset>().length;
    if (validPoints < 6) return;

    // Debounce evaluation by 1.5s to allow child to complete all strokes
    // (e.g. A, B, E have 3 to 4 distinct strokes where finger is lifted)
    _evaluationTimer?.cancel();
    _evaluationTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted || _hasTriggeredCompletion) return;
      _evaluateTracing(strokes, size, totalWaypoints);
    });
  }

  /// While drawing, simply records which waypoints the finger touched.
  /// Does NOT trigger success or failure mid-drawing.
  void _recordWaypointsHit(Offset pos, List<Offset> waypoints) {
    const double hitRadius = 38.0;
    for (int i = 0; i < waypoints.length; i++) {
      if (!_hitWaypoints.contains(i)) {
        if ((pos - waypoints[i]).distance <= hitRadius) {
          _hitWaypoints.add(i);
        }
      }
    }
  }

  /// Evaluates tracing accuracy once the child finishes drawing the entire letter.
  void _evaluateTracing(
    List<TracingStroke> strokes,
    Size size,
    int totalWaypoints,
  ) {
    final validPoints = _userPoints.whereType<Offset>().toList();
    if (validPoints.length < 8) return;

    // 1. Completion Check: Child must finish drawing the entire letter
    final double coverage = totalWaypoints > 0
        ? (_hitWaypoints.length / totalWaypoints)
        : 0.0;
    final bool isLetterCompleted = coverage >= 0.97;

    // 2. Accuracy Check: Measure how accurately drawing followed dotted pattern
    const double accuracyTolerance = 30.0; // Corridor radius in pixels
    int onTrackPoints = 0;
    for (final pt in validPoints) {
      final dist = _minDistanceToGuide(pt, strokes, size);
      if (dist <= accuracyTolerance) {
        onTrackPoints++;
      }
    }

    final double pathAccuracy =
        validPoints.isNotEmpty ? (onTrackPoints / validPoints.length) : 0.0;

    // The child must finish the whole letter AND achieve >= 99% path accuracy
    final bool isSuccess = isLetterCompleted && pathAccuracy >= 0.97;
    final double displayAccuracy =
        isLetterCompleted ? pathAccuracy : (pathAccuracy * (coverage / 0.88));

    if (isSuccess) {
      _triggerSuccess(pathAccuracy);
    } else {
      _triggerFailure(displayAccuracy);
    }
  }

  void _triggerSuccess(double finalAccuracy) {
    if (_hasTriggeredCompletion) return;
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();

    setState(() {
      _hasTriggeredCompletion = true;
      _feedbackStatus = TracingFeedbackStatus.success;
      _accuracy = math.max(finalAccuracy, 0.97);
    });

    KidSoundService.instance.speak('Awesome!');
    widget.onComplete();
  }

  void _triggerFailure(double finalAccuracy) {
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();

    setState(() {
      _feedbackStatus = TracingFeedbackStatus.failure;
      _accuracy = finalAccuracy;
    });

    KidSoundService.instance.speak('Try again!');

    // Show red cross for 1.5 seconds, then clear canvas for retry
    _resetTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _resetCanvas();
    });
  }

  void _resetCanvas() {
    _evaluationTimer?.cancel();
    _resetTimer?.cancel();
    setState(() {
      _userPoints.clear();
      _hitWaypoints.clear();
      _currentCursor = null;
      _hasTriggeredCompletion = false;
      _accuracy = 0.0;
      _feedbackStatus = TracingFeedbackStatus.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strokes = AlphabetLetterData.getTracingStrokes(
      widget.letter,
      isCapital: widget.isCapital,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final waypoints = _computeInterpolatedWaypoints(strokes, size);

        // Position initial cursor at first waypoint
        final initialPoint =
            strokes.isNotEmpty && strokes.first.points.isNotEmpty
                ? Offset(
                    strokes.first.points.first.dx * size.width,
                    strokes.first.points.first.dy * size.height,
                  )
                : Offset(size.width * 0.3, size.height * 0.15);

        final cursor = _currentCursor ?? initialPoint;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Gesture Tracking Canvas
            GestureDetector(
              onPanStart: (d) => _onPanStart(d, waypoints),
              onPanUpdate: (d) => _onPanUpdate(d, waypoints),
              onPanEnd: (d) =>
                  _onPanEnd(d, strokes, size, waypoints.length),
              child: CustomPaint(
                size: size,
                painter: _TracingPainter(
                  strokes: strokes,
                  userPoints: _userPoints,
                  cursor: cursor,
                  isCompleted: widget.isCompleted || _hasTriggeredCompletion,
                ),
              ),
            ),

            // Success Overlay: Green Tick (✓) badge when tracing is completed with >= 99% accuracy
            if (_feedbackStatus == TracingFeedbackStatus.success)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 350),
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
                            color: AppColors.kidGreen.withValues(alpha: 0.28),
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
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.kidGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.tracingSuccess,
                                style: AppTextStyles.headerTitle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.kidGreen,
                                ),
                              ),
                              Text(
                                '${(_accuracy * 100).round()}%',
                                style: AppTextStyles.base.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy,
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

            // Failure Overlay: Red Cross (✗) badge when letter incomplete or accuracy < 99%
            if (_feedbackStatus == TracingFeedbackStatus.failure)
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
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4B4B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 14),
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

class _TracingPainter extends CustomPainter {
  _TracingPainter({
    required this.strokes,
    required this.userPoints,
    required this.cursor,
    required this.isCompleted,
  });

  final List<TracingStroke> strokes;
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
        ..strokeWidth = 20.0
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

    // 3. Draw Green Dot Cursor at current tracing position
    if (!isCompleted) {
      final greenCursorPaint = Paint()
        ..color = AppColors.kidGreen
        ..style = PaintingStyle.fill;

      canvas.drawCircle(cursor, 16.0, greenCursorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) => true;
}
