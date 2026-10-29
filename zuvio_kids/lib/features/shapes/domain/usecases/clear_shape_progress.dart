import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/shape_repository.dart';

/// Use case to clear all Shapes progress on logout.
/// Layer: Domain
class ClearShapeProgress {
  const ClearShapeProgress(this._repository);

  final ShapeRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.clearProgress();
}
