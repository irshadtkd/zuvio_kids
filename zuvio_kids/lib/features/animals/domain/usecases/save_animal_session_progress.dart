import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/animals_repository.dart';

/// Saves completion and awarded stars for an animal learning session.
/// Layer: Domain Use Case
class SaveAnimalSessionProgress {
  const SaveAnimalSessionProgress(this._repository);

  final AnimalsRepository _repository;

  Future<Either<Failure, void>> call(String sessionId, int stars) =>
      _repository.saveSessionCompleted(sessionId, stars);
}
