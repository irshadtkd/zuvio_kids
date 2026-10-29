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
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'package:zuvio_kids/features/shapes/presentation/providers/shapes_provider.dart';

/// Congratulations screen displayed when a Shapes session is completed.
/// Awards 10 stars, plays celebration voice, and provides Next Session and Play Again actions.
/// Layer: Presentation Screen
class ShapesCongratulationsScreen extends ConsumerStatefulWidget {
  const ShapesCongratulationsScreen({super.key});

  @override
  ConsumerState<ShapesCongratulationsScreen> createState() =>
      _ShapesCongratulationsScreenState();
}

class _ShapesCongratulationsScreenState
    extends ConsumerState<ShapesCongratulationsScreen>
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

  void _onNextSession(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(shapesNotifierProvider.notifier);
    final state = ref.read(shapesNotifierProvider).valueOrNull;

    final sessions = state?.sessions ?? [];
    final nextSessionList =
        sessions.where((s) => !s.isCompleted && !s.isLocked).toList();

    if (nextSessionList.isNotEmpty) {
      final nextSession = nextSessionList.first;
      notifier.selectSession(nextSession.id);
      Navigator.pushReplacementNamed(context, AppRoutes.shapesLearning);
    } else {
      notifier.exitToHub();
      Navigator.pushReplacementNamed(context, AppRoutes.shapesHub);
    }
  }

  void _onPlayAgain(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(shapesNotifierProvider.notifier);
    notifier.playAgain();
    Navigator.pushReplacementNamed(context, AppRoutes.shapesLearning);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shapesState = ref.watch(shapesNotifierProvider).valueOrNull;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;

    final childName = shapesState?.studentName.isNotEmpty == true
        ? shapesState!.studentName
        : AppStrings.defaultChildName;

    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final activeSession = shapesState?.activeSession;
    final sessionTitle = activeSession?.title ?? '';

    return Scaffold(
      backgroundColor: context.themePalette.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Header Title
              Text(
                l10n.congratsTitle(childName),
                textAlign: TextAlign.center,
                style: AppTextStyles.splashTitle.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                ),
              ),

              // 3 Big Stars
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

              // Cartoon Friend Avatar
              AnimalAvatar(
                avatarType: friendAvatar,
                size: 140,
              ),

              // Stars Earned Pill Badge & Subtitle
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
                  Text(
                    sessionTitle.isNotEmpty
                        ? sessionTitle
                        : l10n.shapesCongratsSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),

              // Bottom Action Buttons
              Column(
                children: [
                  // Green Next Session Button
                  KidButton(
                    label: l10n.btnNextSession,
                    onPressed: () => _onNextSession(context, ref),
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

class _BigStar extends StatelessWidget {
  const _BigStar({
    required this.size,
    required this.rotation,
  });

  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.starYellow.withValues(alpha: 0.45),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.star_rounded,
          color: AppColors.starYellow,
          size: size * 0.75,
        ),
      ),
    );
  }
}
