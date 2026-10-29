import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/providers/app_theme_provider.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_mode.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/alphabet/presentation/providers/alphabet_provider.dart';
import 'package:zuvio_kids/features/animals/presentation/providers/animals_provider.dart';
import 'package:zuvio_kids/features/colors/presentation/providers/colors_provider.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/category_card.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/star_badge.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/theme_selection_dialog.dart';
import 'package:zuvio_kids/features/numbers/presentation/providers/numbers_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/widgets/animal_avatar.dart';
import 'package:zuvio_kids/features/puzzle/presentation/providers/puzzle_provider.dart';
import 'package:zuvio_kids/features/shapes/presentation/providers/shapes_provider.dart';

/// Home dashboard screen.
/// Tapping the avatar, name, or star badge opens a small bottom-sheet menu
/// with "Change Name", "Change Theme", and "Logout".
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Shows a compact bottom-sheet menu.
  Future<void> _showProfileMenu(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProfileMenuSheet(
        onChangeName: () {
          Navigator.pop(ctx);
          _showChangeNameDialog(context, ref);
        },
        onChangeTheme: () {
          Navigator.pop(ctx);
          _showThemeSelectionDialog(context);
        },
        onLogout: () async {
          Navigator.pop(ctx);
          await _logout(context, ref);
        },
        l10n: l10n,
      ),
    );
  }

  /// Displays the 3 child-friendly themes for selection.
  void _showThemeSelectionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => Consumer(
        builder: (ctx, refConsumer, _) {
          final currentMode =
              refConsumer.watch(appThemeNotifierProvider).valueOrNull ??
                  AppThemeMode.sunnySky;
          return ThemeSelectionDialog(
            currentMode: currentMode,
            onThemeSelected: (selectedMode) {
              refConsumer
                  .read(appThemeNotifierProvider.notifier)
                  .setTheme(selectedMode);
            },
          );
        },
      ),
    );
  }

  /// Opens a dialog to change the child's name without wiping progress or stars.
  void _showChangeNameDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentName =
        ref.read(onboardingNotifierProvider).valueOrNull?.name ?? '';
    final controller = TextEditingController(text: currentName);

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.menuChangeName,
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 22,
            color: AppColors.navy,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: AppSizes.nameMaxLength,
          decoration: InputDecoration(
            hintText: l10n.hintChildName,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.btnBack),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(onboardingNotifierProvider.notifier).setName(newName);
                await ref
                    .read(onboardingNotifierProvider.notifier)
                    .completeOnboarding();
              }
              if (dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
            },
            child: Text(l10n.btnSaveProgress),
          ),
        ],
      ),
    );
  }

  /// Clears stored star points and all local profile and module data on logout.
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(starPointsNotifierProvider.notifier).clearPoints();
    await ref.read(alphabetNotifierProvider.notifier).clearAllProgress();
    await ref.read(numbersNotifierProvider.notifier).clearAllProgress();
    await ref.read(colorsNotifierProvider.notifier).clearAllProgress();
    await ref.read(shapesNotifierProvider.notifier).clearAllProgress();
    await ref.read(puzzleNotifierProvider.notifier).clearAllProgress();
    await ref.read(animalsNotifierProvider.notifier).clearAllProgress();
    await ref.read(onboardingNotifierProvider.notifier).resetProfile();
    await ref.read(appThemeNotifierProvider.notifier).resetToDefault();
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
    final themePalette = context.themePalette;
    final state = ref.watch(onboardingNotifierProvider).valueOrNull;
    final stars = ref.watch(starPointsNotifierProvider).valueOrNull ?? 0;
    final name =
        state?.name.isNotEmpty == true ? state!.name : AppStrings.defaultChildName;
    final avatar = state?.friendAvatar.isNotEmpty == true
        ? state!.friendAvatar
        : AppStrings.defaultFriend;

    return Scaffold(
      backgroundColor: themePalette.scaffoldBackground,
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
                    stars: stars,
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
                      backgroundColor: themePalette.cardAlphabet,
                      visual: Text(
                        l10n.visualAlphabetAbc,
                        style: AppTextStyles.categoryIconText,
                      ),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.alphabetHub),
                    ),
                    CategoryCard(
                      title: l10n.categoryNumbers,
                      backgroundColor: themePalette.cardNumbers,
                      visual: Text(
                        l10n.visualNumbers123,
                        style: AppTextStyles.categoryIconText,
                      ),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.numbersHub),
                    ),
                    CategoryCard(
                      title: l10n.categoryShapes,
                      backgroundColor: themePalette.cardShapes,
                      visual: const ShapesVisual(),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.shapesHub),
                    ),
                    CategoryCard(
                      title: l10n.categoryColors,
                      backgroundColor: themePalette.cardColors,
                      visual: const ColorsVisual(),
                      onTap: () {
                        ref.read(colorsNotifierProvider.notifier).playAgain();
                        Navigator.pushNamed(context, AppRoutes.colorsLearning);
                      },
                    ),
                    CategoryCard(
                      title: l10n.categoryAnimals,
                      backgroundColor: themePalette.cardAnimals,
                      visual: const AnimalsVisual(),
                      onTap: () => Navigator.pushNamed(context, AppRoutes.animalsHub),
                    ),
                    CategoryCard(
                      title: l10n.categoryPuzzles,
                      backgroundColor: themePalette.cardPuzzles,
                      visual: const PuzzlesVisual(),
                      onTap: () {
                        ref.read(puzzleNotifierProvider.notifier).generateNewSet();
                        Navigator.pushNamed(context, AppRoutes.puzzleSessions);
                      },
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

/// Rounded bottom sheet with "Change Name", "Change Theme", and "Logout" menu items.
class _ProfileMenuSheet extends StatelessWidget {
  const _ProfileMenuSheet({
    required this.onChangeName,
    required this.onChangeTheme,
    required this.onLogout,
    required this.l10n,
  });

  final VoidCallback onChangeName;
  final VoidCallback onChangeTheme;
  final VoidCallback onLogout;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final themePalette = context.themePalette;

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

          // Change Theme option alongside Logout
          _MenuTile(
            icon: Icons.palette_rounded,
            iconColor: themePalette.primary,
            label: l10n.menuChangeTheme,
            onTap: onChangeTheme,
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
