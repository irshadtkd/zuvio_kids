import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import '../../domain/entities/puzzle_session_entity.dart';

/// Horizontal session selector displaying all 4 puzzle sessions.
/// Allows direct tapping to jump between puzzles and shows completion checkmarks.
/// Layer: Presentation Widget
class PuzzleSessionPills extends StatelessWidget {
  const PuzzleSessionPills({
    super.key,
    required this.sessions,
    required this.currentIndex,
    required this.onSelectSession,
  });

  final List<PuzzleSessionEntity> sessions;
  final int currentIndex;
  final ValueChanged<int> onSelectSession;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sessions.length, (index) {
        final session = sessions[index];
        final isSelected = index == currentIndex;
        final isCompleted = session.isCompleted;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            onTap: () => onSelectSession(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 14.0 : 10.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isCompleted
                        ? const Color(0xFFD1FAE5) // Soft green
                        : Colors.white.withValues(alpha: 0.8)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isCompleted
                          ? AppColors.kidGreen
                          : AppColors.navy.withValues(alpha: 0.15)),
                  width: isSelected ? 2.0 : 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted && !isSelected)
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.kidGreen,
                      ),
                    ),
                  Text(
                    l10n.labelPuzzleSession((index + 1).toString()),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isCompleted
                              ? const Color(0xFF065F46)
                              : AppColors.navy),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
