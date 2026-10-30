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
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import '../providers/puzzle_provider.dart';

/// Congratulations screen displayed when all 4 puzzle sessions are completed.
/// Awards 10 stars, plays celebratory character and clapping sounds simultaneously,
/// and provides Play Again and Home actions.
/// Layer: Presentation Screen
class PuzzleCongratulationsScreen extends ConsumerStatefulWidget {
  const PuzzleCongratulationsScreen({super.key});

  @override
  ConsumerState<PuzzleCongratulationsScreen> createState() =>
      _PuzzleCongratulationsScreenState();
}

class _PuzzleCongratulationsScreenState
    extends ConsumerState<PuzzleCongratulationsScreen>
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
      ref.read(achievementsNotifierProvider.notifier).unlock('puzzle_champion');
    });
  }

  @override
  void dispose() {
    KidSoundService.instance.stop();
    _sparkleController.dispose();
    super.dispose();
  }

  void _onPlayAgain(BuildContext context, WidgetRef ref) {
    ref.read(puzzleNotifierProvider.notifier).generateNewSet();
    Navigator.pushReplacementNamed(context, AppRoutes.puzzleSessions);
  }

  void _onBackToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;

    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final themePalette = context.themePalette;

    return Scaffold(
      backgroundColor: themePalette.scaffoldBackground,
      body: Stack(
        children: [
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Star Sparkle Visual
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _sparkleController,
                  curve: Curves.elasticOut,
                ),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.starYellow.withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimalAvatar(
                      avatarType: friendAvatar,
                      size: 96,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title: "Puzzle Master!"
              Text(
                l10n.puzzleCongratsTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.splashTitle.copyWith(
                  color: AppColors.navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                l10n.puzzleCongratsSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.base.copyWith(
                  color: AppColors.navy.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // +10 Stars Reward Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
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
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.starsEarnedBadge,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Play Again Button
              KidButton(
                label: l10n.btnPlayAgain,
                showArrow: false,
                backgroundColor: themePalette.actionButton,
                onPressed: () => _onPlayAgain(context, ref),
              ),

              const SizedBox(height: 12),

              // Back to Home Button
              KidButton(
                label: l10n.btnBack,
                showArrow: false,
                backgroundColor: AppColors.navy,
                textColor: Colors.white,
                onPressed: () => _onBackToHome(context),
              ),

              const SizedBox(height: 24),
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
