import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/shapes/presentation/providers/shapes_provider.dart';
import 'package:zuvio_kids/features/shapes/presentation/providers/shapes_state.dart';
import 'package:zuvio_kids/features/shapes/presentation/widgets/shape_discover_step_view.dart';
import 'package:zuvio_kids/features/shapes/presentation/widgets/shape_matching_step_view.dart';
import 'package:zuvio_kids/features/shapes/presentation/widgets/shape_practice_step_view.dart';
import 'package:zuvio_kids/features/shapes/presentation/widgets/shapes_step_pills.dart';
import 'package:zuvio_kids/features/shapes/presentation/widgets/shapes_top_bar.dart';

/// Main screen hosting the 3 learning steps (Discover -> Practice -> Matching) for Shapes.
/// Layer: Presentation Screen
class ShapesLearningScreen extends ConsumerStatefulWidget {
  const ShapesLearningScreen({super.key});

  @override
  ConsumerState<ShapesLearningScreen> createState() =>
      _ShapesLearningScreenState();
}

class _ShapesLearningScreenState extends ConsumerState<ShapesLearningScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final friendAvatar = onboardingState?.friendAvatar ?? 'panda';

    ref.listen<AsyncValue<ShapesState>>(
      shapesNotifierProvider,
      (previous, next) {
        final wasCompleted = previous?.valueOrNull?.isSessionCompleted ?? false;
        final isNowCompleted = next.valueOrNull?.isSessionCompleted ?? false;

        if (!wasCompleted && isNowCompleted && mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.shapesCongrats);
        }
      },
    );

    final asyncState = ref.watch(shapesNotifierProvider);

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
            final currentShape = state.currentShape;

            if (activeSession == null || currentShape == null) {
              return Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.btnBack),
                ),
              );
            }

            final notifier = ref.read(shapesNotifierProvider.notifier);

            final String stepTitle;
            switch (state.currentStep) {
              case 0:
                stepTitle = l10n.shapesDiscoverTitle;
                break;
              case 1:
                stepTitle = l10n.shapesPracticeTitle;
                break;
              case 2:
              default:
                stepTitle = l10n.shapesMatchingTitle;
                break;
            }

            return Column(
              children: [
                // Top Bar
                ShapesTopBar(
                  title: stepTitle,
                  isMuted: KidSoundService.instance.isMuted,
                  onBack: () {
                    notifier.exitToHub();
                    Navigator.pop(context);
                  },
                  onToggleMute: () {
                    setState(KidSoundService.instance.toggleMute);
                  },
                ),

                // Progress Pills (3 shapes in active session)
                ShapesStepPills(
                  totalItems: activeSession.shapes.length,
                  currentIndex: state.currentShapeIndex,
                ),

                // Active Step Content
                Expanded(
                  child: switch (state.currentStep) {
                    0 => ShapeDiscoverStepView(
                        shape: currentShape,
                        onNext: notifier.nextStep,
                      ),
                    1 => ShapePracticeStepView(
                        shape: currentShape,
                        friendAvatar: friendAvatar,
                        isTracingDone: state.isTracingComplete,
                        onTracingDone: notifier.markTracingComplete,
                        onResetTracing: notifier.resetTracing,
                        onNext: notifier.nextStep,
                      ),
                    2 => ShapeMatchingStepView(
                        shape: currentShape,
                        friendAvatar: friendAvatar,
                        selectedOption: state.selectedMatchingOption,
                        isCorrect: state.isAnswerCorrect,
                        onOptionSelected: notifier.onMatchingOptionTapped,
                        onNext: notifier.nextStep,
                      ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
