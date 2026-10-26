import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/alphabet_session_entity.dart';
import '../repositories/alphabet_repository.dart';

/// Retrieves all alphabet sessions with student completion states.
/// Layer: Domain
class GetAlphabetSessions {
  const GetAlphabetSessions(this._repository);

  final AlphabetRepository _repository;

  Future<Either<Failure, List<AlphabetSessionEntity>>> call(String studentName) {
    return _repository.getSessions(studentName);
  }
}
