import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/colors/presentation/providers/colors_provider.dart';
import 'package:zuvio_kids/features/colors/presentation/providers/colors_state.dart';
import 'package:zuvio_kids/features/colors/presentation/widgets/color_discover_step_view.dart';
import 'package:zuvio_kids/features/colors/presentation/widgets/color_paint_step_view.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/numbers_step_pills.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/numbers_top_bar.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';

/// Main interactive screen for Colors learning module (Discover -> Paint).
/// Layer: Presentation Screen
class ColorsLearningScreen extends ConsumerStatefulWidget {
  const ColorsLearningScreen({super.key});

  @override
  ConsumerState<ColorsLearningScreen> createState() =>
      _ColorsLearningScreenState();
}

class _ColorsLearningScreenState extends ConsumerState<ColorsLearningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(colorsNotifierProvider).valueOrNull;
      if (state != null && state.isSessionCompleted) {
        ref.read(colorsNotifierProvider.notifier).playAgain();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;
    final friendAvatar = onboardingState?.friendAvatar ?? 'panda';

    ref.listen<AsyncValue<ColorsState>>(
      colorsNotifierProvider,
      (previous, next) {
        final wasCompleted = previous?.valueOrNull?.isSessionCompleted ?? false;
        final isNowCompleted = next.valueOrNull?.isSessionCompleted ?? false;

        if (!wasCompleted && isNowCompleted && mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.colorsCongrats);
        }
      },
    );

    final asyncState = ref.watch(colorsNotifierProvider);

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
            final currentColor = state.currentColor;
            final notifier = ref.read(colorsNotifierProvider.notifier);

            // Step title: Discover the color vs Color Magic (matches screenshot)
            final String stepTitle = state.currentStep == 0
                ? l10n.discoverTheColor
                : l10n.colorMagic;

            return Column(
              children: [
                // ── Top Bar ────────────────────────────────────────────────
                NumbersTopBar(
                  title: stepTitle,
                  isMuted: KidSoundService.instance.isMuted,
                  onToggleMute: () {
                    setState(KidSoundService.instance.toggleMute);
                  },
                  onBack: () => Navigator.pop(context),
                ),

                // ── Progress Pills for the 7 Colors ────────────────────────
                NumbersStepPills(
                  totalItems: state.session.colors.length,
                  currentIndex: state.currentColorIndex,
                ),

                // ── Step View Body ─────────────────────────────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: switch (state.currentStep) {
                      0 => ColorDiscoverStepView(
                          key: ValueKey('discover_${currentColor.id}'),
                          colorItem: currentColor,
                          onNext: notifier.nextStep,
                        ),
                      1 => ColorPaintStepView(
                          key: ValueKey('paint_${currentColor.id}'),
                          colorItem: currentColor,
                          selectedPaletteColorValue:
                              state.selectedPaletteColorValue,
                          appliedColorValue: state.appliedColorValue,
                          isPaintCorrect: state.isPaintCorrect,
                          onPaletteColorSelected: notifier.selectPaletteColor,
                          onPaintObject: notifier.paintObject,
                          onResetPaint: notifier.resetPaint,
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
