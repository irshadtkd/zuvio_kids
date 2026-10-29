import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/animal_session_entity.dart';
import '../repositories/animals_repository.dart';

/// Retrieves all Animal Learning sessions with user progress.
/// Layer: Domain Use Case
class GetAnimalSessions {
  const GetAnimalSessions(this._repository);

  final AnimalsRepository _repository;

  Future<Either<Failure, List<AnimalSessionEntity>>> call() =>
      _repository.getSessions();
}
