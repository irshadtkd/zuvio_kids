import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/providers/mascot_provider.dart';
import 'package:zuvio_kids/core/utils/feedback_voice_bank.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/mascot_speech_bubble.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';

/// Floating companion mascot widget that reacts to child interactions.
/// Stays in a corner of the screen, animates continuously, and speaks encouragements.
/// Layer: Core Widget
class FloatingMascot extends ConsumerStatefulWidget {
  const FloatingMascot({
    super.key,
    this.size = 72,
    this.showSpeechBubble = true,
  });

  final double size;
  final bool showSpeechBubble;

  @override
  ConsumerState<FloatingMascot> createState() => _FloatingMascotState();
}

class _FloatingMascotState extends ConsumerState<FloatingMascot>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _jumpController;
  late final Animation<double> _idleBob;
  late final Animation<double> _jumpTranslation;
  late final Animation<double> _jumpRotation;

  @override
  void initState() {
    super.initState();
    // Continuous subtle breathing / bobbing
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _idleBob = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    // Tap jump reaction
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _jumpTranslation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -20).chain(
          CurveTween(curve: Curves.easeOutQuad),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -20, end: 0).chain(
          CurveTween(curve: Curves.bounceOut),
        ),
        weight: 50,
      ),
    ]).animate(_jumpController);

    _jumpRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -0.1).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.1, end: 0.1).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 25,
      ),
    ]).animate(_jumpController);
  }

  @override
  void dispose() {
    _idleController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _jumpController.forward(from: 0.0);
    final voiceLine = FeedbackVoiceBank.randomCorrect();
    KidSoundService.instance.speak(voiceLine);
    ref.read(mascotNotifierProvider.notifier).speak(voiceLine);

    // Reset speech after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        ref.read(mascotNotifierProvider.notifier).idle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mascotState = ref.watch(mascotNotifierProvider);
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final avatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final hasMessage = widget.showSpeechBubble &&
        mascotState.speechMessage != null &&
        mascotState.speechMessage!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasMessage) ...[
          MascotSpeechBubble(
            message: mascotState.speechMessage!,
            onTap: () => ref.read(mascotNotifierProvider.notifier).idle(),
          ),
          const SizedBox(height: 6),
        ],
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_idleController, _jumpController]),
            builder: (context, child) {
              final dy = _idleBob.value + _jumpTranslation.value;
              final rot = _jumpRotation.value;
              return Transform.translate(
                offset: Offset(0, dy),
                child: Transform.rotate(
                  angle: rot * math.pi,
                  child: child,
                ),
              );
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: AnimalAvatar(
                  avatarType: avatar,
                  size: widget.size * 0.78,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
