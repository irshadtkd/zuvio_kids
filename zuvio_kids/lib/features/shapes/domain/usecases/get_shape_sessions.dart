import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/shape_session_entity.dart';
import '../repositories/shape_repository.dart';

/// Use case to fetch all 4 Shapes sessions.
/// Layer: Domain
class GetShapeSessions {
  const GetShapeSessions(this._repository);

  final ShapeRepository _repository;

  Future<Either<Failure, List<ShapeSessionEntity>>> call(
    String studentName,
  ) =>
      _repository.getSessions(studentName);
}
