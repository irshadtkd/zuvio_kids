import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';

/// Animated flame streak counter badge for the home screen.
///
/// Shows a flame emoji and the streak count with a pulsing glow when
/// the streak is 3 or more days.
/// Layer: Core Widget
class StreakBadge extends StatefulWidget {
  const StreakBadge({super.key, required this.streak});

  final int streak;

  @override
  State<StreakBadge> createState() => _StreakBadgeState();
}

class _StreakBadgeState extends State<StreakBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.streak >= 3) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant StreakBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streak >= 3 && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (widget.streak < 3 && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _flameEmoji {
    if (widget.streak >= 7) return '🔥🔥🔥';
    if (widget.streak >= 3) return '🔥🔥';
    return '🔥';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.streak < 1) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.streak >= 3 ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.streak >= 3
                  ? const Color(0xFFFF6B35).withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: widget.streak >= 3 ? 14 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_flameEmoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '${widget.streak}',
              style: AppTextStyles.base.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
