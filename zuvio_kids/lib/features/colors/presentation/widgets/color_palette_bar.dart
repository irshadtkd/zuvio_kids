import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';

/// Palette row of circular color swatches matching the reference screenshot.
/// Layer: Presentation Widget
class ColorPaletteBar extends StatelessWidget {
  const ColorPaletteBar({
    super.key,
    required this.paletteOptions,
    required this.selectedColorValue,
    required this.onColorSelected,
  });

  final List<int> paletteOptions;
  final int? selectedColorValue;
  final ValueChanged<int> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: paletteOptions.map((colorValue) {
        final isSelected = selectedColorValue == colorValue;

        return GestureDetector(
          onTap: () => onColorSelected(colorValue),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: isSelected ? 60 : 54,
            height: isSelected ? 60 : 54,
            decoration: BoxDecoration(
              color: Color(colorValue),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.navy : Colors.white,
                width: isSelected ? 4.0 : 3.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isSelected ? 0.2 : 0.08),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
