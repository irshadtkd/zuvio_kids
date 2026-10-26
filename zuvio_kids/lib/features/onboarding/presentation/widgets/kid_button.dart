import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Chunky 3D-styled pill action button for kids ("Start ➔", "Next ➔", "Done! ➔").
class KidButton extends StatefulWidget {
  const KidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.backgroundColor = AppColors.kidGreen,
    this.height = 68,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final Color backgroundColor;
  final double height;
  final bool enabled;

  @override
  State<KidButton> createState() => _KidButtonState();
}

class _KidButtonState extends State<KidButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = widget.enabled && widget.onPressed != null;

    return GestureDetector(
      onTapDown: effectiveEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: effectiveEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: effectiveEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          // 3D layered shadow
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF86BCD8).withValues(alpha: 0.8),
              offset: Offset(0, _isPressed ? 2 : 6),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveEnabled
                ? widget.backgroundColor
                : widget.backgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.navy,
                ),
              ),
              if (widget.showArrow) ...[
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.navy,
                  size: 28,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
