import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/theme/app_theme_mode.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

/// Cross-feature Riverpod AsyncNotifier managing the active UI theme mode.
///
/// Features:
/// - Defaults to [AppThemeMode.sunnySky].
/// - Persists across app sessions until the user logs out.
/// - Restores to default [AppThemeMode.sunnySky] on user logout or fresh install.
/// Layer: Core Provider
class AppThemeNotifier extends AsyncNotifier<AppThemeMode> {
  @override
  Future<AppThemeMode> build() async {
    return _loadSavedTheme();
  }

  Future<AppThemeMode> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString(AppStrings.prefThemeMode);
      if (savedName != null) {
        return AppThemeMode.values.firstWhere(
          (m) => m.name == savedName,
          orElse: () => AppThemeMode.sunnySky,
        );
      }
    } catch (e, st) {
      AppLogger.error('AppThemeNotifier: failed to load theme from preferences', e, st);
    }
    return AppThemeMode.sunnySky;
  }

  /// Sets and persists a new [AppThemeMode], immediately triggering app-wide re-theme.
  Future<void> setTheme(AppThemeMode mode) async {
    state = AsyncData(mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppStrings.prefThemeMode, mode.name);
    } catch (e, st) {
      AppLogger.error('AppThemeNotifier: failed to persist theme', e, st);
    }
  }

  /// Resets the theme to the default [AppThemeMode.sunnySky] (called upon logout).
  Future<void> resetToDefault() async {
    state = const AsyncData(AppThemeMode.sunnySky);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppStrings.prefThemeMode);
    } catch (e, st) {
      AppLogger.error('AppThemeNotifier: failed to clear theme on logout', e, st);
    }
  }
}

/// Provider exposing the current [AppThemeMode].
final appThemeNotifierProvider =
    AsyncNotifierProvider<AppThemeNotifier, AppThemeMode>(
  AppThemeNotifier.new,
);
