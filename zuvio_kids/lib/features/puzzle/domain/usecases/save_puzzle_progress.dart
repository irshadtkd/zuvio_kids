import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/puzzle_repository.dart';

/// Use case to mark a completed puzzle variation signature.
/// Layer: Domain Use Case
class SavePuzzleProgress {
  const SavePuzzleProgress(this._repository);

  final PuzzleRepository _repository;

  Future<Either<Failure, Unit>> call(String variationKey) {
    return _repository.markVariationCompleted(variationKey);
  }
}
