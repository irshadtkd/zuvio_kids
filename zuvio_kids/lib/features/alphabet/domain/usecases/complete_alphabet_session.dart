import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/alphabet_progress_entity.dart';
import '../repositories/alphabet_repository.dart';

/// Completes an alphabet session and credits +10 stars (if not previously completed).
/// Layer: Domain
class CompleteAlphabetSession {
  const CompleteAlphabetSession(this._repository);

  final AlphabetRepository _repository;

  Future<Either<Failure, AlphabetProgressEntity>> call({
    required String studentName,
    required String sessionId,
  }) {
    return _repository.completeSession(
      studentName: studentName,
      sessionId: sessionId,
    );
  }
}
