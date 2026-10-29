import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/numbers/presentation/providers/numbers_provider.dart';
import 'package:zuvio_kids/features/numbers/presentation/providers/numbers_state.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/number_discover_step_view.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/number_play_step_view.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/number_practice_step_view.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/numbers_step_pills.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/numbers_top_bar.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';

/// Main screen hosting the 3 learning steps (Discover -> Practice -> Play) for Numbers.
/// Follows Screenshots 2, 3, and 4.
/// Layer: Presentation Screen
class NumbersLearningScreen extends ConsumerStatefulWidget {
  const NumbersLearningScreen({super.key});

  @override
  ConsumerState<NumbersLearningScreen> createState() =>
      _NumbersLearningScreenState();
}

class _NumbersLearningScreenState extends ConsumerState<NumbersLearningScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final friendAvatar = onboardingState?.friendAvatar ?? 'panda';

    ref.listen<AsyncValue<NumbersState>>(
      numbersNotifierProvider,
      (previous, next) {
        final wasCompleted = previous?.valueOrNull?.isSessionCompleted ?? false;
        final isNowCompleted = next.valueOrNull?.isSessionCompleted ?? false;

        if (!wasCompleted && isNowCompleted && mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.numbersCongrats);
        }
      },
    );

    final asyncState = ref.watch(numbersNotifierProvider);

    return Scaffold(
      backgroundColor: context.themePalette.scaffoldBackground,
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.navy),
          ),
          error: (error, _) => Center(
            child: Text(
              '$error',
              style: const TextStyle(color: AppColors.navy),
            ),
          ),
          data: (state) {
            final activeSession = state.activeSession;
            final currentNumber = state.currentNumber;

            if (activeSession == null || currentNumber == null) {
              return Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.btnBack),
                ),
              );
            }

            final notifier = ref.read(numbersNotifierProvider.notifier);

            // Step Title depends on currentStep
            final String stepTitle;
            switch (state.currentStep) {
              case 0:
                stepTitle = l10n.meetTheNumber;
                break;
              case 1:
                stepTitle = l10n.traceTheNumber;
                break;
              case 2:
              default:
                stepTitle = l10n.findTheNumber;
                break;
            }

            return Column(
              children: [
                // ── Top Bar ────────────────────────────────────────────────
                NumbersTopBar(
                  title: stepTitle,
                  isMuted: KidSoundService.instance.isMuted,
                  onToggleMute: () {
                    setState(KidSoundService.instance.toggleMute);
                  },
                  onBack: () {
                    notifier.exitToHub();
                    Navigator.pop(context);
                  },
                ),

                // ── Step Progress Pills ────────────────────────────────────
                NumbersStepPills(
                  totalItems: activeSession.numbers.length,
                  currentIndex: state.currentNumberIndex,
                ),

                // ── Step View Body ─────────────────────────────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: switch (state.currentStep) {
                      0 => NumberDiscoverStepView(
                          key: ValueKey(
                              'discover_${currentNumber.value}'),
                          number: currentNumber,
                          onNext: notifier.nextStep,
                        ),
                      1 => NumberPracticeStepView(
                          key: ValueKey(
                              'practice_${currentNumber.value}'),
                          number: currentNumber,
                          isTracingDone: state.isTracingComplete,
                          onTracingDone: notifier.markTracingComplete,
                          onResetTracing: notifier.resetTracing,
                          onNext: notifier.nextStep,
                          friendAvatar: friendAvatar,
                        ),
                      2 => NumberPlayStepView(
                          key: ValueKey('play_${currentNumber.value}'),
                          number: currentNumber,
                          selectedAnswer: state.selectedQuizAnswer,
                          isCorrect: state.isAnswerCorrect,
                          onAnswerSelected: notifier.onQuizAnswerTapped,
                          onNext: notifier.nextStep,
                          friendAvatar: friendAvatar,
                        ),
                      _ => const SizedBox.shrink(),
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
