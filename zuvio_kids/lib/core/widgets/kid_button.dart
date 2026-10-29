import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';

/// Chunky 3D-styled pill action button for kids ("Start ➔", "Next ➔", "Done! ➔").
/// Layer: Core Widgets
class KidButton extends StatefulWidget {
  const KidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.backgroundColor,
    this.textColor,
    this.shadowColor,
    this.height = 68,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? shadowColor;
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
    final palette = context.themePalette;
    final effectiveBg = widget.backgroundColor ?? palette.actionButton;
    final effectiveShadow = widget.shadowColor ??
        (widget.backgroundColor != null
            ? Color.alphaBlend(
                Colors.black.withValues(alpha: 0.28),
                widget.backgroundColor!,
              )
            : palette.actionButtonShadow);
    final effectiveTextColor = widget.textColor ??
        (ThemeData.estimateBrightnessForColor(effectiveBg) == Brightness.dark
            ? Colors.white
            : AppColors.navy);

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
              color: effectiveShadow.withValues(alpha: 0.8),
              offset: Offset(0, _isPressed ? 2 : 6),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveEnabled
                ? effectiveBg
                : effectiveBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: effectiveTextColor,
                ),
              ),
              if (widget.showArrow) ...[
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: effectiveTextColor,
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
