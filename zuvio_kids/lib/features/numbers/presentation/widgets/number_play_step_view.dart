import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_entity.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';

/// Step 3 — Play Quiz View for Numbers.
/// Follows Screenshot 4:
/// - White card: "Which number is this?" + coral dot visual representation
/// - 3 large pastel option cards (coral, yellow, light green)
/// - Shuffled option positions
/// - Green border on correct, red border on wrong
/// - Panda avatar + speech bubble helper when not yet correct
/// - Green "Next →" button shown only after selecting the correct answer
/// Layer: Presentation Widget
class NumberPlayStepView extends StatefulWidget {
  const NumberPlayStepView({
    super.key,
    required this.number,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.onAnswerSelected,
    required this.onNext,
    this.friendAvatar = AppStrings.defaultFriend,
  });

  final NumberEntity number;
  final int? selectedAnswer;
  final bool? isCorrect;
  final ValueChanged<int> onAnswerSelected;
  final VoidCallback onNext;
  final String friendAvatar;

  @override
  State<NumberPlayStepView> createState() => _NumberPlayStepViewState();
}

class _NumberPlayStepViewState extends State<NumberPlayStepView> {
  late List<int> _shuffledOptions;

  @override
  void initState() {
    super.initState();
    _initShuffledOptions();
    _speakPrompt();
  }

  @override
  void didUpdateWidget(covariant NumberPlayStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.number.value != widget.number.value) {
      _initShuffledOptions();
      _speakPrompt();
    }
  }

  void _initShuffledOptions() {
    _shuffledOptions = List<int>.from(widget.number.quizOptions)..shuffle();
  }

  void _speakPrompt() {
    KidSoundService.instance.speak('Which number is this? Count the dots!');
  }

  void _handleOptionTap(int value) {
    widget.onAnswerSelected(value);
    final isRight = value == widget.number.correctQuizAnswer;
    if (isRight) {
      KidSoundService.instance.speak('Awesome! That is ${widget.number.wordName}!');
    } else {
      KidSoundService.instance.speak('Try again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAnsweredCorrectly = widget.isCorrect == true;

    // Background colors for the 3 option cards matching Screenshot 4
    final optionCardColors = [
      AppColors.cardPink,
      AppColors.cardYellow,
      AppColors.cardGreen,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Main White Card: Question + Coral Dots
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingL,
              ),
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
                  Text(
                    l10n.whichNumberIsThis,
                    style: AppTextStyles.speechBubbleTitle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: _buildDotsVisual(widget.number.value),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3 Pastel Option Cards Row
          Row(
            children: List.generate(_shuffledOptions.length, (index) {
              final optionValue = _shuffledOptions[index];
              final isSelected = widget.selectedAnswer == optionValue;
              final isThisOptionCorrect =
                  optionValue == widget.number.correctQuizAnswer;

              Color borderColor = Colors.transparent;
              if (isSelected) {
                borderColor =
                    isThisOptionCorrect ? AppColors.kidGreen : AppColors.error;
              }

              final bgColor =
                  optionCardColors[index % optionCardColors.length];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == _shuffledOptions.length - 1 ? 0 : 6,
                  ),
                  child: GestureDetector(
                    onTap: () => _handleOptionTap(optionValue),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 110,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: borderColor,
                          width: isSelected ? 4.0 : 0.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$optionValue',
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Bottom Action: Next Button (if correct) OR Helper Row (if not yet correct)
          if (isAnsweredCorrectly)
            KidButton(
              label: l10n.btnNext,
              onPressed: widget.onNext,
            )
          else
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
                      widget.selectedAnswer != null && !isAnsweredCorrectly
                          ? l10n.countAgainYouCanDoIt
                          : l10n.whichNumberIsThis,
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Builds the visual representation of [count] coral dots with navy border.
  Widget _buildDotsVisual(int count) {
    final double dotSize;
    final double spacing;
    final int itemsPerRow;

    if (count <= 10) {
      dotSize = 36.0;
      spacing = 10.0;
      itemsPerRow = 5;
    } else if (count <= 30) {
      dotSize = 22.0;
      spacing = 6.0;
      itemsPerRow = 10;
    } else if (count <= 60) {
      dotSize = 16.0;
      spacing = 4.0;
      itemsPerRow = 10;
    } else {
      dotSize = 13.0;
      spacing = 3.0;
      itemsPerRow = 10;
    }

    // Split count into rows
    final numRows = (count / itemsPerRow).ceil();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(numRows, (rIdx) {
          final rowStartIndex = rIdx * itemsPerRow;
          final rowItemCount = math.min(itemsPerRow, count - rowStartIndex);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: spacing / 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(rowItemCount, (_) {
                return Container(
                  width: dotSize,
                  height: dotSize,
                  margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                  decoration: BoxDecoration(
                    color: AppColors.numberCoral,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.navy,
                      width: dotSize > 25 ? 3.0 : 2.0,
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
