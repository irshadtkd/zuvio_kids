import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/color_session_entity.dart';
import '../repositories/color_repository.dart';

/// Fetches the Colors learning session for the student.
/// [studentClass] is used to determine the color list (UKG gets extended set).
/// Layer: Domain UseCase
class GetColorSession {
  const GetColorSession(this._repository);

  final ColorRepository _repository;

  Future<Either<Failure, ColorSessionEntity>> call(
    String studentName, {
    String studentClass = '',
  }) =>
      _repository.getSession(studentName, studentClass: studentClass);
}
