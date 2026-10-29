import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';

/// Top bar with back button, step title, and mute toggle button.
/// Matches Screenshots 2, 3, and 4.
/// Layer: Presentation Widget
class NumbersTopBar extends StatelessWidget {
  const NumbersTopBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.isMuted,
    required this.onToggleMute,
  });

  final String title;
  final VoidCallback onBack;
  final bool isMuted;
  final VoidCallback onToggleMute;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.themePalette;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular White Back Button
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
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
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

          // Title: "Meet the number" / "Trace the number" / "Find the number"
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headerTitle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.navy,
              ),
            ),
          ),

          // Circular Speaker / Mute Button
          GestureDetector(
            onTap: onToggleMute,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: palette.highlight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: palette.highlightShadow.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: AppColors.navy,
                size: 26,
                semanticLabel: isMuted ? l10n.btnUnmute : l10n.btnMute,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
