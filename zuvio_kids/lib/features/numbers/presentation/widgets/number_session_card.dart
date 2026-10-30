import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/numbers/domain/entities/number_session_entity.dart';

/// Card widget for a single number learning session on the Numbers Hub grid.
/// Exactly follows the reference design in Screenshot 1.
/// - Completed: Green card with white Star + Range label
/// - Unlocked: Yellow card with large Session Number + Range label
/// - Locked: Light grey card with Lock icon + Range label
/// Layer: Presentation Widget
class NumberSessionCard extends StatelessWidget {
  const NumberSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final NumberSessionEntity session;
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
          border: Border.all(
            color: Colors.white.withValues(alpha: isLocked ? 0.4 : 0.7),
            width: 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isLocked ? 0.02 : 0.07),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Graphic
            if (isCompleted)
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              )
            else if (!isLocked)
              Text(
                '${session.sessionNumber}',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
              )
            else
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.navy,
                size: 34,
              ),

            const SizedBox(height: 6),

            // Bottom Range Label (e.g. "1-10", "11-20")
            Text(
              session.rangeLabel,
              style: AppTextStyles.base.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
