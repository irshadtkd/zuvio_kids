import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/puzzle_session_entity.dart';

/// Contract for puzzle data access, randomized generation, and history tracking.
/// Layer: Domain Repository Interface
abstract interface class PuzzleRepository {
  /// Generates a new randomized set of 4 puzzle sessions (Alphabet, Numbers, Colors, Shapes),
  /// avoiding previously completed variations.
  Future<Either<Failure, List<PuzzleSessionEntity>>> generateNewPuzzleSet();

  /// Marks a specific puzzle variation signature as completed in local storage.
  Future<Either<Failure, Unit>> markVariationCompleted(String variationKey);

  /// Clears stored puzzle progress and variation history (e.g. on user logout).
  Future<Either<Failure, Unit>> clearProgress();
}
