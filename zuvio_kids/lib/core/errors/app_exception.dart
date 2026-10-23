/// Base class for typed exceptions thrown inside data sources.
/// These must be caught and converted to [Failure]s at the repository boundary.
sealed class AppException implements Exception {
  const AppException({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a remote server returns an error response.
final class ServerException extends AppException {
  const ServerException({required super.message});
}

/// Thrown when a local cache/database operation fails.
final class CacheException extends AppException {
  const CacheException({required super.message});
}

/// Thrown when a network request cannot be made (no connectivity).
final class NetworkException extends AppException {
  const NetworkException({required super.message});
}
