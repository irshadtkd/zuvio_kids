import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/dashed_shadow_slot.dart';
import '../widgets/puzzle_draggable_item.dart';
import '../widgets/puzzle_session_pills.dart';
import '../widgets/puzzle_top_bar.dart';

/// Screen displaying the 4 puzzle sessions.
/// Faithfully reproduces the design layout:
/// - Top bar with back, two-line title, and audio button
/// - Friend avatar with speech bubble instruction
/// - 4 session indicators for switching puzzles
/// - Main card with dashed shadow slots and colorful draggable/tappable pictures
/// - Next button to advance or finish
/// Layer: Presentation Screen
class PuzzleSessionsScreen extends ConsumerStatefulWidget {
  const PuzzleSessionsScreen({super.key});

  @override
  ConsumerState<PuzzleSessionsScreen> createState() =>
      _PuzzleSessionsScreenState();
}

class _PuzzleSessionsScreenState extends ConsumerState<PuzzleSessionsScreen> {
  bool _hasSpokenInitialInstruction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasSpokenInitialInstruction) return;
      _hasSpokenInitialInstruction = true;
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        KidSoundService.instance.speak(l10n.instructionMatchShadows);
      }
    });
  }

  void _onNext(BuildContext context, WidgetRef ref) {
    final state = ref.read(puzzleNotifierProvider).valueOrNull;
    final notifier = ref.read(puzzleNotifierProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    if (state == null) return;

    if (!state.isCurrentSessionCompleted) {
      // Gently guide the child to complete the matches first
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.instructionMatchShadows,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      KidSoundService.instance.speak(l10n.instructionMatchShadows);
      return;
    }

    final isFinishedAll = notifier.nextSession();
    if (isFinishedAll) {
      Navigator.pushReplacementNamed(context, AppRoutes.puzzleCongrats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final puzzleAsync = ref.watch(puzzleNotifierProvider);
    final onboardingState = ref.watch(onboardingNotifierProvider).valueOrNull;

    final friendAvatar = onboardingState?.friendAvatar.isNotEmpty == true
        ? onboardingState!.friendAvatar
        : AppStrings.defaultFriend;

    final themePalette = context.themePalette;

    return Scaffold(
      backgroundColor: themePalette.scaffoldBackground,
      body: SafeArea(
        child: puzzleAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, _) => Center(
            child: Text(
              l10n.errorUnexpected,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          data: (state) {
            if (state.sessions.isEmpty) {
              return Center(
                child: Text(
                  l10n.errorUnexpected,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }

            final currentSession = state.currentSession;
            final matchedSet = state.matchedItemIds[currentSession.id] ?? <String>{};
            final notifier = ref.read(puzzleNotifierProvider.notifier);

            return Column(
              children: [
                // 1. Top Bar
                PuzzleTopBar(
                  onBack: () => Navigator.pop(context),
                  instructionToSpeak: l10n.instructionMatchShadows,
                ),

                const SizedBox(height: 6),

                // 2. Avatar + Speech Bubble Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      // Friend Avatar
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.navy.withValues(alpha: 0.15),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: AnimalAvatar(
                          avatarType: friendAvatar,
                          size: 50,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Speech Bubble
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            l10n.instructionMatchShadows,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Display All 4 Puzzle Sessions via Selector Pills
                PuzzleSessionPills(
                  sessions: state.sessions,
                  currentIndex: state.currentSessionIndex,
                  onSelectSession: notifier.selectSession,
                ),

                const SizedBox(height: 14),

                // 4. Main White Card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 22.0,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final slotSize = ((constraints.maxWidth - 32) / 3)
                              .clamp(72.0, 96.0);

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Shadows Heading
                                Text(
                                  l10n.headingShadows,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.navy,
                                    letterSpacing: -0.2,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Shadows Row (3 slots)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: currentSession.shadowItems.map((item) {
                                    final isMatched =
                                        matchedSet.contains(item.id);

                                    return DashedShadowSlot(
                                      item: item,
                                      size: slotSize,
                                      isMatched: isMatched,
                                      onMatchAttempt: (candidateId) {
                                        final selectedId = candidateId.isNotEmpty
                                            ? candidateId
                                            : state.selectedPictureId;

                                        if (selectedId != null) {
                                          final success = notifier.tryMatch(
                                            item.id,
                                            selectedId,
                                          );
                                          if (!success) {
                                            KidSoundService.instance.speak(
                                              l10n.feedbackPuzzleTryAgain,
                                            );
                                          }
                                        }
                                      },
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 18),

                                // Pictures Heading
                                Text(
                                  l10n.headingPictures,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.navy,
                                    letterSpacing: -0.2,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Pictures Row (3 pictures)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: currentSession.pictureItems.map((item) {
                                    final isMatched =
                                        matchedSet.contains(item.id);
                                    final isSelected =
                                        state.selectedPictureId == item.id;

                                    return PuzzleDraggableItem(
                                      item: item,
                                      size: slotSize * 0.92,
                                      isMatched: isMatched,
                                      isSelected: isSelected,
                                      onTap: () {
                                        notifier.selectPicture(item.id);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Bottom Next Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: KidButton(
                    label: l10n.btnNext,
                    backgroundColor: state.isCurrentSessionCompleted
                        ? AppColors.kidGreen
                        : AppColors.kidGreen.withValues(alpha: 0.85),
                    onPressed: () => _onNext(context, ref),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
