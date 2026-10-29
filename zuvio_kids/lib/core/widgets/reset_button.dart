import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';

/// Chunky 3D-styled circular action button placed at the bottom-left corner
/// to reset or clear letter/number tracing.
/// Layer: Core Widgets
class ResetButton extends StatefulWidget {
  const ResetButton({
    super.key,
    required this.onPressed,
    this.size = 68,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final double size;
  final String? tooltip;

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tooltipText = widget.tooltip ?? l10n?.btnClear ?? 'Clear';
    final effectiveEnabled = widget.onPressed != null;

    return Tooltip(
      message: tooltipText,
      child: GestureDetector(
        onTapDown: effectiveEnabled
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapUp: effectiveEnabled
            ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: effectiveEnabled
            ? () => setState(() => _isPressed = false)
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // 3D layered shadow matching KidButton
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF86BCD8).withValues(alpha: 0.8),
                offset: Offset(0, _isPressed ? 2 : 6),
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.refresh_rounded,
              color: AppColors.navy,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
