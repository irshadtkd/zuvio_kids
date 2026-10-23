---
name: zuvio-error-handling
description: >-
  Use this skill when implementing, reviewing, or extending error handling in
  the ZuvioKids project. Covers the Failure sealed class hierarchy,
  AppException types, Either-based repository patterns, the centralised
  ErrorHandler, and how notifiers surface errors to the UI.
---

# ZuvioKids Error Handling Skill

Follow these patterns for all error handling in the project.

---

## Core Types (already in `core/errors/`)

### `failure.dart` — Sealed Failure hierarchy
```dart
/// Base sealed class for all domain-level failures.
sealed class Failure {
  const Failure({required this.message});
  final String message;
}

/// Failure due to network or remote server issues.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Failure due to local cache / storage issues.
final class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure due to invalid user input or missing required data.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Failure due to insufficient permissions.
final class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Fallback for unexpected/unclassified errors.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
```

### `app_exception.dart` — Data-layer exceptions
```dart
/// Base class for exceptions thrown inside data sources.
sealed class AppException implements Exception {
  const AppException({required this.message});
  final String message;
}

final class ServerException extends AppException {
  const ServerException({required super.message});
}

final class CacheException extends AppException {
  const CacheException({required super.message});
}

final class NetworkException extends AppException {
  const NetworkException({required super.message});
}
```

### `error_handler.dart` — Maps failures to localised messages
```dart
import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'failure.dart';

abstract final class ErrorHandler {
  /// Maps a [Failure] (or any [Object]) to a user-facing localised string.
  static String getLocalizedMessage(Object error, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (error is NetworkFailure) return l10n.errorNetworkUnavailable;
    if (error is CacheFailure)   return l10n.errorCacheFailure;
    if (error is ValidationFailure) return error.message; // already localised
    if (error is PermissionFailure) return l10n.errorPermissionDenied;
    return l10n.errorUnexpected;
  }
}
```

---

## Repository Pattern with Either

```dart
import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import 'package:zuvio_kids/core/errors/app_exception.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

@override
Future<Either<Failure, T>> someMethod() async {
  try {
    final result = await _dataSource.fetch();
    return right(result);
  } on ServerException catch (e, st) {
    AppLogger.error('ServerException in someMethod', e, st);
    return left(NetworkFailure(message: e.message));
  } on CacheException catch (e, st) {
    AppLogger.error('CacheException in someMethod', e, st);
    return left(CacheFailure(message: e.message));
  } catch (e, st) {
    AppLogger.error('Unexpected error in someMethod', e, st);
    return left(UnexpectedFailure(message: e.toString()));
  }
}
```

**Rules:**
- Every repository method **must** return `Either<Failure, T>`.
- No raw exception should ever escape a repository method.
- Always log errors at the repository level before converting to `Failure`.

---

## Notifier Error Surfacing

```dart
class ExampleNotifier extends AsyncNotifier<List<ExampleEntity>> {
  @override
  Future<List<ExampleEntity>> build() => _fetch();

  Future<List<ExampleEntity>> _fetch() async {
    final result = await ref.read(exampleUseCaseProvider)();
    return result.fold(
      // Throw the Failure object — AsyncValue.error will capture it
      (failure) => throw failure,
      (data)    => data,
    );
  }
}
```

The screen uses `state.when(error: (e, _) => ...)` and calls
`ErrorHandler.getLocalizedMessage(e, context)`.

---

## Screen Error Display Pattern

```dart
state.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stackTrace) => ErrorView(
    message: ErrorHandler.getLocalizedMessage(error, context),
    onRetry: () => ref.invalidate(exampleNotifierProvider),
  ),
  data: (items) => /* your list */,
);
```

Use the `ErrorView` widget from `core/widgets/error_view.dart`:
```dart
/// Reusable error display widget with optional retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSizes.gapM),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.gapM),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.btnRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## Logger (`core/utils/app_logger.dart`)

```dart
import 'package:flutter/foundation.dart';

/// Centralised logger. Replace with a production logging package as needed.
abstract final class AppLogger {
  static void debug(String message) {
    if (kDebugMode) debugPrint('[DEBUG] $message');
  }

  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO] $message');
  }

  static void warning(String message) {
    if (kDebugMode) debugPrint('[WARN] $message');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }
    // TODO: integrate crash reporting (e.g., Firebase Crashlytics) here
  }
}
```

**Rules:**
- Never use `print()`. Always use `AppLogger`.
- `AppLogger.error` is the only place to call crash-reporting SDKs.
- In production builds, `kDebugMode` is false, so debug logs are suppressed.

---

## Required ARB Strings for Error Handling

Add these to **both** `app_en.arb` and `app_ml.arb`:

```json
// app_en.arb
"errorNetworkUnavailable": "No internet connection. Please try again.",
"errorCacheFailure": "Could not load saved data. Please try again.",
"errorPermissionDenied": "Permission denied. Please check your settings.",
"errorUnexpected": "Something went wrong. Please try again later.",
"btnRetry": "Retry"
```

```json
// app_ml.arb
"errorNetworkUnavailable": "ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ല. വീണ്ടും ശ്രമിക്കുക.",
"errorCacheFailure": "സംരക്ഷിച്ച ഡേറ്റ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല. വീണ്ടും ശ്രമിക്കുക.",
"errorPermissionDenied": "അനുമതി നിരസിച്ചു. ക്രമീകരണങ്ങൾ പരിശോധിക്കുക.",
"errorUnexpected": "എന്തോ തകരാറ് സംഭവിച്ചു. കുറച്ചു കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക.",
"btnRetry": "വീണ്ടും ശ്രമിക്കുക"
```
