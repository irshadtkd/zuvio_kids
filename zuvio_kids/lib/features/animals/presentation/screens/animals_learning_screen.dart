import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/errors/error_handler.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/animated_kid_background.dart';
import 'package:zuvio_kids/core/widgets/floating_mascot.dart';
import '../providers/animals_provider.dart';
import '../widgets/animal_animated_illustration.dart';
import '../widgets/animal_step_indicator.dart';

/// Screen displaying one animal at a time with its animated SVG and audio sound effect.
/// Provides simple next/previous navigation and interactive child-friendly controls.
/// Layer: Presentation Screen
class AnimalsLearningScreen extends ConsumerStatefulWidget {
  const AnimalsLearningScreen({super.key});

  @override
  ConsumerState<AnimalsLearningScreen> createState() =>
      _AnimalsLearningScreenState();
}

class _AnimalsLearningScreenState extends ConsumerState<AnimalsLearningScreen> {
  @override
  void initState() {
    super.initState();
    // Play sound for the current animal on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(animalsNotifierProvider.notifier).playCurrentAnimalSound();
    });
  }

  @override
  void dispose() {
    // Silence any playing audio when exiting the screen
    KidSoundService.instance.stop();
    super.dispose();
  }

  String _getLocalizedAnimalName(AppLocalizations l10n, String nameKey) {
    switch (nameKey) {
      case 'animalElephant':
        return l10n.animalElephant;
      case 'animalCat':
        return l10n.animalCat;
      case 'animalTiger':
        return l10n.animalTiger;
      case 'animalLion':
        return l10n.animalLion;
      case 'animalCow':
        return l10n.animalCow;
      case 'animalGoat':
        return l10n.animalGoat;
      case 'animalMonkey':
        return l10n.animalMonkey;
      case 'animalDog':
        return l10n.animalDog;
      case 'animalHen':
        return l10n.animalHen;
      case 'animalHorse':
        return l10n.animalHorse;
      case 'animalRabbit':
        return l10n.animalRabbit;
      case 'animalParrot':
        return l10n.animalParrot;
      case 'animalFish':
        return l10n.animalFish;
      case 'animalGiraffe':
        return l10n.animalGiraffe;
      case 'animalZebra':
        return l10n.animalZebra;
      case 'animalDeer':
        return l10n.animalDeer;
      case 'animalPeacock':
        return l10n.animalPeacock;
      case 'animalFrog':
        return l10n.animalFrog;
      case 'animalCamel':
        return l10n.animalCamel;
      case 'animalBear':
        return l10n.animalBear;
      default:
        return nameKey;
    }
  }

  bool _hasShownMidQuiz = false;

  Future<void> _handleNext() async {
    final notifier = ref.read(animalsNotifierProvider.notifier);
    final state = ref.read(animalsNotifierProvider).valueOrNull;
    if (state != null && state.currentAnimalIndex == 4 && !_hasShownMidQuiz) {
      _hasShownMidQuiz = true;
      await Navigator.pushNamed(context, AppRoutes.animalsQuiz);
    }
    final isFinished = await notifier.nextAnimal();
    if (isFinished && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.animalsCongrats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncState = ref.watch(animalsNotifierProvider);
    final palette = context.themePalette;

    return Scaffold(
      body: AnimatedKidBackground(
        primaryColor: const Color(0xFFD6F0FD),
        secondaryColor: const Color(0xFFEFF8FE),
        child: SafeArea(
        child: asyncState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.navy),
          ),
          error: (error, _) => Center(
            child: Text(
              ErrorHandler.getLocalizedMessage(error, context),
              style: AppTextStyles.base.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
          ),
          data: (state) {
            final session = state.selectedSession;
            final animal = state.currentAnimal;

            if (session == null || animal == null) {
              return Center(
                child: Text(
                  l10n.errorUnexpected,
                  style: AppTextStyles.base.copyWith(
                    fontSize: 16,
                    color: AppColors.navy,
                  ),
                ),
              );
            }

            final currentIndex = state.currentAnimalIndex;
            final totalCount = session.animals.length;
            final isFirst = currentIndex == 0;
            final isLast = currentIndex == totalCount - 1;
            final animalColor = Color(animal.colorValue);

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                    vertical: AppSizes.paddingM,
                  ),
                  child: Column(
                children: [
                  // ── Top Header Bar ──────────────────────────────────────────
                  Row(
                    children: [
                      Semantics(
                        button: true,
                        label: l10n.btnBack,
                        child: GestureDetector(
                          onTap: () {
                            KidSoundService.instance.stop();
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.navy,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Step Dots Indicator
                      Expanded(
                        child: AnimalStepIndicator(
                          totalSteps: totalCount,
                          currentIndex: currentIndex,
                          activeColor: animalColor,
                          onStepTapped: (index) {
                            ref
                                .read(animalsNotifierProvider.notifier)
                                .jumpToAnimal(index);
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Speaker / Audio Button
                      Semantics(
                        button: true,
                        label: l10n.btnPlaySound,
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(animalsNotifierProvider.notifier)
                                .playCurrentAnimalSound();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              state.isSoundPlaying
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_down_rounded,
                              color: animalColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Counter Pill ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.animalsItemProgress(currentIndex + 1, totalCount),
                      style: AppTextStyles.base.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Main Animal Presentation Card ─────────────────────────
                  Expanded(
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        final vx = details.primaryVelocity;
                        if (vx != null) {
                          if (vx < -200) {
                            _handleNext();
                          } else if (vx > 200) {
                            ref
                                .read(animalsNotifierProvider.notifier)
                                .previousAnimal();
                          }
                        }
                      },
                      child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            animalColor.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: animalColor.withValues(alpha: 0.25),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: animalColor.withValues(alpha: 0.3),
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated SVG Illustration
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final targetSize =
                                    (constraints.maxHeight * 0.72)
                                        .clamp(160.0, 250.0);
                                return AnimalAnimatedIllustration(
                                  key: ValueKey(animal.id),
                                  animal: animal,
                                  size: targetSize,
                                  onTap: () {
                                    ref
                                        .read(animalsNotifierProvider.notifier)
                                        .playCurrentAnimalSound();
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Animal Name (Localised + English)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _getLocalizedAnimalName(l10n, animal.nameKey),
                              style: AppTextStyles.splashTitle.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppColors.navy,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Interactive Play Sound Pill Button
                          Semantics(
                            button: true,
                            label: l10n.btnPlaySound,
                            child: GestureDetector(
                              onTap: () {
                                ref
                                    .read(animalsNotifierProvider.notifier)
                                    .playCurrentAnimalSound();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: animalColor.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: animalColor.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.music_note_rounded,
                                      color: animalColor,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      l10n.btnPlaySound,
                                      style: AppTextStyles.base.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                  const SizedBox(height: 20),

                  // ── Bottom Navigation Controls ────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Button
                      if (!isFirst)
                        Semantics(
                          button: true,
                          label: l10n.btnBack,
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(animalsNotifierProvider.notifier)
                                  .previousAnimal();
                            },
                            child: Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.navy,
                                size: 30,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 62),

                      // Next / Complete Button
                      Semantics(
                        button: true,
                        label: isLast ? l10n.btnStart : l10n.btnNext,
                        child: GestureDetector(
                          onTap: _handleNext,
                          child: Container(
                            height: 62,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                              color: isLast
                                  ? AppColors.kidGreen
                                  : palette.actionButton,
                              borderRadius: BorderRadius.circular(31),
                              boxShadow: [
                                BoxShadow(
                                  color: (isLast
                                          ? AppColors.kidGreenShadow
                                          : palette.actionButtonShadow)
                                      .withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.btnNext,
                                  style: AppTextStyles.buttonLabel.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isLast
                                      ? Icons.check_circle_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 20,
              bottom: 90,
              child: FloatingMascot(size: 60),
            ),
          ],
        );
      },
        ),
      ),
      ),
    );
  }
}
