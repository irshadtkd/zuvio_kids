import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Interactive step tabs row for [1 Discover, 2 Practice, 3 Play].
/// Layer: Presentation Widget
class AlphabetStepPills extends StatelessWidget {
  const AlphabetStepPills({
    super.key,
    required this.currentStep,
    required this.onStepSelected,
  });

  final int currentStep;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final steps = [
      (0, l10n.stepDiscover),
      (1, l10n.stepPractice),
      (2, l10n.stepPlay),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: steps.map((step) {
          final isSelected = currentStep == step.$1;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onStepSelected(step.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cardYellow : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0xFFD69E1F).withValues(alpha: 0.6)
                            : Colors.black.withValues(alpha: 0.04),
                        offset: Offset(0, isSelected ? 3 : 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step.$2,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
