import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/category_card.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/star_badge.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';

/// Home dashboard screen.
/// Tapping the avatar, name, or star badge opens a small bottom-sheet menu
/// with "Change Name" and "Logout" — both clear local data and restart the app.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _onCategoryTapped(
    BuildContext context,
    String categoryTitle,
    AppLocalizations l10n,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.notifyActivityStarting(categoryTitle)),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Shows a compact bottom-sheet menu.
  Future<void> _showProfileMenu(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProfileMenuSheet(
        onChangeName: () async {
          Navigator.pop(ctx);
          await _clearAndRestart(context, ref);
        },
        onLogout: () async {
          Navigator.pop(ctx);
          await _clearAndRestart(context, ref);
        },
        l10n: l10n,
      ),
    );
  }

  /// Clears all local profile data and navigates to the splash screen.
  Future<void> _clearAndRestart(BuildContext context, WidgetRef ref) async {
    await ref.read(onboardingNotifierProvider.notifier).resetProfile();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.splash,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingNotifierProvider).valueOrNull;
    final name =
        state?.name.isNotEmpty == true ? state!.name : AppStrings.defaultChildName;
    final avatar = state?.friendAvatar.isNotEmpty == true
        ? state!.friendAvatar
        : AppStrings.defaultFriend;

    return Scaffold(
      backgroundColor: AppColors.appSkyBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // ── Top Bar: Avatar + Greeting + Star Badge ───────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showProfileMenu(context, ref),
                    child: AnimalAvatar(avatarType: avatar, size: 58),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showProfileMenu(context, ref),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeGreeting(name),
                            style: AppTextStyles.homeGreeting,
                          ),
                          Text(
                            l10n.homePlayAndLearn,
                            style: AppTextStyles.homePlaySubtitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  StarBadge(
                    stars: 24,
                    onTap: () => _showProfileMenu(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── 2×3 Learning Category Grid ────────────────────────────
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    CategoryCard(
                      title: l10n.categoryAlphabet,
                      backgroundColor: AppColors.cardYellow,
                      visual: Text(
                        l10n.visualAlphabetAbc,
                        style: AppTextStyles.categoryIconText,
                      ),
                      onTap: () => _onCategoryTapped(context, l10n.categoryAlphabet, l10n),
                    ),
                    CategoryCard(
                      title: l10n.categoryNumbers,
                      backgroundColor: AppColors.cardPink,
                      visual: Text(
                        l10n.visualNumbers123,
                        style: AppTextStyles.categoryIconText,
                      ),
                      onTap: () => _onCategoryTapped(context, l10n.categoryNumbers, l10n),
                    ),
                    CategoryCard(
                      title: l10n.categoryShapes,
                      backgroundColor: AppColors.cardGreen,
                      visual: const ShapesVisual(),
                      onTap: () => _onCategoryTapped(context, l10n.categoryShapes, l10n),
                    ),
                    CategoryCard(
                      title: l10n.categoryColors,
                      backgroundColor: AppColors.cardLavender,
                      visual: const ColorsVisual(),
                      onTap: () => _onCategoryTapped(context, l10n.categoryColors, l10n),
                    ),
                    CategoryCard(
                      title: l10n.categoryAnimals,
                      backgroundColor: AppColors.cardPeach,
                      visual: Text(
                        l10n.visualAnimalsMoo,
                        style: AppTextStyles.categoryIconText,
                      ),
                      onTap: () => _onCategoryTapped(context, l10n.categoryAnimals, l10n),
                    ),
                    CategoryCard(
                      title: l10n.categoryPuzzles,
                      backgroundColor: AppColors.cardBlue,
                      visual: const PuzzlesVisual(),
                      onTap: () => _onCategoryTapped(context, l10n.categoryPuzzles, l10n),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile bottom-sheet menu
// ─────────────────────────────────────────────────────────────────────────────

/// Rounded bottom sheet with "Change Name" and "Logout" menu items.
class _ProfileMenuSheet extends StatelessWidget {
  const _ProfileMenuSheet({
    required this.onChangeName,
    required this.onLogout,
    required this.l10n,
  });

  final VoidCallback onChangeName;
  final VoidCallback onLogout;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          const SizedBox(width: 40, height: 4, child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          )),
          const SizedBox(height: 16),

          // Change Name option
          _MenuTile(
            icon: Icons.edit_rounded,
            iconColor: AppColors.kidGreen,
            label: l10n.menuChangeName,
            onTap: onChangeName,
          ),

          const Divider(
            height: 1,
            color: AppColors.divider,
            indent: 20,
            endIndent: 20,
          ),

          // Logout option
          _MenuTile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            label: l10n.menuLogout,
            labelColor: AppColors.error,
            onTap: onLogout,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Single tappable row inside the profile menu sheet.
class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.speechBubbleBody.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: labelColor ?? AppColors.navy,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.divider, size: 22),
          ],
        ),
      ),
    );
  }
}
