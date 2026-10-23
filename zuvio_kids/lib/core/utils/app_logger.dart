import 'package:flutter/foundation.dart';

/// Centralised logger for ZuvioKids.
///
/// In debug builds, logs are printed via [debugPrint].
/// In release builds all output is suppressed (kDebugMode == false).
/// Integrate a crash-reporting SDK in the [error] method for production use.
abstract final class AppLogger {
  static void debug(String message) {
    if (kDebugMode) debugPrint('[DEBUG] $message');
  }

  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO]  $message');
  }

  static void warning(String message) {
    if (kDebugMode) debugPrint('[WARN]  $message');
  }

  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('        Error : $error');
      if (stackTrace != null) debugPrint('        Stack : $stackTrace');
    }
    // TODO(team): Forward to Firebase Crashlytics or Sentry here.
  }
}
