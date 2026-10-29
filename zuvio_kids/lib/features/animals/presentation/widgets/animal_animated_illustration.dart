import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/animal_entity.dart';

/// Animated SVG illustration for a kid-friendly animal character.
/// Includes breathing idle oscillation, entrance pop-in, and interactive tap bounce.
/// Layer: Presentation Widget
class AnimalAnimatedIllustration extends StatefulWidget {
  const AnimalAnimatedIllustration({
    super.key,
    required this.animal,
    this.size = 220.0,
    this.onTap,
  });

  final AnimalEntity animal;
  final double size;
  final VoidCallback? onTap;

  @override
  State<AnimalAnimatedIllustration> createState() =>
      _AnimalAnimatedIllustrationState();
}

class _AnimalAnimatedIllustrationState extends State<AnimalAnimatedIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _entranceController;
  late final AnimationController _tapController;

  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceFade;
  late final Animation<double> _tapScale;
  late final Animation<double> _tapWobble;

  @override
  void initState() {
    super.initState();

    // ── Continuous gentle breathing/floating idle animation ─────────────────
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    // ── Pop-in entrance animation ───────────────────────────────────────────
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _entranceScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );
    _entranceFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeIn,
      ),
    );

    // ── Interactive tap bounce & wobble ─────────────────────────────────────
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _tapScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 60,
      ),
    ]).animate(_tapController);

    _tapWobble = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.08),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.08, end: -0.08),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.08, end: 0.0),
        weight: 25,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _tapController,
        curve: Curves.easeInOut,
      ),
    );

    _entranceController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimalAnimatedIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animal.id != widget.animal.id) {
      _entranceController.reset();
      _entranceController.forward();
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _entranceController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapController.reset();
    _tapController.forward();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final animalColor = Color(widget.animal.colorValue);

    return Semantics(
      button: true,
      label: widget.animal.englishName,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: widget.size + 40,
          height: widget.size + 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Soft glowing halo background ──────────────────────────────
              AnimatedBuilder(
                animation: _idleController,
                builder: (context, _) {
                  final glowScale = 1.0 + (_idleController.value * 0.08);
                  return Transform.scale(
                    scale: glowScale,
                    child: Container(
                      width: widget.size * 0.95,
                      height: widget.size * 0.95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            animalColor.withValues(alpha: 0.28),
                            animalColor.withValues(alpha: 0.08),
                            animalColor.withValues(alpha: 0.0),
                          ],
                          stops: const [0.4, 0.75, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── Animated Animal SVG ───────────────────────────────────────
              AnimatedBuilder(
                animation: Listenable.merge([
                  _idleController,
                  _entranceController,
                  _tapController,
                ]),
                builder: (context, _) {
                  // Breathing vertical bob: -6 to +6 px
                  final idleY = math.sin(_idleController.value * math.pi * 2) * 5.0;
                  // Breathing subtle scale: 1.0 to 1.025
                  final idleScale = 1.0 + (_idleController.value * 0.025);

                  final totalScale =
                      _entranceScale.value * idleScale * _tapScale.value;
                  final totalRotation = _tapWobble.value;

                  return Opacity(
                    opacity: _entranceFade.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, idleY),
                      child: Transform.rotate(
                        angle: totalRotation,
                        child: Transform.scale(
                          scale: totalScale,
                          child: SvgPicture.asset(
                            widget.animal.svgAsset,
                            width: widget.size,
                            height: widget.size,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
