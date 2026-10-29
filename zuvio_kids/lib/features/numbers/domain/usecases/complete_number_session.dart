import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/number_progress_entity.dart';
import '../repositories/number_repository.dart';

/// Completes a number learning session, awarding 10 stars and unlocking the next session.
/// Layer: Domain UseCase
class CompleteNumberSession {
  const CompleteNumberSession(this._repository);

  final NumberRepository _repository;

  Future<Either<Failure, NumberProgressEntity>> call({
    required String studentName,
    required String sessionId,
  }) =>
      _repository.completeSession(
        studentName: studentName,
        sessionId: sessionId,
      );
}
