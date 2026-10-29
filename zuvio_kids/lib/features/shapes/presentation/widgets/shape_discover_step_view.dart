import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_entity.dart';
import 'shape_visual.dart';

/// Step 1 — Discover Shape View.
/// - Displays solid and outline shapes with shape name
/// - Pronounces the shape name
/// - Replay button respecting mute setting
/// - Full-width "Next →" button at bottom
/// Layer: Presentation Widget
class ShapeDiscoverStepView extends StatefulWidget {
  const ShapeDiscoverStepView({
    super.key,
    required this.shape,
    required this.onNext,
  });

  final ShapeEntity shape;
  final VoidCallback onNext;

  @override
  State<ShapeDiscoverStepView> createState() => ShapeDiscoverStepViewState();
}

class ShapeDiscoverStepViewState extends State<ShapeDiscoverStepView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  int _sequenceId = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startPronunciationSequence();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ShapeDiscoverStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shape.id != widget.shape.id) {
      _startPronunciationSequence();
    }
  }

  @override
  void dispose() {
    _sequenceId++;
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startPronunciationSequence({bool isReplay = false}) async {
    final currentId = ++_sequenceId;
    _pulseController.stop();
    _pulseController.value = 0.0;

    if (!isReplay) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted || currentId != _sequenceId) return;
    }

    final sound = KidSoundService.instance;
    final shapeName = widget.shape.englishName;

    // Speak shape name
    _pulseController.repeat(reverse: true);
    await sound.speak(shapeName);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted || currentId != _sequenceId) return;
    _pulseController.stop();
    await _pulseController.animateTo(0.0,
        duration: const Duration(milliseconds: 150));
  }

  void _replaySound() {
    _startPronunciationSequence(isReplay: true);
  }

  String _getLocalizedShapeName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'shapeCircle':
        return l10n.shapeCircle;
      case 'shapeSquare':
        return l10n.shapeSquare;
      case 'shapeTriangle':
        return l10n.shapeTriangle;
      case 'shapeRectangle':
        return l10n.shapeRectangle;
      case 'shapeOval':
        return l10n.shapeOval;
      case 'shapeStar':
        return l10n.shapeStar;
      case 'shapeHeart':
        return l10n.shapeHeart;
      case 'shapeDiamond':
        return l10n.shapeDiamond;
      case 'shapePentagon':
        return l10n.shapePentagon;
      case 'shapeHexagon':
        return l10n.shapeHexagon;
      case 'shapeCrescent':
        return l10n.shapeCrescent;
      case 'shapeSemicircle':
        return l10n.shapeSemicircle;
      default:
        return widget.shape.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shapeName = _getLocalizedShapeName(l10n, widget.shape.nameKey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Central White Card
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main Content: Solid & Outlined Shapes + Shape Name
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Shapes (Both Filled and Outline Together)
                        GestureDetector(
                          onTap: _replaySound,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 1. Filled (Solid) Shape
                                Container(
                                  width: 130,
                                  height: 130,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(widget.shape.colorValue)
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Color(widget.shape.colorValue)
                                          .withValues(alpha: 0.20),
                                      width: 2,
                                    ),
                                  ),
                                  child: ShapeVisualWidget(
                                    shapeId: widget.shape.id,
                                    size: 104,
                                    color: Color(widget.shape.colorValue),
                                  ),
                                ),

                                const SizedBox(width: 20),

                                // 2. Outline (Unfilled) Shape
                                Container(
                                  width: 130,
                                  height: 130,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Color(widget.shape.colorValue)
                                          .withValues(alpha: 0.20),
                                      width: 2,
                                    ),
                                  ),
                                  child: ShapeVisualWidget(
                                    shapeId: widget.shape.id,
                                    size: 104,
                                    color: Color(widget.shape.colorValue),
                                    mode: ShapeVisualMode.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Shape Name (e.g. Circle, Square)
                        Text(
                          shapeName,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Replay Button in Bottom-Right Corner
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _replaySound,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.starYellow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.replay_rounded,
                          color: AppColors.navy,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Next Button
          KidButton(
            label: l10n.btnNext,
            onPressed: widget.onNext,
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
