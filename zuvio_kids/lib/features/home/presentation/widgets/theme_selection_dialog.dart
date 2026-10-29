import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_mode.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';

/// Interactive modal dialog allowing kids to choose between the 3 UI themes.
/// Layer: Presentation Widget
class ThemeSelectionDialog extends StatelessWidget {
  const ThemeSelectionDialog({
    super.key,
    required this.currentMode,
    required this.onThemeSelected,
  });

  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onThemeSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentPalette = context.themePalette;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row: Title + Close Icon
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: currentPalette.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.palette_rounded,
                    color: currentPalette.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.themeDialogTitle,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 22,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        l10n.themeDialogSubtitle,
                        style: AppTextStyles.cardSubtitle.copyWith(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 26,
                  ),
                  tooltip: l10n.btnClose,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3 Theme Option Cards
            _ThemeOptionCard(
              mode: AppThemeMode.sunnySky,
              title: l10n.themeSunnySky,
              description: l10n.themeSunnySkyDesc,
              isSelected: currentMode == AppThemeMode.sunnySky,
              colors: const [
                AppColors.appSkyBlue,
                AppColors.primary,
                AppColors.kidGreen,
                AppColors.cardYellow,
              ],
              onTap: () => onThemeSelected(AppThemeMode.sunnySky),
              l10n: l10n,
            ),
            const SizedBox(height: 12),

            _ThemeOptionCard(
              mode: AppThemeMode.candyCarnival,
              title: l10n.themeCandyCarnival,
              description: l10n.themeCandyCarnivalDesc,
              isSelected: currentMode == AppThemeMode.candyCarnival,
              colors: const [
                AppColors.candyPinkBg,
                AppColors.candyPrimary,
                AppColors.candyButton,
                AppColors.candyYellow,
              ],
              onTap: () => onThemeSelected(AppThemeMode.candyCarnival),
              l10n: l10n,
            ),
            const SizedBox(height: 12),

            _ThemeOptionCard(
              mode: AppThemeMode.magicMeadow,
              title: l10n.themeMagicMeadow,
              description: l10n.themeMagicMeadowDesc,
              isSelected: currentMode == AppThemeMode.magicMeadow,
              colors: const [
                AppColors.meadowGreenBg,
                AppColors.meadowPrimary,
                AppColors.meadowButton,
                AppColors.meadowYellow,
              ],
              onTap: () => onThemeSelected(AppThemeMode.magicMeadow),
              l10n: l10n,
            ),
            const SizedBox(height: 20),

            // Done Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentPalette.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.btnClose,
                  style: AppTextStyles.buttonLabel.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single card representing one theme option in the selection dialog.
class _ThemeOptionCard extends StatelessWidget {
  const _ThemeOptionCard({
    required this.mode,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.colors,
    required this.onTap,
    required this.l10n,
  });

  final AppThemeMode mode;
  final String title;
  final String description;
  final bool isSelected;
  final List<Color> colors;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final activeColor = colors[1];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Visual Palette Circles Preview
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: colors[0],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors[1],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors[2],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Theme Name & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(
                      fontSize: 18,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTextStyles.cardSubtitle.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Selection Checkmark / Radio Badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
