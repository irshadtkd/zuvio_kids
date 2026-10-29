import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/alphabet/presentation/providers/alphabet_provider.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/alphabet_step_pills.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/alphabet_top_bar.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/discover_step_view.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/play_step_view.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/practice_step_view.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';

/// Main interactive letter learning screen hosting the 3 steps: Discover, Practice, Play.
/// Layer: Presentation Screen
class AlphabetLearningScreen extends ConsumerStatefulWidget {
  const AlphabetLearningScreen({super.key});

  @override
  ConsumerState<AlphabetLearningScreen> createState() =>
      _AlphabetLearningScreenState();
}

class _AlphabetLearningScreenState
    extends ConsumerState<AlphabetLearningScreen> {
  final GlobalKey<DiscoverStepViewState> _discoverKey = GlobalKey();
  final GlobalKey<PracticeStepViewState> _practiceKey = GlobalKey();
  final GlobalKey<PlayStepViewState> _playKey = GlobalKey();

  void _onSpeakerTap() {
    setState(KidSoundService.instance.toggleMute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themePalette = context.themePalette;
    final alphabetState = ref.watch(alphabetNotifierProvider).valueOrNull;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;

    // Listen for session completion to transition to Congratulations screen
    ref.listen(alphabetNotifierProvider, (previous, next) {
      final isCompleted = next.valueOrNull?.isSessionCompleted ?? false;
      final wasCompleted = previous?.valueOrNull?.isSessionCompleted ?? false;
      if (isCompleted && !wasCompleted && mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.alphabetCongrats,
        );
      }
    });

    final currentLetter = alphabetState?.currentLetter;
    if (currentLetter == null) {
      return Scaffold(
        backgroundColor: themePalette.scaffoldBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentStep = alphabetState?.currentStep ?? 0;
    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final notifier = ref.read(alphabetNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: themePalette.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ────────────────────────────────────────────────────
            AlphabetTopBar(
              title: l10n.titleAlphabet,
              isMuted: KidSoundService.instance.isMuted,
              onBack: () {
                notifier.exitToHub();
                Navigator.pop(context);
              },
              onSpeakerTap: _onSpeakerTap,
            ),

            // ── Step Pills: 1 Discover, 2 Practice, 3 Play ─────────────────
            AlphabetStepPills(
              currentStep: currentStep,
              onStepSelected: notifier.setStep,
            ),
            const SizedBox(height: 8),

            // ── Active Step Body ───────────────────────────────────────────
            Expanded(
              child: IndexedStack(
                index: currentStep,
                children: [
                  // Step 1: Discover
                  DiscoverStepView(
                    key: _discoverKey,
                    letter: currentLetter,
                    onNext: notifier.nextStep,
                  ),

                  // Step 2: Practice
                  PracticeStepView(
                    key: _practiceKey,
                    letter: currentLetter,
                    isTracingDone: alphabetState?.isTracingComplete ?? false,
                    onTracingDone: notifier.markTracingComplete,
                    onResetTracing: notifier.resetTracing,
                    onNext: notifier.nextStep,
                    friendAvatar: friendAvatar,
                  ),

                  // Step 3: Play
                  PlayStepView(
                    key: _playKey,
                    letter: currentLetter,
                    selectedWord: alphabetState?.selectedWord,
                    isAnswerCorrect: alphabetState?.isAnswerCorrect,
                    stars: alphabetState?.playStars ?? 0,
                    onWordSelected: notifier.onWordTapped,
                    onNext: notifier.nextStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
