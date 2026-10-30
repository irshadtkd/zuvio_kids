import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/core/widgets/kid_confetti_overlay.dart';
import 'package:zuvio_kids/features/achievements/presentation/providers/achievements_provider.dart';
import 'package:zuvio_kids/features/numbers/presentation/providers/numbers_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';

/// Congratulations screen displayed when a Numbers session (10 numbers) is completed.
/// Awards 10 stars, plays celebration voice, and provides Next Level and Play Again actions.
/// Layer: Presentation Screen
class NumbersCongratulationsScreen extends ConsumerStatefulWidget {
  const NumbersCongratulationsScreen({super.key});

  @override
  ConsumerState<NumbersCongratulationsScreen> createState() =>
      _NumbersCongratulationsScreenState();
}

class _NumbersCongratulationsScreenState
    extends ConsumerState<NumbersCongratulationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkleController;
  final _confettiKey = GlobalKey<KidConfettiOverlayState>();
  bool _hasPlayedCelebrationAudio = false;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    // Play character and clapping sounds simultaneously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasPlayedCelebrationAudio) return;
      _hasPlayedCelebrationAudio = true;
      _confettiKey.currentState?.burst();
      final onboardingState = ref.read(onboardingNotifierProvider).valueOrNull;
      final friend = onboardingState?.friendAvatar.isNotEmpty == true
          ? onboardingState!.friendAvatar
          : AppStrings.defaultFriend;
      KidSoundService.instance.playCelebrationSounds(friend);
      ref.read(achievementsNotifierProvider.notifier).unlock('number_ninja');
    });
  }

  @override
  void dispose() {
    KidSoundService.instance.stop();
    _sparkleController.dispose();
    super.dispose();
  }

  void _onNextLevel(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(numbersNotifierProvider.notifier);
    final state = ref.read(numbersNotifierProvider).valueOrNull;

    // Find the next incomplete, unlocked session
    final sessions = state?.sessions ?? [];
    final nextSessionList =
        sessions.where((s) => !s.isCompleted && !s.isLocked).toList();

    if (nextSessionList.isNotEmpty) {
      final nextSession = nextSessionList.first;
      notifier.selectSession(nextSession.id);
      Navigator.pushReplacementNamed(context, AppRoutes.numbersLearning);
    } else {
      // All done! Return to hub
      notifier.exitToHub();
      Navigator.pushReplacementNamed(context, AppRoutes.numbersHub);
    }
  }

  void _onPlayAgain(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(numbersNotifierProvider.notifier);
    notifier.playAgain();
    Navigator.pushReplacementNamed(context, AppRoutes.numbersLearning);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final numbersState = ref.watch(numbersNotifierProvider).valueOrNull;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;

    final childName = numbersState?.studentName.isNotEmpty == true
        ? numbersState!.studentName
        : AppStrings.defaultChildName;

    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final activeSession = numbersState?.activeSession;
    final sessionRange = activeSession?.rangeLabel ?? '1-10';

    return Scaffold(
      backgroundColor: context.themePalette.scaffoldBackground,
      body: Stack(
        children: [
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ── Header Title ("Great job, Mia!") ──────────────────────────
              Text(
                l10n.congratsTitle(childName),
                textAlign: TextAlign.center,
                style: AppTextStyles.splashTitle.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
              ),

              // ── 3 Big Stars Row ───────────────────────────────────────────
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _sparkleController,
                  curve: Curves.elasticOut,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _BigStar(size: 72, rotation: -0.15),
                    SizedBox(width: 8),
                    _BigStar(size: 96, rotation: 0.0),
                    SizedBox(width: 8),
                    _BigStar(size: 72, rotation: 0.15),
                  ],
                ),
              ),

              // ── Big Cartoon Friend Avatar ─────────────────────────────────
              AnimalAvatar(
                avatarType: friendAvatar,
                size: 140,
              ),

              // ── Stars Earned Pill Badge & Level Status ─────────────────────
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.starYellow,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.numbersStarsEarned,
                          style: AppTextStyles.base.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle ("You completed session 1-10!")
                  Text(
                    l10n.numbersCongratsSubtitle(sessionRange),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),

              // ── Bottom Action Buttons ─────────────────────────────────────
              Column(
                children: [
                  // Green Next Level Button
                  KidButton(
                    label: l10n.btnNextLevel,
                    onPressed: () => _onNextLevel(context, ref),
                  ),
                  const SizedBox(height: 14),

                  // Yellow Play Again Button
                  KidButton(
                    label: l10n.btnPlayAgain,
                    showArrow: false,
                    backgroundColor: context.themePalette.highlight,
                    onPressed: () => _onPlayAgain(context, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      KidConfettiOverlay(key: _confettiKey),
    ],
  ),
);
  }
}

/// Large golden star with dark outline.
class _BigStar extends StatelessWidget {
  const _BigStar({required this.size, required this.rotation});

  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.star_rounded,
            size: size + 6,
            color: AppColors.navy,
          ),
          Icon(
            Icons.star_rounded,
            size: size,
            color: const Color(0xFFFFD13B),
          ),
        ],
      ),
    );
  }
}
