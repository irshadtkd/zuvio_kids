import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'app_theme_mode.dart';
import 'app_theme_palette.dart';

/// Centralised theme factory for ZuvioKids.
/// All theme customisations must go through this class.
abstract final class AppTheme {
  /// Builds a [ThemeData] instance according to the selected [AppThemeMode].
  static ThemeData buildTheme(AppThemeMode mode) {
    final palette = AppThemePalette.fromMode(mode);

    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        primary: palette.primary,
        secondary: palette.highlight,
        error: AppColors.error,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: palette.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.actionButton,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
      extensions: [palette],
    );
  }

  /// Default light theme using [AppThemeMode.sunnySky].
  static ThemeData get light => buildTheme(AppThemeMode.sunnySky);
}
