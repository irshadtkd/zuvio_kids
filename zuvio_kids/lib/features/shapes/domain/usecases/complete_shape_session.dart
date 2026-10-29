import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/shape_repository.dart';

/// Use case to mark a shape session complete and persist progress.
/// Layer: Domain
class CompleteShapeSession {
  const CompleteShapeSession(this._repository);

  final ShapeRepository _repository;

  Future<Either<Failure, Unit>> call(
    String studentName,
    String sessionId,
  ) =>
      _repository.completeSession(studentName, sessionId);
}
