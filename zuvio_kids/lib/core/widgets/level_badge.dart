import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/level_service.dart';

/// Displays the child's current level as an animated pill badge.
/// Shows the level emoji, level name (localised), and a thin progress bar.
/// Layer: Core Widget
class LevelBadge extends StatelessWidget {
  const LevelBadge({
    super.key,
    required this.stars,
    this.compact = false,
  });

  final int stars;
  /// If true, shows only the emoji without the label.
  final bool compact;

  String _localizedLevelName(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'levelChampion':
        return l10n.levelChampion;
      case 'levelHero':
        return l10n.levelHero;
      case 'levelExplorer':
        return l10n.levelExplorer;
      case 'levelRisingStar':
        return l10n.levelRisingStar;
      default:
        return l10n.levelLittleLearner;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = LevelService.levelAt(stars);
    final progress = LevelService.progressToNextLevel(stars);
    final levelName = _localizedLevelName(context, level.key);

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          level.emoji,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(level.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                levelName,
                style: AppTextStyles.base.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 90,
            height: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.background,
                color: AppColors.starYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
