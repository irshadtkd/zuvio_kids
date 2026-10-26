import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Kid-friendly on-screen alphabet keyboard matching Screenshot 3.
class KidKeyboard extends StatelessWidget {
  const KidKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
  });

  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;

  static const List<String> _row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> _row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  static const List<String> _row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  Widget _buildKey(String char) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onKeyPressed(char),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                char,
                style: AppTextStyles.keyboardKey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackspace,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.backspace_outlined,
              size: 20,
              color: AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: _row1.map(_buildKey).toList(),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: _row2.map(_buildKey).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              ..._row3.map(_buildKey),
              _buildBackspaceKey(),
            ],
          ),
        ),
      ],
    );
  }
}
