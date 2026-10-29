import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/shape_progress_entity.dart';
import '../repositories/shape_repository.dart';

/// Use case to fetch stored shapes progress.
/// Layer: Domain
class GetShapeProgress {
  const GetShapeProgress(this._repository);

  final ShapeRepository _repository;

  Future<Either<Failure, ShapeProgressEntity>> call(
    String studentName,
  ) =>
      _repository.getProgress(studentName);
}
