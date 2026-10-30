import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/features/achievements/domain/entities/badge_entity.dart';

/// A single achievement badge card for the Trophy Room.
/// Shows the emoji, name, and a lock overlay when not yet earned.
/// Layer: Presentation Widget
class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key, required this.badge});

  final BadgeEntity badge;

  String _localizedName(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'achievementAnimalExplorer':
        return l10n.achievementAnimalExplorer;
      case 'achievementAnimalMaster':
        return l10n.achievementAnimalMaster;
      case 'achievementAlphabetStar':
        return l10n.achievementAlphabetStar;
      case 'achievementNumberNinja':
        return l10n.achievementNumberNinja;
      case 'achievementColorArtist':
        return l10n.achievementColorArtist;
      case 'achievementShapeFinder':
        return l10n.achievementShapeFinder;
      case 'achievementPuzzleChampion':
        return l10n.achievementPuzzleChampion;
      case 'achievementOnFire':
        return l10n.achievementOnFire;
      case 'achievementStarCollector':
        return l10n.achievementStarCollector;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _localizedName(context, badge.nameKey);
    final l10n = AppLocalizations.of(context)!;

    return AnimatedOpacity(
      opacity: badge.isUnlocked ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: badge.isUnlocked ? Colors.white : AppColors.cardLocked,
          borderRadius: BorderRadius.circular(22),
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.starYellow.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 42,
                    color: badge.isUnlocked ? null : Colors.grey.shade400,
                  ),
                ),
                if (!badge.isUnlocked)
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              badge.isUnlocked ? name : l10n.badgeLockedHint,
              style: AppTextStyles.base.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: badge.isUnlocked ? AppColors.navy : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
