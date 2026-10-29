import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/number_progress_entity.dart';
import '../repositories/number_repository.dart';

/// Fetches the student's number learning progress (completed sessions, stars).
/// Layer: Domain UseCase
class GetNumberProgress {
  const GetNumberProgress(this._repository);

  final NumberRepository _repository;

  Future<Either<Failure, NumberProgressEntity>> call(String studentName) =>
      _repository.getProgress(studentName);
}
