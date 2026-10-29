import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/errors/error_handler.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/star_badge.dart';
import '../providers/animals_provider.dart';
import '../widgets/animal_session_card.dart';

/// Hub screen displaying the 2 Animal Learning Sessions.
/// Layer: Presentation Screen
class AnimalsHubScreen extends ConsumerWidget {
  const AnimalsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncState = ref.watch(animalsNotifierProvider);
    final palette = context.themePalette;

    return Scaffold(
      backgroundColor: palette.scaffoldBackground,
      body: SafeArea(
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
            final sessions = state.sessions;
            final totalStars = state.totalStars;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top Bar: Back Button + Title + Star Badge ───────────────
                  Row(
                    children: [
                      Semantics(
                        button: true,
                        label: l10n.btnBack,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          l10n.titleAnimals,
                          style: AppTextStyles.headerTitle.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      StarBadge(stars: totalStars),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Subtitle ───────────────────────────────────────────────
                  Text(
                    l10n.animalsHubSubtitle,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── 2 Sessions List ─────────────────────────────────────────
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return AnimalSessionCard(
                          session: session,
                          onTap: () {
                            ref
                                .read(animalsNotifierProvider.notifier)
                                .selectSession(session.id);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.animalsLearning,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
