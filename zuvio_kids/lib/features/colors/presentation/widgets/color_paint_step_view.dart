import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/core/widgets/reset_button.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_item_entity.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'color_objects.dart';
import 'color_palette_bar.dart';
import 'rainbow_visual.dart';

/// Step 2 — Paint Coloring Activity View.
/// Follows the attached reference screenshot exactly:
/// - Rainbow illustration at top of white card
/// - Prompt: "Paint the [object] [color]!"
/// - Paintable object in center
/// - Palette of 5 color swatches below card
/// - Reset/Clear button at bottom-left corner
/// - Panda avatar + Speech bubble helper
/// - Green tick (✓) on correct, red cross (✗) on wrong
/// - Green Next button enabled only after successful painting
/// Layer: Presentation Widget
class ColorPaintStepView extends StatelessWidget {
  const ColorPaintStepView({
    super.key,
    required this.colorItem,
    required this.selectedPaletteColorValue,
    required this.appliedColorValue,
    required this.isPaintCorrect,
    required this.onPaletteColorSelected,
    required this.onPaintObject,
    required this.onResetPaint,
    required this.onNext,
    this.friendAvatar = AppStrings.defaultFriend,
  });

  final ColorItemEntity colorItem;
  final int? selectedPaletteColorValue;
  final int? appliedColorValue;
  final bool? isPaintCorrect;
  final ValueChanged<int> onPaletteColorSelected;
  final VoidCallback onPaintObject;
  final VoidCallback onResetPaint;
  final VoidCallback onNext;
  final String friendAvatar;

  String _getLocalizedObjectName(AppLocalizations l10n, String name) {
    switch (name) {
      case 'apple':
        return l10n.objectApple;
      case 'banana':
        return l10n.objectBanana;
      case 'leaf':
        return l10n.objectLeaf;
      case 'balloon':
        return l10n.objectBalloon;
      case 'carrot':
        return l10n.objectCarrot;
      case 'grapes':
        return l10n.objectGrapes;
      case 'flower':
      default:
        return l10n.objectFlower;
    }
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
    final objectLabel = _getLocalizedObjectName(l10n, colorItem.objectName);
    final colorLabel = _getLocalizedColorName(l10n, colorItem.id).toLowerCase();
    final isSuccess = isPaintCorrect == true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Main White Card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rainbow Illustration at Top
                      const RainbowVisual(
                        height: 90,
                      ),

                      // Instruction: "Paint the apple red!"
                      Text(
                        l10n.paintTheObject(objectLabel, colorLabel),
                        style: AppTextStyles.speechBubbleTitle.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navy,
                        ),
                      ),

                      // Interactive Paintable Object (e.g. Apple)
                      Expanded(
                        child: Center(
                          child: PaintableObjectWidget(
                            objectName: colorItem.objectName,
                            appliedColorValue: appliedColorValue,
                            onTap: onPaintObject,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Success Overlay: Green Tick (✓)
                  if (isSuccess)
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.kidGreen,
                                width: 4.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.kidGreen.withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.kidGreen,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),

                  // Failure Overlay: Red Cross (✗)
                  if (isPaintCorrect == false)
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFF4B4B),
                                width: 4.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF4B4B)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFFFF4B4B),
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Palette Swatches Row
          ColorPaletteBar(
            paletteOptions: colorItem.paletteOptions,
            selectedColorValue: selectedPaletteColorValue,
            onColorSelected: onPaletteColorSelected,
          ),

          const SizedBox(height: 16),

          // Bottom Action Row:
          // If Success -> Reset Button at bottom-left + Next Button
          // Else -> Reset Button at bottom-left + Panda speech bubble
          Row(
            children: [
              ResetButton(
                tooltip: l10n.btnClear,
                onPressed: onResetPaint,
              ),
              const SizedBox(width: 12),
              if (isSuccess)
                Expanded(
                  child: KidButton(
                    label: l10n.btnNext,
                    onPressed: onNext,
                  ),
                )
              else
                Expanded(
                  child: Row(
                    children: [
                      AnimalAvatar(
                        avatarType: friendAvatar,
                        size: 54,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
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
                            l10n.tapColorThenObject(objectLabel),
                            style: AppTextStyles.base.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ],
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
