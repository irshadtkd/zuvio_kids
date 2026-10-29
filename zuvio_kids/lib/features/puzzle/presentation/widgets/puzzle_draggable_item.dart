import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import '../../domain/entities/puzzle_item_entity.dart';
import 'puzzle_item_visual.dart';

/// Draggable and tappable picture item in the "Pictures" row.
/// Supports drag-and-drop as well as tap-to-match interaction.
/// Layer: Presentation Widget
class PuzzleDraggableItem extends StatelessWidget {
  const PuzzleDraggableItem({
    super.key,
    required this.item,
    required this.isMatched,
    required this.isSelected,
    required this.onTap,
    this.size = 72.0,
  });

  final PuzzleItemEntity item;
  final bool isMatched;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (isMatched) {
      // Once matched, show subtle ghost placeholder to keep row alignment
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.04),
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.kidGreen.withValues(alpha: 0.4),
              size: 24,
            ),
          ),
        ),
      );
    }

    final visualWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFEFF6FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 3.0)
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: PuzzleItemVisual(
          item: item,
          size: size * 0.70,
        ),
      ),
    );

    return Draggable<String>(
      data: item.id,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.15,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: PuzzleItemVisual(
              item: item,
              size: size * 0.70,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: visualWidget,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: visualWidget,
      ),
    );
  }
}
