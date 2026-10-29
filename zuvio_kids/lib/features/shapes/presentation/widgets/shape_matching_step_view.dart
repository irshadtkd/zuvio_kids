import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'package:zuvio_kids/features/shapes/data/datasources/shape_data.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_entity.dart';
import 'shape_visual.dart';

/// Step 3 — Shape Matching View.
/// - Target shape outline silhouette card with title "Find the [shape]!"
/// - Shuffled shape options with animated selection
/// - Green border + checkmark on correct
/// - Red border + cross on incorrect, allowing another attempt
/// - Next button appears only upon correct answer
/// Layer: Presentation Widget
class ShapeMatchingStepView extends StatefulWidget {
  const ShapeMatchingStepView({
    super.key,
    required this.shape,
    required this.selectedOption,
    required this.isCorrect,
    required this.onOptionSelected,
    required this.onNext,
    this.friendAvatar = AppStrings.defaultFriend,
  });

  final ShapeEntity shape;
  final String? selectedOption;
  final bool? isCorrect;
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onNext;
  final String friendAvatar;

  @override
  State<ShapeMatchingStepView> createState() => ShapeMatchingStepViewState();
}

class ShapeMatchingStepViewState extends State<ShapeMatchingStepView> {
  late List<String> _shuffledOptionIds;

  @override
  void initState() {
    super.initState();
    _initShuffledOptions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _speakPrompt();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ShapeMatchingStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shape.id != widget.shape.id) {
      _initShuffledOptions();
      _speakPrompt();
    }
  }

  void _initShuffledOptions() {
    _shuffledOptionIds = List<String>.from(widget.shape.quizOptionIds)..shuffle();
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

  void _speakPrompt() {
    KidSoundService.instance.speak('Find the ${widget.shape.englishName}!');
  }

  void _handleOptionTap(String optionId) {
    widget.onOptionSelected(optionId);
    final isRight = optionId == widget.shape.id;

    if (isRight) {
      KidSoundService.instance
          .speak('Super! That is the ${widget.shape.englishName}!');
    } else {
      KidSoundService.instance.speak('Oops, try again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shapeName = _getLocalizedShapeName(l10n, widget.shape.nameKey);
    final isSuccess = widget.isCorrect == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Top Card: Target Shape Outline or Filled on Success
          Expanded(
            flex: 6,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Target Shape silhouette or filled
                      ShapeVisualWidget(
                        shapeId: widget.shape.id,
                        color: isSuccess
                            ? Color(widget.shape.colorValue)
                            : const Color(0xFF64748B),
                        mode: isSuccess
                            ? ShapeVisualMode.filled
                            : ShapeVisualMode.silhouette,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        isSuccess
                            ? l10n.shapesMatchCorrect(shapeName)
                            : l10n.shapesMatchInstruction(shapeName),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headerTitle.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isSuccess ? AppColors.kidGreen : AppColors.navy,
                        ),
                      ),
                    ],
                  ),

                  // Green Checkmark Badge overlay when answered correctly
                  if (isSuccess)
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.kidGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Options Row: 3 shape cards
          Expanded(
            flex: 4,
            child: Row(
              children: _shuffledOptionIds.map((optId) {
                final optionShape = ShapeData.getShapeById(optId);
                final isSelected = widget.selectedOption == optId;
                final isRight = optId == widget.shape.id;

                Border border = Border.all(color: Colors.transparent, width: 3.5);
                Color cardBg = Colors.white;

                if (isSelected) {
                  if (widget.isCorrect == true && isRight) {
                    border = Border.all(color: AppColors.kidGreen, width: 4.0);
                    cardBg = AppColors.kidGreen.withValues(alpha: 0.08);
                  } else if (widget.isCorrect == false) {
                    border = Border.all(color: const Color(0xFFFF4B4B), width: 4.0);
                    cardBg = const Color(0xFFFF4B4B).withValues(alpha: 0.08);
                  }
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () => _handleOptionTap(optId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(24),
                          border: border,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: ShapeVisualWidget(
                                shapeId: optId,
                                size: 76,
                                color: Color(optionShape.colorValue),
                              ),
                            ),

                            // Mini Status Indicator Badge
                            if (isSelected && widget.isCorrect == true && isRight)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: AppColors.kidGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              )
                            else if (isSelected && widget.isCorrect == false)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF4B4B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Bottom Action Row: Helper bubble or Next Button
          if (isSuccess)
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
                      l10n.shapesMatchInstruction(shapeName),
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
}
