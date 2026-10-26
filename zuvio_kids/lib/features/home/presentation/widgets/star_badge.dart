import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Top bar star badge displaying child's star reward points.
class StarBadge extends StatelessWidget {
  const StarBadge({
    super.key,
    required this.stars,
    this.onTap,
  });

  final int stars;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star_rounded,
              color: AppColors.starYellow,
              size: 26,
            ),
            const SizedBox(width: 6),
            Text(
              stars.toString(),
              style: AppTextStyles.starBadgeText,
            ),
          ],
        ),
      ),
    );
  }
}
