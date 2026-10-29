import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/number_progress_entity.dart';
import '../entities/number_session_entity.dart';

/// Abstract repository interface for Numbers learning module.
/// Layer: Domain (pure Dart)
abstract interface class NumberRepository {
  /// Fetches all 10 number sessions mapped to current student progress.
  Future<Either<Failure, List<NumberSessionEntity>>> getSessions(
    String studentName,
  );

  /// Fetches the numbers progress (completed sessions, total stars) for [studentName].
  Future<Either<Failure, NumberProgressEntity>> getProgress(
    String studentName,
  );

  /// Completes [sessionId] for [studentName], awarding 10 stars if not already awarded.
  Future<Either<Failure, NumberProgressEntity>> completeSession({
    required String studentName,
    required String sessionId,
  });

  /// Clears all stored numbers learning progress for [studentName].
  Future<Either<Failure, void>> clearProgress(String studentName);

  /// Clears all numbers learning data across all stored profiles (called on logout).
  Future<Either<Failure, void>> clearAll();
}
