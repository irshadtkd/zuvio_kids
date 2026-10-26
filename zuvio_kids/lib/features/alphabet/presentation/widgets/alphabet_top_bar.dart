import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Top bar with circular back button, title, and yellow speaker replay button.
/// Layer: Presentation Widget
class AlphabetTopBar extends StatelessWidget {
  const AlphabetTopBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onSpeakerTap,
    this.isMuted = false,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onSpeakerTap;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular White Back Button
          Semantics(
            button: true,
            label: l10n.btnBack,
            child: GestureDetector(
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
                      blurRadius: 8,
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
          ),

          // Title
          Text(
            title,
            style: AppTextStyles.headerTitle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.navy,
            ),
          ),

          // Circular Speaker / Mute Toggle Button
          Semantics(
            button: true,
            label: isMuted ? l10n.btnUnmute : l10n.btnMute,
            child: GestureDetector(
              onTap: onSpeakerTap,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isMuted ? AppColors.divider : AppColors.cardYellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isMuted
                          ? Colors.black.withValues(alpha: 0.04)
                          : const Color(0xFFD69E1F).withValues(alpha: 0.8),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: isMuted ? AppColors.textSecondary : AppColors.navy,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
