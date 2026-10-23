/// Base sealed class for all domain-level failures in ZuvioKids.
sealed class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
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

/// Failure due to insufficient device/system permissions.
final class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Fallback for unexpected or unclassified errors.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
