import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/widgets/kid_confetti_overlay.dart';
import 'package:zuvio_kids/features/achievements/presentation/providers/achievements_provider.dart';
import 'package:zuvio_kids/features/achievements/presentation/widgets/badge_card.dart';

/// Trophy Room screen showing all achievement badges.
/// Accessible from the Home screen header.
/// Layer: Presentation Screen
class TrophyRoomScreen extends ConsumerStatefulWidget {
  const TrophyRoomScreen({super.key});

  @override
  ConsumerState<TrophyRoomScreen> createState() => _TrophyRoomScreenState();
}

class _TrophyRoomScreenState extends ConsumerState<TrophyRoomScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  final _confettiKey = GlobalKey<KidConfettiOverlayState>();

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final badges = ref.read(achievementsNotifierProvider).valueOrNull ?? [];
      final anyUnlocked = badges.any((b) => b.isUnlocked);
      if (anyUnlocked && mounted) {
        Future.delayed(const Duration(milliseconds: 400), () {
          _confettiKey.currentState?.smallBurst();
        });
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.themePalette;
    final asyncBadges = ref.watch(achievementsNotifierProvider);

    return Scaffold(
      backgroundColor: palette.scaffoldBackground,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 50,
                          height: 50,
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
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.trophyRoomTitle,
                            style: AppTextStyles.headerTitle.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            l10n.trophyRoomSubtitle,
                            style: AppTextStyles.base.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Badge grid
                  Expanded(
                    child: asyncBadges.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.navy),
                      ),
                      error: (err, stack) => const SizedBox.shrink(),
                      data: (badges) {
                        final unlocked = badges.where((b) => b.isUnlocked).length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🏆', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$unlocked / ${badges.length}',
                                    style: AppTextStyles.base.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: badges.length,
                                itemBuilder: (context, index) {
                                  return AnimatedBuilder(
                                    animation: _entranceController,
                                    builder: (context, child) {
                                      final delay = (index * 0.08).clamp(0.0, 0.8);
                                      final t = ((_entranceController.value - delay) /
                                              (1.0 - delay))
                                          .clamp(0.0, 1.0);
                                      return Opacity(
                                        opacity: t,
                                        child: Transform.translate(
                                          offset: Offset(0, 20 * (1.0 - t)),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: BadgeCard(badge: badges[index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Confetti
          KidConfettiOverlay(key: _confettiKey),
        ],
      ),
    );
  }
}
