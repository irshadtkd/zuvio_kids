import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_letter_entity.dart';
import 'alphabet_illustration.dart';

/// Discover step view: animated letter display, illustration, and pronunciation.
/// Strictly displays single letter according to session case (Capital A–Z or Small a–z).
/// Synchronizes voice with pulsing letter animation & highlight with 2-second pauses.
/// Layer: Presentation Widget
class DiscoverStepView extends ConsumerStatefulWidget {
  const DiscoverStepView({
    super.key,
    required this.letter,
    required this.onNext,
  });

  final AlphabetLetterEntity letter;
  final VoidCallback onNext;

  @override
  ConsumerState<DiscoverStepView> createState() => DiscoverStepViewState();
}

class DiscoverStepViewState extends ConsumerState<DiscoverStepView>
    with SingleTickerProviderStateMixin {
  late AnimationController _voiceSyncController;
  late Animation<double> _scaleAnimation;
  bool _isHighlighted = false;
  int _sequenceId = 0;

  @override
  void initState() {
    super.initState();
    _voiceSyncController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.22).animate(
      CurvedAnimation(
        parent: _voiceSyncController,
        curve: Curves.easeInOutBack,
      ),
    );

    _startPronunciationSequence();
  }

  @override
  void didUpdateWidget(covariant DiscoverStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letter.letter != widget.letter.letter ||
        oldWidget.letter.isCapital != widget.letter.isCapital) {
      _startPronunciationSequence();
    }
  }

  /// Public replay method called when replay button is tapped.
  Future<void> playAudioSequence() async {
    _startPronunciationSequence(initialDelayMs: 0);
  }

  Timer? _delayTimer;

  Future<void> _delay(int milliseconds) {
    _delayTimer?.cancel();
    final completer = Completer<void>();
    _delayTimer = Timer(Duration(milliseconds: milliseconds), () {
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  void _startPronunciationSequence({int initialDelayMs = 2000}) {
    _sequenceId++;
    _delayTimer?.cancel();
    final currentId = _sequenceId;
    _runSynchronizedSequence(currentId, initialDelayMs: initialDelayMs);
  }

  /// Sequence requirement:
  /// 1. Display letter.
  /// 2. Wait 2 seconds (0s on replay tap) -> Pronounce letter with animation & highlight.
  /// 3. Wait 2 seconds -> Pronounce letter again with animation & highlight.
  /// 4. After that, pronounce supporting phrase "A for Apple".
  Future<void> _runSynchronizedSequence(
    int id, {
    int initialDelayMs = 2000,
  }) async {
    // Reset any ongoing animation
    _voiceSyncController.stop();
    _voiceSyncController.value = 0.0;
    if (mounted) setState(() => _isHighlighted = false);

    // 1. Initial wait (2 seconds on letter appearance, 0ms on explicit replay)
    if (initialDelayMs > 0) {
      await _delay(initialDelayMs);
      if (!mounted || id != _sequenceId) return;
    }

    final sound = KidSoundService.instance;
    // Always pronounce only the letter name (e.g. "A", "B", "C")
    // Never include prefixes like "Capital A" or "Small a"
    final letterName = widget.letter.letter.toUpperCase();

    // 2. First pronunciation + synchronized animation & highlight
    if (mounted) setState(() => _isHighlighted = true);
    _voiceSyncController.repeat(reverse: true);
    await sound.speakLetter(letterName);
    await _delay(700);
    if (!mounted || id != _sequenceId) return;
    _voiceSyncController.stop();
    await _voiceSyncController.animateTo(0.0,
        duration: const Duration(milliseconds: 150));
    if (mounted) setState(() => _isHighlighted = false);

    // 3. Exactly 2 seconds gap before second pronunciation
    await _delay(2000);
    if (!mounted || id != _sequenceId) return;

    // 4. Second pronunciation + synchronized animation & highlight
    if (mounted) setState(() => _isHighlighted = true);
    _voiceSyncController.repeat(reverse: true);
    await sound.speakLetter(letterName);
    await _delay(700);
    if (!mounted || id != _sequenceId) return;
    _voiceSyncController.stop();
    await _voiceSyncController.animateTo(0.0,
        duration: const Duration(milliseconds: 150));
    if (mounted) setState(() => _isHighlighted = false);

    // 5. Brief pause then pronounce phrase: "A for Apple"
    await _delay(800);
    if (!mounted || id != _sequenceId) return;
    await sound.speakLetterPhrase(letterName, widget.letter.primaryWord);
  }

  @override
  void dispose() {
    _sequenceId++;
    _delayTimer?.cancel();
    _voiceSyncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Strictly display single letter for the active session (A–Z or a–z)
    final displayLetter = widget.letter.displayLetter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // ── Main White Card ──────────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Synchronized Voice-Animated & Highlighted Letter
                        AnimatedBuilder(
                          animation: _voiceSyncController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                decoration: _isHighlighted
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFF5E5E)
                                                .withValues(alpha: 0.28),
                                            blurRadius: 36,
                                            spreadRadius: 12,
                                          ),
                                        ],
                                      )
                                    : null,
                                child: Text(
                                  displayLetter,
                                  style: AppTextStyles.base.copyWith(
                                    fontSize: 124,
                                    fontWeight: FontWeight.w900,
                                    color: _isHighlighted
                                        ? const Color(0xFFFF2E63)
                                        : const Color(0xFFFF5E5E),
                                    height: 1.0,
                                    shadows: _isHighlighted
                                        ? const [
                                            Shadow(
                                              color: Color(0xFFFF2E63),
                                              blurRadius: 20,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Illustration (e.g. Apple)
                        AlphabetIllustration(
                          word: widget.letter.primaryWord,
                          size: 96,
                        ),

                        // Phrase ("A for Apple" or "a for Apple")
                        Text(
                          l10n.letterForWord(
                            displayLetter,
                            widget.letter.primaryWord,
                          ),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headerTitle.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Small Play Button at Bottom-Right Corner of Letter Card
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Semantics(
                      button: true,
                      label: l10n.btnReplayAudio,
                      child: GestureDetector(
                        onTap: playAudioSequence,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.cardYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD69E1F)
                                    .withValues(alpha: 0.8),
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.navy,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Bottom Next Button ───────────────────────────────────────────
          KidButton(
            label: l10n.btnNext,
            onPressed: widget.onNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
