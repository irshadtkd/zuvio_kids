import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/color_session_entity.dart';
import '../repositories/color_repository.dart';

/// Fetches the Colors learning session for the student.
/// Layer: Domain UseCase
class GetColorSession {
  const GetColorSession(this._repository);

  final ColorRepository _repository;

  Future<Either<Failure, ColorSessionEntity>> call(String studentName) =>
      _repository.getSession(studentName);
}
