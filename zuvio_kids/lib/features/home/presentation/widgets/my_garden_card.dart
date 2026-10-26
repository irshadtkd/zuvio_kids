import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Bottom reward banner displaying "My Garden" progress and lock button.
class MyGardenCard extends StatelessWidget {
  const MyGardenCard({
    super.key,
    required this.title,
    this.progress = 0.38,
    this.onLockTapped,
  });

  final String title;
  final double progress;
  final VoidCallback? onLockTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side: Title + Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.gardenTitle,
                ),
                const SizedBox(height: 8),
                // Green Progress Bar
                Container(
                  height: 9,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.gardenTrackGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kidGreen,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          // Right side: Lock Icon in circular navy border
          GestureDetector(
            onTap: onLockTapped,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.navy, width: 2.5),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.navy,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
