import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_session_entity.dart';

/// Card widget for a single Shapes learning session on the Hub grid.
/// - Completed: Green card with white Star + Title
/// - Unlocked: Yellow card with large Session Number + Title
/// - Locked: Light grey card with Lock icon + Title
/// Layer: Presentation Widget
class ShapeSessionCard extends StatelessWidget {
  const ShapeSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final ShapeSessionEntity session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCompleted = session.isCompleted;
    final isLocked = session.isLocked;
    final palette = context.themePalette;

    final Color bgColor;
    final Color shadowColor;
    if (isCompleted) {
      bgColor = palette.actionButton;
      shadowColor = palette.actionButtonShadow.withValues(alpha: 0.35);
    } else if (!isLocked) {
      bgColor = palette.highlight;
      shadowColor = palette.highlightShadow.withValues(alpha: 0.35);
    } else {
      bgColor = AppColors.cardLocked;
      shadowColor = Colors.black.withValues(alpha: 0.04);
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Graphic
            if (isCompleted)
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.starYellow,
                  size: 38,
                ),
              )
            else if (!isLocked)
              Text(
                '${session.sessionNumber}',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
              )
            else
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.divider.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: AppColors.textSecondary,
                  size: 26,
                ),
              ),

            const SizedBox(height: 8),

            // Session Shapes Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                session.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.base.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isCompleted
                      ? Colors.white
                      : (isLocked ? AppColors.textSecondary : AppColors.navy),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
