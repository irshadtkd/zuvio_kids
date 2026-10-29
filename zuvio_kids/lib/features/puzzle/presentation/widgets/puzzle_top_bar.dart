import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';

/// Top bar matching the sample screen layout:
/// - Circular white back button
/// - Bold two-line "Puzzle\nPlayground" title
/// - Circular yellow sound/speaker button
/// Layer: Presentation Widget
class PuzzleTopBar extends StatelessWidget {
  const PuzzleTopBar({
    super.key,
    required this.onBack,
    required this.instructionToSpeak,
  });

  final VoidCallback onBack;
  final String instructionToSpeak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular white back button
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
                    offset: const Offset(0, 4),
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

          // Title: "Puzzle\nPlayground"
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                l10n.titlePuzzlePlayground,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                  height: 1.15,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),

          // Circular yellow sound button
          GestureDetector(
            onTap: () {
              KidSoundService.instance.speak(instructionToSpeak);
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFBF00), // Rich sun yellow
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFBF00).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: AppColors.navy,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
