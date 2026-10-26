import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../entities/alphabet_progress_entity.dart';
import '../repositories/alphabet_repository.dart';

/// Retrieves learning progress and star balance for a student.
/// Layer: Domain
class GetAlphabetProgress {
  const GetAlphabetProgress(this._repository);

  final AlphabetRepository _repository;

  Future<Either<Failure, AlphabetProgressEntity>> call(String studentName) {
    return _repository.getProgress(studentName);
  }
}
