import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';

/// Interactive dot/step indicator showing progress across the 10 animals in a session.
/// Layer: Presentation Widget
class AnimalStepIndicator extends StatelessWidget {
  const AnimalStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentIndex,
    required this.onStepTapped,
    this.activeColor = AppColors.navy,
  });

  final int totalSteps;
  final int currentIndex;
  final ValueChanged<int> onStepTapped;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentIndex;
        final isPassed = index < currentIndex;

        return GestureDetector(
          onTap: () => onStepTapped(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor
                  : (isPassed
                      ? activeColor.withValues(alpha: 0.45)
                      : AppColors.divider),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }
}
