import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/number_session_entity.dart';
import '../repositories/number_repository.dart';

/// Fetches all 10 number learning sessions for the student.
/// Layer: Domain UseCase
class GetNumberSessions {
  const GetNumberSessions(this._repository);

  final NumberRepository _repository;

  Future<Either<Failure, List<NumberSessionEntity>>> call(
    String studentName,
  ) =>
      _repository.getSessions(studentName);
}
