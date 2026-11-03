import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/services/ai_magic_service.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';

/// AI Magic overlay widget for the Animals learning screen.
///
/// Displays an animated bubble with a fun AI-generated animal action description
/// and sparkle particles. Triggered by tapping the AI Magic button.
///
/// Accepts data from the parent screen; does not read any provider directly.
/// Layer: Presentation Widget
class AnimalAiMagicOverlay extends StatefulWidget {
  const AnimalAiMagicOverlay({
    super.key,
    required this.animalName,
    required this.animalEnglishName,
    required this.animalColor,
    required this.soundAssetId,
    required this.onClose,
  });

  final String animalName;
  final String animalEnglishName;
  final Color animalColor;
  final String soundAssetId;
  final VoidCallback onClose;

  @override
  State<AnimalAiMagicOverlay> createState() => _AnimalAiMagicOverlayState();
}

class _AnimalAiMagicOverlayState extends State<AnimalAiMagicOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _sparkleController;
  late final AnimationController _pulseController;

  late final Animation<double> _entranceScale;
  late final Animation<double> _entranceFade;

  String? _actionText;
  bool _isLoading = true;
  bool _hasError = false;

  final List<_SparkleParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Entrance pop-in
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entranceScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.elasticOut),
    );
    _entranceFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    // Sparkle rotation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Gentle pulse for the bubble
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _generateParticles();
    _entranceController.forward();
    _loadAction();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 16; i++) {
      _particles.add(_SparkleParticle(
        angle: (_random.nextDouble() * 2 * math.pi),
        radius: 90 + _random.nextDouble() * 80,
        size: 6 + _random.nextDouble() * 12,
        phase: _random.nextDouble(),
        color: _sparkleColors[i % _sparkleColors.length],
      ));
    }
  }

  static const List<Color> _sparkleColors = [
    Color(0xFFFFD700),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFA29BFE),
    Color(0xFFFF9F43),
    Color(0xFF00B894),
    Color(0xFFFD79A8),
    Color(0xFF74B9FF),
  ];

  Future<void> _loadAction() async {
    try {
      final text = await AiMagicService.instance
          .generateAnimalAction(widget.animalEnglishName);
      if (!mounted) return;
      setState(() {
        _actionText = text;
        _isLoading = false;
      });
      // Play the animal sound to reinforce the experience
      await KidSoundService.instance.playAnimalSound(widget.soundAssetId);
    } catch (e, st) {
      AppLogger.error('AnimalAiMagicOverlay: _loadAction failed', e, st);
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _sparkleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: FadeTransition(
            opacity: _entranceFade,
            child: ScaleTransition(
              scale: _entranceScale,
              child: GestureDetector(
                onTap: () {}, // Prevent close on inner tap
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Sparkle ring around the bubble ─────────────────
                      _SparkleRing(
                        particles: _particles,
                        controller: _sparkleController,
                        animalColor: widget.animalColor,
                      ),
                      const SizedBox(height: 12),

                      // ── Action Bubble ───────────────────────────────────
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale =
                              1.0 + _pulseController.value * 0.025;
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: widget.animalColor.withValues(alpha: 0.6),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    widget.animalColor.withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Emoji + title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '✨',
                                    style: TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Magic!',
                                    style: AppTextStyles.base.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: widget.animalColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '✨',
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Action text / loading / error
                              if (_isLoading)
                                _buildLoadingState()
                              else if (_hasError || _actionText == null)
                                _buildErrorState()
                              else
                                _buildActionText(_actionText!),

                              const SizedBox(height: 20),

                              // Close hint
                              Text(
                                'Tap anywhere to close',
                                style: AppTextStyles.base.copyWith(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            color: widget.animalColor,
            strokeWidth: 4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Generating magic...',
          style: AppTextStyles.base.copyWith(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Text(
      'Magic is resting. Try again! 😊',
      style: AppTextStyles.base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionText(String text) {
    return Text(
      text,
      style: AppTextStyles.base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ── AI Magic Button ──────────────────────────────────────────────────────────

/// Compact, glowing "AI Magic" pill button used on the Animals learning screen.
/// Accepts data; does not depend on any provider.
/// Layer: Presentation Widget
class AnimalAiMagicButton extends StatefulWidget {
  const AnimalAiMagicButton({
    super.key,
    required this.animalColor,
    required this.onPressed,
  });

  final Color animalColor;
  final VoidCallback onPressed;

  @override
  State<AnimalAiMagicButton> createState() => _AnimalAiMagicButtonState();
}

class _AnimalAiMagicButtonState extends State<AnimalAiMagicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'AI Magic',
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          final glowRadius = 8.0 + _glowController.value * 14.0;
          return GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF9B59B6),
                    const Color(0xFF3498DB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B59B6).withValues(alpha: 0.55),
                    blurRadius: glowRadius,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('✨', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Text(
                    'AI Magic',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Sparkle Ring ─────────────────────────────────────────────────────────────

class _SparkleParticle {
  const _SparkleParticle({
    required this.angle,
    required this.radius,
    required this.size,
    required this.phase,
    required this.color,
  });

  final double angle;
  final double radius;
  final double size;
  final double phase;
  final Color color;
}

class _SparkleRing extends StatelessWidget {
  const _SparkleRing({
    required this.particles,
    required this.controller,
    required this.animalColor,
  });

  final List<_SparkleParticle> particles;
  final AnimationController controller;
  final Color animalColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: _SparklePainter(
            particles: particles,
            progress: controller.value,
          ),
        );
      },
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter({
    required this.particles,
    required this.progress,
  });

  final List<_SparkleParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (final p in particles) {
      final angle = p.angle + progress * 2 * math.pi;
      final opacity = 0.5 + 0.5 * math.sin((progress + p.phase) * 2 * math.pi);
      final currentSize =
          p.size * (0.7 + 0.3 * math.sin((progress + p.phase) * math.pi));

      final x = cx + math.cos(angle) * p.radius;
      final y = cy + math.sin(angle) * p.radius;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0.2, 1.0))
        ..style = PaintingStyle.fill;

      // Draw a small star/diamond sparkle
      _drawSparkle(canvas, Offset(x, y), currentSize, paint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const arms = 4;
    for (int i = 0; i < arms * 2; i++) {
      final angle = (i * math.pi / arms) - math.pi / 2;
      final r = i.isEven ? size : size * 0.4;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) =>
      old.progress != progress;
}

