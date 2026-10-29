import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/shape_progress_entity.dart';
import '../entities/shape_session_entity.dart';

/// Abstract repository contract for Shapes learning.
/// Layer: Domain
abstract interface class ShapeRepository {
  /// Fetches all 4 shape sessions with unlocked/completed status.
  Future<Either<Failure, List<ShapeSessionEntity>>> getSessions(
    String studentName,
  );

  /// Fetches saved progress for the current student.
  Future<Either<Failure, ShapeProgressEntity>> getProgress(
    String studentName,
  );

  /// Marks a session as completed, awards 10 stars (if not already completed),
  /// and unlocks the subsequent session.
  Future<Either<Failure, Unit>> completeSession(
    String studentName,
    String sessionId,
  );

  /// Clears all stored shapes progress from local storage.
  Future<Either<Failure, Unit>> clearProgress();
}
