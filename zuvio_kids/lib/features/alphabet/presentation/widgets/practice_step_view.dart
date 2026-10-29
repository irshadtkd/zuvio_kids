import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/core/widgets/reset_button.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_letter_entity.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'tracing_canvas.dart';

/// Practice step view: dotted letter tracing with finger.
/// Matches Image 2.
/// Layer: Presentation Widget
class PracticeStepView extends StatefulWidget {
  const PracticeStepView({
    super.key,
    required this.letter,
    required this.onNext,
    required this.onTracingDone,
    required this.isTracingDone,
    this.onResetTracing,
    this.friendAvatar = AppStrings.defaultFriend,
  });

  final AlphabetLetterEntity letter;
  final VoidCallback onNext;
  final VoidCallback onTracingDone;
  final VoidCallback? onResetTracing;
  final bool isTracingDone;
  final String friendAvatar;

  @override
  State<PracticeStepView> createState() => PracticeStepViewState();
}

class PracticeStepViewState extends State<PracticeStepView> {
  final GlobalKey<TracingCanvasState> _canvasKey =
      GlobalKey<TracingCanvasState>();
  @override
  void initState() {
    super.initState();
    _speakPrompt();
  }

  void playAudioPrompt() {
    _speakPrompt();
  }

  void _speakPrompt() {
    final phonetic =
        KidSoundService.instance.getPhoneticLetterName(widget.letter.letter);
    final prompt = 'Trace $phonetic. $phonetic for ${widget.letter.primaryWord}!';
    KidSoundService.instance.speak(prompt);
  }

  void _handleReset() {
    _canvasKey.currentState?.resetCanvas();
    widget.onResetTracing?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // ── Main White Card ──────────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              child: Column(
                children: [
                  // Dotted Tracing Canvas
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TracingCanvas(
                        key: _canvasKey,
                        letter: widget.letter.letter,
                        isCapital: widget.letter.isCapital,
                        isCompleted: widget.isTracingDone,
                        onComplete: widget.onTracingDone,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Prompt Text ("Trace B. B for Ball!" or "Trace b. b for Ball!")
                  Text(
                    l10n.traceLetterPrompt(
                      widget.letter.displayLetter,
                      widget.letter.primaryWord,
                    ),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headerTitle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Helper Row: Friend Avatar + Speech Bubble ────────────────────
          Row(
            children: [
              AnimalAvatar(
                avatarType: widget.friendAvatar,
                size: 56,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    l10n.practiceHelperPrompt,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Bottom Action Row: Reset Button (Bottom-Left) + Next Button ─
          Row(
            children: [
              ResetButton(
                tooltip: l10n.btnClear,
                onPressed: _handleReset,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: KidButton(
                  label: l10n.btnNext,
                  enabled: widget.isTracingDone,
                  onPressed: widget.isTracingDone ? widget.onNext : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
