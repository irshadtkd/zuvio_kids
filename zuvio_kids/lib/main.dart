import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    // ProviderScope is the root Riverpod scope — must wrap the entire app.
    const ProviderScope(child: ZuvioKidsApp()),
  );
}

/// Root application widget. Contains only configuration — no business logic.
class ZuvioKidsApp extends StatelessWidget {
  const ZuvioKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // ── Theming ─────────────────────────────────────────────────────
      theme: AppTheme.light,

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
