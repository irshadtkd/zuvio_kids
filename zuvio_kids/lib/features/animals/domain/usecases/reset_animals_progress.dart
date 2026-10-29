import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/animals_repository.dart';

/// Resets saved animal session progress and stars.
/// Layer: Domain Use Case
class ResetAnimalsProgress {
  const ResetAnimalsProgress(this._repository);

  final AnimalsRepository _repository;

  Future<Either<Failure, void>> call() => _repository.resetProgress();
}
