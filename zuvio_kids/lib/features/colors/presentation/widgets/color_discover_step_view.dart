import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_item_entity.dart';

/// Step 1 — Discover Color View.
/// - Displays color splash with scale/pulse animation
/// - Pronounces the color name twice with a 2-second gap
/// - Replay button at bottom-right of the card respecting mute setting
/// - Full-width "Next →" button at bottom
/// Layer: Presentation Widget
class ColorDiscoverStepView extends StatefulWidget {
  const ColorDiscoverStepView({
    super.key,
    required this.colorItem,
    required this.onNext,
  });

  final ColorItemEntity colorItem;
  final VoidCallback onNext;

  @override
  State<ColorDiscoverStepView> createState() => _ColorDiscoverStepViewState();
}

class _ColorDiscoverStepViewState extends State<ColorDiscoverStepView>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _startPronunciationSequence();
  }

  @override
  void didUpdateWidget(covariant ColorDiscoverStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colorItem.id != widget.colorItem.id) {
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

    // Small delay before starting auto pronunciation
    if (!isReplay) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted || currentId != _sequenceId) return;
    }

    final sound = KidSoundService.instance;
    final spokenWord = widget.colorItem.name;

    // 1. First pronunciation with synchronized animation
    _pulseController.repeat(reverse: true);
    await sound.speak(spokenWord);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted || currentId != _sequenceId) return;
    _pulseController.stop();
    await _pulseController.animateTo(0.0,
        duration: const Duration(milliseconds: 150));

    // 2. Exactly 2 seconds gap
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    if (!mounted || currentId != _sequenceId) return;

    // 3. Second pronunciation with synchronized animation
    _pulseController.repeat(reverse: true);
    await sound.speak(spokenWord);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted || currentId != _sequenceId) return;
    _pulseController.stop();
    await _pulseController.animateTo(0.0,
        duration: const Duration(milliseconds: 150));
  }

  void _replaySound() {
    _startPronunciationSequence(isReplay: true);
  }

  String _getLocalizedColorName(AppLocalizations l10n, String id) {
    switch (id) {
      case 'red':
        return l10n.colorRed;
      case 'yellow':
        return l10n.colorYellow;
      case 'green':
        return l10n.colorGreen;
      case 'blue':
        return l10n.colorBlue;
      case 'orange':
        return l10n.colorOrange;
      case 'purple':
        return l10n.colorPurple;
      case 'pink':
      default:
        return l10n.colorPink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Color(widget.colorItem.colorValue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Main White Card
          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _replaySound,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSizes.paddingXL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Vibrant Color Circle
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Color Name (e.g. "Red")
                        Text(
                          _getLocalizedColorName(l10n, widget.colorItem.id),
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle: "Tap the color to hear it again"
                        Text(
                          l10n.tapColorToHearAgain,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.base.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Replay Button at Bottom-Right of Card
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _replaySound,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardYellow.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volume_up_rounded,
                        color: AppColors.navy,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Green "Next ➔" Button
          KidButton(
            label: l10n.btnNext,
            onPressed: widget.onNext,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
