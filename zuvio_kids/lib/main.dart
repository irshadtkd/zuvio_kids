import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/providers/app_theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_mode.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScope is the root Riverpod scope — must wrap the entire app.
    const ProviderScope(child: ZuvioKidsApp()),
  );
}

/// Root application widget. Contains only configuration — no business logic.
class ZuvioKidsApp extends ConsumerWidget {
  const ZuvioKidsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(appThemeNotifierProvider).valueOrNull ?? AppThemeMode.sunnySky;

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // ── Theming ─────────────────────────────────────────────────────
      theme: AppTheme.buildTheme(themeMode),

      // ── Localisation ────────────────────────────────────────────────
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // ── Navigation ──────────────────────────────────────────────────
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
