import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/core/widgets/kid_confetti_overlay.dart';
import 'package:zuvio_kids/features/achievements/presentation/providers/achievements_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import '../providers/animals_provider.dart';

/// Screen displayed when an animal learning session is successfully completed.
/// Celebrates achievement with fanfare, awards stars, and provides next actions.
/// Layer: Presentation Screen
class AnimalsCongratulationsScreen extends ConsumerStatefulWidget {
  const AnimalsCongratulationsScreen({super.key});

  @override
  ConsumerState<AnimalsCongratulationsScreen> createState() =>
      _AnimalsCongratulationsScreenState();
}

class _AnimalsCongratulationsScreenState
    extends ConsumerState<AnimalsCongratulationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sparkleController;
  late final Animation<double> _scaleAnimation;
  final _confettiKey = GlobalKey<KidConfettiOverlayState>();
  bool _hasPlayedCelebrationAudio = false;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.elasticOut,
    );
    _sparkleController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasPlayedCelebrationAudio) return;
      _hasPlayedCelebrationAudio = true;
      _confettiKey.currentState?.burst();
      final onboardingState = ref.read(onboardingNotifierProvider).valueOrNull;
      final friend = onboardingState?.friendAvatar.isNotEmpty == true
          ? onboardingState!.friendAvatar
          : AppStrings.defaultFriend;
      KidSoundService.instance.playCelebrationSounds(friend);

      final session = ref.read(animalsNotifierProvider).valueOrNull?.selectedSession;
      if (session?.sessionNumber == 1) {
        ref.read(achievementsNotifierProvider.notifier).unlock('animal_explorer');
      } else if (session?.sessionNumber == 2) {
        ref.read(achievementsNotifierProvider.notifier).unlock('animal_master');
      }
    });
  }

  @override
  void dispose() {
    KidSoundService.instance.stop();
    _sparkleController.dispose();
    super.dispose();
  }

  void _onNextSession(BuildContext context) {
    final state = ref.read(animalsNotifierProvider).valueOrNull;
    final sessions = state?.sessions ?? [];
    final uncompleted =
        sessions.where((s) => !s.isCompleted && !s.isLocked).toList();

    if (uncompleted.isNotEmpty) {
      ref
          .read(animalsNotifierProvider.notifier)
          .selectSession(uncompleted.first.id);
      Navigator.pushReplacementNamed(context, AppRoutes.animalsLearning);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.animalsHub);
    }
  }

  void _onPlayAgain(BuildContext context) {
    final state = ref.read(animalsNotifierProvider).valueOrNull;
    final currentSession = state?.selectedSession;
    if (currentSession != null) {
      ref
          .read(animalsNotifierProvider.notifier)
          .selectSession(currentSession.id);
      Navigator.pushReplacementNamed(context, AppRoutes.animalsLearning);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.animalsHub);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.themePalette;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final state = ref.watch(animalsNotifierProvider).valueOrNull;
    final sessions = state?.sessions ?? [];
    final hasNextSession =
        sessions.any((s) => !s.isCompleted && !s.isLocked);

    return Scaffold(
      backgroundColor: palette.scaffoldBackground,
      body: Stack(
        children: [
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingL,
            vertical: AppSizes.paddingM,
          ),
          child: Column(
            children: [
              const Spacer(),

              // ── Star & Avatar Celebration Graphic ─────────────────────────
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.starYellow.withValues(alpha: 0.35),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimalAvatar(avatarType: friendAvatar, size: 120),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.starYellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Title ─────────────────────────────────────────────────────
              Text(
                l10n.animalCongratsTitle,
                style: AppTextStyles.splashTitle.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // ── Subtitle ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.animalCongratsSubtitle,
                  style: AppTextStyles.base.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // ── Stars Earned Pill ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                      '+5 Stars!',
                      style: AppTextStyles.base.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Action Buttons ────────────────────────────────────────────
              if (hasNextSession) ...[
                KidButton(
                  label: l10n.btnNext,
                  backgroundColor: palette.actionButton,
                  shadowColor: palette.actionButtonShadow,
                  onPressed: () => _onNextSession(context),
                ),
                const SizedBox(height: 14),
              ],

              KidButton(
                label: l10n.btnRetry,
                backgroundColor: palette.highlight,
                shadowColor: palette.highlightShadow,
                textColor: AppColors.navy,
                showArrow: false,
                onPressed: () => _onPlayAgain(context),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.animalsHub,
                    (route) => route.settings.name == AppRoutes.home,
                  );
                },
                child: Text(
                  l10n.btnBack,
                  style: AppTextStyles.base.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),

              const SizedBox(height: 10),
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
