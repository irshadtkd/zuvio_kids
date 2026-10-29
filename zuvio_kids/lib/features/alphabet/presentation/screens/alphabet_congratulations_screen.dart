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
import 'package:zuvio_kids/features/alphabet/presentation/providers/alphabet_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';

/// Congratulations screen displayed when a session is completed.
/// Matches Image 4 with "Great job, [Name]!", 3 big stars, Panda friend avatar,
/// "+10 Stars Earned!", and Next Level / Play Again actions.
/// Layer: Presentation Screen
class AlphabetCongratulationsScreen extends ConsumerStatefulWidget {
  const AlphabetCongratulationsScreen({super.key});

  @override
  ConsumerState<AlphabetCongratulationsScreen> createState() =>
      _AlphabetCongratulationsScreenState();
}

class _AlphabetCongratulationsScreenState
    extends ConsumerState<AlphabetCongratulationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparkleController;
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
      final onboardingState = ref.read(onboardingNotifierProvider).valueOrNull;
      final friend = onboardingState?.friendAvatar.isNotEmpty == true
          ? onboardingState!.friendAvatar
          : AppStrings.defaultFriend;
      KidSoundService.instance.playCelebrationSounds(friend);
    });
  }

  @override
  void dispose() {
    KidSoundService.instance.stop();
    _sparkleController.dispose();
    super.dispose();
  }

  void _onNextLevel(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(alphabetNotifierProvider.notifier);
    final state = ref.read(alphabetNotifierProvider).valueOrNull;

    // Find the next incomplete, unlocked session
    final sessions = state?.sessions ?? [];
    final nextSessionList =
        sessions.where((s) => !s.isCompleted && !s.isLocked).toList();

    if (nextSessionList.isNotEmpty) {
      final nextSession = nextSessionList.first;
      notifier.selectSession(nextSession.id);
      Navigator.pushReplacementNamed(context, AppRoutes.alphabetLearning);
    } else {
      // All done! Return to hub
      notifier.exitToHub();
      Navigator.pushReplacementNamed(context, AppRoutes.alphabetHub);
    }
  }

  void _onPlayAgain(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(alphabetNotifierProvider.notifier);
    final state = ref.read(alphabetNotifierProvider).valueOrNull;
    final sessionId = state?.activeSession?.id ?? AppStrings.sessionCapital1;

    notifier.playAgain(sessionId);
    Navigator.pushReplacementNamed(context, AppRoutes.alphabetLearning);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alphabetState = ref.watch(alphabetNotifierProvider).valueOrNull;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;

    final childName = alphabetState?.studentName.isNotEmpty == true
        ? alphabetState!.studentName
        : AppStrings.defaultChildName;

    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final activeSession = alphabetState?.activeSession;
    final sessionNum = activeSession?.sessionNumber ?? 1;
    final nextSessionNum = sessionNum < 4 ? sessionNum + 1 : 4;
    final isAllDone = sessionNum >= 4;

    return Scaffold(
      backgroundColor: context.themePalette.scaffoldBackground,
      body: SafeArea(
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
                          l10n.starsEarnedBadge,
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

                  // Subtitle ("Session 1 done. Session 2 is unlocked!")
                  Text(
                    isAllDone
                        ? l10n.allSessionsComplete
                        : l10n.sessionCompleteUnlocked(
                            sessionNum.toString(),
                            nextSessionNum.toString(),
                          ),
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
    );
  }
}

/// Large golden star with dark outline and drop shadow.
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
