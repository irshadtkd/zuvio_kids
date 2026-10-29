import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/core/widgets/reset_button.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_entity.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'number_tracing_canvas.dart';

/// Step 2 — Practice Tracing View for Numbers.
/// Follows Screenshot 3:
/// - White card with dotted number pattern and stroke badge
/// - Helper row: Cartoon avatar + "Follow the dots with your finger!"
/// - Bottom buttons row: Yellow "Show me" + Green "Next →"
/// Layer: Presentation Widget
class NumberPracticeStepView extends StatefulWidget {
  const NumberPracticeStepView({
    super.key,
    required this.number,
    required this.onNext,
    required this.onTracingDone,
    required this.isTracingDone,
    this.onResetTracing,
    this.friendAvatar = AppStrings.defaultFriend,
  });

  final NumberEntity number;
  final VoidCallback onNext;
  final VoidCallback onTracingDone;
  final VoidCallback? onResetTracing;
  final bool isTracingDone;
  final String friendAvatar;

  @override
  State<NumberPracticeStepView> createState() => _NumberPracticeStepViewState();
}

class _NumberPracticeStepViewState extends State<NumberPracticeStepView> {
  final GlobalKey<NumberTracingCanvasState> _canvasKey =
      GlobalKey<NumberTracingCanvasState>();

  @override
  void initState() {
    super.initState();
    _speakPrompt();
  }

  @override
  void didUpdateWidget(covariant NumberPracticeStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number.value != widget.number.value) {
      _speakPrompt();
    }
  }

  void _speakPrompt() {
    KidSoundService.instance.speak('Trace number ${widget.number.wordName}!');
  }

  void _handleShowMe() {
    final renderBox =
        _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _canvasKey.currentState?.playShowMeDemo(renderBox.size);
    }
  }

  void _handleReset() {
    _canvasKey.currentState?.resetCanvas();
    widget.onResetTracing?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Main White Card with Number Tracing Canvas
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingM),
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
              child: NumberTracingCanvas(
                key: _canvasKey,
                number: widget.number.value,
                isCompleted: widget.isTracingDone,
                onComplete: widget.onTracingDone,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Helper Row: Avatar + Speech Bubble
          Row(
            children: [
              AnimalAvatar(
                avatarType: widget.friendAvatar,
                size: 54,
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
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    l10n.followDotsWithFinger,
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

          // Action Buttons: Reset (bottom-left), "Show me" (yellow), "Next ➔" (green)
          Row(
            children: [
              ResetButton(
                tooltip: l10n.btnClear,
                onPressed: _handleReset,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KidButton(
                  label: l10n.btnShowMe,
                  backgroundColor: AppColors.cardYellow,
                  showArrow: false,
                  onPressed: _handleShowMe,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KidButton(
                  label: l10n.btnNext,
                  enabled: widget.isTracingDone,
                  onPressed: widget.isTracingDone ? widget.onNext : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
