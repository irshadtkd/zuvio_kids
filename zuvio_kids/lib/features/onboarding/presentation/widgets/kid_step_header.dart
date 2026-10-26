import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Top bar with circular back button, title, and 3-step pill indicators.
class KidStepHeader extends StatelessWidget {
  const KidStepHeader({
    super.key,
    required this.title,
    required this.currentStep,
    this.totalSteps = 3,
    required this.onBack,
  });

  final String title;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Circular white back button
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.navy,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.headerTitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 3-step progress pills
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            final isCompleted = index <= currentStep;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 26,
              height: 10,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.kidGreen : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        ),
      ],
    );
  }
}
