import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';

import 'failure.dart';

/// Maps [Failure] objects (or any [Object]) to user-facing localised strings.
///
/// Usage:
/// ```dart
/// state.when(
///   error: (e, _) => Text(ErrorHandler.getLocalizedMessage(e, context)),
/// )
/// ```
abstract final class ErrorHandler {
  static String getLocalizedMessage(Object error, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return switch (error) {
      NetworkFailure()    => l10n.errorNetworkUnavailable,
      CacheFailure()      => l10n.errorCacheFailure,
      PermissionFailure() => l10n.errorPermissionDenied,
      ValidationFailure() => error.message, // message is already localised
      UnexpectedFailure() => l10n.errorUnexpected,
      _                   => l10n.errorUnexpected,
    };
  }
}
