import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_entity.dart';

/// Step 1 — Discover Number View.
/// - Displays number with attractive scale/pulse animation
/// - Pronounces the number twice with a 2-second gap
/// - Replay button at bottom-right of the card respecting mute setting
/// - Full-width "Next →" button at bottom
/// Matches Screenshot 2.
/// Layer: Presentation Widget
class NumberDiscoverStepView extends StatefulWidget {
  const NumberDiscoverStepView({
    super.key,
    required this.number,
    required this.onNext,
  });

  final NumberEntity number;
  final VoidCallback onNext;

  @override
  State<NumberDiscoverStepView> createState() => _NumberDiscoverStepViewState();
}

class _NumberDiscoverStepViewState extends State<NumberDiscoverStepView>
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
  void didUpdateWidget(covariant NumberDiscoverStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number.value != widget.number.value) {
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
    final spokenWord = widget.number.wordName;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                        // Animated Large Coral Numeral
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text(
                            '${widget.number.value}',
                            style: AppTextStyles.base.copyWith(
                              fontSize: 130,
                              fontWeight: FontWeight.w900,
                              color: AppColors.numberCoral,
                              height: 1.0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Word Name (e.g. "Seven")
                        Text(
                          widget.number.wordName,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle: "Tap the number to hear it again"
                        Text(
                          l10n.tapNumberToHearAgain,
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
                        Icons.play_arrow_rounded,
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
