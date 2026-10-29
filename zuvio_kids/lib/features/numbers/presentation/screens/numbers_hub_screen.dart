import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/errors/error_handler.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/numbers/presentation/providers/numbers_provider.dart';
import 'package:zuvio_kids/features/numbers/presentation/widgets/number_session_card.dart';

/// Hub screen displaying all 10 Numbers sessions in a 2-column grid.
/// Follows Screenshot 1 exactly.
/// Layer: Presentation Screen
class NumbersHubScreen extends ConsumerWidget {
  const NumbersHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
              ErrorHandler.getLocalizedMessage(error, context),
              style: AppTextStyles.base.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
          ),
          data: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Back Button + Title
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.paddingL,
                    right: AppSizes.paddingL,
                    top: AppSizes.paddingM,
                    bottom: AppSizes.paddingS,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
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
                      const SizedBox(width: 16),
                      Text(
                        l10n.numbersHubTitle,
                        style: AppTextStyles.splashTitle.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),

                // Subtitle: "Pick a level. Stars unlock the next one!"
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                    vertical: AppSizes.paddingS,
                  ),
                  child: Text(
                    l10n.numbersHubSubtitle,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 2-Column Grid of 10 Session Cards
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingL,
                      vertical: AppSizes.paddingS,
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: state.sessions.length,
                    itemBuilder: (context, index) {
                      final session = state.sessions[index];
                      return NumberSessionCard(
                        session: session,
                        onTap: () {
                          ref
                              .read(numbersNotifierProvider.notifier)
                              .selectSession(session.id);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.numbersLearning,
                          );
                        },
                      );
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
