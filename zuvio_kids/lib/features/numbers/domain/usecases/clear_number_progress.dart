import 'package:fpdart/fpdart.dart';
import 'package:zuvio_kids/core/errors/failure.dart';
import '../repositories/number_repository.dart';

/// Clears number learning progress.
/// If [studentName] is provided, clears only that student's progress.
/// If omitted, clears all number progress across all profiles (used during logout).
/// Layer: Domain UseCase
class ClearNumberProgress {
  const ClearNumberProgress(this._repository);

  final NumberRepository _repository;

  Future<Either<Failure, void>> call([String? studentName]) {
    if (studentName != null && studentName.isNotEmpty) {
      return _repository.clearProgress(studentName);
    }
    return _repository.clearAll();
  }
}
