import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/puzzle_session_entity.dart';
import '../repositories/puzzle_repository.dart';

/// Use case to generate a new randomized set of 4 puzzle sessions.
/// Layer: Domain Use Case
class GetPuzzleSessions {
  const GetPuzzleSessions(this._repository);

  final PuzzleRepository _repository;

  Future<Either<Failure, List<PuzzleSessionEntity>>> call() {
    return _repository.generateNewPuzzleSet();
  }
}
