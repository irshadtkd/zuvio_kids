import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import '../../domain/entities/animal_session_entity.dart';

/// Card widget representing an Animal Learning Session on the Hub screen.
/// Layer: Presentation Widget
class AnimalSessionCard extends StatelessWidget {
  const AnimalSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final AnimalSessionEntity session;
  final VoidCallback onTap;

  String _getTitle(AppLocalizations l10n) {
    if (session.sessionNumber == 1) {
      return l10n.animalsSession1Title;
    }
    return l10n.animalsSession2Title;
  }

  String _getSubtitle(AppLocalizations l10n) {
    if (session.sessionNumber == 1) {
      return l10n.animalsSession1Subtitle;
    }
    return l10n.animalsSession2Subtitle;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.themePalette;
    final isLocked = session.isLocked;
    final isCompleted = session.isCompleted;

    // First two animal previews for illustration
    final preview1 = session.animals.isNotEmpty ? session.animals[0] : null;
    final preview2 = session.animals.length > 1 ? session.animals[1] : null;

    final badgeColor = session.sessionNumber == 1
        ? palette.cardAnimals
        : palette.cardShapes;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isLocked ? Colors.white.withValues(alpha: 0.76) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isLocked
              ? AppColors.cardLocked
              : Colors.white,
          width: 2.5,
        ),
        boxShadow: [
          // 3D tactile block bevel
          BoxShadow(
            color: isLocked
                ? Colors.black.withValues(alpha: 0.04)
                : badgeColor.withValues(alpha: 0.4),
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isLocked ? 0.02 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 7),
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
                // ── Preview Container with Avatar / SVG Icons ─────────────────
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    gradient: isLocked
                        ? null
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              badgeColor,
                              badgeColor.withValues(alpha: 0.75),
                            ],
                          ),
                    color: isLocked ? AppColors.cardLocked : null,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      if (!isLocked)
                        BoxShadow(
                          color: badgeColor.withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isLocked)
                        const Icon(
                          Icons.lock_rounded,
                          color: AppColors.textSecondary,
                          size: 32,
                        )
                      else ...[
                        if (preview1 != null)
                          Positioned(
                            left: 4,
                            bottom: 6,
                            child: SvgPicture.asset(
                              preview1.svgAsset,
                              width: 44,
                              height: 44,
                            ),
                          ),
                        if (preview2 != null)
                          Positioned(
                            right: 4,
                            top: 6,
                            child: SvgPicture.asset(
                              preview2.svgAsset,
                              width: 40,
                              height: 40,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // ── Title + Subtitle ──────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(l10n),
                        style: AppTextStyles.base.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isLocked
                              ? AppColors.textSecondary
                              : AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _getSubtitle(l10n),
                        style: AppTextStyles.base.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Trailing Status Badge ─────────────────────────────────────
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kidGreen.withValues(alpha: 0.14),
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
                          '+${session.starsEarned > 0 ? session.starsEarned : 5}',
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
                  const SizedBox.shrink()
                else
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: palette.actionButton,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: palette.actionButtonShadow
                              .withValues(alpha: 0.5),
                          offset: const Offset(0, 3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
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
