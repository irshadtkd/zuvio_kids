import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/providers/app_theme_provider.dart';
import 'package:zuvio_kids/core/theme/app_theme.dart';
import 'package:zuvio_kids/core/theme/app_theme_mode.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/features/home/presentation/widgets/theme_selection_dialog.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppThemeNotifier Tests', () {
    test('defaults to sunnySky theme when no preference is saved', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialTheme =
          await container.read(appThemeNotifierProvider.future);
      expect(initialTheme, AppThemeMode.sunnySky);
    });

    test('sets theme to candyCarnival and persists in SharedPreferences',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(appThemeNotifierProvider.future);
      await container
          .read(appThemeNotifierProvider.notifier)
          .setTheme(AppThemeMode.candyCarnival);

      expect(
        container.read(appThemeNotifierProvider).value,
        AppThemeMode.candyCarnival,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(AppStrings.prefThemeMode),
        AppThemeMode.candyCarnival.name,
      );
    });

    test('sets theme to magicMeadow and persists in SharedPreferences',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(appThemeNotifierProvider.future);
      await container
          .read(appThemeNotifierProvider.notifier)
          .setTheme(AppThemeMode.magicMeadow);

      expect(
        container.read(appThemeNotifierProvider).value,
        AppThemeMode.magicMeadow,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(AppStrings.prefThemeMode),
        AppThemeMode.magicMeadow.name,
      );
    });

    test('retains selected theme across restarts', () async {
      SharedPreferences.setMockInitialValues({
        AppStrings.prefThemeMode: AppThemeMode.candyCarnival.name,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final loaded = await container.read(appThemeNotifierProvider.future);
      expect(loaded, AppThemeMode.candyCarnival);
    });

    test('resets to default sunnySky and removes pref key on logout', () async {
      SharedPreferences.setMockInitialValues({
        AppStrings.prefThemeMode: AppThemeMode.magicMeadow.name,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(appThemeNotifierProvider.future);
      await container.read(appThemeNotifierProvider.notifier).resetToDefault();

      expect(
        container.read(appThemeNotifierProvider).value,
        AppThemeMode.sunnySky,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(AppStrings.prefThemeMode), isFalse);
    });
  });

  group('AppTheme & Palette Configuration Tests', () {
    test('all 3 palettes have valid, distinct background and primary colors',
        () {
      const sunny = AppThemePalette.sunnySky;
      const candy = AppThemePalette.candyCarnival;
      const meadow = AppThemePalette.magicMeadow;

      expect(sunny.scaffoldBackground, AppColors.appSkyBlue);
      expect(candy.scaffoldBackground, AppColors.candyPinkBg);
      expect(meadow.scaffoldBackground, AppColors.meadowGreenBg);

      expect(sunny.primary, AppColors.primary);
      expect(candy.primary, AppColors.candyPrimary);
      expect(meadow.primary, AppColors.meadowPrimary);

      expect(sunny.sessionColors.length, 4);
      expect(candy.sessionColors.length, 4);
      expect(meadow.sessionColors.length, 4);
    });

    test('buildTheme generates ThemeData with AppThemePalette extension', () {
      final themeData = AppTheme.buildTheme(AppThemeMode.candyCarnival);
      final palette = themeData.extension<AppThemePalette>();

      expect(palette, isNotNull);
      expect(palette!.mode, AppThemeMode.candyCarnival);
      expect(themeData.scaffoldBackgroundColor, AppColors.candyPinkBg);
    });
  });

  group('ThemeSelectionDialog Widget Tests', () {
    testWidgets('renders all 3 theme options and triggers onThemeSelected',
        (tester) async {
      AppThemeMode? selectedMode;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.buildTheme(AppThemeMode.sunnySky),
          home: Scaffold(
            body: ThemeSelectionDialog(
              currentMode: AppThemeMode.sunnySky,
              onThemeSelected: (mode) {
                selectedMode = mode;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header and 3 theme options are rendered
      expect(find.text('Choose Theme'), findsOneWidget);
      expect(find.text('Sunny Sky'), findsOneWidget);
      expect(find.text('Candy Carnival'), findsOneWidget);
      expect(find.text('Magic Meadow'), findsOneWidget);

      // Tap Candy Carnival option
      await tester.tap(find.text('Candy Carnival'));
      await tester.pumpAndSettle();

      expect(selectedMode, AppThemeMode.candyCarnival);

      // Tap Magic Meadow option
      await tester.tap(find.text('Magic Meadow'));
      await tester.pumpAndSettle();

      expect(selectedMode, AppThemeMode.magicMeadow);
    });
  });
}
