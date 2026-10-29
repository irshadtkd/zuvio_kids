import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';

/// Progress pill capsules row showing progress across the shapes in the active session.
/// Layer: Presentation Widget
class ShapesStepPills extends StatelessWidget {
  const ShapesStepPills({
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
            width: 38,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
