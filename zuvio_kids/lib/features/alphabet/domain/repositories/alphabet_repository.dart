import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/alphabet_progress_entity.dart';
import '../entities/alphabet_session_entity.dart';

/// Abstract repository interface for Alphabet learning module.
/// Layer: Domain (pure Dart)
abstract interface class AlphabetRepository {
  /// Fetches all 4 alphabet sessions mapped to current student progress.
  Future<Either<Failure, List<AlphabetSessionEntity>>> getSessions(
    String studentName,
  );

  /// Fetches the alphabet progress (completed sessions, total stars) for [studentName].
  Future<Either<Failure, AlphabetProgressEntity>> getProgress(
    String studentName,
  );

  /// Completes [sessionId] for [studentName], awarding 10 stars if not already awarded.
  Future<Either<Failure, AlphabetProgressEntity>> completeSession({
    required String studentName,
    required String sessionId,
  });

  /// Clears all stored alphabet learning progress for [studentName].
  Future<Either<Failure, void>> clearProgress(String studentName);

  /// Clears all alphabet learning data across all stored profiles (called on logout).
  Future<Either<Failure, void>> clearAll();
}
