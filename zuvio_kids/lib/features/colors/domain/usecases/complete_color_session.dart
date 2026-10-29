import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/color_progress_entity.dart';
import '../repositories/color_repository.dart';

/// Completes the Colors learning session, awarding 10 stars.
/// Layer: Domain UseCase
class CompleteColorSession {
  const CompleteColorSession(this._repository);

  final ColorRepository _repository;

  Future<Either<Failure, ColorProgressEntity>> call(String studentName) =>
      _repository.completeSession(studentName);
}
