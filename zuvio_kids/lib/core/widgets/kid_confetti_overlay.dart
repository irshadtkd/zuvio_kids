import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Reusable confetti overlay widget for celebration moments.
///
/// Wrap it in a [Stack] over the screen content and call
/// [KidConfettiOverlayState.burst()] to trigger a particle explosion.
///
/// Usage:
/// ```dart
/// final _confettiKey = GlobalKey<KidConfettiOverlayState>();
/// // In build, inside a Stack:
/// KidConfettiOverlay(key: _confettiKey)
/// // To trigger:
/// _confettiKey.currentState?.burst();
/// ```
/// Layer: Core Widget
class KidConfettiOverlay extends StatefulWidget {
  const KidConfettiOverlay({
    super.key,
    this.autoPlay = false,
    this.type = KidConfettiType.stars,
  });

  /// Whether to start the confetti immediately on mount.
  final bool autoPlay;

  /// Visual style of the confetti particles.
  final KidConfettiType type;

  @override
  State<KidConfettiOverlay> createState() => KidConfettiOverlayState();
}

/// Confetti particle style.
enum KidConfettiType { stars, rainbow, hearts, balloons }

class KidConfettiOverlayState extends State<KidConfettiOverlay> {
  late final ConfettiController _topLeft;
  late final ConfettiController _topRight;
  late final ConfettiController _center;

  @override
  void initState() {
    super.initState();
    _topLeft = ConfettiController(duration: const Duration(seconds: 3));
    _topRight = ConfettiController(duration: const Duration(seconds: 3));
    _center = ConfettiController(duration: const Duration(seconds: 2));
    if (widget.autoPlay) burst();
  }

  @override
  void dispose() {
    _topLeft.dispose();
    _topRight.dispose();
    _center.dispose();
    super.dispose();
  }

  /// Triggers a full celebration confetti burst from all positions.
  void burst() {
    _topLeft.play();
    _topRight.play();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _center.play();
    });
  }

  /// Triggers a small single confetti burst (for correct answers).
  void smallBurst() {
    _center.play();
  }

  List<Color> get _colors {
    switch (widget.type) {
      case KidConfettiType.stars:
        return const [
          Color(0xFFFFD700), Color(0xFFFF6B9D), Color(0xFF4ECDC4),
          Color(0xFFFF8C42), Color(0xFF6C63FF), Color(0xFF2ECC71),
        ];
      case KidConfettiType.rainbow:
        return const [
          Color(0xFFFF0000), Color(0xFFFF7F00), Color(0xFFFFFF00),
          Color(0xFF00FF00), Color(0xFF0000FF), Color(0xFF8B00FF),
        ];
      case KidConfettiType.hearts:
        return const [
          Color(0xFFFF69B4), Color(0xFFFF1493), Color(0xFFFF6EB4),
          Color(0xFFFFB6C1), Color(0xFFFF4466),
        ];
      case KidConfettiType.balloons:
        return const [
          Color(0xFFFF6B6B), Color(0xFFFFE66D), Color(0xFF4ECDC4),
          Color(0xFF45B7D1), Color(0xFFA8E6CF),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left burst
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _topLeft,
            blastDirection: pi / 4, // down-right
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            minBlastForce: 8,
            gravity: 0.3,
            colors: _colors,
          ),
        ),
        // Top-right burst
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _topRight,
            blastDirection: (3 * pi) / 4, // down-left
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            minBlastForce: 8,
            gravity: 0.3,
            colors: _colors,
          ),
        ),
        // Center burst
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _center,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.06,
            numberOfParticles: 30,
            maxBlastForce: 25,
            minBlastForce: 10,
            gravity: 0.25,
            colors: _colors,
          ),
        ),
      ],
    );
  }
}
