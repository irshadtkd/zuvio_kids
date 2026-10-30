import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_session_entity.dart';

/// Card representing one of the 4 learning sessions in the Alphabet Hub.
/// Layer: Presentation Widget
class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final AlphabetSessionEntity session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionColors = context.themePalette.sessionColors;
    final color = sessionColors[(session.sessionNumber - 1) % sessionColors.length];

    String title;
    String subtitle;
    switch (session.sessionNumber) {
      case 1:
        title = l10n.session1Title;
        subtitle = l10n.session1Subtitle;
        break;
      case 2:
        title = l10n.session2Title;
        subtitle = l10n.session2Subtitle;
        break;
      case 3:
        title = l10n.session3Title;
        subtitle = l10n.session3Subtitle;
        break;
      case 4:
      default:
        title = l10n.session4Title;
        subtitle = l10n.session4Subtitle;
        break;
    }

    final isLocked = session.isLocked;
    final isCompleted = session.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.white.withValues(alpha: 0.76) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isLocked ? AppColors.cardLocked : Colors.white,
          width: 2.5,
        ),
        boxShadow: [
          // 3D tactile block bevel
          BoxShadow(
            color: isLocked
                ? Colors.black.withValues(alpha: 0.04)
                : color.withValues(alpha: 0.38),
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isLocked ? 0.02 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLocked ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Colorful Session Number Badge with gradient
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: isLocked
                        ? null
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color,
                              color.withValues(alpha: 0.76),
                            ],
                          ),
                    color: isLocked ? AppColors.cardLocked : null,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      if (!isLocked)
                        BoxShadow(
                          color: color.withValues(alpha: 0.28),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      session.letterRange,
                      style: AppTextStyles.base.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isLocked ? AppColors.textSecondary : AppColors.navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.base.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isLocked
                              ? AppColors.textSecondary
                              : AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.base.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge or Lock
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kidGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.starYellow,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+10',
                          style: AppTextStyles.base.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.kidGreen,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isLocked)
                  const Icon(
                    Icons.lock_rounded,
                    color: AppColors.textHint,
                    size: 26,
                  )
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.kidGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kidGreenShadow.withValues(alpha: 0.6),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
