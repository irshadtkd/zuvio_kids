import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/alphabet_repository.dart';

/// Clears all stored alphabet progress (called on logout/reset).
/// Layer: Domain
class ClearAlphabetProgress {
  const ClearAlphabetProgress(this._repository);

  final AlphabetRepository _repository;

  Future<Either<Failure, void>> call([String? studentName]) {
    if (studentName != null && studentName.isNotEmpty) {
      return _repository.clearProgress(studentName);
    }
    return _repository.clearAll();
  }
}
