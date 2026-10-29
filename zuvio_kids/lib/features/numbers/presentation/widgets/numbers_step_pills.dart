import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';

/// Progress pill capsules row showing progress across the numbers in the active session.
/// Matches Screenshots 2, 3, and 4.
/// Layer: Presentation Widget
class NumbersStepPills extends StatelessWidget {
  const NumbersStepPills({
    super.key,
    required this.totalItems,
    required this.currentIndex,
  });

  final int totalItems;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final palette = context.themePalette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalItems, (index) {
          final isCompletedOrCurrent = index <= currentIndex;

          return Container(
            width: 28,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isCompletedOrCurrent ? palette.actionButton : Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
